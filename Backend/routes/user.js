const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Middleware to verify JWT token
const authMiddleware = (req, res, next) => {
    const authHeader = req.header('Authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ msg: 'No token, authorization denied' });
    }
    const token = authHeader.split(' ')[1];

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded.user;
        next();
    } catch (err) {
        res.status(401).json({ msg: 'Token is not valid' });
    }
};

// GET /api/user/me
router.get('/me', authMiddleware, async (req, res) => {
    try {
        const user = await User.findById(req.user.id).select('-password');
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }
        res.json({ user });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

// POST /api/user/redeem
router.post('/redeem', authMiddleware, async (req, res) => {
    try {
        const user = await User.findById(req.user.id);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        if (user.subscriptionEnd === null) {
            return res.status(400).json({ error: 'Lifetime accounts cannot claim new keys.' });
        }
        
        const { licenseKey, key } = req.body;
        const actualKey = licenseKey || key;
        
        if (!actualKey) {
            return res.status(400).json({ error: 'No key provided' });
        }
        
        if (user.keys.includes(actualKey)) {
            return res.status(400).json({ error: 'Key already claimed by you.' });
        }
        
        const License = require('../models/License');
        const license = await License.findOne({ key: actualKey });
        
        if (!license) {
            return res.status(400).json({ error: 'Invalid License Key.' });
        }
        if (license.claimedBy) {
            return res.status(400).json({ error: 'License Key already claimed.' });
        }
        
        if (license.durationMs === null) {
            user.subscriptionEnd = null; // Upgraded to lifetime
        } else {
            const now = new Date();
            if (user.subscriptionEnd && user.subscriptionEnd > now) {
                user.subscriptionEnd = new Date(user.subscriptionEnd.getTime() + license.durationMs);
            } else {
                user.subscriptionEnd = new Date(now.getTime() + license.durationMs);
            }
        }
        
        user.keys.push(actualKey);
        await user.save();
        
        license.claimedBy = user._id;
        license.claimedAt = new Date();
        await license.save();
        
        res.json({ message: 'Key successfully redeemed!' });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Server Error' });
    }
});

module.exports = router;
