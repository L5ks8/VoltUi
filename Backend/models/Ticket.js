const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
    sender: {
        type: String,
        enum: ['user', 'support', 'system'],
        required: true
    },
    authorName: {
        type: String,
        required: true
    },
    text: {
        type: String,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

const ticketSchema = new mongoose.Schema({
    ticketId: {
        type: String,
        required: true,
        unique: true
    },
    ticketNumber: {
        type: Number,
        default: 1
    },
    userId: {
        type: String,
        default: null
    },
    username: {
        type: String,
        default: 'User'
    },
    robloxId: {
        type: String,
        default: '0'
    },
    robloxUsername: {
        type: String,
        default: 'RobloxUser'
    },
    hwid: {
        type: String,
        default: 'N/A'
    },
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        default: ''
    },
    status: {
        type: String,
        enum: ['open', 'closed'],
        default: 'open'
    },
    guildId: {
        type: String,
        default: '1542592937307938867'
    },
    channelId: {
        type: String,
        default: null
    },
    messages: [messageSchema],
    createdAt: {
        type: Date,
        default: Date.now
    },
    closedAt: {
        type: Date,
        default: null
    }
});

module.exports = mongoose.model('Ticket', ticketSchema);
