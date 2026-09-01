local ToggleComponent = {}
local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function ToggleComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Toggle"
    local descText = config.Description or ""
    local hoverText = config.HoverText or ""
    local state = config.Default or false
    local cb = config.Callback or function() end
    
    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Name = headerText
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Text = ""
    ToggleFrame.BackgroundColor3 = Color3.new(0.13, 0.13, 0.13)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, descText == "" and 42 or 52)
    ToggleFrame.Parent = TabContent
    
    local ToggleLayout = Instance.new("UIListLayout")
    ToggleLayout.FillDirection = Enum.FillDirection.Horizontal
    ToggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ToggleLayout.Parent = ToggleFrame
    
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, -70, 1, 0)
    TextContainer.Parent = ToggleFrame
    
    local TextLayout = Instance.new("UIListLayout")
    TextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TextLayout.Padding = UDim.new(0, 2)
    TextLayout.Parent = TextContainer
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 14)
    TextPadding.Parent = TextContainer
    
    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Header.Size = UDim2.new(1, 0, 0, 16)
    Header.Text = headerText
    Header.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.TextYAlignment = Enum.TextYAlignment.Center
    Header.Parent = TextContainer
    
    if descText ~= "" then
        local Description = Instance.new("TextLabel")
        Description.Name = "Description"
        Description.BackgroundTransparency = 1
        Description.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Description.Size = UDim2.new(1, 0, 0, 14)
        Description.Text = descText
        Description.TextColor3 = Color3.new(0.6, 0.6, 0.6)
        Description.TextSize = 12
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextYAlignment = Enum.TextYAlignment.Center
        Description.Parent = TextContainer
    end
    
    local SwitchContainer = Instance.new("Frame")
    SwitchContainer.Name = "SwitchContainer"
    SwitchContainer.BackgroundTransparency = 1
    SwitchContainer.LayoutOrder = 1
    SwitchContainer.Size = UDim2.new(0, 70, 1, 0)
    SwitchContainer.Parent = ToggleFrame
    
    local SwitchLayout = Instance.new("UIListLayout")
    SwitchLayout.FillDirection = Enum.FillDirection.Horizontal
    SwitchLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    SwitchLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SwitchLayout.Parent = SwitchContainer
    
    local SwitchPadding = Instance.new("UIPadding")
    SwitchPadding.PaddingRight = UDim.new(0, 14)
    SwitchPadding.Parent = SwitchContainer
    
    local SwitchBg = Instance.new("Frame")
    SwitchBg.Name = "SwitchBg"
    SwitchBg.BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.new(0.141, 0.141, 0.141)
    SwitchBg.Size = UDim2.new(0, 36, 0, 20)
    SwitchBg.Parent = SwitchContainer
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg
    
    local SwitchStroke = Instance.new("UIStroke")
    SwitchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SwitchStroke.Color = state and Color3.new(1, 1, 1) or Color3.new(0.275, 0.275, 0.275)
    SwitchStroke.Parent = SwitchBg
    
    local SwitchDot = Instance.new("Frame")
    SwitchDot.Name = "Dot"
    SwitchDot.BackgroundColor3 = state and Color3.new(0, 0, 0) or Color3.new(0.6, 0.6, 0.6)
    SwitchDot.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    SwitchDot.AnchorPoint = Vector2.new(0, 0.5)
    SwitchDot.Size = UDim2.new(0, 16, 0, 16)
    SwitchDot.Parent = SwitchBg
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = SwitchDot

    local Tooltip
    local MouseMoveConn
    if hoverText ~= "" then
        Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
        Tooltip.BackgroundTransparency = 1
        Tooltip.Size = UDim2.new(0, 0, 0, 22)
        Tooltip.AutomaticSize = Enum.AutomaticSize.X
        Tooltip.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Tooltip.Text = hoverText
        Tooltip.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        Tooltip.TextSize = 12
        Tooltip.TextTransparency = 1
        Tooltip.ZIndex = 100000
        Tooltip.Visible = false
        
        local ScreenGui = TabContent:FindFirstAncestorOfClass("ScreenGui")
        Tooltip.Parent = ScreenGui or ToggleFrame
        
        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip
        
        local TooltipStroke = Instance.new("UIStroke")
        TooltipStroke.Color = Color3.new(0.2, 0.2, 0.2)
        TooltipStroke.Transparency = 1
        TooltipStroke.Parent = Tooltip
        
        local TooltipPadding = Instance.new("UIPadding")
        TooltipPadding.PaddingLeft = UDim.new(0, 8)
        TooltipPadding.PaddingRight = UDim.new(0, 8)
        TooltipPadding.Parent = Tooltip
    end
    
    local function UpdateToggle()
        if state then
            Tween(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(1, 1, 1)})
            Tween(SwitchStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.new(1, 1, 1)})
            Tween(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0.5, 0), BackgroundColor3 = Color3.new(0, 0, 0)})
        else
            Tween(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(0.141, 0.141, 0.141)})
            Tween(SwitchStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.new(0.275, 0.275, 0.275)})
            Tween(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)})
        end
    end
    
    Maid:GiveTask(ToggleFrame.MouseButton1Click:Connect(function()
        state = not state
        UpdateToggle()
        cb(state)
    end))
    
    Maid:GiveTask(ToggleFrame.MouseEnter:Connect(function()
        Tween(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0})
        if Tooltip then
            Tooltip.Visible = true
            Tween(Tooltip, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextTransparency = 0})
            Tween(Tooltip.UIStroke, TweenInfo.new(0.2), {Transparency = 0})
            
            if MouseMoveConn then MouseMoveConn:Disconnect() end
            MouseMoveConn = RunService.RenderStepped:Connect(function()
                Tooltip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
            end)
        end
    end))
    
    Maid:GiveTask(ToggleFrame.MouseLeave:Connect(function()
        Tween(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        if Tooltip then
            Tween(Tooltip, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1})
            Tween(Tooltip.UIStroke, TweenInfo.new(0.2), {Transparency = 1})
            
            if MouseMoveConn then
                MouseMoveConn:Disconnect()
                MouseMoveConn = nil
            end
            
            task.delay(0.2, function()
                if Tooltip.BackgroundTransparency == 1 then
                    Tooltip.Visible = false
                end
            end)
        end
    end))
    
    -- Cleanup Tooltip when Toggle is destroyed
    Maid:GiveTask(function()
        if MouseMoveConn then
            MouseMoveConn:Disconnect()
        end
        if Tooltip then
            Tooltip:Destroy()
        end
    end)
    
    return ToggleFrame
end

return ToggleComponent
