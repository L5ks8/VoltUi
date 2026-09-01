module.exports = function(req, res, next) {
    const apiKey = req.header('Authorization');
    
    if (!apiKey) {
        return res.status(401).json({ success: false, message: 'No API key, authorization denied' });
    }

    if (apiKey !== process.env.ADMIN_API_KEY) {
        return res.status(403).json({ success: false, message: 'Invalid API key' });
    }

    next();
};
