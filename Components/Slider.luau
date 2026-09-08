local SliderComponent = {}
local TweenService = game:GetService("TweenService")
local ThemeManager = require(script.Parent.Parent.Core.Theme)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

function SliderComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Slider"
    local descText = config.Description or ""
    local minVal = config.Min or (config.Range and config.Range[1]) or 0
    local maxVal = config.Max or (config.Range and config.Range[2]) or 100
    local increment = config.Increment or 1
    local suffix = config.Suffix or ""
    local currentValue = config.Default or config.CurrentValue or minVal
    local cb = config.Callback or function() end
    local accentColor = config.AccentColor or Color3.fromRGB(245, 245, 245)

    currentValue = math.clamp(currentValue, minVal, maxVal)

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = headerText
    ThemeManager:Register(SliderFrame, "BackgroundColor3", "SecondaryBackground")
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, descText == "" and 48 or 58)
    SliderFrame.Parent = TabContent

    local TopRow = Instance.new("Frame")
    TopRow.Name = "TopRow"
    TopRow.BackgroundTransparency = 1
    TopRow.Size = UDim2.new(1, -28, 0, 20)
    TopRow.Position = UDim2.new(0, 14, 0, 6)
    TopRow.Parent = SliderFrame

    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Header.Size = UDim2.new(1, -80, 1, 0)
    Header.Text = headerText
    ThemeManager:Register(Header, "TextColor3", "TextPrimary")
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.TextYAlignment = Enum.TextYAlignment.Center
    Header.Parent = TopRow

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "ValueLabel"
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ValueLabel.Size = UDim2.new(0, 80, 1, 0)
    ValueLabel.Position = UDim2.new(1, -80, 0, 0)
    ValueLabel.Text = tostring(currentValue) .. suffix
    ThemeManager:Register(ValueLabel, "TextColor3", "TextPrimary")
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.TextYAlignment = Enum.TextYAlignment.Center
    ValueLabel.Parent = TopRow

    if descText ~= "" then
        local Description = Instance.new("TextLabel")
        Description.Name = "Description"
        Description.BackgroundTransparency = 1
        Description.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Description.Position = UDim2.new(0, 14, 0, 26)
        Description.Size = UDim2.new(1, -28, 0, 14)
        Description.Text = descText
        ThemeManager:Register(Description, "TextColor3", "TextSecondary")
        Description.TextSize = 12
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextYAlignment = Enum.TextYAlignment.Center
        Description.Parent = SliderFrame
    end

    local SliderBar = Instance.new("TextButton")
    SliderBar.Name = "SliderBar"
    SliderBar.AutoButtonColor = false
    SliderBar.Text = ""
    ThemeManager:Register(SliderBar, "BackgroundColor3", "SecondaryBackground")
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 14, 1, -12)
    SliderBar.Size = UDim2.new(1, -28, 0, 6)
    SliderBar.Parent = SliderFrame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar

    local BarStroke = Instance.new("UIStroke")
    ThemeManager:Register(BarStroke, "Color", "StrokeColor")
    BarStroke.Thickness = 1
    BarStroke.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.BackgroundColor3 = accentColor
    Fill.BorderSizePixel = 0
    local pct = (maxVal == minVal) and 0 or ((currentValue - minVal) / (maxVal - minVal))
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(pct, 0, 0.5, 0)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    ThemeManager:Register(Knob, "BackgroundColor3", "TextPrimary")
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBar

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobStroke = Instance.new("UIStroke")
    ThemeManager:Register(KnobStroke, "Color", "StrokeColor")
    KnobStroke.Thickness = 1.5
    KnobStroke.Parent = Knob

    local dragging = false

    local function updateFromInput(input)
        local rel = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local rawVal = minVal + (rel * (maxVal - minVal))
        local stepped = math.floor((rawVal - minVal) / increment + 0.5) * increment + minVal
        stepped = math.clamp(stepped, minVal, maxVal)

        if increment < 1 then
            local dec = tostring(increment):match("%.(%d+)")
            local count = dec and #dec or 2
            stepped = tonumber(string.format("%." .. count .. "f", stepped))
        end

        currentValue = stepped
        local newPct = (maxVal == minVal) and 0 or ((currentValue - minVal) / (maxVal - minVal))
        Fill.Size = UDim2.new(newPct, 0, 1, 0)
        Knob.Position = UDim2.new(newPct, 0, 0.5, 0)
        ValueLabel.Text = tostring(currentValue) .. suffix
        cb(currentValue)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Tween(Knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16)})
            updateFromInput(input)
        end
    end)

    Maid:GiveTask(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end))

    Maid:GiveTask(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                Tween(Knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 14, 0, 14)})
            end
        end
    end))

    SliderFrame.MouseEnter:Connect(function()
        Tween(SliderFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85})
    end)
    SliderFrame.MouseLeave:Connect(function()
        Tween(SliderFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end)

    local SliderObject = {}
    SliderObject.Instance = SliderFrame

    function SliderObject:Set(newVal)
        currentValue = math.clamp(newVal, minVal, maxVal)
        local newPct = (maxVal == minVal) and 0 or ((currentValue - minVal) / (maxVal - minVal))
        Fill.Size = UDim2.new(newPct, 0, 1, 0)
        Knob.Position = UDim2.new(newPct, 0, 0.5, 0)
        ValueLabel.Text = tostring(currentValue) .. suffix
        cb(currentValue)
    end

    function SliderObject:Get()
        return currentValue
    end

    setmetatable(SliderObject, {
        __index = function(_, key) return SliderFrame[key] end,
        __newindex = function(_, key, value) SliderFrame[key] = value end
    })

    return SliderObject
end

return SliderComponent
