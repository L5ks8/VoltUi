local ColorPickerComponent = {}
local TweenService = game:GetService("TweenService")
local ThemeManager = require(script.Parent.Parent.Core.Theme)
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

local function createColorPickerPopup(rootOverlay, initialColor, initialAlpha, onChangeCallback)
    local currentColor = initialColor or Color3.fromRGB(245, 245, 245)
    local currentAlpha = initialAlpha or 0
    local h, s, v = currentColor:ToHSV()

    local ModalBackdrop = Instance.new("TextButton")
    ModalBackdrop.Name = "ColorPickerBackdrop"
    ModalBackdrop.AutoButtonColor = false
    ModalBackdrop.Text = ""
    ModalBackdrop.BackgroundTransparency = 1
    ModalBackdrop.Size = UDim2.new(1, 0, 1, 0)
    ModalBackdrop.ZIndex = 50000
    ModalBackdrop.Parent = rootOverlay

    local Card = Instance.new("Frame")
    Card.Name = "ColorPickerCard"
    ThemeManager:Register(Card, "BackgroundColor3", "SecondaryBackground")
    Card.BorderSizePixel = 0
    Card.Size = UDim2.new(0, 230, 0, 260)
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.new(0.5, 0, 0.5, 0)
    Card.ZIndex = 50001
    Card.Parent = ModalBackdrop

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    ThemeManager:Register(CardStroke, "Color", "StrokeColor")
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 28)
    Header.Parent = Card

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(0, 100, 1, 0)
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Title.Text = "Color Picker"
    ThemeManager:Register(Title, "TextColor3", "TextPrimary")
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 50002
    Title.Parent = Header

    local HexLabel = Instance.new("TextLabel")
    HexLabel.Name = "HexLabel"
    HexLabel.BackgroundTransparency = 1
    HexLabel.Position = UDim2.new(1, -70, 0, 0)
    HexLabel.Size = UDim2.new(0, 45, 1, 0)
    HexLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    HexLabel.Text = "#" .. currentColor:ToHex():upper()
    ThemeManager:Register(HexLabel, "TextColor3", "TextSecondary")
    HexLabel.TextSize = 11
    HexLabel.TextXAlignment = Enum.TextXAlignment.Right
    HexLabel.ZIndex = 50002
    HexLabel.Parent = Header

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "Close"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -26, 0, 4)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Image = "rbxassetid://121170570745612"
    ThemeManager:Register(CloseBtn, "ImageColor3", "TextSecondary")
    CloseBtn.ZIndex = 50002
    CloseBtn.Parent = Header

    local SVCanvas = Instance.new("TextButton")
    SVCanvas.Name = "SVCanvas"
    SVCanvas.AutoButtonColor = false
    SVCanvas.Text = ""
    SVCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    SVCanvas.BorderSizePixel = 0
    SVCanvas.Position = UDim2.new(0, 12, 0, 32)
    SVCanvas.Size = UDim2.new(0, 206, 0, 130)
    SVCanvas.ZIndex = 50002
    SVCanvas.Parent = Card

    local SVCorner = Instance.new("UICorner")
    SVCorner.CornerRadius = UDim.new(0, 6)
    SVCorner.Parent = SVCanvas

    local SatGrad = Instance.new("UIGradient")
    SatGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
    SatGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    SatGrad.Parent = SVCanvas

    local ValOverlay = Instance.new("Frame")
    ValOverlay.Name = "ValOverlay"
    ThemeManager:Register(ValOverlay, "BackgroundColor3", "MainBackground")
    ValOverlay.BorderSizePixel = 0
    ValOverlay.Size = UDim2.new(1, 0, 1, 0)
    ValOverlay.ZIndex = 50003
    ValOverlay.Parent = SVCanvas

    local ValCorner = Instance.new("UICorner")
    ValCorner.CornerRadius = UDim.new(0, 6)
    ValCorner.Parent = ValOverlay

    local ValGrad = Instance.new("UIGradient")
    ValGrad.Rotation = 90
    ValGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    ValGrad.Parent = ValOverlay

    local SVCursor = Instance.new("Frame")
    SVCursor.Name = "Cursor"
    SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
    SVCursor.Size = UDim2.new(0, 12, 0, 12)
    SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SVCursor.BorderSizePixel = 0
    SVCursor.ZIndex = 50004
    SVCursor.Parent = SVCanvas

    local SVCursorCorner = Instance.new("UICorner")
    SVCursorCorner.CornerRadius = UDim.new(1, 0)
    SVCursorCorner.Parent = SVCursor

    local SVCursorStroke = Instance.new("UIStroke")
    ThemeManager:Register(SVCursorStroke, "Color", "MainBackground")
    SVCursorStroke.Thickness = 1.5
    SVCursorStroke.Parent = SVCursor

    local HueBar = Instance.new("TextButton")
    HueBar.Name = "HueBar"
    HueBar.AutoButtonColor = false
    HueBar.Text = ""
    HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueBar.BorderSizePixel = 0
    HueBar.Position = UDim2.new(0, 12, 0, 172)
    HueBar.Size = UDim2.new(0, 206, 0, 12)
    HueBar.ZIndex = 50002
    HueBar.Parent = Card

    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(1, 0)
    HueCorner.Parent = HueBar

    local HueGrad = Instance.new("UIGradient")
    HueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
    })
    HueGrad.Parent = HueBar

    local HueKnob = Instance.new("Frame")
    HueKnob.Name = "Knob"
    HueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
    HueKnob.Size = UDim2.new(0, 16, 0, 16)
    HueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueKnob.BorderSizePixel = 0
    HueKnob.ZIndex = 50003
    HueKnob.Parent = HueBar

    local HueKnobCorner = Instance.new("UICorner")
    HueKnobCorner.CornerRadius = UDim.new(1, 0)
    HueKnobCorner.Parent = HueKnob

    local HueKnobStroke = Instance.new("UIStroke")
    ThemeManager:Register(HueKnobStroke, "Color", "MainBackground")
    HueKnobStroke.Thickness = 1.5
    HueKnobStroke.Parent = HueKnob

    local PaletteRow = Instance.new("Frame")
    PaletteRow.Name = "Palette"
    PaletteRow.BackgroundTransparency = 1
    PaletteRow.Position = UDim2.new(0, 12, 0, 196)
    PaletteRow.Size = UDim2.new(0, 206, 0, 22)
    PaletteRow.ZIndex = 50002
    PaletteRow.Parent = Card

    local PaletteLayout = Instance.new("UIListLayout")
    PaletteLayout.FillDirection = Enum.FillDirection.Horizontal
    PaletteLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    PaletteLayout.Padding = UDim.new(0, 6)
    PaletteLayout.Parent = PaletteRow

    local presets = {
        Color3.fromRGB(245, 245, 245),
        Color3.fromRGB(46, 204, 113),
        Color3.fromRGB(52, 152, 219),
        Color3.fromRGB(155, 89, 182),
        Color3.fromRGB(230, 126, 34),
        Color3.fromRGB(231, 76, 60),
        Color3.fromRGB(241, 196, 15),
    }

    local function applyCurrent()
        currentColor = Color3.fromHSV(h, s, v)
        SVCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        HexLabel.Text = "#" .. currentColor:ToHex():upper()
        if onChangeCallback then
            onChangeCallback(currentColor, currentAlpha)
        end
    end

    for _, pcol in ipairs(presets) do
        local Dot = Instance.new("TextButton")
        Dot.Name = "Preset"
        Dot.AutoButtonColor = false
        Dot.Text = ""
        Dot.BackgroundColor3 = pcol
        Dot.Size = UDim2.new(0, 20, 0, 20)
        Dot.ZIndex = 50003
        Dot.Parent = PaletteRow

        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = Dot

        Dot.MouseButton1Click:Connect(function()
            h, s, v = pcol:ToHSV()
            HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
            SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            applyCurrent()
        end)
    end

    local draggingSV = false
    local draggingHue = false

    local function updateSV(input)
        local relX = math.clamp((input.Position.X - SVCanvas.AbsolutePosition.X) / SVCanvas.AbsoluteSize.X, 0, 1)
        local relY = math.clamp((input.Position.Y - SVCanvas.AbsolutePosition.Y) / SVCanvas.AbsoluteSize.Y, 0, 1)
        s = relX
        v = 1 - relY
        SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
        applyCurrent()
    end

    local function updateHue(input)
        local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
        h = relX
        HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
        applyCurrent()
    end

    SVCanvas.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
            updateSV(input)
        end
    end)

    HueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            updateHue(input)
        end
    end)

    local moveConn = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingSV then updateSV(input) end
            if draggingHue then updateHue(input) end
        end
    end)

    local endConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = false
            draggingHue = false
        end
    end)

    local function close()
        moveConn:Disconnect()
        endConn:Disconnect()
        ModalBackdrop:Destroy()
    end

    CloseBtn.MouseButton1Click:Connect(close)
    ModalBackdrop.MouseButton1Click:Connect(function()
        close()
    end)

    return {
        SetColor = function(newCol)
            currentColor = newCol
            h, s, v = currentColor:ToHSV()
            HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
            SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            applyCurrent()
        end
    }
end

function ColorPickerComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Color Picker"
    local descText = config.Description or ""
    local currentColor = config.Default or config.CurrentValue or Color3.fromRGB(245, 245, 245)
    local currentAlpha = config.Alpha or 0
    local cb = config.Callback or function() end

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

    local SwatchContainer = Instance.new("Frame")
    SwatchContainer.Name = "SwatchContainer"
    SwatchContainer.BackgroundTransparency = 1
    SwatchContainer.LayoutOrder = 1
    SwatchContainer.Size = UDim2.new(0, 120, 1, 0)
    SwatchContainer.Parent = RowFrame

    local SwatchLayout = Instance.new("UIListLayout")
    SwatchLayout.FillDirection = Enum.FillDirection.Horizontal
    SwatchLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    SwatchLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SwatchLayout.Padding = UDim.new(0, 8)
    SwatchLayout.Parent = SwatchContainer

    local SwatchPadding = Instance.new("UIPadding")
    SwatchPadding.PaddingRight = UDim.new(0, 14)
    SwatchPadding.Parent = SwatchContainer

    local HexPreview = Instance.new("TextLabel")
    HexPreview.Name = "HexPreview"
    HexPreview.BackgroundTransparency = 1
    HexPreview.Size = UDim2.new(0, 56, 0, 20)
    HexPreview.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    HexPreview.Text = "#" .. currentColor:ToHex():upper()
    ThemeManager:Register(HexPreview, "TextColor3", "TextTertiary")
    HexPreview.TextSize = 11
    HexPreview.TextXAlignment = Enum.TextXAlignment.Right
    HexPreview.Parent = SwatchContainer

    local SwatchBtn = Instance.new("TextButton")
    SwatchBtn.Name = "Swatch"
    SwatchBtn.AutoButtonColor = false
    SwatchBtn.Text = ""
    SwatchBtn.BackgroundColor3 = currentColor
    SwatchBtn.Size = UDim2.new(0, 26, 0, 26)
    SwatchBtn.Parent = SwatchContainer

    local SwatchCorner = Instance.new("UICorner")
    SwatchCorner.CornerRadius = UDim.new(0, 6)
    SwatchCorner.Parent = SwatchBtn

    local SwatchStroke = Instance.new("UIStroke")
    SwatchStroke.Color = Color3.fromRGB(55, 52, 65)
    SwatchStroke.Thickness = 1
    SwatchStroke.Parent = SwatchBtn

    local popupRef = nil

    local function updateColor(newCol, newAlpha)
        currentColor = newCol
        currentAlpha = newAlpha or currentAlpha
        SwatchBtn.BackgroundColor3 = currentColor
        HexPreview.Text = "#" .. currentColor:ToHex():upper()
        cb(currentColor, currentAlpha)
    end

    SwatchBtn.MouseButton1Click:Connect(function()
        local overlay = getRootOverlay(RowFrame)
        if not overlay then return end
        popupRef = createColorPickerPopup(overlay, currentColor, currentAlpha, function(newCol, newAlpha)
            updateColor(newCol, newAlpha)
        end)
    end)

    RowFrame.MouseEnter:Connect(function()
        Tween(RowFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85})
    end)
    RowFrame.MouseLeave:Connect(function()
        Tween(RowFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end)

    local ColorPickerObject = {}
    ColorPickerObject.Instance = RowFrame

    function ColorPickerObject:Set(newCol, newAlpha)
        updateColor(newCol, newAlpha)
        if popupRef and popupRef.SetColor then
            popupRef.SetColor(newCol)
        end
    end

    function ColorPickerObject:Get()
        return currentColor, currentAlpha
    end

    setmetatable(ColorPickerObject, {
        __index = function(_, key) return RowFrame[key] end,
        __newindex = function(_, key, value) RowFrame[key] = value end
    })

    return ColorPickerObject
end

return ColorPickerComponent
