const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const bot = require('../bot');
const { EmbedBuilder } = require('discord.js');

// Register Route
router.post('/register', async (req, res) => {
    try {
        const { username, password, licenseKey, hwid } = req.body;
        
        const License = require('../models/License');
        const license = await License.findOne({ key: licenseKey });
        
        if (!license) {
            return res.status(400).json({ error: 'Invalid License Key.' });
        }
        if (license.claimedBy) {
            return res.status(400).json({ error: 'License Key already claimed.' });
        }
        if (!license.discordId) {
            return res.status(400).json({ error: 'You must redeem this key in the Discord server first!' });
        }
        
        // Check if user exists
        let user = await User.findOne({ username });
        if (user) {
            return res.status(400).json({ error: 'Username already exists.' });
        }
        
        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);
        
        let subEnd = null;
        if (license.durationMs !== null) {
            subEnd = new Date(Date.now() + license.durationMs);
        }

        user = new User({
            username,
            password: hashedPassword,
            hwid: hwid || null,
            keys: [licenseKey],
            subscriptionEnd: subEnd,
            discordId: license.discordId || null
        });
        
        await user.save();
        
        license.claimedBy = user._id;
        license.claimedAt = new Date();
        await license.save();
        res.json({ message: 'Successfully registered!' });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

// Login Route
router.post('/login', async (req, res) => {
    try {
        const { username, password, hwid } = req.body;
        
        // Find user
        let user = await User.findOne({ username });
        if (!user) {
            return res.status(400).json({ error: 'Invalid credentials.' });
        }
        
        // Check password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ error: 'Invalid credentials.' });
        }
        
        // Check if banned
        if (user.banned) {
            return res.status(403).json({ error: 'You are banned from using VoltUi.' });
        }
        
        // HWID Locking
        if (!user.hwid) {
            user.hwid = hwid;
        } else if (user.hwid !== hwid) {
            return res.status(403).json({ error: 'Invalid HWID. Please reset your HWID.' });
        }
        
        user.executions = (user.executions || 0) + 1;
        await user.save();
        
        // Generate Token
        const payload = {
            user: { id: user.id }
        };
        
        jwt.sign(
            payload,
            process.env.JWT_SECRET,
            { expiresIn: '24h' },
            (err, token) => {
                if (err) throw err;
                res.json({ token, message: 'Erfolgreich eingeloggt' });
            }
        );
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

// Forgot Password Route
router.post('/forgot-password', async (req, res) => {
    try {
        const { username } = req.body;
        if (!username) return res.status(400).json({ error: 'Username is required.' });

        const user = await User.findOne({ username });
        if (!user) return res.status(404).json({ error: 'User not found.' });
        if (!user.discordId) return res.status(400).json({ error: 'No Discord account linked to this user.' });

        // Generate 6-digit code
        const code = Math.floor(100000 + Math.random() * 900000).toString();
        user.resetCode = code;
        user.resetCodeExpires = new Date(Date.now() + 15 * 60 * 1000); // 15 mins
        await user.save();

        const embed = new EmbedBuilder()
            .setTitle('Password Reset')
            .setDescription(`Your Volt password reset code is: **${code}**\nThis code will expire in 15 minutes.`)
            .setColor('#f39c12');
        
        const success = await bot.sendDM(user.discordId, null, embed);
        if (success) {
            res.json({ message: 'Verification code sent to your Discord DM.' });
        } else {
            res.status(500).json({ error: 'Failed to send DM to your Discord account. Check your privacy settings.' });
        }
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

// Reset Password Route
router.post('/reset-password', async (req, res) => {
    try {
        const { username, code, newPassword } = req.body;
        if (!username || !code || !newPassword) return res.status(400).json({ error: 'Missing fields.' });

        const user = await User.findOne({ username });
        if (!user) return res.status(404).json({ error: 'User not found.' });

        if (user.resetCode !== code) return res.status(400).json({ error: 'Invalid verification code.' });
        if (user.resetCodeExpires < new Date()) return res.status(400).json({ error: 'Verification code has expired.' });

        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(newPassword, salt);
        user.resetCode = null;
        user.resetCodeExpires = null;
        await user.save();

        res.json({ message: 'Password has been reset successfully. You can now login.' });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
