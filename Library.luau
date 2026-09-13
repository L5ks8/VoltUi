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
    local baseUrl = "https://raw.githubusercontent.com/L5ks8/VoltUi/main/"
    local cache = {}

    local function httpGet(url)
        if game and game.HttpGet then
            return game:HttpGet(url)
        elseif http and http.request then
            return http.request({Url = url, Method = "GET"}).Body
        elseif request then
            return request({Url = url, Method = "GET"}).Body
        end
        error("[VoltUi] No HTTP GET method available")
    end

    local Root = { Name = "VoltUi", __path = "" }
    Root.Parent = nil

    local function makeFolder(name, parent, path)
        local folder = { Name = name, Parent = parent, __path = path }
        parent[name] = folder

        function folder:FindFirstChild(key)
            return self[key]
        end
        function folder:WaitForChild(key)
            return self[key]
        end

        setmetatable(folder, {
            __index = function(self, key)
                local mod = {
                    Name = key,
                    Parent = self,
                    __path = self.__path .. "/" .. key .. ".luau"
                }
                function mod:FindFirstChild(k)
                    return self[k]
                end
                function mod:WaitForChild(k)
                    return self[k]
                end
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
            local mod = {
                Name = key,
                Parent = self,
                __path = key .. ".luau"
            }
            function mod:FindFirstChild(k)
                return self[k]
            end
            function mod:WaitForChild(k)
                return self[k]
            end
            rawset(self, key, mod)
            return mod
        end
    })

    local function virtualRequire(mod)
        local path = (type(mod) == "table" and mod.__path) and mod.__path or tostring(mod)
        if cache[path] then return cache[path] end

        local code
        if isfile and isfile("VoltUi/" .. path) then
            code = readfile("VoltUi/" .. path)
        elseif isfile and isfile(path) then
            code = readfile(path)
        else
            code = httpGet(baseUrl .. path .. "?v=" .. tostring(tick()) .. "_" .. tostring(math.random(100000, 999999)))
        end

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

        local env
        env = setmetatable({
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

    Window = virtualRequire(Core.Window)
    Notifications = virtualRequire(Core.Notifications)
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
    return Window:CreateWindow(Config)
end

function Library:Notify(Config)
    return Notifications.Notify(Config)
end

function Library:Notification(Config)
    return Notifications.Notify(Config)
end

return Library
