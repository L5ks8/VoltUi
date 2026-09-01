local HttpService = game:GetService("HttpService")
local AES = require(script.Parent.AES)

local Api = {}
Api.BaseUrl = "https://volthub-18b3.onrender.com/api"
Api.Token = nil
Api.UserData = nil

function Api.Request(endpoint, method, body)
    local requestFunc = request or http_request or (http and http.request) or syn and syn.request
    if not requestFunc then
        warn("HTTP Requests are not supported by this executor.")
        return nil
    end

    local headers = {
        ["Content-Type"] = "application/json"
    }
    if Api.Token then
        headers["Authorization"] = "Bearer " .. Api.Token
    end

    local options = {
        Url = Api.BaseUrl .. endpoint,
        Method = method or "GET",
        Headers = headers
    }
    if body then
        local jsonStr = HttpService:JSONEncode(body)
        local encryptedBody = AES.encrypt(jsonStr)
        
        if encryptedBody then
            options.Body = HttpService:JSONEncode({ encrypted = encryptedBody })
        else
            warn("Failed to encrypt payload, sending unencrypted (this will likely be rejected by the server).")
            options.Body = jsonStr
        end
    end

    local success, res = pcall(function()
        return requestFunc(options)
    end)

    if success and res and res.Body then
        local decodeSuccess, decoded = pcall(function()
            return HttpService:JSONDecode(res.Body)
        end)
        
        if decodeSuccess then
            if decoded.encrypted then
                local decryptedStr = AES.decrypt(decoded.encrypted)
                if decryptedStr then
                    local finalSuccess, finalDecoded = pcall(function() return HttpService:JSONDecode(decryptedStr) end)
                    if finalSuccess then
                        return finalDecoded
                    end
                end
                return { error = "Failed to decrypt server response" }
            end
            
            return decoded 
        else
            return { error = "Server returned invalid JSON: " .. tostring(res.Body) }
        end
    end
    return nil
end

function Api.GetHWID()
    local gethwid = gethwid or get_hwid or function() return "DUMMY_HWID_123" end
    local success, hwid = pcall(gethwid)
    if success and hwid then return hwid end
    return "DUMMY_HWID_123"
end

function Api.GetToken()
    if Api.Token then return Api.Token end
    local readfileFunc = readfile or (file and file.Read) or nil
    if readfileFunc then
        local success, token = pcall(function() return readfileFunc("VoltToken.txt") end)
        if success and token and token ~= "" then
            Api.Token = token
            return token
        end
    end
    return nil
end

function Api.SaveToken(token)
    Api.Token = token
    local writefileFunc = writefile or (file and file.Write) or nil
    if writefileFunc then
        pcall(function() writefileFunc("VoltToken.txt", token) end)
    end
end

function Api.Login(username, password)
    local hwid = Api.GetHWID()
    local res = Api.Request("/auth/login", "POST", {
        username = username,
        password = password,
        hwid = hwid
    })

    if res and res.token then
        Api.SaveToken(res.token)
        return true, "Success"
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.Register(username, password, licenseKey)
    local hwid = Api.GetHWID()
    local res = Api.Request("/auth/register", "POST", {
        username = username,
        password = password,
        licenseKey = licenseKey,
        hwid = hwid
    })

    if res and res.message then
        return true, res.message
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.ForgotPassword(username)
    local res = Api.Request("/auth/forgot-password", "POST", {
        username = username
    })
    
    if res and res.message then
        return true, res.message
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.ResetPassword(username, code, newPassword)
    local res = Api.Request("/auth/reset-password", "POST", {
        username = username,
        code = code,
        newPassword = newPassword
    })
    
    if res and res.message then
        return true, res.message
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.RedeemKey(key)
    if not Api.GetToken() then return false, "Not authenticated" end
    local res = Api.Request("/user/redeem", "POST", { licenseKey = key, key = key })
    if res and res.message then
        return true, res.message
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.FetchMe()
    if not Api.GetToken() then return nil end
    local meRes = Api.Request("/user/me", "GET")
    if meRes and meRes.user then
        Api.UserData = meRes.user
        return Api.UserData
    end
    return nil
end

return Api
