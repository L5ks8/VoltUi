local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local Notifications = {}
Notifications.Container = nil
Notifications.ParentGui = nil

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

function Notifications.Init(ParentGui)
    Notifications.ParentGui = ParentGui

    if Notifications.Container and Notifications.Container.Parent then
        Notifications.Container:Destroy()
    end

    local Container = Instance.new("Frame")
    Container.Name = "VoltNotifications"
    Container.BackgroundTransparency = 1
    Container.AnchorPoint = Vector2.new(1, 1)
    Container.Position = UDim2.new(1, -20, 1, -20)
    Container.Size = UDim2.new(0, 320, 1, -40)
    Container.ZIndex = 10000
    Container.ClipsDescendants = false
    Container.Parent = ParentGui

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Container

    Notifications.Container = Container
end

function Notifications.Notify(options)
    options = options or {}
    local ParentGui = Notifications.ParentGui or (Notifications.Container and Notifications.Container.Parent)
    if not Notifications.Container or not Notifications.Container.Parent then
        if ParentGui then
            Notifications.Init(ParentGui)
        else
            return
        end
    end

    local title = options.Title or options.Header or "Notification"
    local content = options.Content or options.Description or options.Text or ""
    local duration = options.Duration
    if duration == nil then
        duration = math.clamp((#content * 0.05) + 3, 3, 10)
    end
    local notifType = string.lower(options.Type or "info")

    local accentColor = Color3.fromRGB(196, 36, 104)
    local iconAsset = "rbxassetid://10709791437"

    if notifType == "success" then
        accentColor = Color3.fromRGB(46, 204, 113)
        iconAsset = "rbxassetid://10709790387"
    elseif notifType == "error" then
        accentColor = Color3.fromRGB(231, 76, 60)
        iconAsset = "rbxassetid://10709790537"
    elseif notifType == "warning" then
        accentColor = Color3.fromRGB(241, 196, 15)
        iconAsset = "rbxassetid://10709790537"
    end

    if options.Icon then
        if type(options.Icon) == "number" then
            iconAsset = "rbxassetid://" .. tostring(options.Icon)
        elseif type(options.Icon) == "string" then
            iconAsset = string.find(options.Icon, "rbxassetid://") and options.Icon or ("rbxassetid://" .. options.Icon)
        end
    end

    local contentHeight = 16
    if content ~= "" then
        local bounds = TextService:GetTextSize(content, 12, Enum.Font.GothamMedium, Vector2.new(280, 2000))
        contentHeight = math.max(16, bounds.Y + 4)
    end
    local targetHeight = 36 + contentHeight + 14

    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "NotificationWrapper"
    Wrapper.BackgroundTransparency = 1
    Wrapper.BorderSizePixel = 0
    Wrapper.ClipsDescendants = false
    Wrapper.Size = UDim2.new(1, 0, 0, 0)
    Wrapper.Parent = Notifications.Container

    local Notif = Instance.new("Frame")
    Notif.Name = "NotificationCard"
    Notif.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Notif.BackgroundTransparency = 1
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.Size = UDim2.new(1, 0, 1, 0)
    Notif.Parent = Wrapper

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(48, 48, 48)
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    Stroke.Parent = Notif

    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    Shadow.Size = UDim2.new(1, 6, 1, 6)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 1
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = Notif.ZIndex - 1
    Shadow.Parent = Wrapper
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 10)
    ShadowCorner.Parent = Shadow

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "Header"
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Size = UDim2.new(1, 0, 0, 24)
    HeaderFrame.Position = UDim2.new(0, 0, 0, 8)
    HeaderFrame.Parent = Notif

    local HeaderPad = Instance.new("UIPadding")
    HeaderPad.PaddingLeft = UDim.new(0, 12)
    HeaderPad.PaddingRight = UDim.new(0, 10)
    HeaderPad.Parent = HeaderFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(0, 0, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Image = iconAsset
    Icon.ImageColor3 = Color3.fromRGB(245, 245, 250)
    Icon.ImageTransparency = 1
    Icon.Parent = HeaderFrame

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Name = "Title"
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Size = UDim2.new(1, -90, 1, 0)
    TitleLbl.Position = UDim2.new(0, 22, 0, 0)
    TitleLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
    TitleLbl.TextSize = 13
    TitleLbl.TextTransparency = 1
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextYAlignment = Enum.TextYAlignment.Center
    TitleLbl.Parent = HeaderFrame

    local TimeLbl = Instance.new("TextLabel")
    TimeLbl.Name = "Time"
    TimeLbl.BackgroundTransparency = 1
    TimeLbl.Size = UDim2.new(0, 50, 1, 0)
    TimeLbl.Position = UDim2.new(1, -22, 0, 0)
    TimeLbl.AnchorPoint = Vector2.new(1, 0)
    TimeLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TimeLbl.Text = "now"
    TimeLbl.TextColor3 = Color3.fromRGB(125, 125, 135)
    TimeLbl.TextSize = 11
    TimeLbl.TextTransparency = 1
    TimeLbl.TextXAlignment = Enum.TextXAlignment.Right
    TimeLbl.TextYAlignment = Enum.TextYAlignment.Center
    TimeLbl.Parent = HeaderFrame

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "Close"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.Position = UDim2.new(1, 0, 0.5, 0)
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Image = "rbxassetid://10747384394"
    CloseBtn.ImageColor3 = Color3.fromRGB(140, 140, 150)
    CloseBtn.ImageTransparency = 1
    CloseBtn.Parent = HeaderFrame

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Name = "Description"
    DescLbl.BackgroundTransparency = 1
    DescLbl.Position = UDim2.new(0, 12, 0, 32)
    DescLbl.Size = UDim2.new(1, -24, 0, contentHeight)
    DescLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    DescLbl.Text = content
    DescLbl.TextColor3 = Color3.fromRGB(175, 175, 185)
    DescLbl.TextSize = 12
    DescLbl.TextTransparency = 1
    DescLbl.TextWrapped = true
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.TextYAlignment = Enum.TextYAlignment.Top
    DescLbl.Parent = Notif

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.BackgroundColor3 = accentColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.Parent = Notif

    local entranceInfo = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    Tween(Wrapper, entranceInfo, {Size = UDim2.new(1, 0, 0, targetHeight)})
    Tween(Notif, entranceInfo, {BackgroundTransparency = 0.08})
    Tween(Stroke, entranceInfo, {Transparency = 0.4})
    Tween(Shadow, entranceInfo, {BackgroundTransparency = 0.75})
    Tween(Icon, entranceInfo, {ImageTransparency = 0})
    Tween(TitleLbl, entranceInfo, {TextTransparency = 0})
    Tween(TimeLbl, entranceInfo, {TextTransparency = 0})
    Tween(CloseBtn, entranceInfo, {ImageTransparency = 0})
    Tween(DescLbl, entranceInfo, {TextTransparency = 0})

    local startTime = tick()
    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        if not Wrapper.Parent then
            if renderConn then renderConn:Disconnect() end
            return
        end
        local elapsed = tick() - startTime
        if elapsed < 4 then
            TimeLbl.Text = "now"
        elseif elapsed < 60 then
            TimeLbl.Text = math.floor(elapsed) .. "s ago"
        elseif elapsed < 3600 then
            TimeLbl.Text = math.floor(elapsed / 60) .. "m ago"
        else
            TimeLbl.Text = math.floor(elapsed / 3600) .. "h ago"
        end
    end)

    if duration > 0 then
        Tween(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
    else
        ProgressBar.Visible = false
    end

    local closed = false
    local function Dismiss()
        if closed then return end
        closed = true
        if renderConn then renderConn:Disconnect() end

        local exitInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
        Tween(Notif, exitInfo, {BackgroundTransparency = 1})
        Tween(Stroke, exitInfo, {Transparency = 1})
        Tween(Shadow, exitInfo, {BackgroundTransparency = 1})
        Tween(Icon, exitInfo, {ImageTransparency = 1})
        Tween(TitleLbl, exitInfo, {TextTransparency = 1})
        Tween(TimeLbl, exitInfo, {TextTransparency = 1})
        Tween(CloseBtn, exitInfo, {ImageTransparency = 1})
        Tween(DescLbl, exitInfo, {TextTransparency = 1})
        Tween(ProgressBar, exitInfo, {BackgroundTransparency = 1})
        
        local tw = Tween(Wrapper, exitInfo, {Size = UDim2.new(1, 0, 0, 0)})
        tw.Completed:Connect(function()
            Wrapper:Destroy()
        end)
    end

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(140, 140, 150)})
    end)
    CloseBtn.MouseButton1Click:Connect(Dismiss)

    if duration > 0 then
        task.delay(duration, Dismiss)
    end

    return {
        Dismiss = Dismiss,
        Wrapper = Wrapper,
        Notif = Notif,
    }
end

return Notifications
