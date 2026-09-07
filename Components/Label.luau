local LabelComponent = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

local function getRootOverlay(instance)
    local screenGui = instance:FindFirstAncestorOfClass("ScreenGui")
    if not screenGui then return nil end
    local overlay = screenGui:FindFirstChild("VoltPopupOverlay")
    if not overlay then
        overlay = Instance.new("Frame")
        overlay.Name = "VoltPopupOverlay"
        overlay.BackgroundTransparency = 1
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.ZIndex = 50000
        overlay.Parent = screenGui
    end
    return overlay
end

function LabelComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Label"
    local descText = config.Description or ""
    local iconAsset = config.Icon
    local accentColor = config.AccentColor or Color3.fromRGB(245, 245, 245)

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = headerText
    LabelFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.BorderSizePixel = 0
    LabelFrame.Size = UDim2.new(1, 0, 0, descText == "" and 38 or 48)
    LabelFrame.Parent = TabContent

    local LabelLayout = Instance.new("UIListLayout")
    LabelLayout.FillDirection = Enum.FillDirection.Horizontal
    LabelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LabelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LabelLayout.Parent = LabelFrame

    local LeftContainer = Instance.new("Frame")
    LeftContainer.Name = "Left"
    LeftContainer.BackgroundTransparency = 1
    LeftContainer.Size = UDim2.new(1, -160, 1, 0)
    LeftContainer.Parent = LabelFrame

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LeftLayout.Padding = UDim.new(0, 2)
    LeftLayout.Parent = LeftContainer

    local LeftPadding = Instance.new("UIPadding")
    LeftPadding.PaddingLeft = UDim.new(0, 14)
    LeftPadding.Parent = LeftContainer

    local HeaderRow = Instance.new("Frame")
    HeaderRow.Name = "HeaderRow"
    HeaderRow.BackgroundTransparency = 1
    HeaderRow.Size = UDim2.new(1, 0, 0, 18)
    HeaderRow.Parent = LeftContainer

    local HeaderLayout = Instance.new("UIListLayout")
    HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    HeaderLayout.Padding = UDim.new(0, 8)
    HeaderLayout.Parent = HeaderRow

    if iconAsset then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.BackgroundTransparency = 1
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Image = (type(iconAsset) == "number") and ("rbxassetid://" .. tostring(iconAsset)) or tostring(iconAsset)
        Icon.ImageColor3 = Color3.fromRGB(240, 240, 245)
        Icon.Parent = HeaderRow
    end

    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Header.Size = UDim2.new(1, -30, 1, 0)
    Header.Text = headerText
    Header.TextColor3 = Color3.fromRGB(240, 240, 245)
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.TextYAlignment = Enum.TextYAlignment.Center
    Header.Parent = HeaderRow

    if descText ~= "" then
        local Description = Instance.new("TextLabel")
        Description.Name = "Description"
        Description.BackgroundTransparency = 1
        Description.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Description.Size = UDim2.new(1, 0, 0, 14)
        Description.Text = descText
        Description.TextColor3 = Color3.fromRGB(150, 150, 160)
        Description.TextSize = 12
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextYAlignment = Enum.TextYAlignment.Center
        Description.Parent = LeftContainer
    end

    local RightControls = Instance.new("Frame")
    RightControls.Name = "RightControls"
    RightControls.BackgroundTransparency = 1
    RightControls.LayoutOrder = 1
    RightControls.Size = UDim2.new(0, 160, 1, 0)
    RightControls.Parent = LabelFrame

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.FillDirection = Enum.FillDirection.Horizontal
    RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RightLayout.Padding = UDim.new(0, 8)
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Parent = RightControls

    local RightPadding = Instance.new("UIPadding")
    RightPadding.PaddingRight = UDim.new(0, 14)
    RightPadding.Parent = RightControls

    local LabelObject = {}
    LabelObject.Instance = LabelFrame

    function LabelObject:Set(newText)
        headerText = tostring(newText)
        Header.Text = headerText
    end

    function LabelObject:Get()
        return headerText
    end

    function LabelObject:AddKeybind(kbConfig)
        kbConfig = kbConfig or {}
        local currentKey = kbConfig.Default or kbConfig.CurrentValue or "None"
        if typeof(currentKey) == "EnumItem" then currentKey = currentKey.Name end
        local kbCallback = kbConfig.Callback or function() end

        local KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Name = "KeybindBadge"
        KeybindBtn.AutoButtonColor = false
        KeybindBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        KeybindBtn.Size = UDim2.new(0, 0, 0, 22)
        KeybindBtn.AutomaticSize = Enum.AutomaticSize.X
        KeybindBtn.Text = ""
        KeybindBtn.Parent = RightControls

        local KbCorner = Instance.new("UICorner")
        KbCorner.CornerRadius = UDim.new(0, 5)
        KbCorner.Parent = KeybindBtn

        local KbStroke = Instance.new("UIStroke")
        KbStroke.Color = Color3.fromRGB(48, 48, 48)
        KbStroke.Thickness = 1
        KbStroke.Parent = KeybindBtn

        local KbPadding = Instance.new("UIPadding")
        KbPadding.PaddingLeft = UDim.new(0, 8)
        KbPadding.PaddingRight = UDim.new(0, 8)
        KbPadding.Parent = KeybindBtn

        local KbLabel = Instance.new("TextLabel")
        KbLabel.Name = "Label"
        KbLabel.BackgroundTransparency = 1
        KbLabel.Size = UDim2.new(1, 0, 1, 0)
        KbLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        KbLabel.Text = tostring(currentKey)
        KbLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        KbLabel.TextSize = 12
        KbLabel.Parent = KeybindBtn

        local listening = false
        KeybindBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            KbLabel.Text = "[ ... ]"
            Tween(KbStroke, TweenInfo.new(0.2), {Color = accentColor})

            local listenConn
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
                    KbLabel.Text = currentKey
                    Tween(KbStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(48, 48, 48)})
                    listening = false
                    listenConn:Disconnect()
                    kbCallback(currentKey)
                end
            end)
        end)

        return {
            Set = function(_, key)
                currentKey = tostring(key)
                KbLabel.Text = currentKey
            end,
            Get = function() return currentKey end
        }
    end
    LabelObject.AddBind = LabelObject.AddKeybind

    function LabelObject:AddColorPicker(cpConfig)
        cpConfig = cpConfig or {}
        local currentColor = cpConfig.Default or cpConfig.CurrentValue or Color3.fromRGB(196, 36, 104)
        local cpCallback = cpConfig.Callback or function() end

        local SwatchBtn = Instance.new("TextButton")
        SwatchBtn.Name = "ColorPickerSwatch"
        SwatchBtn.AutoButtonColor = false
        SwatchBtn.Text = ""
        SwatchBtn.BackgroundColor3 = currentColor
        SwatchBtn.Size = UDim2.new(0, 22, 0, 22)
        SwatchBtn.Parent = RightControls

        local SwatchCorner = Instance.new("UICorner")
        SwatchCorner.CornerRadius = UDim.new(0, 6)
        SwatchCorner.Parent = SwatchBtn

        local SwatchStroke = Instance.new("UIStroke")
        SwatchStroke.Color = Color3.fromRGB(48, 48, 48)
        SwatchStroke.Thickness = 1
        SwatchStroke.Parent = SwatchBtn

        SwatchBtn.MouseButton1Click:Connect(function()
            local overlay = getRootOverlay(LabelFrame)
            if not overlay then return end
            local newCol = (currentColor == Color3.fromRGB(196, 36, 104)) and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(196, 36, 104)
            currentColor = newCol
            SwatchBtn.BackgroundColor3 = currentColor
            cpCallback(currentColor)
        end)

        return {
            Set = function(_, col)
                currentColor = col
                SwatchBtn.BackgroundColor3 = currentColor
                cpCallback(currentColor)
            end,
            Get = function() return currentColor end
        }
    end

    setmetatable(LabelObject, {
        __index = function(_, key) return LabelFrame[key] end,
        __newindex = function(_, key, value) LabelFrame[key] = value end
    })

    return LabelObject
end

return LabelComponent
