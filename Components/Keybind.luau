local KeybindComponent = {}
local TweenService = game:GetService("TweenService")
local ThemeManager = require(script.Parent.Parent.Core.Theme)
local UserInputService = game:GetService("UserInputService")

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

function KeybindComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Keybind"
    local descText = config.Description or ""
    local currentKey = config.Default or config.CurrentValue or "None"
    if typeof(currentKey) == "EnumItem" then
        currentKey = currentKey.Name
    end
    local cb = config.Callback or function() end
    local accentColor = config.AccentColor or Color3.fromRGB(245, 245, 245)

    local RowFrame = Instance.new("Frame")
    RowFrame.Name = headerText
    ThemeManager:Register(RowFrame, "BackgroundColor3", "SecondaryBackground")
    RowFrame.BackgroundTransparency = 1
    RowFrame.BorderSizePixel = 0
    RowFrame.Size = UDim2.new(1, 0, 0, descText == "" and 42 or 52)
    RowFrame.Parent = TabContent

    local RowLayout = Instance.new("UIListLayout")
    RowLayout.FillDirection = Enum.FillDirection.Horizontal
    RowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RowLayout.Parent = RowFrame

    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, -120, 1, 0)
    TextContainer.Parent = RowFrame

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

    local KeybindContainer = Instance.new("Frame")
    KeybindContainer.Name = "KeybindContainer"
    KeybindContainer.BackgroundTransparency = 1
    KeybindContainer.LayoutOrder = 1
    KeybindContainer.Size = UDim2.new(0, 120, 1, 0)
    KeybindContainer.Parent = RowFrame

    local KeybindLayout = Instance.new("UIListLayout")
    KeybindLayout.FillDirection = Enum.FillDirection.Horizontal
    KeybindLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    KeybindLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    KeybindLayout.Parent = KeybindContainer

    local KeybindPadding = Instance.new("UIPadding")
    KeybindPadding.PaddingRight = UDim.new(0, 14)
    KeybindPadding.Parent = KeybindContainer

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Name = "KeyBtn"
    KeyBtn.AutoButtonColor = false
    ThemeManager:Register(KeyBtn, "BackgroundColor3", "MainBackground")
    KeyBtn.Size = UDim2.new(0, 0, 0, 26)
    KeyBtn.AutomaticSize = Enum.AutomaticSize.X
    KeyBtn.Text = ""
    KeyBtn.Parent = KeybindContainer

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 6)
    KeyCorner.Parent = KeyBtn

    local KeyStroke = Instance.new("UIStroke")
    ThemeManager:Register(KeyStroke, "Color", "StrokeColor")
    KeyStroke.Thickness = 1
    KeyStroke.Parent = KeyBtn

    local BtnPadding = Instance.new("UIPadding")
    BtnPadding.PaddingLeft = UDim.new(0, 10)
    BtnPadding.PaddingRight = UDim.new(0, 10)
    BtnPadding.Parent = KeyBtn

    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Name = "Label"
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Size = UDim2.new(0, 0, 1, 0)
    KeyLabel.AutomaticSize = Enum.AutomaticSize.X
    KeyLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    KeyLabel.Text = tostring(currentKey)
    ThemeManager:Register(KeyLabel, "TextColor3", "TextPrimary")
    KeyLabel.TextSize = 12
    KeyLabel.Parent = KeyBtn

    local listening = false
    local listenConn

    local function stopListening()
        if not listening then return end
        listening = false
        KeyLabel.Text = tostring(currentKey)
        Tween(KeyStroke, TweenInfo.new(0.2), {Color = ThemeManager:GetColor("StrokeColor")})
        if listenConn then
            listenConn:Disconnect()
            listenConn = nil
        end
    end

    KeyBtn.MouseButton1Click:Connect(function()
        if listening then
            stopListening()
            return
        end

        listening = true
        KeyLabel.Text = "[ ... ]"
        Tween(KeyStroke, TweenInfo.new(0.2), {Color = accentColor})

        listenConn = UserInputService.InputBegan:Connect(function(input)
            local capturedKey = nil

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                capturedKey = "MB1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                capturedKey = "MB2"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                capturedKey = "MB3"
            elseif input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
                    capturedKey = "None"
                elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                    capturedKey = input.KeyCode.Name
                end
            end

            if capturedKey then
                currentKey = capturedKey
                KeyLabel.Text = currentKey
                Tween(KeyStroke, TweenInfo.new(0.2), {Color = ThemeManager:GetColor("StrokeColor")})
                listening = false
                if listenConn then
                    listenConn:Disconnect()
                    listenConn = nil
                end
                cb(currentKey)
            end
        end)
    end)

    Maid:GiveTask(function()
        stopListening()
    end)

    RowFrame.MouseEnter:Connect(function()
        Tween(RowFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85})
    end)
    RowFrame.MouseLeave:Connect(function()
        Tween(RowFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end)

    local KeybindObject = {}
    KeybindObject.Instance = RowFrame

    function KeybindObject:Set(newKey)
        if typeof(newKey) == "EnumItem" then
            newKey = newKey.Name
        end
        currentKey = tostring(newKey)
        KeyLabel.Text = currentKey
        cb(currentKey)
    end

    function KeybindObject:Get()
        return currentKey
    end

    setmetatable(KeybindObject, {
        __index = function(_, key) return RowFrame[key] end,
        __newindex = function(_, key, value) RowFrame[key] = value end
    })

    return KeybindObject
end

return KeybindComponent
