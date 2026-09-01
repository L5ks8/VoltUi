local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)
local ContextActionService = game:GetService("ContextActionService")

local CloseWarn = {}

function CloseWarn.Create(ParentGui, maid, ConfirmCallback, CancelCallback)
    local Overlay = Instance.new("Frame")
    Overlay.Name = "CloseWarnOverlay"
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.ZIndex = 9999
    Overlay.Visible = false
    Overlay.Active = true
    Overlay.Parent = ParentGui
    
    local Main = Instance.new("Frame")
    Main.Name = "CloseWarnModal"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 320, 0, 160)
    Main.ZIndex = 10000
    Main.Parent = Overlay
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.Parent = Main

    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0
    UIScale.Parent = Main
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 20)
    Title.Size = UDim2.new(1, -40, 0, 24)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Close VoltUi?"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main
    
    local Subtext = Instance.new("TextLabel")
    Subtext.Name = "Subtext"
    Subtext.BackgroundTransparency = 1
    Subtext.Position = UDim2.new(0, 20, 0, 50)
    Subtext.Size = UDim2.new(1, -40, 0, 40)
    Subtext.Font = Enum.Font.GothamMedium
    Subtext.Text = "Are you sure you want to close this window? You will need to re-inject to open it again."
    Subtext.TextColor3 = Color3.fromRGB(150, 150, 150)
    Subtext.TextSize = 14
    Subtext.TextWrapped = true
    Subtext.TextXAlignment = Enum.TextXAlignment.Left
    Subtext.TextYAlignment = Enum.TextYAlignment.Top
    Subtext.Parent = Main
    
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(0, 20, 1, -50)
    ButtonContainer.Size = UDim2.new(1, -40, 0, 32)
    ButtonContainer.Parent = Main
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ButtonContainer
    
    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Name = "Cancel"
    CancelBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CancelBtn.BorderSizePixel = 0
    CancelBtn.Size = UDim2.new(0, 80, 1, 0)
    CancelBtn.Font = Enum.Font.GothamSemibold
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Color3.new(1, 1, 1)
    CancelBtn.TextSize = 14
    CancelBtn.AutoButtonColor = false
    CancelBtn.LayoutOrder = 1
    CancelBtn.Parent = ButtonContainer
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 6)
    CancelCorner.Parent = CancelBtn
    
    local CancelStroke = Instance.new("UIStroke")
    CancelStroke.Color = Color3.fromRGB(60, 60, 60)
    CancelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CancelStroke.Parent = CancelBtn
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Size = UDim2.new(0, 80, 1, 0)
    CloseBtn.Font = Enum.Font.GothamSemibold
    CloseBtn.Text = "Close"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 14
    CloseBtn.AutoButtonColor = false
    CloseBtn.LayoutOrder = 2
    CloseBtn.Parent = ButtonContainer
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    maid:GiveTask(CancelBtn.MouseEnter:Connect(function()
        Tween(CancelBtn, TweenInfoObj, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    end))
    maid:GiveTask(CancelBtn.MouseLeave:Connect(function()
        Tween(CancelBtn, TweenInfoObj, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
    end))
    
    maid:GiveTask(CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, TweenInfoObj, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)})
    end))
    maid:GiveTask(CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, TweenInfoObj, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)})
    end))
    
    local function Hide()
        ContextActionService:UnbindAction("VoltUi_Modal_Block")
        Tween(Overlay, TweenInfoObj, {BackgroundTransparency = 1})
        local hideTween = Tween(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
        task.spawn(function()
            hideTween.Completed:Wait()
            Overlay.Visible = false
        end)
    end
    
    maid:GiveTask(CancelBtn.MouseButton1Click:Connect(function()
        Hide()
        if CancelCallback then CancelCallback() end
    end))
    
    maid:GiveTask(CloseBtn.MouseButton1Click:Connect(function()
        Hide()
        if ConfirmCallback then ConfirmCallback() end
    end))
    
    maid:GiveTask(Overlay:GetPropertyChangedSignal("Visible"):Connect(function()
        if Overlay.Visible and Overlay.BackgroundTransparency == 1 then
            ContextActionService:BindAction("VoltUi_Modal_Block", function()
                return Enum.ContextActionResult.Sink
            end, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
            
            UIScale.Scale = 0.8
            Tween(Overlay, TweenInfoObj, {BackgroundTransparency = 0.5})
            Tween(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
        end
    end))
    
    return Overlay
end

return CloseWarn
