local Minimized = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Minimized.Create(ParentGui, RestoreCallback)
    local Frame = Instance.new("ImageButton")
    Frame.Name = "Minimized"
    Frame.Active = true
    Frame.AnchorPoint = Vector2.new(0.1, 0.3)
    Frame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Frame.BorderColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.064, 0, 0.083, 0)
    Frame.Selectable = false
    Frame.Size = UDim2.new(0, 70, 0, 70)
    Frame.Visible = false
    Frame.AutoButtonColor = false
    Frame.Parent = ParentGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Frame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Parent = Frame
    
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Image = "rbxassetid://71942076965693"
    ImageLabel.Position = UDim2.new(-0.3, 0, 0.143, 0)
    ImageLabel.Size = UDim2.new(0, 45, 0, 45)
    ImageLabel.Parent = Frame
    
    Frame.MouseButton1Click:Connect(function()
        Frame.Visible = false
        if RestoreCallback then RestoreCallback() end
    end)
    
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(Frame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    return Frame
end

return Minimized
