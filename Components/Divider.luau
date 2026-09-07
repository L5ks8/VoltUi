local DividerComponent = {}

function DividerComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Text = Config} or (Config or {})
    local dividerText = config.Text or config.Name or ""

    local DividerFrame = Instance.new("Frame")
    DividerFrame.Name = "Divider"
    DividerFrame.BackgroundTransparency = 1
    DividerFrame.BorderSizePixel = 0
    DividerFrame.Size = UDim2.new(1, 0, 0, dividerText ~= "" and 20 or 9)
    DividerFrame.Parent = TabContent

    if dividerText ~= "" then
        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.Padding = UDim.new(0, 8)
        Layout.Parent = DividerFrame

        local LeftLine = Instance.new("Frame")
        LeftLine.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        LeftLine.BorderSizePixel = 0
        LeftLine.Size = UDim2.new(0.35, 0, 0, 1)
        LeftLine.Parent = DividerFrame

        local Text = Instance.new("TextLabel")
        Text.BackgroundTransparency = 1
        Text.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Text.Text = dividerText
        Text.TextColor3 = Color3.fromRGB(120, 120, 130)
        Text.TextSize = 11
        Text.AutomaticSize = Enum.AutomaticSize.X
        Text.Size = UDim2.new(0, 0, 1, 0)
        Text.Parent = DividerFrame

        local RightLine = Instance.new("Frame")
        RightLine.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        RightLine.BorderSizePixel = 0
        RightLine.Size = UDim2.new(0.35, 0, 0, 1)
        RightLine.Parent = DividerFrame
    else
        local Line = Instance.new("Frame")
        Line.Name = "Line"
        Line.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
        Line.BorderSizePixel = 0
        Line.AnchorPoint = Vector2.new(0.5, 0.5)
        Line.Position = UDim2.new(0.5, 0, 0.5, 0)
        Line.Size = UDim2.new(1, -24, 0, 1)
        Line.Parent = DividerFrame
    end

    local DividerObject = {}
    DividerObject.Instance = DividerFrame

    setmetatable(DividerObject, {
        __index = function(_, key) return DividerFrame[key] end,
        __newindex = function(_, key, value) DividerFrame[key] = value end
    })

    return DividerObject
end

return DividerComponent
