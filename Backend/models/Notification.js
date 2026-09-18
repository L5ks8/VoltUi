const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true
    },
    message: {
        type: String,
        required: true,
        trim: true
    },
    target: {
        type: String,
        enum: ['all', 'user'],
        default: 'all'
    },
    targetUserId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        default: null
    },
    targetDiscordId: {
        type: String,
        default: null
    },
    targetRobloxId: {
        type: String,
        default: null
    },
    targetUsername: {
        type: String,
        default: null
    }
}, { timestamps: true });

module.exports = mongoose.model('Notification', notificationSchema);
