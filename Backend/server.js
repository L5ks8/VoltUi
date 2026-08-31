require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const { encryptionMiddleware } = require('./encryption');

const app = express();
app.use(express.json());
app.use(cors());

// Basic sanity check route
app.get('/', (req, res) => {
    // Send raw json here to not trigger encryption wrapper if accessed in browser
    res.type('json').send(JSON.stringify({ message: "Volt API is running" }));
});

// Apply Encryption Middleware globally to all API routes
app.use('/api', encryptionMiddleware);

// Rate Limiting for Auth Routes (DDoS protection)
const authLimiter = rateLimit({
    windowMs: 1 * 60 * 1000, // 1 minute
    max: 5, // 5 requests per IP per minute
    message: { error: "Too many requests from this IP, please try again after a minute." },
    standardHeaders: true,
    legacyHeaders: false
});

// Apply stricter rate limit to authentication endpoints
app.use('/api/auth/login', authLimiter);
app.use('/api/auth/register', authLimiter);
app.use('/api/auth/forgot-password', authLimiter);
app.use('/api/auth/reset-password', authLimiter);

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/user', require('./routes/user'));

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/volt')
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('MongoDB connection error:', err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// Start Discord Bot
const bot = require('./bot');
bot.start();
