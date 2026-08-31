local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)
local Utility = require(Utils.Utility)

local Topbar = {}

function Topbar.Create(Main, Config, maid)
    local Title = Config.Title or "Volt - 1.0.0"
    
    local TopbarFrame = Instance.new("Frame")
    TopbarFrame.Name = "Topbar"
    TopbarFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    TopbarFrame.BorderColor3 = Color3.new(0, 0, 0)
    TopbarFrame.BorderSizePixel = 0
    TopbarFrame.Size = UDim2.new(1, 0, 0, 30)
    TopbarFrame.ZIndex = 50
    TopbarFrame.Parent = Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.BottomLeftRadius = UDim.new(0, 0)
    TopbarCorner.BottomRightRadius = UDim.new(0, 0)
    TopbarCorner.Parent = TopbarFrame
    
    local TopbarBorder = Instance.new("Frame")
    TopbarBorder.Name = "Border"
    TopbarBorder.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    TopbarBorder.BorderSizePixel = 0
    TopbarBorder.Position = UDim2.new(0, 0, 1, -1)
    TopbarBorder.Size = UDim2.new(1, 0, 0, 1)
    TopbarBorder.Parent = TopbarFrame
    
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
    Actions.AnchorPoint = Vector2.new(1, 0)
    Actions.BackgroundColor3 = Color3.new(1, 1, 1)
    Actions.BackgroundTransparency = 1
    Actions.BorderColor3 = Color3.new(0, 0, 0)
    Actions.BorderSizePixel = 0
    Actions.Position = UDim2.new(1, 0, 0, 0)
    Actions.Size = UDim2.new(0, 114, 0, 30)
    Actions.Parent = TopbarFrame
    
    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsLayout.Parent = Actions
    
    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.AutoButtonColor = false
    Minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Minimize.BackgroundTransparency = 1
    Minimize.BorderColor3 = Color3.new(0, 0, 0)
    Minimize.BorderSizePixel = 0
    Minimize.Size = UDim2.new(0, 37, 0, 30)
    Minimize.Text = ""
    Minimize.Parent = Actions
    
    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.Active = false
    MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.BorderColor3 = Color3.new(0, 0, 0)
    MinimizeIcon.BorderSizePixel = 0
    MinimizeIcon.Image = "rbxassetid://109304937949559"
    MinimizeIcon.ImageTransparency = 0.3
    MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinimizeIcon.Size = UDim2.new(0, 30, 0, 30)
    MinimizeIcon.Parent = Minimize
    
    local Fullscreen = Instance.new("TextButton")
    Fullscreen.Name = "Fullscreen"
    Fullscreen.AutoButtonColor = false
    Fullscreen.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Fullscreen.BackgroundTransparency = 1
    Fullscreen.BorderColor3 = Color3.new(0, 0, 0)
    Fullscreen.BorderSizePixel = 0
    Fullscreen.LayoutOrder = 1
    Fullscreen.Size = UDim2.new(0, 37, 0, 30)
    Fullscreen.Text = ""
    Fullscreen.Parent = Actions
    
    local FullscreenIcon = Instance.new("ImageLabel")
    FullscreenIcon.Active = false
    FullscreenIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FullscreenIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    FullscreenIcon.BackgroundTransparency = 1
    FullscreenIcon.BorderColor3 = Color3.new(0, 0, 0)
    FullscreenIcon.BorderSizePixel = 0
    FullscreenIcon.Image = "rbxassetid://89144063792928"
    FullscreenIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    FullscreenIcon.Size = UDim2.new(0, 23, 0, 23)
    FullscreenIcon.Parent = Fullscreen
    
    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.AutoButtonColor = false
    Close.BackgroundColor3 = Color3.fromRGB(235, 70, 70)
    Close.BackgroundTransparency = 1
    Close.BorderColor3 = Color3.new(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.LayoutOrder = 2
    Close.Size = UDim2.new(0, 40, 0, 30)
    Close.Text = ""
    Close.Parent = Actions
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 0)
    CloseCorner.TopRightRadius = UDim.new(0, 8)
    CloseCorner.Parent = Close
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Active = false
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.BorderColor3 = Color3.new(0, 0, 0)
    CloseIcon.BorderSizePixel = 0
    CloseIcon.Image = "rbxassetid://121170570745612"
    CloseIcon.ImageTransparency = 0.3
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size = UDim2.new(0, 30, 0, 30)
    CloseIcon.Parent = Close
    
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
    VersionText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    VersionText.Size = UDim2.new(1, 0, 1, 0)
    VersionText.Text = Title
    VersionText.TextColor3 = Color3.new(0.537, 0.537, 0.537)
    VersionText.TextSize = 13
    VersionText.Parent = Version
    
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function ApplyHover(button, text, hoverColor)
        button.AutoButtonColor = false
        button.BackgroundTransparency = 1
        
        local HoverBox = Instance.new("Frame")
        HoverBox.Name = "HoverBox"
        HoverBox.AnchorPoint = Vector2.new(0.5, 0.5)
        HoverBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        HoverBox.Size = UDim2.new(1, 0, 1, 0)
        HoverBox.BackgroundColor3 = hoverColor
        HoverBox.BackgroundTransparency = 1
        HoverBox.BorderSizePixel = 0
        HoverBox.ZIndex = 0
        HoverBox.Parent = button
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = button.Name == "Close" and UDim.new(0, 0) or UDim.new(0, 6)
        if button.Name == "Close" then
            Corner.TopRightRadius = UDim.new(0, 8)
        end
        Corner.Parent = HoverBox
        
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
        Tooltip.BackgroundTransparency = 1
        Tooltip.AnchorPoint = Vector2.new(0.5, 0)
        Tooltip.Position = UDim2.new(0.5, 0, 1, 4)
        Tooltip.Size = UDim2.new(0, 0, 0, 18)
        Tooltip.AutomaticSize = Enum.AutomaticSize.X
        Tooltip.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Tooltip.Text = text
        Tooltip.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        Tooltip.TextSize = 12
        Tooltip.TextTransparency = 1
        Tooltip.ZIndex = 10
        Tooltip.Visible = false
        Tooltip.Parent = button
        
        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip
        
        local TooltipPadding = Instance.new("UIPadding")
        TooltipPadding.PaddingLeft = UDim.new(0, 6)
        TooltipPadding.PaddingRight = UDim.new(0, 6)
        TooltipPadding.Parent = Tooltip
        
        local TooltipStroke = Instance.new("UIStroke")
        TooltipStroke.Color = Color3.new(0.216, 0.216, 0.216)
        TooltipStroke.Transparency = 1
        TooltipStroke.Parent = Tooltip
        
        local icon = button:FindFirstChildOfClass("ImageLabel")
        if icon then icon.Active = false end
        
        -- State tracking for hover to prevent flicker when moving quickly
        local isHovering = false
        
        maid:GiveTask(button.MouseEnter:Connect(function()
            isHovering = true
            Tooltip.Visible = true
            Tween(HoverBox, TweenInfoObj, {BackgroundTransparency = 0})
            Tween(Tooltip, TweenInfoObj, {BackgroundTransparency = 0, TextTransparency = 0})
            Tween(TooltipStroke, TweenInfoObj, {Transparency = 0})
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = 0}) end
        end))
        
        maid:GiveTask(button.MouseLeave:Connect(function()
            isHovering = false
            Tween(HoverBox, TweenInfoObj, {BackgroundTransparency = 1})
            Tween(Tooltip, TweenInfoObj, {BackgroundTransparency = 1, TextTransparency = 1})
            Tween(TooltipStroke, TweenInfoObj, {Transparency = 1})
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = 0.3}) end
            task.delay(0.2, function()
                if not isHovering then
                    Tooltip.Visible = false
                end
            end)
        end))
    end
    
    ApplyHover(Minimize, "Minimize", Color3.fromRGB(45, 45, 45))
    ApplyHover(Fullscreen, "Fullscreen", Color3.fromRGB(45, 45, 45))
    ApplyHover(Close, "Close", Color3.fromRGB(235, 70, 70))
    
    Utility.MakeDraggable(TopbarFrame, Main, maid)
    
    return {
        Instance = TopbarFrame,
        CloseButton = Close,
        MinimizeButton = Minimize,
        FullscreenButton = Fullscreen
    }
end

return Topbar
