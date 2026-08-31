const mongoose = require('mongoose');

const licenseSchema = new mongoose.Schema({
    key: {
        type: String,
        required: true,
        unique: true
    },
    durationMs: {
        type: Number,
        default: null
    },
    claimedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        default: null
    },
    claimedAt: {
        type: Date,
        default: null
    },
    discordId: {
        type: String,
        default: null
    },
    isFree: {
        type: Boolean,
        default: false
    }
}, { timestamps: true });

module.exports = mongoose.model('License', licenseSchema);
