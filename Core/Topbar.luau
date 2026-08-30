local Topbar = {}
local TweenService = game:GetService("TweenService")

function Topbar.Create(Main, Config)
    local Title = Config.Title or "Volt - 1.0.0"
    
    local TopbarFrame = Instance.new("Frame")
    TopbarFrame.Name = "Topbar"
    TopbarFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    TopbarFrame.BorderColor3 = Color3.new(0, 0, 0)
    TopbarFrame.BorderSizePixel = 0
    TopbarFrame.Size = UDim2.new(0, 800, 0, 30)
    TopbarFrame.Parent = Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.BottomLeftRadius = UDim.new(0, 0)
    TopbarCorner.BottomRightRadius = UDim.new(0, 0)
    TopbarCorner.Parent = TopbarFrame
    
    local TopbarStroke = Instance.new("UIStroke")
    TopbarStroke.Color = Color3.new(0.216, 0.216, 0.216)
    TopbarStroke.Parent = TopbarFrame
    
    local TopbarIcon = Instance.new("Frame")
    TopbarIcon.Name = "Icon"
    TopbarIcon.AnchorPoint = Vector2.new(0, 0.5)
    TopbarIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    TopbarIcon.BackgroundTransparency = 1
    TopbarIcon.BorderColor3 = Color3.new(0, 0, 0)
    TopbarIcon.BorderSizePixel = 0
    TopbarIcon.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarIcon.Size = UDim2.new(0, 30, 0, 30)
    TopbarIcon.Parent = TopbarFrame
    
    local TopbarLogo = Instance.new("ImageLabel")
    TopbarLogo.Name = "Logo"
    TopbarLogo.BackgroundColor3 = Color3.new(1, 1, 1)
    TopbarLogo.BackgroundTransparency = 1
    TopbarLogo.BorderColor3 = Color3.new(0, 0, 0)
    TopbarLogo.BorderSizePixel = 0
    TopbarLogo.Image = "rbxassetid://71942076965693"
    TopbarLogo.Size = UDim2.new(0, 20, 0, 20)
    TopbarLogo.Parent = TopbarIcon
    
    local TopbarIconLayout = Instance.new("UIListLayout")
    TopbarIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TopbarIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TopbarIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TopbarIconLayout.Parent = TopbarIcon
    
    local Actions = Instance.new("Frame")
    Actions.Name = "Actions"
    Actions.BackgroundColor3 = Color3.new(1, 1, 1)
    Actions.BackgroundTransparency = 1
    Actions.BorderColor3 = Color3.new(0, 0, 0)
    Actions.BorderSizePixel = 0
    Actions.Position = UDim2.new(0.861, 0, 0, 0)
    Actions.Size = UDim2.new(0, 111, 0, 30)
    Actions.Parent = TopbarFrame
    
    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsLayout.Parent = Actions
    
    local Minimize = Instance.new("ImageButton")
    Minimize.Name = "Minimize"
    Minimize.BackgroundColor3 = Color3.new(1, 1, 1)
    Minimize.BackgroundTransparency = 1
    Minimize.BorderColor3 = Color3.new(0, 0, 0)
    Minimize.BorderSizePixel = 0
    Minimize.Size = UDim2.new(0, 37, 0, 30)
    Minimize.Parent = Actions
    
    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.BorderColor3 = Color3.new(0, 0, 0)
    MinimizeIcon.BorderSizePixel = 0
    MinimizeIcon.Image = "rbxassetid://109304937949559"
    MinimizeIcon.ImageTransparency = 0.3
    MinimizeIcon.Size = UDim2.new(0, 30, 0, 30)
    MinimizeIcon.Parent = Minimize
    
    local MinimizeLayout = Instance.new("UIListLayout")
    MinimizeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MinimizeLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    MinimizeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MinimizeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    MinimizeLayout.Parent = Minimize
    
    local Fullscreen = Instance.new("ImageButton")
    Fullscreen.Name = "Fullscreen"
    Fullscreen.BackgroundColor3 = Color3.new(1, 1, 1)
    Fullscreen.BackgroundTransparency = 1
    Fullscreen.BorderColor3 = Color3.new(0, 0, 0)
    Fullscreen.BorderSizePixel = 0
    Fullscreen.LayoutOrder = 1
    Fullscreen.Size = UDim2.new(0, 37, 0, 30)
    Fullscreen.Parent = Actions
    
    local FullscreenIcon = Instance.new("ImageLabel")
    FullscreenIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    FullscreenIcon.BackgroundTransparency = 1
    FullscreenIcon.BorderColor3 = Color3.new(0, 0, 0)
    FullscreenIcon.BorderSizePixel = 0
    FullscreenIcon.Image = "rbxassetid://89144063792928"
    FullscreenIcon.Size = UDim2.new(0, 23, 0, 23)
    FullscreenIcon.Parent = Fullscreen
    
    local FullscreenLayout = Instance.new("UIListLayout")
    FullscreenLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    FullscreenLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    FullscreenLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FullscreenLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    FullscreenLayout.Parent = Fullscreen
    
    local Close = Instance.new("ImageButton")
    Close.Name = "Close"
    Close.BackgroundColor3 = Color3.new(1, 1, 1)
    Close.BackgroundTransparency = 1
    Close.BorderColor3 = Color3.new(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.HoverImage = "rbxassetid://0"
    Close.LayoutOrder = 2
    Close.Size = UDim2.new(0.324, 0, 1, 0)
    Close.Parent = Actions
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.BorderColor3 = Color3.new(0, 0, 0)
    CloseIcon.BorderSizePixel = 0
    CloseIcon.Image = "rbxassetid://121170570745612"
    CloseIcon.ImageTransparency = 0.3
    CloseIcon.Size = UDim2.new(0, 30, 0, 30)
    CloseIcon.Parent = Close
    
    local CloseLayout = Instance.new("UIListLayout")
    CloseLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CloseLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CloseLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    CloseLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceAround
    CloseLayout.Parent = Close
    
    local Version = Instance.new("Frame")
    Version.Name = "Version"
    Version.AnchorPoint = Vector2.new(0.5, 0.5)
    Version.BackgroundColor3 = Color3.new(1, 1, 1)
    Version.BackgroundTransparency = 1
    Version.BorderColor3 = Color3.new(0, 0, 0)
    Version.BorderSizePixel = 0
    Version.Position = UDim2.new(0.5, 0, 0.5, 0)
    Version.Size = UDim2.new(0, 100, 0, 30)
    Version.Parent = TopbarFrame
    
    local VersionText = Instance.new("TextLabel")
    VersionText.Name = "Text"
    VersionText.BackgroundColor3 = Color3.new(1, 1, 1)
    VersionText.BackgroundTransparency = 1
    VersionText.BorderColor3 = Color3.new(0, 0, 0)
    VersionText.BorderSizePixel = 0
    VersionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    VersionText.Size = UDim2.new(1, 0, 1, 0)
    VersionText.Text = Title
    VersionText.TextColor3 = Color3.new(0.537, 0.537, 0.537)
    VersionText.TextSize = 13
    VersionText.Parent = Version
    
    local HoverRed = Color3.fromRGB(235, 70, 70)
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    Close.MouseEnter:Connect(function()
        TweenService:Create(Close, TweenInfoObj, {BackgroundTransparency = 0, BackgroundColor3 = HoverRed}):Play()
    end)
    Close.MouseLeave:Connect(function()
        TweenService:Create(Close, TweenInfoObj, {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
    end)
    
    return {
        Instance = TopbarFrame,
        CloseButton = Close,
        MinimizeButton = Minimize,
        FullscreenButton = Fullscreen
    }
end

return Topbar
