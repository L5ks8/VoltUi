const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');

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

router.get('/me', authMiddleware, async (req, res) => {
    try {
        const user = await User.findById(req.user.id).select('-password').lean();
        if (!user) {
            return res.status(404).json({ msg: 'User not found' });
        }

        if (user.banned) {
            return res.status(403).json({ msg: 'You are banned from using Volt.' });
        }

        if (user.subscriptionEnd) {
            const ms = user.subscriptionEnd.getTime() - Date.now();
            if (ms > 0) {
                const days = Math.floor(ms / (1000 * 60 * 60 * 24));
                const hours = Math.floor((ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                user.remaining = days > 0 ? `${days}d ${hours}h` : `${hours}h`;
            } else {
                user.remaining = 'Expired';
            }
        }

        const License = require('../models/License');
        const licenses = await License.find({ claimedBy: user._id }).lean();

        const validLicenses = [];
        for (const lic of licenses) {
            let isExpired = false;
            if (lic.durationMs !== null && lic.claimedAt) {
                const expiresAt = new Date(lic.claimedAt).getTime() + lic.durationMs;
                if (expiresAt < Date.now()) {
                    isExpired = true;
                }
            }

            if (isExpired) {
                await License.deleteOne({ _id: lic._id });
                await User.updateOne({ _id: user._id }, { $pull: { keys: lic.key } });
            } else {
                validLicenses.push(lic);
            }
        }

        const formattedLicenses = validLicenses.map(lic => {
            let claimedStr = 'N/A';
            let expiresStr = 'N/A';
            if (lic.claimedAt) {
                const d = new Date(lic.claimedAt);
                claimedStr = `${d.getDate()}.${d.getMonth() + 1}.${d.getFullYear()}`;
                if (lic.durationMs === null) {
                    expiresStr = 'Lifetime';
                } else if (lic.durationMs) {
                    const e = new Date(d.getTime() + lic.durationMs);
                    expiresStr = `${e.getDate()}.${e.getMonth() + 1}.${e.getFullYear()}`;
                }
            }
            return {
                ...lic,
                claimedStr,
                expiresStr
            };
        });

        user.licenseObjects = formattedLicenses;

        res.json({ user });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

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

        if (license.discordId) {
            if (user.discordId && user.discordId !== license.discordId) {
                return res.status(400).json({ error: 'This key is linked to a different Discord account.' });
            }
            if (!user.discordId) {
                user.discordId = license.discordId;
            }
        }

        if (license.durationMs === null) {
            user.subscriptionEnd = null;
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
