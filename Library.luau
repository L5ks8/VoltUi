local Library = {
    Version = "1.1.4"
}
local isStudio = false
pcall(function()
    isStudio = (typeof(script) == "Instance" and script:FindFirstChild("Core") ~= nil and script.Core:FindFirstChild("Window") ~= nil)
end)

local Window, Notifications

if isStudio then
    pcall(function()
        Window = require(script.Core.Window)
        Notifications = require(script.Core.Notifications)
    end)
end

if not Window then
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")

    local function _tw(inst, info, props)
        local t = TweenService:Create(inst, info, props)
        t:Play()
        return t
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VoltLoader"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui)
        elseif gethui then gui.Parent = gethui()
        else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local baseUrl = "https://raw.githubusercontent.com/L5ks8/VoltUi/main/"
    local cache = {}
    
    local function rawHttpGet(url)
        local req = (type(http) == "table" and http.request) or request or http_request
        if req then
            return req({
                Url = url,
                Method = "GET",
                Headers = { ["Cache-Control"] = "no-cache", ["Pragma"] = "no-cache" }
            }).Body
        elseif game and game.HttpGet then
            return game:HttpGet(url)
        else
            error("[VoltUi] No HTTP GET method available")
        end
    end

    -- Dynamically download and construct the standalone loading screen
    local loadingSource = rawHttpGet(baseUrl .. "Core/Loading.luau?v=" .. tostring(tick()) .. "_" .. tostring(math.random(100000, 999999)))
    local loadingFn, err = loadstring(loadingSource, "@VoltUi/Core/Loading.luau")
    if not loadingFn then error("[VoltUi] Failed to compile loader: " .. tostring(err)) end
    local LoadingClass = loadingFn()
    
    local loadingObj = LoadingClass.Create(gui)
    local downloadCount = 0

    local function httpGet(url)
        local fname = url:match("main/(.+)$") or "module"
        fname = fname:gsub("%?.+", "")
        loadingObj:SetStatus("Downloading " .. fname)
        
        local result = rawHttpGet(url)
        
        downloadCount = downloadCount + 1
        local pct = math.min((downloadCount / 35) * 0.50, 0.50)
        loadingObj:SetProgress(pct)
        return result
    end

    local Root = { Name = "VoltUi", __path = "" }
    Root.Parent = nil

    local function makeFolder(name, parent, path)
        local folder = { Name = name, Parent = parent, __path = path }
        parent[name] = folder
        function folder:FindFirstChild(key) return self[key] end
        function folder:WaitForChild(key) return self[key] end
        setmetatable(folder, {
            __index = function(self, key)
                local mod = { Name = key, Parent = self, __path = self.__path .. "/" .. key .. ".luau" }
                function mod:FindFirstChild(k) return self[k] end
                function mod:WaitForChild(k) return self[k] end
                rawset(self, key, mod)
                return mod
            end
        })
        return folder
    end

    local Core = makeFolder("Core", Root, "Core")
    local Utils = makeFolder("Utils", Root, "Utils")
    local Components = makeFolder("Components", Root, "Components")
    local Themes = makeFolder("Themes", Root, "Themes")

    setmetatable(Root, {
        __index = function(self, key)
            if key == "Core" then return Core end
            if key == "Utils" then return Utils end
            if key == "Components" then return Components end
            if key == "Themes" then return Themes end
            local mod = { Name = key, Parent = self, __path = key .. ".luau" }
            function mod:FindFirstChild(k) return self[k] end
            function mod:WaitForChild(k) return self[k] end
            rawset(self, key, mod)
            return mod
        end
    })

    local function virtualRequire(mod)
        local path = (type(mod) == "table" and mod.__path) and mod.__path or tostring(mod)
        if cache[path] then return cache[path] end
        
        local code = httpGet(baseUrl .. path .. "?v=" .. tostring(tick()) .. "_" .. tostring(math.random(100000, 999999)))
        
        local fn, err
        local ok, res = pcall(loadstring, code, "@VoltUi/" .. path)
        if ok and type(res) == "function" then
            fn = res
        else
            fn, err = loadstring(code)
        end
        if not fn then
            error("[VoltUi] Failed to compile " .. tostring(path) .. ": " .. tostring(err or res))
        end
        local env = setmetatable({
            script = mod,
            require = virtualRequire,
            Core = Core,
            Utils = Utils,
            Components = Components,
            Themes = Themes,
            Root = Root,
        }, { __index = getfenv() })
        setfenv(fn, env)
        local result = fn()
        cache[path] = result
        return result
    end

    loadingObj:SetStatus("Loading Core...")
    Window = virtualRequire(Core.Window)
    loadingObj:SetStatus("Loading Notifications...")
    Notifications = virtualRequire(Core.Notifications)

    Library._loadingObj = loadingObj
    Library._skipLoadingSequence = true
end

function Library:CreateWindow(Config)
    pcall(function()
        local mkfolder = makefolder or (file and file.CreateDir) or nil
        local isf = isfolder or (file and file.Exists) or nil
        local writef = writefile or (file and file.Write) or nil
        local isf2 = isfile or (file and file.Exists) or nil
        if mkfolder and isf then
            if not isf("VoltHub") then mkfolder("VoltHub") end
            if not isf("VoltHub/Configs") then mkfolder("VoltHub/Configs") end
            if not isf("VoltHub/Images") then mkfolder("VoltHub/Images") end
            if not isf("VoltHub/Assets") then mkfolder("VoltHub/Assets") end
        end
        if writef and isf2 then
            if not isf2("VoltHub/Settings.json") then
                writef("VoltHub/Settings.json", "{}")
            end
        end
    end)
    if Library._skipLoadingSequence then
        Config._skipLoadingSequence = true
        Config._externalLoadingScreen = Library._loadingObj
    end
    return Window:CreateWindow(Config)
end

function Library:Notify(Config)
    return Notifications.Notify(Config)
end

function Library:Notification(Config)
    return Notifications.Notify(Config)
end

return Library
