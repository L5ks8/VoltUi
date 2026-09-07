const CryptoJS = require('crypto-js');

const AES_KEY = CryptoJS.enc.Utf8.parse("VoltUiSuperSecretKey1234567890!!");
const AES_IV = CryptoJS.enc.Utf8.parse("VoltUiSecretIV!!");

const encryptPayload = (data) => {
    const jsonStr = JSON.stringify(data);
    const encrypted = CryptoJS.AES.encrypt(jsonStr, AES_KEY, {
        iv: AES_IV,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });
    return encrypted.toString();
};

const decryptPayload = (ciphertext) => {
    try {
        const decrypted = CryptoJS.AES.decrypt(ciphertext, AES_KEY, {
            iv: AES_IV,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
        const str = decrypted.toString(CryptoJS.enc.Utf8);
        return JSON.parse(str);
    } catch (e) {
        return null;
    }
};

const encryptionMiddleware = (req, res, next) => {
    const noEncryption = req.headers['x-no-encryption'] === 'true' || req.headers['x-bypass-encryption'] === 'true';

    if (['POST', 'PUT', 'PATCH'].includes(req.method)) {
        if (req.body && req.body.encrypted) {
            const decryptedBody = decryptPayload(req.body.encrypted);
            if (decryptedBody) {
                req.body = decryptedBody;
            } else {
                return res.status(400).json({ error: "Invalid encrypted payload" });
            }
        } else if (noEncryption || (req.body && typeof req.body === 'object')) {
            // Allow unencrypted JSON payload
        } else {
            return res.status(403).json({ error: "All payloads must be AES encrypted." });
        }
    }

    const originalJson = res.json;
    res.json = function(data) {
        if (noEncryption) {
            return originalJson.call(this, data);
        }
        const encrypted = encryptPayload(data);
        if (encrypted) {
            return originalJson.call(this, { encrypted: encrypted });
        }
        return originalJson.call(this, data);
    };

    next();
};

module.exports = { encryptionMiddleware, encryptPayload, decryptPayload };

