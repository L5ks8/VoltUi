require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const { encryptionMiddleware } = require('./encryption');

const app = express();
app.set('trust proxy', 1);
app.use(express.json());
app.use(cors());

const requireApiKey = require('./middleware/requireApiKey');

app.get('/', (req, res) => {
    res.type('json').send(JSON.stringify({ message: "Volt API is running" }));
});

app.get('/api', (req, res) => {
    res.type('json').send(JSON.stringify({
        status: "online",
        name: "Volt API",
        version: "1.0.0",
        message: "Volt API is operational"
    }));
});

app.get('/version', (req, res) => {
    res.type('json').send(JSON.stringify({
        version: "1.0.0"
    }));
});

app.get('/api/version', (req, res) => {
    res.type('json').send(JSON.stringify({
        version: "1.0.0"
    }));
});

const License = require('./models/License');

const verifyKeyHandler = async (req, res) => {
    try {
        const key = req.body && (req.body.key || req.body.licenseKey);
        if (!key || typeof key !== 'string') {
            return res.status(400).json({ valid: false, message: 'No key provided.' });
        }
        const cleanKey = key.trim();
        const license = await License.findOne({ key: cleanKey });
        if (!license) {
            return res.status(400).json({ valid: false, message: 'Invalid key.' });
        }
        if (license.claimedAt && license.durationMs) {
            const expireTime = new Date(license.claimedAt.getTime() + license.durationMs);
            if (Date.now() > expireTime.getTime()) {
                return res.status(400).json({ valid: false, message: 'Key has expired.' });
            }
        }
        if (!license.claimedAt) {
            license.claimedAt = new Date();
            await license.save();
        }
        return res.json({ valid: true, message: 'Key verified successfully!' });
    } catch (err) {
        console.error('Verify key error:', err);
        return res.status(500).json({ valid: false, message: 'Server error' });
    }
};

app.post('/check-key', verifyKeyHandler);
app.post('/api/check-key', verifyKeyHandler);

// Developer API (unencrypted, uses Admin API Key)
app.use('/api/v1', requireApiKey, require('./routes/adminApi'));

app.use('/api', encryptionMiddleware);

const authLimiter = rateLimit({
    windowMs: 1 * 60 * 1000,
    max: 5,
    message: { error: "Too many requests from this IP, please try again after a minute." },
    standardHeaders: true,
    legacyHeaders: false
});

app.use('/api/auth/login', authLimiter);
app.use('/api/auth/register', authLimiter);
app.use('/api/auth/forgot-password', authLimiter);
app.use('/api/auth/reset-password', authLimiter);

app.use('/api/auth', require('./routes/auth'));
app.use('/api/user', require('./routes/user'));

mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/voltui')
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('MongoDB connection error:', err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

const bot = require('./bot');
bot.start();
