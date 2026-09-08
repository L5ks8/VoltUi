local InputComponent = {}
local TweenService = game:GetService("TweenService")
local ThemeManager = require(script.Parent.Parent.Core.Theme)

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

function InputComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Input"
    local descText = config.Description or ""
    local placeholder = config.PlaceholderText or config.Placeholder or "Type here..."
    local currentValue = config.Default or config.CurrentValue or ""
    local numeric = config.Numeric or false
    local maxChars = config.MaxCharacters
    local cb = config.Callback or function() end
    local accentColor = config.AccentColor or Color3.fromRGB(245, 245, 245)

    local InputFrame = Instance.new("Frame")
    InputFrame.Name = headerText
    ThemeManager:Register(InputFrame, "BackgroundColor3", "SecondaryBackground")
    InputFrame.BackgroundTransparency = 1
    InputFrame.BorderSizePixel = 0
    InputFrame.Size = UDim2.new(1, 0, 0, descText == "" and 42 or 52)
    InputFrame.Parent = TabContent

    local InputLayout = Instance.new("UIListLayout")
    InputLayout.FillDirection = Enum.FillDirection.Horizontal
    InputLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    InputLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InputLayout.Parent = InputFrame

    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, -160, 1, 0)
    TextContainer.Parent = InputFrame

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
    ThemeManager:Register(Header, "TextColor3", "TextPrimary")
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
        ThemeManager:Register(Description, "TextColor3", "TextSecondary")
        Description.TextSize = 12
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextYAlignment = Enum.TextYAlignment.Center
        Description.Parent = TextContainer
    end

    local BoxContainer = Instance.new("Frame")
    BoxContainer.Name = "BoxContainer"
    BoxContainer.BackgroundTransparency = 1
    BoxContainer.LayoutOrder = 1
    BoxContainer.Size = UDim2.new(0, 160, 1, 0)
    BoxContainer.Parent = InputFrame

    local BoxWrapper = Instance.new("Frame")
    BoxWrapper.Name = "BoxWrapper"
    ThemeManager:Register(BoxWrapper, "BackgroundColor3", "MainBackground")
    BoxWrapper.BorderSizePixel = 0
    BoxWrapper.AnchorPoint = Vector2.new(1, 0.5)
    BoxWrapper.Position = UDim2.new(1, -14, 0.5, 0)
    BoxWrapper.Size = UDim2.new(0, 130, 0, 26)
    BoxWrapper.Parent = BoxContainer

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = BoxWrapper

    local BoxStroke = Instance.new("UIStroke")
    ThemeManager:Register(BoxStroke, "Color", "StrokeColor")
    BoxStroke.Thickness = 1
    BoxStroke.Parent = BoxWrapper

    local TextBox = Instance.new("TextBox")
    TextBox.Name = "TextBox"
    TextBox.BackgroundTransparency = 1
    TextBox.ClearTextOnFocus = config.ClearOnFocus or false
    TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    TextBox.PlaceholderText = placeholder
    TextBox.Size = UDim2.new(1, -16, 1, 0)
    TextBox.Position = UDim2.new(0, 8, 0, 0)
    TextBox.Text = tostring(currentValue)
    ThemeManager:Register(TextBox, "TextColor3", "TextPrimary")
    TextBox.TextSize = 12
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Parent = BoxWrapper

    TextBox.Focused:Connect(function()
        Tween(BoxStroke, TweenInfo.new(0.2), {Color = accentColor})
    end)

    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if numeric then
            local filtered = TextBox.Text:gsub("%D+", "")
            if TextBox.Text ~= filtered then
                TextBox.Text = filtered
            end
        end
        if maxChars and #TextBox.Text > maxChars then
            TextBox.Text = TextBox.Text:sub(1, maxChars)
        end
    end)

    TextBox.FocusLost:Connect(function(enterPressed)
        Tween(BoxStroke, TweenInfo.new(0.2), {Color = ThemeManager:GetColor("StrokeColor")})
        currentValue = TextBox.Text
        if config.RemoveTextAfterFocusLost then
            TextBox.Text = ""
        end
        cb(currentValue, enterPressed)
    end)

    InputFrame.MouseEnter:Connect(function()
        Tween(InputFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85})
    end)
    InputFrame.MouseLeave:Connect(function()
        Tween(InputFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end)

    local InputObject = {}
    InputObject.Instance = InputFrame

    function InputObject:Set(newText)
        currentValue = tostring(newText)
        TextBox.Text = currentValue
        cb(currentValue, false)
    end

    function InputObject:Get()
        return currentValue
    end

    setmetatable(InputObject, {
        __index = function(_, key) return InputFrame[key] end,
        __newindex = function(_, key, value) InputFrame[key] = value end
    })

    return InputObject
end

return InputComponent
