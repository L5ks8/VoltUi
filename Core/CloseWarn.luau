local CloseWarn = {}
local TweenService = game:GetService("TweenService")

function CloseWarn.Create(ParentGui, ConfirmCallback, CancelCallback)
    local Main = Instance.new("Frame")
    Main.Name = "CloseWarn"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.475, 0)
    Main.Size = UDim2.new(0, 200, 0, 108)
    Main.ZIndex = 100
    Main.Visible = false
    Main.Parent = ParentGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main
    
    local Question = Instance.new("Frame")
    Question.Name = "Question"
    Question.BackgroundColor3 = Color3.new(1, 1, 1)
    Question.BackgroundTransparency = 1
    Question.BorderColor3 = Color3.new(0, 0, 0)
    Question.BorderSizePixel = 0
    Question.Size = UDim2.new(0, 200, 0, 59)
    Question.Parent = Main
    
    local QuestionText = Instance.new("TextLabel")
    QuestionText.BackgroundColor3 = Color3.new(1, 1, 1)
    QuestionText.BackgroundTransparency = 1
    QuestionText.BorderColor3 = Color3.new(0, 0, 0)
    QuestionText.BorderSizePixel = 0
    QuestionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    QuestionText.LineHeight = 1.5
    QuestionText.Size = UDim2.new(1, 0, 1, 0)
    QuestionText.Text = "Are you Sure you want to close this Window ?"
    QuestionText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    QuestionText.TextSize = 14
    QuestionText.TextWrapped = true
    QuestionText.Parent = Question
    
    local QuestionStroke = Instance.new("UIStroke")
    QuestionStroke.Color = Color3.new(0.353, 0.353, 0.353)
    QuestionStroke.Parent = Question
    
    local QuestionCorner = Instance.new("UICorner")
    QuestionCorner.BottomLeftRadius = UDim.new(0, 0)
    QuestionCorner.BottomRightRadius = UDim.new(0, 0)
    QuestionCorner.Parent = Question
    
    local Buttons = Instance.new("Frame")
    Buttons.Name = "Buttons"
    Buttons.BackgroundColor3 = Color3.new(1, 1, 1)
    Buttons.BackgroundTransparency = 1
    Buttons.BorderColor3 = Color3.new(0, 0, 0)
    Buttons.BorderSizePixel = 0
    Buttons.LayoutOrder = 1
    Buttons.Position = UDim2.new(0, 0, 0.546, 0)
    Buttons.Size = UDim2.new(0, 200, 0, 49)
    Buttons.Parent = Main
    
    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ButtonsLayout.Padding = UDim.new(0, 9)
    ButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ButtonsLayout.Parent = Buttons
    
    local Confirm = Instance.new("TextButton")
    Confirm.Name = "Confirm"
    Confirm.BackgroundColor3 = Color3.new(1, 1, 1)
    Confirm.BackgroundTransparency = 1
    Confirm.BorderColor3 = Color3.new(0, 0, 0)
    Confirm.BorderSizePixel = 0
    Confirm.Size = UDim2.new(0, 80, 0, 30)
    Confirm.Text = ""
    Confirm.Parent = Buttons
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.Parent = Confirm
    
    local ConfirmLayout = Instance.new("UIListLayout")
    ConfirmLayout.FillDirection = Enum.FillDirection.Horizontal
    ConfirmLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ConfirmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ConfirmLayout.Parent = Confirm
    
    local ConfirmText = Instance.new("TextLabel")
    ConfirmText.BackgroundColor3 = Color3.new(1, 1, 1)
    ConfirmText.BackgroundTransparency = 1
    ConfirmText.BorderColor3 = Color3.new(0, 0, 0)
    ConfirmText.BorderSizePixel = 0
    ConfirmText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ConfirmText.Size = UDim2.new(1, 0, 1, 0)
    ConfirmText.Text = "Confirm"
    ConfirmText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    ConfirmText.TextSize = 14
    ConfirmText.Parent = Confirm
    
    local Cancel = Instance.new("TextButton")
    Cancel.Name = "Cancel"
    Cancel.BackgroundColor3 = Color3.new(1, 1, 1)
    Cancel.BackgroundTransparency = 1
    Cancel.BorderColor3 = Color3.new(0, 0, 0)
    Cancel.BorderSizePixel = 0
    Cancel.LayoutOrder = 1
    Cancel.Size = UDim2.new(0, 80, 0, 30)
    Cancel.Text = ""
    Cancel.Parent = Buttons
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.Parent = Cancel
    
    local CancelLayout = Instance.new("UIListLayout")
    CancelLayout.FillDirection = Enum.FillDirection.Horizontal
    CancelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CancelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    CancelLayout.Parent = Cancel
    
    local CancelText = Instance.new("TextLabel")
    CancelText.BackgroundColor3 = Color3.new(1, 1, 1)
    CancelText.BackgroundTransparency = 1
    CancelText.BorderColor3 = Color3.new(0, 0, 0)
    CancelText.BorderSizePixel = 0
    CancelText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    CancelText.Size = UDim2.new(1, 0, 1, 0)
    CancelText.Text = "Cancel"
    CancelText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    CancelText.TextSize = 14
    CancelText.Parent = Cancel
    
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.new(0.353, 0.353, 0.353)
    MainStroke.Parent = Main
    
    local HoverRed = Color3.fromRGB(235, 70, 70)
    local HoverGreen = Color3.fromRGB(70, 235, 70)
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    Confirm.MouseEnter:Connect(function()
        TweenService:Create(Confirm, TweenInfoObj, {BackgroundTransparency = 0, BackgroundColor3 = HoverGreen}):Play()
    end)
    Confirm.MouseLeave:Connect(function()
        TweenService:Create(Confirm, TweenInfoObj, {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
    end)
    
    Cancel.MouseEnter:Connect(function()
        TweenService:Create(Cancel, TweenInfoObj, {BackgroundTransparency = 0, BackgroundColor3 = HoverRed}):Play()
    end)
    Cancel.MouseLeave:Connect(function()
        TweenService:Create(Cancel, TweenInfoObj, {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
    end)
    
    Confirm.MouseButton1Click:Connect(function()
        Main.Visible = false
        if ConfirmCallback then ConfirmCallback() end
    end)
    
    Cancel.MouseButton1Click:Connect(function()
        Main.Visible = false
        if CancelCallback then CancelCallback() end
    end)
    
    return Main
end

return CloseWarn
