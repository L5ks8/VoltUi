local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)

local Notifications = {}
Notifications.Container = nil

-- Configuration
local Config = {
    Width = 320,
    BaseHeight = 65,
    Padding = 15,
    Gap = 10,
    SuccessColor = Color3.fromRGB(39, 174, 96),
    SuccessIconBg = Color3.fromRGB(25, 45, 35),
    ErrorColor = Color3.fromRGB(231, 76, 60),
    ErrorIconBg = Color3.fromRGB(55, 25, 25),
    BgColor = Color3.fromRGB(20, 25, 22),
    StrokeColor = Color3.fromRGB(40, 50, 45)
}

function Notifications.Init(ParentGui)
    local Container = Instance.new("Frame")
    Container.Name = "NotificationContainer"
    Container.BackgroundTransparency = 1
    Container.AnchorPoint = Vector2.new(1, 1)
    Container.Position = UDim2.new(1, -20, 1, -20)
    Container.Size = UDim2.new(0, Config.Width, 1, -40)
    Container.ZIndex = 100
    Container.ClipsDescendants = false
    Container.Parent = ParentGui

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Padding = UDim.new(0, Config.Gap)
    Layout.Parent = Container

    Notifications.Container = Container
end

function Notifications.Notify(options)
    if not Notifications.Container then return end

    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 3
    local type = options.Type or "Success" -- "Success" or "Error"

    local isError = (string.lower(type) == "error")
    local mainColor = isError and Config.ErrorColor or Config.SuccessColor
    local iconAsset = isError and "rbxassetid://85824584748112" or "rbxassetid://118922551501473" -- X or Check
    
    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "NotificationWrapper"
    Wrapper.BackgroundTransparency = 1
    Wrapper.Size = UDim2.new(1, 0, 0, Config.BaseHeight)
    Wrapper.Parent = Notifications.Container

    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
    Notif.BackgroundColor3 = Config.BgColor
    Notif.Size = UDim2.new(1, 0, 1, 0)
    Notif.Position = UDim2.new(1, Config.Width, 0, 0) -- Start off-screen right
    Notif.BackgroundTransparency = 0.05
    Notif.Parent = Wrapper
    
    local Accent = Instance.new("Frame")
    Accent.Name = "Accent"
    Accent.BackgroundColor3 = mainColor
    Accent.BorderSizePixel = 0
    Accent.Size = UDim2.new(0, 3, 1, 0)
    Accent.Parent = Notif
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 6)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Config.StrokeColor
    Stroke.Parent = Notif

    -- Icon Background
    local IconBg = Instance.new("Frame")
    IconBg.BackgroundTransparency = 1
    IconBg.Size = UDim2.new(0, 30, 0, 30)
    IconBg.Position = UDim2.new(0, Config.Padding, 0.5, -15)
    IconBg.Parent = Notif

    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Image = iconAsset
    Icon.ImageColor3 = Color3.new(1, 1, 1) -- White icons
    Icon.Parent = IconBg

    -- Title
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Size = UDim2.new(1, -90, 0, 18)
    TitleLbl.Position = UDim2.new(0, Config.Padding + 40, 0, 14)
    TitleLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.new(1, 1, 1)
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Notif

    -- Content
    local ContentLbl = Instance.new("TextLabel")
    ContentLbl.BackgroundTransparency = 1
    ContentLbl.Size = UDim2.new(1, -90, 0, 14)
    ContentLbl.Position = UDim2.new(0, Config.Padding + 40, 0, 34)
    ContentLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ContentLbl.Text = content
    ContentLbl.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    ContentLbl.TextSize = 12
    ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
    ContentLbl.TextWrapped = true
    ContentLbl.Parent = Notif

    -- Close Button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, -Config.Padding, 0.5, 0)
    CloseBtn.Image = "rbxassetid://121170570745612" -- X icon
    CloseBtn.ImageColor3 = Color3.new(0.5, 0.5, 0.5)
    CloseBtn.Parent = Notif

    local closed = false

    local function CloseNotif()
        if closed then return end
        closed = true
        Tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, Config.Width, 0, 0)})
        task.delay(0.3, function()
            Wrapper:Destroy()
        end)
    end

    CloseBtn.MouseButton1Click:Connect(CloseNotif)

    -- Animate In
    Tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})

    -- Auto Close
    task.delay(duration, CloseNotif)
end

return Notifications
