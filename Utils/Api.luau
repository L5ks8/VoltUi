local HttpService = game:GetService("HttpService")

local Api = {}
Api.BaseUrl = "http://localhost:3000/api"
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
        options.Body = HttpService:JSONEncode(body)
    end

    local success, res = pcall(function()
        return requestFunc(options)
    end)

    if success and res then
        return HttpService:JSONDecode(res.Body)
    end
    return nil
end

function Api.GetHWID()
    -- Some executors support getting HWID
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

function Api.Register(username, email, password, licenseKey)
    local hwid = Api.GetHWID()
    local res = Api.Request("/auth/register", "POST", {
        username = username,
        email = email,
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
