const express = require('express');
const router = express.Router();
const User = require('../models/User');
const License = require('../models/License');

// POST /api/v1/keys
// Generate a new key
router.post('/keys', async (req, res) => {
    try {
        const { durationDays, note, isFree, discordId } = req.body;
        
        const generateKey = () => {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            let key = '';
            for (let i = 0; i < 24; i++) {
                key += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return key;
        };

        const key = generateKey();
        const durationMs = durationDays ? durationDays * 24 * 60 * 60 * 1000 : null;

        const license = new License({
            key,
            durationMs,
            isFree: isFree || false,
            note: note || null,
            discordId: discordId || null
        });

        await license.save();

        res.json({
            success: true,
            message: 'Key generated successfully!',
            user_key: key
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

// POST /api/v1/users/resethwid
// Reset HWID for a given discordId or username
router.post('/users/resethwid', async (req, res) => {
    try {
        const { discordId, username, force } = req.body;
        
        if (!discordId && !username) {
            return res.status(400).json({ success: false, message: 'Provide discordId or username' });
        }

        const query = discordId ? { discordId } : { username };
        const user = await User.findOne(query);

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        if (!force && user.lastReset) {
            const cooldown = 48 * 60 * 60 * 1000;
            if ((Date.now() - user.lastReset.getTime()) < cooldown) {
                return res.status(400).json({ success: false, message: 'User is on HWID reset cooldown' });
            }
        }

        user.hwid = null;
        user.hwidResets = (user.hwidResets || 0) + 1;
        user.lastReset = new Date();
        await user.save();

        res.json({ success: true, message: 'HWID successfully reset!' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

// GET /api/v1/stats
// Return some basic stats about executions and users
router.get('/stats', async (req, res) => {
    try {
        const totalUsers = await User.countDocuments();
        const bannedUsers = await User.countDocuments({ banned: true });
        
        const result = await User.aggregate([
            { $group: { _id: null, totalExecutions: { $sum: "$executions" } } }
        ]);
        
        const totalExecutions = result.length > 0 ? result[0].totalExecutions : 0;
        
        res.json({
            success: true,
            stats: {
                totalUsers,
                bannedUsers,
                totalExecutions
            }
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

module.exports = router;
