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
    local RunService = game:GetService("RunService")

    local function _tween(inst, info, props)
        local t = TweenService:Create(inst, info, props)
        t:Play()
        return t
    end

    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "VoltIntro"
    IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    IntroGui.IgnoreGuiInset = true
    IntroGui.ResetOnSpawn = false
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(IntroGui)
        elseif gethui then IntroGui.Parent = gethui()
        else IntroGui.Parent = game:GetService("CoreGui") end
    end)
    if not IntroGui.Parent then
        IntroGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local IntroMain = Instance.new("Frame")
    IntroMain.Name = "Intro"
    IntroMain.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroMain.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    IntroMain.BorderSizePixel = 0
    IntroMain.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroMain.Size = UDim2.new(0, 800, 0, 600)
    IntroMain.ZIndex = 99999
    IntroMain.Parent = IntroGui

    local IC = Instance.new("UICorner")
    IC.Parent = IntroMain

    local IL = Instance.new("UIListLayout")
    IL.FillDirection = Enum.FillDirection.Horizontal
    IL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    IL.SortOrder = Enum.SortOrder.LayoutOrder
    IL.VerticalAlignment = Enum.VerticalAlignment.Center
    IL.Parent = IntroMain

    local IIcon = Instance.new("ImageLabel")
    IIcon.Name = "Icon"
    IIcon.BackgroundTransparency = 1
    IIcon.BorderSizePixel = 0
    IIcon.Image = "rbxassetid://71942076965693"
    IIcon.Size = UDim2.new(0, 100, 0, 100)
    IIcon.ImageTransparency = 1
    IIcon.ZIndex = 100000
    IIcon.Parent = IntroMain

    local IText = Instance.new("TextLabel")
    IText.Name = "Text"
    IText.BackgroundTransparency = 1
    IText.BorderSizePixel = 0
    IText.FontFace = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    IText.Size = UDim2.new(0, 0, 0, 100)
    IText.Text = "olt"
    IText.TextColor3 = Color3.new(0.984, 0.984, 0.984)
    IText.TextSize = 76
    IText.TextXAlignment = Enum.TextXAlignment.Left
    IText.ClipsDescendants = true
    IText.MaxVisibleGraphemes = 0
    IText.ZIndex = 100000
    IText.Parent = IntroMain

    local introReady = false
    task.spawn(function()
        task.wait(0.2)
        _tween(IIcon, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
        task.wait(1)
        task.wait(0.2)
        _tween(IText, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 150, 0, 100)})
        task.wait(0.8)
        for i = 1, 3 do
            IText.MaxVisibleGraphemes = i
            task.wait(0.15)
        end
        task.wait(0.8)
        introReady = true
    end)

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

    while not introReady do
        task.wait(0.05)
    end

    _tween(IIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
    _tween(IText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
    task.wait(0.3)
    _tween(IntroMain, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    task.wait(0.4)
    IntroGui:Destroy()

    Library._introAlreadyShown = true
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
    if Library._introAlreadyShown then
        Config._introAlreadyShown = true
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
