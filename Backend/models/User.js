const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    password: {
        type: String,
        required: true
    },
    hwid: {
        type: String,
        default: null
    },
    role: {
        type: String,
        enum: ['user', 'admin'],
        default: 'user'
    },
    discordId: {
        type: String,
        default: null
    },
    keys: {
        type: [String],
        default: []
    },
    subscriptionEnd: {
        type: Date,
        default: null
    },
    executions: {
        type: Number,
        default: 0
    },
    hwidResets: {
        type: Number,
        default: 0
    },
    lastReset: {
        type: Date,
        default: null
    },
    resetCode: {
        type: String,
        default: null
    },
    resetCodeExpires: {
        type: Date,
        default: null
    },
    banned: {
        type: Boolean,
        default: false
    }
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
