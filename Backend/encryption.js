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
    if (['POST', 'PUT', 'PATCH'].includes(req.method)) {
        if (req.body && req.body.encrypted) {
            const decryptedBody = decryptPayload(req.body.encrypted);
            if (decryptedBody) {
                req.body = decryptedBody;
            } else {
                return res.status(400).json({ error: "Invalid encrypted payload" });
            }
        } else {
            return res.status(403).json({ error: "All payloads must be AES encrypted." });
        }
    }

    const originalJson = res.json;
    res.json = function(data) {
        const encrypted = encryptPayload(data);
        return originalJson.call(this, { encrypted: encrypted });
    };

    next();
};

module.exports = { encryptionMiddleware, encryptPayload, decryptPayload };
