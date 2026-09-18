const express = require('express');
const router = express.Router();
const Ticket = require('../models/Ticket');
const bot = require('../bot');

const COOLDOWN_MS = 10 * 60 * 1000;

router.get('/cooldown', async (req, res) => {
    try {
        const { robloxId, userId } = req.query;
        if (!robloxId && !userId) {
            return res.json({ canSubmit: true, cooldownSeconds: 0 });
        }

        const filter = [];
        if (robloxId && String(robloxId) !== '0') filter.push({ robloxId: String(robloxId) });
        if (userId) filter.push({ userId: String(userId) });

        if (filter.length === 0) {
            return res.json({ canSubmit: true, cooldownSeconds: 0 });
        }

        const lastTicket = await Ticket.findOne({ $or: filter }).sort({ createdAt: -1 });
        if (!lastTicket) {
            return res.json({ canSubmit: true, cooldownSeconds: 0 });
        }

        const elapsed = Date.now() - new Date(lastTicket.createdAt).getTime();
        if (elapsed < COOLDOWN_MS) {
            const timeLeft = Math.ceil((COOLDOWN_MS - elapsed) / 1000);
            return res.json({ canSubmit: false, cooldownSeconds: timeLeft });
        }

        return res.json({ canSubmit: true, cooldownSeconds: 0 });
    } catch (err) {
        console.error('Check ticket cooldown error:', err);
        return res.status(500).json({ success: false, error: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { title, description, robloxId, robloxUsername, hwid, userId, username } = req.body;

        if (!title || typeof title !== 'string' || title.trim() === '') {
            return res.status(400).json({ success: false, error: 'Title is required.' });
        }

        const filter = [];
        if (robloxId && String(robloxId) !== '0') filter.push({ robloxId: String(robloxId) });
        if (userId) filter.push({ userId: String(userId) });

        if (filter.length > 0) {
            const lastTicket = await Ticket.findOne({ $or: filter }).sort({ createdAt: -1 });
            if (lastTicket) {
                const elapsed = Date.now() - new Date(lastTicket.createdAt).getTime();
                if (elapsed < COOLDOWN_MS) {
                    const timeLeft = Math.ceil((COOLDOWN_MS - elapsed) / 1000);
                    return res.status(429).json({
                        success: false,
                        error: 'cooldown',
                        timeLeft,
                        message: `Please wait ${timeLeft}s before submitting another report.`
                    });
                }
            }
        }

        const count = await Ticket.countDocuments();
        const ticketNumber = count + 1;
        const ticketId = 't_' + Date.now().toString(36) + Math.random().toString(36).substring(2, 5);

        const initialMessages = [];
        if (description && description.trim() !== '') {
            initialMessages.push({
                sender: 'user',
                authorName: robloxUsername || username || 'Player',
                text: description.trim(),
                createdAt: new Date()
            });
        }

        const ticket = new Ticket({
            ticketId,
            ticketNumber,
            userId: userId || null,
            username: username || 'User',
            robloxId: String(robloxId || '0'),
            robloxUsername: robloxUsername || 'RobloxUser',
            hwid: hwid || 'N/A',
            title: title.trim(),
            description: (description || '').trim(),
            status: 'open',
            messages: initialMessages,
            createdAt: new Date()
        });

        await ticket.save();

        if (bot && bot.createTicketChannel) {
            bot.createTicketChannel(ticket).then(async channelId => {
                if (channelId) {
                    ticket.channelId = channelId;
                    await ticket.save();
                }
            }).catch(e => {
                console.error('Failed to create Discord ticket channel:', e);
            });
        }

        return res.json({ success: true, ticket });
    } catch (err) {
        console.error('Create ticket error:', err);
        return res.status(500).json({ success: false, error: err.message });
    }
});

router.get('/', async (req, res) => {
    try {
        const { robloxId, userId } = req.query;
        const filter = [];
        if (robloxId && String(robloxId) !== '0') filter.push({ robloxId: String(robloxId) });
        if (userId) filter.push({ userId: String(userId) });

        if (filter.length === 0) {
            return res.json({ success: true, tickets: [] });
        }

        const tickets = await Ticket.find({ $or: filter })
            .select('ticketId ticketNumber title status createdAt closedAt')
            .sort({ createdAt: -1 })
            .limit(30)
            .lean();

        return res.json({ success: true, tickets });
    } catch (err) {
        console.error('Get tickets error:', err);
        return res.status(500).json({ success: false, error: err.message });
    }
});

router.get('/:id/messages', async (req, res) => {
    try {
        const ticket = await Ticket.findOne({ ticketId: req.params.id }).lean();
        if (!ticket) {
            return res.status(404).json({ success: false, error: 'Ticket not found.' });
        }

        return res.json({
            success: true,
            ticketId: ticket.ticketId,
            title: ticket.title,
            status: ticket.status,
            createdAt: ticket.createdAt,
            messages: ticket.messages || []
        });
    } catch (err) {
        console.error('Get ticket messages error:', err);
        return res.status(500).json({ success: false, error: err.message });
    }
});

router.post('/:id/messages', async (req, res) => {
    try {
        const { text, authorName } = req.body;
        if (!text || typeof text !== 'string' || text.trim() === '') {
            return res.status(400).json({ success: false, error: 'Message text is required.' });
        }

        const ticket = await Ticket.findOne({ ticketId: req.params.id });
        if (!ticket) {
            return res.status(404).json({ success: false, error: 'Ticket not found.' });
        }

        if (ticket.status === 'closed') {
            return res.status(400).json({ success: false, error: 'Ticket is closed.' });
        }

        const newMsg = {
            sender: 'user',
            authorName: authorName || ticket.robloxUsername || ticket.username || 'Player',
            text: text.trim(),
            createdAt: new Date()
        };

        ticket.messages.push(newMsg);
        await ticket.save();

        if (ticket.channelId && bot && bot.sendUserMessageToTicket) {
            bot.sendUserMessageToTicket(ticket.channelId, newMsg.text, newMsg.authorName).catch(e => {
                console.error('Failed to forward message to Discord channel:', e);
            });
        }

        return res.json({ success: true, message: newMsg });
    } catch (err) {
        console.error('Send ticket message error:', err);
        return res.status(500).json({ success: false, error: err.message });
    }
});

module.exports = router;
