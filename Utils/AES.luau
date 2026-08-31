local AES = {}

local Key = "VoltUiSuperSecretKey1234567890!!" -- 32 bytes
local IV = "VoltUiSecretIV!!" -- 16 bytes

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

    -- Try to encrypt using standard aes-cbc
    local success, result = pcall(function()
        return encrypt("aes-cbc", data, Key, IV)
    end)
    local err1 = not success and result or nil
    
    if not success then
        -- Fallback 2: uppercase AES-CBC
        success, result = pcall(function()
            return encrypt("AES-CBC", data, Key, IV)
        end)
    end
    local err2 = not success and result or nil

    if not success then
        -- Fallback 3: for executors that don't take cipher type (aes-cbc is default)
        success, result = pcall(function()
            return encrypt(data, Key, IV, "CBC")
        end)
    end
    local err3 = not success and result or nil
    
    if not success then
        warn("AES Encryption failed. Errors:")
        warn("1: " .. tostring(err1))
        warn("2: " .. tostring(err2))
        warn("3: " .. tostring(err3))
    end
    
    if success and result then
        -- Some executors return base64 automatically, some raw string.
        -- We can safely try to base64 encode it, if it's already base64, we base64 it again, which is fine as long as we decode it symmetrically.
        -- But let's just encode it to be safe.
        if b64encode then
            local b64Success, b64Result = pcall(function() return b64encode(result) end)
            if b64Success and b64Result then
                return b64Result
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

    local cipher = cipher_b64
    if b64decode then
        local b64Success, b64Result = pcall(function() return b64decode(cipher_b64) end)
        if b64Success and b64Result then
            cipher = b64Result
        end
    end

    local success, result = pcall(function()
        return decrypt("aes-cbc", cipher, Key, IV)
    end)
    local err1 = not success and result or nil
    
    if not success then
        success, result = pcall(function()
            return decrypt("AES-CBC", cipher, Key, IV)
        end)
    end
    local err2 = not success and result or nil
    
    if not success then
        success, result = pcall(function()
            return decrypt(cipher, Key, IV, "CBC")
        end)
    end
    local err3 = not success and result or nil
    
    if not success then
        warn("AES Decryption failed. Errors:")
        warn("1: " .. tostring(err1))
        warn("2: " .. tostring(err2))
        warn("3: " .. tostring(err3))
    end
    
    if success and result then
        return result
    end
    
    return nil
end

return AES
