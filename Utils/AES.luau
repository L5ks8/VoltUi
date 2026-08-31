local AES = {}

local Key = "VoltUiSuperSecretKey1234567890!!" -- 32 bytes
local IV = "VoltUiSecretIV!!" -- 16 bytes
local KeyB64 = "Vm9sdFVpU3VwZXJTZWNyZXRLZXkxMjM0NTY3ODkwISE="
local IVB64 = "Vm9sdFVpU2VjcmV0SVYhIQ=="

function AES.encrypt(data)
    local encrypt = (crypt and crypt.custom and crypt.custom.encrypt) 
                 or (syn and syn.crypt and syn.crypt.custom and syn.crypt.custom.encrypt)
                 or (crypt and crypt.encrypt)
    
    local b64encode = (crypt and crypt.base64encode) 
                   or (syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.encode) 
                   or (base64_encode)
                   or (crypt and crypt.base64 and crypt.base64.encode)
                   
    if not encrypt then
        warn("Executor does not support AES encryption!")
        return nil
    end

    -- Try signature with Base64 Key and IV [Delta/Macsploit expect Key/IV to be base64 strings]
    local success, result = pcall(function()
        return encrypt(data, KeyB64, IVB64, "CBC")
    end)
    local err0 = not success and result or nil

    if not success then
        success, result = pcall(function()
            return encrypt("aes-cbc", data, KeyB64, IVB64)
        end)
    end
    local err0b = not success and result or nil

    if not success then
        -- Try signature: encrypt(data, key, iv, mode) with raw strings
        success, result = pcall(function()
            return encrypt(data, Key, IV, "CBC")
        end)
    end
    local err1 = not success and result or nil
    
    if not success then
        -- Try signature: encrypt(algorithm, data, key, iv) with raw strings
        success, result = pcall(function()
            return encrypt("aes-cbc", data, Key, IV)
        end)
    end
    local err2 = not success and result or nil

    if not success then
        success, result = pcall(function()
            return encrypt("AES-CBC", data, Key, IV)
        end)
    end
    local err3 = not success and result or nil
    
    if not success then
        warn("AES Encryption failed. Errors:")
        warn("0 (B64 Key/IV, CBC): " .. tostring(err0))
        warn("0b (B64 Key/IV, aes-cbc): " .. tostring(err0b))
        warn("1 (Raw Key/IV, CBC): " .. tostring(err1))
        warn("2 (Raw Key/IV, aes-cbc): " .. tostring(err2))
        warn("3 (Raw Key/IV, AES-CBC): " .. tostring(err3))
    end
    
    if success and result then
        -- Some executors return raw string instead of base64. 
        -- We must return base64 to the server.
        -- We can try to decode it from base64; if it fails, it's raw, so we encode it.
        if b64encode and b64decode then
            local isBase64 = pcall(function() return b64decode(result) end)
            if not isBase64 then
                local b64Success, b64Result = pcall(function() return b64encode(result) end)
                if b64Success and b64Result then
                    return b64Result
                end
            end
        end
        return result
    end
    
    return nil
end

function AES.decrypt(cipher_b64)
    local decrypt = (crypt and crypt.custom and crypt.custom.decrypt) 
                 or (syn and syn.crypt and syn.crypt.custom and syn.crypt.custom.decrypt)
                 or (crypt and crypt.decrypt)
                 
    local b64decode = (crypt and crypt.base64decode) 
                   or (syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode) 
                   or (base64_decode)
                   or (crypt and crypt.base64 and crypt.base64.decode)

    if not decrypt then
        warn("Executor does not support AES decryption!")
        return nil
    end

    -- We will try both the raw base64 string and the decoded raw bytes.
    -- First, let's try with base64 Key and IV, since some executors expect base64 for these arguments
    local success, result = pcall(function()
        return decrypt(cipher_b64, KeyB64, IVB64, "CBC")
    end)
    local err0 = not success and result or nil
    
    if not success then
        success, result = pcall(function()
            return decrypt("aes-cbc", cipher_b64, KeyB64, IVB64)
        end)
    end
    local err0b = not success and result or nil

    if not success then
        success, result = pcall(function()
            return decrypt(cipher_b64, Key, IV, "CBC")
        end)
    end
    local err1 = not success and result or nil
    
    if not success then
        success, result = pcall(function()
            return decrypt("aes-cbc", cipher_b64, Key, IV)
        end)
    end
    local err2 = not success and result or nil

    -- If that failed, maybe it expects raw bytes instead of base64 string
    local cipher_raw = cipher_b64
    if b64decode then
        pcall(function() cipher_raw = b64decode(cipher_b64) end)
    end

    if not success then
        success, result = pcall(function()
            return decrypt(cipher_raw, Key, IV, "CBC")
        end)
    end
    local err3 = not success and result or nil
    
    if not success then
        success, result = pcall(function()
            return decrypt("aes-cbc", cipher_raw, Key, IV)
        end)
    end
    local err4 = not success and result or nil

    if not success then
        warn("AES Decryption failed. Errors:")
        warn("0 (B64 Data/Key/IV, CBC): " .. tostring(err0))
        warn("0b (B64 Data/Key/IV, aes-cbc): " .. tostring(err0b))
        warn("1 (B64 Data, Raw Key/IV, CBC): " .. tostring(err1))
        warn("2 (B64 Data, Raw Key/IV, aes-cbc): " .. tostring(err2))
        warn("3 (Raw Data/Key/IV, CBC): " .. tostring(err3))
        warn("4 (Raw Data/Key/IV, aes-cbc): " .. tostring(err4))
    end
    
    if success and result then
        return result
    end
    
    return nil
end

return AES
