local Library = {}

local isStudio = (typeof(script) == "Instance")
local Window, Notifications

if isStudio then
    Window = require(script.Core.Window)
    Notifications = require(script.Core.Notifications)
else
    -- Virtual loader
    local baseUrl = "https://raw.githubusercontent.com/L5ks8/VoltUi/main/"
    local cache = {}

    local Root = { Name = "VoltUi", __path = "" }
    Root.Parent = nil

    local function makeFolder(name, parent, path)
        local folder = { Name = name, Parent = parent, __path = path }
        parent[name] = folder
        setmetatable(folder, {
            __index = function(self, key)
                local mod = {
                    Name = key,
                    Parent = self,
                    __path = self.__path .. "/" .. key .. ".luau"
                }
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
            code = game:HttpGet(baseUrl .. path)
        end

        local fn, err = loadstring(code, path)
        if not fn then error("Failed to compile " .. path .. ": " .. tostring(err)) end

        local env
        env = setmetatable({
            script = mod,
            require = virtualRequire,
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
    return Window:CreateWindow(Config)
end

function Library:Notify(Config)
    return Notifications.Notify(Config)
end

function Library:Notification(Config)
    return Notifications.Notify(Config)
end

return Library
