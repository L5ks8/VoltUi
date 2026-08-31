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

app.get('/', (req, res) => {
    res.type('json').send(JSON.stringify({ message: "Volt API is running" }));
});

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

mongoose.connect(process.env.MONGODB_URI || 'mongodb:
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('MongoDB connection error:', err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

const bot = require('./bot');
bot.start();
