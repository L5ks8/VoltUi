const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Register Route
router.post('/register', async (req, res) => {
    try {
        const { username, email, password, licenseKey, hwid } = req.body;
        
        if (licenseKey !== "Voltontop") {
            return res.status(400).json({ error: 'Ungültiger License Key.' });
        }
        
        // Check if user exists
        let user = await User.findOne({ $or: [{ username }, { email }] });
        if (user) {
            return res.status(400).json({ error: 'Benutzername oder Email existiert bereits.' });
        }
        
        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);
        
        user = new User({
            username,
            email,
            password: hashedPassword,
            hwid: hwid || null
        });
        
        await user.save();
        res.json({ message: 'Erfolgreich registriert!' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
});

// Login Route
router.post('/login', async (req, res) => {
    try {
        const { username, password, hwid } = req.body;
        
        // Find user
        let user = await User.findOne({ username });
        if (!user) {
            return res.status(400).json({ error: 'Falsche Zugangsdaten.' });
        }
        
        // Check password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ error: 'Falsche Zugangsdaten.' });
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
        res.status(500).send('Server error');
    }
});

module.exports = router;
