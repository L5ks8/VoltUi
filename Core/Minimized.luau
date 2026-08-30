local Utils = script.Parent.Parent.Utils
local Utility = require(Utils.Utility)

local Minimized = {}

function Minimized.Create(ParentGui, maid, RestoreCallback)
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
    
    maid:GiveTask(Frame.MouseButton1Click:Connect(function()
        Frame.Visible = false
        if RestoreCallback then RestoreCallback() end
    end))
    
    Utility.MakeDraggable(Frame, Frame, maid)
    
    return Frame
end

return Minimized
