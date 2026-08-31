const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

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
            subscriptionEnd: subEnd
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
        
        // HWID Locking / Updating
        if (!user.hwid || user.hwid !== hwid) {
            // Update HWID on successful login from a new device
            user.hwid = hwid;
            await user.save();
        }
        
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

module.exports = router;
