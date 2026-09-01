local ButtonComponent = {}
local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)

function ButtonComponent.Create(TabContent, Maid, Config)
    local btnConfig = type(Config) == "string" and {Header = Config} or Config
    local headerText = btnConfig.Header or btnConfig.Name or "Button"
    local descText = btnConfig.Description or ""
    local buttonText = btnConfig.ButtonText or "Click"
    local cb = btnConfig.Callback or function() end
    
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Name = headerText
    BtnFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    BtnFrame.BorderColor3 = Color3.new(0, 0, 0)
    BtnFrame.BorderSizePixel = 0
    BtnFrame.Size = UDim2.new(1, 0, 0, descText == "" and 42 or 52)
    BtnFrame.Parent = TabContent
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = BtnFrame
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    BtnStroke.Color = Color3.new(0.216, 0.216, 0.216)
    BtnStroke.Parent = BtnFrame
    
    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BtnLayout.Parent = BtnFrame
    
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, -130, 1, 0)
    TextContainer.Parent = BtnFrame
    
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
    
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.LayoutOrder = 1
    ButtonContainer.Size = UDim2.new(0, 130, 1, 0)
    ButtonContainer.Parent = BtnFrame
    
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ButtonLayout.Parent = ButtonContainer
    
    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.PaddingRight = UDim.new(0, 14)
    ButtonPadding.Parent = ButtonContainer
    
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Name = "Button"
    ClickBtn.AutoButtonColor = false
    ClickBtn.BackgroundColor3 = Color3.new(0.141, 0.141, 0.141)
    ClickBtn.BorderSizePixel = 0
    ClickBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ClickBtn.Size = UDim2.new(0, 100, 0, 30)
    ClickBtn.Text = buttonText
    ClickBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ClickBtn.TextSize = 13
    ClickBtn.Parent = ButtonContainer
    
    local ClickBtnCorner = Instance.new("UICorner")
    ClickBtnCorner.CornerRadius = UDim.new(0, 5)
    ClickBtnCorner.Parent = ClickBtn
    
    local ClickBtnStroke = Instance.new("UIStroke")
    ClickBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ClickBtnStroke.Color = Color3.new(0.275, 0.275, 0.275)
    ClickBtnStroke.Parent = ClickBtn
    
    Maid:GiveTask(ClickBtn.MouseButton1Click:Connect(function()
        cb()
    end))
    
    Maid:GiveTask(ClickBtn.MouseEnter:Connect(function()
        Tween(ClickBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)})
        Tween(ClickBtnStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.new(0.35, 0.35, 0.35)})
        Tween(ClickBtn, TweenInfo.new(0.25), {TextColor3 = Color3.new(1, 1, 1)})
    end))
    
    Maid:GiveTask(ClickBtn.MouseLeave:Connect(function()
        Tween(ClickBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(0.141, 0.141, 0.141)})
        Tween(ClickBtnStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.new(0.275, 0.275, 0.275)})
        Tween(ClickBtn, TweenInfo.new(0.3), {TextColor3 = Color3.new(0.8, 0.8, 0.8)})
    end))
    
    Maid:GiveTask(ClickBtn.MouseButton1Down:Connect(function()
        Tween(ClickBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(0.22, 0.22, 0.22)})
    end))
    
    Maid:GiveTask(ClickBtn.MouseButton1Up:Connect(function()
        Tween(ClickBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)})
    end))
    
    return BtnFrame
end

return ButtonComponent
