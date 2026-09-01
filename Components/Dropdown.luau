local DropdownComponent = {}
local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function DropdownComponent.Create(TabContent, Maid, Config)
    local headerText = Config.Name or "Dropdown"
    local descText = Config.Description or ""
    local hoverText = Config.HoverText or ""
    local options = Config.Options or {}
    local selected = Config.Default or (options[1] or "")
    local cb = Config.Callback or function() end
    local isLarge = Config.Large or false
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = headerText
    DropdownFrame.BackgroundColor3 = Color3.new(0.13, 0.13, 0.13)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.BorderSizePixel = 0
    
    local height = 42
    if isLarge then
        height = descText == "" and 60 or 75
    else
        height = descText == "" and 42 or 52
    end
    DropdownFrame.Size = UDim2.new(1, 0, 0, height)
    DropdownFrame.Parent = TabContent
    
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.FillDirection = isLarge and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = DropdownFrame
    
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = isLarge and UDim2.new(1, 0, 0, descText == "" and 26 or 40) or UDim2.new(1, -130, 1, 0)
    TextContainer.Parent = DropdownFrame
    
    local TextLayout = Instance.new("UIListLayout")
    TextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TextLayout.Padding = UDim.new(0, 2)
    TextLayout.Parent = TextContainer
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 14)
    if isLarge then
        TextPadding.PaddingTop = UDim.new(0, 4)
    end
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
    
    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Name = "DropdownContainer"
    DropdownContainer.BackgroundTransparency = 1
    DropdownContainer.LayoutOrder = 1
    DropdownContainer.Size = isLarge and UDim2.new(1, 0, 0, 32) or UDim2.new(0, 130, 1, 0)
    DropdownContainer.Parent = DropdownFrame
    
    local DropdownContainerLayout = Instance.new("UIListLayout")
    DropdownContainerLayout.FillDirection = Enum.FillDirection.Horizontal
    DropdownContainerLayout.HorizontalAlignment = isLarge and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Right
    DropdownContainerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    DropdownContainerLayout.Parent = DropdownContainer
    
    local DropdownContainerPadding = Instance.new("UIPadding")
    if not isLarge then
        DropdownContainerPadding.PaddingRight = UDim.new(0, 14)
    end
    DropdownContainerPadding.Parent = DropdownContainer
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Name = "DropdownBtn"
    DropdownBtn.BackgroundColor3 = Color3.new(0.141, 0.141, 0.141)
    DropdownBtn.Size = isLarge and UDim2.new(1, -28, 0, 28) or UDim2.new(0, 116, 0, 26)
    DropdownBtn.Text = ""
    DropdownBtn.AutoButtonColor = false
    DropdownBtn.Parent = DropdownContainer
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownBtn
    
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = Color3.new(0.2, 0.2, 0.2)
    DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DropdownStroke.Parent = DropdownBtn
    
    local DropdownText = Instance.new("TextLabel")
    DropdownText.Name = "SelectedText"
    DropdownText.BackgroundTransparency = 1
    DropdownText.Size = UDim2.new(1, -30, 1, 0)
    DropdownText.Position = UDim2.new(0, 10, 0, 0)
    DropdownText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    DropdownText.Text = selected
    DropdownText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    DropdownText.TextSize = 13
    DropdownText.TextXAlignment = Enum.TextXAlignment.Left
    DropdownText.Parent = DropdownBtn
    
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(1, -22, 0.5, -8)
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Image = "rbxassetid://6031091004" -- Chevron down
    Icon.ImageColor3 = Color3.new(0.6, 0.6, 0.6)
    Icon.Parent = DropdownBtn

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
        Tooltip.Parent = ScreenGui or DropdownFrame
        
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
    
    local ScreenGui = TabContent:FindFirstAncestorOfClass("ScreenGui")
    local MenuOpen = false
    local DropdownMenu
    local DropdownOverlay
    
    local function CloseDropdown()
        if not MenuOpen then return end
        MenuOpen = false
        
        Tween(Icon, TweenInfo.new(0.2), {Rotation = 0})
        Tween(DropdownStroke, TweenInfo.new(0.2), {Color = Color3.new(0.2, 0.2, 0.2)})
        
        if DropdownMenu then
            local tween = Tween(DropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, 0)})
            task.delay(0.2, function()
                if not MenuOpen and DropdownMenu then
                    DropdownMenu:Destroy()
                    DropdownMenu = nil
                end
            end)
        end
        
        if DropdownOverlay then
            DropdownOverlay:Destroy()
            DropdownOverlay = nil
        end
    end
    
    local function OpenDropdown()
        if MenuOpen then return end
        if not ScreenGui then return end
        MenuOpen = true
        
        Tween(Icon, TweenInfo.new(0.2), {Rotation = 180})
        Tween(DropdownStroke, TweenInfo.new(0.2), {Color = Color3.new(0.4, 0.4, 0.4)})
        
        DropdownOverlay = Instance.new("TextButton")
        DropdownOverlay.Name = "DropdownOverlay"
        DropdownOverlay.BackgroundTransparency = 1
        DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
        DropdownOverlay.ZIndex = 10000
        DropdownOverlay.Text = ""
        DropdownOverlay.Parent = ScreenGui
        
        DropdownOverlay.MouseButton1Click:Connect(function()
            CloseDropdown()
        end)
        
        DropdownMenu = Instance.new("Frame")
        DropdownMenu.Name = "DropdownMenu"
        DropdownMenu.BackgroundColor3 = Color3.new(0.141, 0.141, 0.141)
        DropdownMenu.BorderSizePixel = 0
        DropdownMenu.ClipsDescendants = true
        DropdownMenu.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X - ScreenGui.AbsolutePosition.X, 0, (DropdownBtn.AbsolutePosition.Y - ScreenGui.AbsolutePosition.Y) + DropdownBtn.AbsoluteSize.Y + 4)
        DropdownMenu.Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, 0)
        DropdownMenu.ZIndex = 10001
        DropdownMenu.Parent = ScreenGui
        
        local MenuCorner = Instance.new("UICorner")
        MenuCorner.CornerRadius = UDim.new(0, 6)
        MenuCorner.Parent = DropdownMenu
        
        local MenuStroke = Instance.new("UIStroke")
        MenuStroke.Color = Color3.new(0.2, 0.2, 0.2)
        MenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        MenuStroke.Parent = DropdownMenu
        
        local ScrollFrame = Instance.new("ScrollingFrame")
        ScrollFrame.BackgroundTransparency = 1
        ScrollFrame.BorderSizePixel = 0
        ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
        ScrollFrame.ScrollBarThickness = 2
        ScrollFrame.ScrollBarImageColor3 = Color3.new(0.3, 0.3, 0.3)
        ScrollFrame.ZIndex = 10002
        ScrollFrame.Parent = DropdownMenu
        
        local ScrollLayout = Instance.new("UIListLayout")
        ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollLayout.Parent = ScrollFrame
        
        local ScrollPadding = Instance.new("UIPadding")
        ScrollPadding.PaddingTop = UDim.new(0, 4)
        ScrollPadding.PaddingBottom = UDim.new(0, 4)
        ScrollPadding.PaddingLeft = UDim.new(0, 4)
        ScrollPadding.PaddingRight = UDim.new(0, 4)
        ScrollPadding.Parent = ScrollFrame
        
        local targetHeight = 8
        
        for i, option in ipairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Name = option
            OptBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            OptBtn.BackgroundTransparency = option == selected and 0 or 1
            OptBtn.Size = UDim2.new(1, 0, 0, 26)
            OptBtn.Text = ""
            OptBtn.AutoButtonColor = false
            OptBtn.ZIndex = 10003
            OptBtn.Parent = ScrollFrame
            
            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 4)
            OptCorner.Parent = OptBtn
            
            local OptStroke = Instance.new("UIStroke")
            OptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            OptStroke.Color = Color3.new(0.3, 0.3, 0.3)
            OptStroke.Transparency = option == selected and 0 or 1
            OptStroke.Parent = OptBtn
            
            local OptText = Instance.new("TextLabel")
            OptText.BackgroundTransparency = 1
            OptText.Size = UDim2.new(1, -30, 1, 0)
            OptText.Position = UDim2.new(0, 8, 0, 0)
            OptText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            OptText.Text = option
            OptText.TextColor3 = option == selected and Color3.new(0.9, 0.9, 0.9) or Color3.new(0.6, 0.6, 0.6)
            OptText.TextSize = 13
            OptText.TextXAlignment = Enum.TextXAlignment.Left
            OptText.ZIndex = 10004
            OptText.Parent = OptBtn
            
            local Checkmark = Instance.new("ImageLabel")
            Checkmark.Name = "Checkmark"
            Checkmark.BackgroundTransparency = 1
            Checkmark.Position = UDim2.new(1, -22, 0.5, -8)
            Checkmark.Size = UDim2.new(0, 16, 0, 16)
            Checkmark.Image = "rbxassetid://118922551501473"
            Checkmark.ImageColor3 = Color3.new(0.8, 0.8, 0.8)
            Checkmark.ZIndex = 10004
            Checkmark.Visible = (option == selected)
            Checkmark.Parent = OptBtn
            
            OptBtn.MouseEnter:Connect(function()
                if option ~= selected then
                    Tween(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5})
                    Tween(OptText, TweenInfo.new(0.15), {TextColor3 = Color3.new(0.9, 0.9, 0.9)})
                end
            end)
            
            OptBtn.MouseLeave:Connect(function()
                if option ~= selected then
                    Tween(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1})
                    Tween(OptText, TweenInfo.new(0.15), {TextColor3 = Color3.new(0.6, 0.6, 0.6)})
                end
            end)
            
            OptBtn.MouseButton1Click:Connect(function()
                selected = option
                DropdownText.Text = option
                cb(selected)
                CloseDropdown()
            end)
            
            targetHeight = targetHeight + 26
        end
        
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, targetHeight)
        
        if targetHeight > 150 then
            targetHeight = 150
        end
        
        Tween(DropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, targetHeight)})
    end
    
    Maid:GiveTask(DropdownBtn.MouseButton1Click:Connect(function()
        if MenuOpen then
            CloseDropdown()
        else
            OpenDropdown()
        end
    end))
    
    local ClickTarget = isLarge and DropdownBtn or DropdownFrame
    if ClickTarget == DropdownFrame then
        ClickTarget = Instance.new("TextButton")
        ClickTarget.BackgroundTransparency = 1
        ClickTarget.Text = ""
        ClickTarget.Size = UDim2.new(1, 0, 1, 0)
        ClickTarget.ZIndex = 10
        ClickTarget.Parent = DropdownFrame
        
        Maid:GiveTask(ClickTarget.MouseButton1Click:Connect(function()
            if MenuOpen then
                CloseDropdown()
            else
                OpenDropdown()
            end
        end))
    end
    

    -- Tooltip logic (attaches to the frame)
    local TooltipTarget = ClickTarget.Parent == DropdownFrame and ClickTarget or DropdownFrame
    
    Maid:GiveTask(TooltipTarget.MouseEnter:Connect(function()
        if not isLarge then
            Tween(DropdownFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0})
        end
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
    
    Maid:GiveTask(TooltipTarget.MouseLeave:Connect(function()
        if not isLarge then
            Tween(DropdownFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        end
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
    
    Maid:GiveTask(function()
        CloseDropdown()
        if MouseMoveConn then
            MouseMoveConn:Disconnect()
        end
        if Tooltip then
            Tooltip:Destroy()
        end
    end)
    
    return DropdownFrame
end

return DropdownComponent
