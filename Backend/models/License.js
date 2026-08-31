const mongoose = require('mongoose');

const licenseSchema = new mongoose.Schema({
    key: {
        type: String,
        required: true,
        unique: true
    },
    durationMs: {
        type: Number,
        default: null // null for lifetime
    },
    claimedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        default: null
    },
    claimedAt: {
        type: Date,
        default: null
    }
}, { timestamps: true });

module.exports = mongoose.model('License', licenseSchema);
