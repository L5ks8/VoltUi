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

    local mf = Instance.new("Frame")
    mf.AnchorPoint = Vector2.new(0.5, 0.5)
    mf.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    mf.BorderSizePixel = 0
    mf.Position = UDim2.new(0.5, 0, 0.5, 0)
    mf.Size = UDim2.new(0, 800, 0, 600)
    mf.ZIndex = 99999
    mf.ClipsDescendants = true
    mf.Parent = gui

    local mfCorner = Instance.new("UICorner")
    mfCorner.Parent = mf

    local introBox = Instance.new("Frame")
    introBox.BackgroundTransparency = 1
    introBox.AnchorPoint = Vector2.new(0.5, 0.5)
    introBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    introBox.Size = UDim2.new(0, 400, 0, 100)
    introBox.ZIndex = 100000
    introBox.Parent = mf

    local il = Instance.new("UIListLayout")
    il.FillDirection = Enum.FillDirection.Horizontal
    il.HorizontalAlignment = Enum.HorizontalAlignment.Center
    il.SortOrder = Enum.SortOrder.LayoutOrder
    il.VerticalAlignment = Enum.VerticalAlignment.Center
    il.Parent = introBox

    local ic = Instance.new("ImageLabel")
    ic.BackgroundTransparency = 1
    ic.BorderSizePixel = 0
    ic.Image = "rbxassetid://71942076965693"
    ic.Size = UDim2.new(0, 100, 0, 100)
    ic.ImageTransparency = 1
    ic.ZIndex = 100000
    ic.Parent = introBox

    local tx = Instance.new("TextLabel")
    tx.BackgroundTransparency = 1
    tx.BorderSizePixel = 0
    tx.FontFace = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    tx.Size = UDim2.new(0, 0, 0, 100)
    tx.Text = "olt"
    tx.TextColor3 = Color3.new(0.984, 0.984, 0.984)
    tx.TextSize = 76
    tx.TextXAlignment = Enum.TextXAlignment.Left
    tx.ClipsDescendants = true
    tx.MaxVisibleGraphemes = 0
    tx.ZIndex = 100000
    tx.Parent = introBox

    local statusLbl = Instance.new("TextLabel")
    statusLbl.BackgroundTransparency = 1
    statusLbl.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    statusLbl.AnchorPoint = Vector2.new(0, 1)
    statusLbl.Position = UDim2.new(0, 35, 1, -50)
    statusLbl.Size = UDim2.new(1, -70, 0, 25)
    statusLbl.Text = ""
    statusLbl.TextColor3 = Color3.new(1, 1, 1)
    statusLbl.TextSize = 20
    statusLbl.TextTransparency = 1
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.ZIndex = 100000
    statusLbl.Parent = mf

    local barBg = Instance.new("Frame")
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.AnchorPoint = Vector2.new(0, 1)
    barBg.Position = UDim2.new(0, 35, 1, -30)
    barBg.Size = UDim2.new(1, -70, 0, 6)
    barBg.BackgroundTransparency = 1
    barBg.ZIndex = 100000
    barBg.Parent = mf

    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundTransparency = 1
    barFill.ZIndex = 100001
    barFill.Parent = barBg

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    local mfStroke = Instance.new("UIStroke")
    mfStroke.Color = Color3.new(0.353, 0.353, 0.353)
    mfStroke.Transparency = 1
    mfStroke.Parent = mf

    local loadingShown = false
    local allDownloaded = false
    local downloadCount = 0

    task.spawn(function()
        task.wait(0.2)
        _tw(ic, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
        task.wait(1)
        task.wait(0.2)
        _tw(tx, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 150, 0, 100)})
        task.wait(0.8)
        for i = 1, 3 do
            tx.MaxVisibleGraphemes = i
            task.wait(0.15)
        end
        task.wait(0.8)

        _tw(ic, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 1})
        _tw(tx, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1})
        task.wait(0.3)
        introBox.Visible = false

        _tw(mfStroke, TweenInfo.new(0.3), {Transparency = 0})
        _tw(statusLbl, TweenInfo.new(0.3), {TextTransparency = 0})
        _tw(barBg, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        _tw(barFill, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        task.wait(0.3)
        loadingShown = true

        if allDownloaded then
            statusLbl.Text = "Ready!"
            _tw(barFill, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
            task.wait(0.4)
            _tw(mf, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
            _tw(mfStroke, TweenInfo.new(0.4), {Transparency = 1})
            _tw(statusLbl, TweenInfo.new(0.4), {TextTransparency = 1})
            _tw(barBg, TweenInfo.new(0.4), {BackgroundTransparency = 1})
            _tw(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1})
            task.wait(0.4)
            gui:Destroy()
        end
    end)

    local baseUrl = "https://raw.githubusercontent.com/L5ks8/VoltUi/main/"
    local cache = {}

    local function httpGet(url)
        local fname = url:match("main/(.+)$") or "module"
        fname = fname:gsub("%?.+", "")
        statusLbl.Text = "Downloading " .. fname
        local result
        if game and game.HttpGet then
            result = game:HttpGet(url)
        elseif http and http.request then
            result = http.request({Url = url, Method = "GET"}).Body
        elseif request then
            result = request({Url = url, Method = "GET"}).Body
        else
            error("[VoltUi] No HTTP GET method available")
        end
        downloadCount = downloadCount + 1
        _tw(barFill, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Size = UDim2.new(math.min(downloadCount / 15, 0.95), 0, 1, 0)})
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

    statusLbl.Text = "Loading Core..."
    Window = virtualRequire(Core.Window)
    statusLbl.Text = "Loading Notifications..."
    Notifications = virtualRequire(Core.Notifications)
    allDownloaded = true

    while not loadingShown do task.wait(0.05) end

    statusLbl.Text = "Ready!"
    _tw(barFill, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    task.wait(0.4)

    _tw(mf, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    _tw(mfStroke, TweenInfo.new(0.4), {Transparency = 1})
    _tw(statusLbl, TweenInfo.new(0.4), {TextTransparency = 1})
    _tw(barBg, TweenInfo.new(0.4), {BackgroundTransparency = 1})
    _tw(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1})
    task.wait(0.4)
    gui:Destroy()

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
