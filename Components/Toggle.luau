local ToggleComponent = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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
    local currentColor = initialColor or Color3.fromRGB(196, 36, 104)
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
    Card.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
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
    CardStroke.Color = Color3.fromRGB(48, 48, 48)
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
    Title.TextColor3 = Color3.fromRGB(240, 240, 245)
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
    HexLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    HexLabel.TextSize = 11
    HexLabel.TextXAlignment = Enum.TextXAlignment.Right
    HexLabel.ZIndex = 50002
    HexLabel.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -24, 0, 4)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    CloseBtn.TextSize = 12
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
    ValOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
    SVCursorStroke.Color = Color3.fromRGB(0, 0, 0)
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
    HueKnobStroke.Color = Color3.fromRGB(0, 0, 0)
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
        Color3.fromRGB(196, 36, 104),
        Color3.fromRGB(245, 245, 245),
        Color3.fromRGB(46, 204, 113),
        Color3.fromRGB(52, 152, 219),
        Color3.fromRGB(155, 89, 182),
        Color3.fromRGB(230, 126, 34),
        Color3.fromRGB(231, 76, 60),
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
    ModalBackdrop.MouseButton1Click:Connect(close)

    return {
        Set = function(newCol)
            currentColor = newCol
            h, s, v = currentColor:ToHSV()
            HueKnob.Position = UDim2.new(h, 0, 0.5, 0)
            SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            applyCurrent()
        end
    }
end

function ToggleComponent.Create(TabContent, Maid, Config, Flag)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Toggle"
    local descText = config.Description or ""
    local hoverText = config.HoverText or config.Tooltip or ""
    local state = config.CurrentValue ~= nil and config.CurrentValue or (config.Default ~= nil and config.Default or false)
    local cb = config.Callback or function() end

    local isCheckbox = (config.Style == 1 or config.Style == "Box" or config.Style == "Checkbox" or config.Box == true)

    local switchOnColor = config.SwitchColor or config.AccentColor or Color3.fromRGB(245, 245, 245)
    local switchOffColor = Color3.fromRGB(28, 28, 28)
    local strokeOffColor = Color3.fromRGB(48, 48, 48)
    local strokeOnColor = config.SwitchColor or config.AccentColor or Color3.fromRGB(245, 245, 245)
    local isLightOn = (switchOnColor.R * 0.299 + switchOnColor.G * 0.587 + switchOnColor.B * 0.114) > 0.5
    local dotOnColor = isLightOn and Color3.fromRGB(24, 24, 24) or Color3.fromRGB(255, 255, 255)

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Name = headerText
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Text = ""
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, descText == "" and 44 or 54)
    ToggleFrame.Parent = TabContent

    local MainLayout = Instance.new("UIListLayout")
    MainLayout.FillDirection = Enum.FillDirection.Horizontal
    MainLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = ToggleFrame

    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, -200, 1, 0)
    TextContainer.Parent = ToggleFrame

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
    Header.TextColor3 = Color3.fromRGB(240, 240, 245)
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.TextYAlignment = Enum.TextYAlignment.Center
    Header.TextTruncate = Enum.TextTruncate.AtEnd
    Header.Parent = TextContainer

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
        Description.TextTruncate = Enum.TextTruncate.AtEnd
        Description.Parent = TextContainer
    end

    local RightControls = Instance.new("Frame")
    RightControls.Name = "RightControls"
    RightControls.BackgroundTransparency = 1
    RightControls.LayoutOrder = 1
    RightControls.Size = UDim2.new(0, 0, 1, 0)
    RightControls.AutomaticSize = Enum.AutomaticSize.X
    RightControls.Parent = ToggleFrame

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.FillDirection = Enum.FillDirection.Horizontal
    RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RightLayout.Padding = UDim.new(0, 10)
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Parent = RightControls

    local RightPadding = Instance.new("UIPadding")
    RightPadding.PaddingRight = UDim.new(0, 14)
    RightPadding.Parent = RightControls

    local ToggleControl
    local UpdateToggleVisuals

    if isCheckbox then
        local BoxBg = Instance.new("TextButton")
        BoxBg.Name = "CheckboxBg"
        BoxBg.AutoButtonColor = false
        BoxBg.Text = ""
        BoxBg.BackgroundColor3 = state and switchOnColor or Color3.fromRGB(28, 28, 28)
        BoxBg.BackgroundTransparency = state and 0 or 0.2
        BoxBg.Size = UDim2.new(0, 22, 0, 22)
        BoxBg.LayoutOrder = 100
        BoxBg.Parent = RightControls

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 6)
        BoxCorner.Parent = BoxBg

        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        BoxStroke.Color = state and strokeOnColor or strokeOffColor
        BoxStroke.Thickness = 1
        BoxStroke.Parent = BoxBg

        local CheckIcon = Instance.new("ImageLabel")
        CheckIcon.Name = "CheckIcon"
        CheckIcon.BackgroundTransparency = 1
        CheckIcon.Size = state and UDim2.new(0, 14, 0, 14) or UDim2.new(0, 6, 0, 6)
        CheckIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CheckIcon.Image = "rbxassetid://10709790387"
        CheckIcon.ImageColor3 = dotOnColor
        CheckIcon.ImageTransparency = state and 0 or 1
        CheckIcon.Parent = BoxBg

        ToggleControl = BoxBg

        UpdateToggleVisuals = function()
            if state then
                Tween(BoxBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = switchOnColor,
                    BackgroundTransparency = 0,
                })
                Tween(BoxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = strokeOnColor,
                })
                Tween(CheckIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 0,
                    ImageColor3 = dotOnColor,
                    Size = UDim2.new(0, 14, 0, 14),
                })
            else
                Tween(BoxBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    BackgroundTransparency = 0.2,
                })
                Tween(BoxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = strokeOffColor,
                })
                Tween(CheckIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 1,
                    Size = UDim2.new(0, 6, 0, 6),
                })
            end
        end
    else
        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Name = "SwitchBg"
        SwitchBg.AutoButtonColor = false
        SwitchBg.Text = ""
        SwitchBg.BackgroundColor3 = state and switchOnColor or switchOffColor
        SwitchBg.Size = UDim2.new(0, 38, 0, 20)
        SwitchBg.LayoutOrder = 100
        SwitchBg.Parent = RightControls

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = SwitchBg

        local SwitchStroke = Instance.new("UIStroke")
        SwitchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        SwitchStroke.Color = state and strokeOnColor or strokeOffColor
        SwitchStroke.Thickness = 1
        SwitchStroke.Parent = SwitchBg

        local SwitchDot = Instance.new("Frame")
        SwitchDot.Name = "Dot"
        SwitchDot.BackgroundColor3 = state and dotOnColor or Color3.fromRGB(150, 150, 150)
        SwitchDot.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        SwitchDot.AnchorPoint = Vector2.new(0, 0.5)
        SwitchDot.Size = UDim2.new(0, 16, 0, 16)
        SwitchDot.Parent = SwitchBg

        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = SwitchDot

        ToggleControl = SwitchBg

        UpdateToggleVisuals = function()
            if state then
                Tween(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = switchOnColor})
                Tween(SwitchStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = strokeOnColor})
                Tween(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0.5, 0), BackgroundColor3 = dotOnColor})
            else
                Tween(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = switchOffColor})
                Tween(SwitchStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = strokeOffColor})
                Tween(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Color3.fromRGB(150, 150, 150)})
            end
        end
    end

    local function ToggleState()
        state = not state
        UpdateToggleVisuals()
        cb(state)
    end

    ToggleFrame.MouseButton1Click:Connect(ToggleState)
    ToggleControl.MouseButton1Click:Connect(ToggleState)

    ToggleFrame.MouseEnter:Connect(function()
        Tween(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85})
    end)
    ToggleFrame.MouseLeave:Connect(function()
        Tween(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end)

    local ToggleObject = {}
    ToggleObject.Instance = ToggleFrame
    ToggleObject.State = state

    function ToggleObject:Set(newState)
        state = not not newState
        UpdateToggleVisuals()
        cb(state)
    end

    function ToggleObject:Get()
        return state
    end

    function ToggleObject:AddColorPicker(cpConfig, cpFlag)
        cpConfig = cpConfig or {}
        local currentColor = cpConfig.CurrentValue or cpConfig.Default or Color3.fromRGB(196, 36, 104)
        local currentAlpha = cpConfig.Transparency or cpConfig.Alpha or 0
        local cpCallback = cpConfig.Callback or function() end

        local SwatchBtn = Instance.new("TextButton")
        SwatchBtn.Name = "ColorPickerSwatch"
        SwatchBtn.AutoButtonColor = false
        SwatchBtn.Text = ""
        SwatchBtn.BackgroundColor3 = currentColor
        SwatchBtn.Size = UDim2.new(0, 22, 0, 22)
        SwatchBtn.LayoutOrder = 10
        SwatchBtn.Parent = RightControls

        local SwatchCorner = Instance.new("UICorner")
        SwatchCorner.CornerRadius = UDim.new(0, 6)
        SwatchCorner.Parent = SwatchBtn

        local SwatchStroke = Instance.new("UIStroke")
        SwatchStroke.Color = Color3.fromRGB(48, 48, 48)
        SwatchStroke.Thickness = 1
        SwatchStroke.Parent = SwatchBtn

        SwatchBtn.MouseEnter:Connect(function()
            Tween(SwatchStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(80, 80, 80)})
        end)
        SwatchBtn.MouseLeave:Connect(function()
            Tween(SwatchStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(48, 48, 48)})
        end)

        SwatchBtn.MouseButton1Click:Connect(function()
            local overlay = getRootOverlay(ToggleFrame)
            if not overlay then return end
            createColorPickerPopup(overlay, currentColor, currentAlpha, function(newCol, newAlpha)
                currentColor = newCol
                currentAlpha = newAlpha or currentAlpha
                SwatchBtn.BackgroundColor3 = currentColor
                cpCallback(currentColor, currentAlpha)
            end)
        end)

        local CPObject = {}
        function CPObject:Set(newCol, newAlpha)
            currentColor = newCol or currentColor
            currentAlpha = newAlpha or currentAlpha
            SwatchBtn.BackgroundColor3 = currentColor
            cpCallback(currentColor, currentAlpha)
        end
        function CPObject:Get()
            return currentColor, currentAlpha
        end
        return CPObject
    end

    function ToggleObject:AddKeybind(kbConfig, kbFlag)
        kbConfig = kbConfig or {}
        local currentKey = kbConfig.CurrentValue or kbConfig.Default or "None"
        if typeof(currentKey) == "EnumItem" then
            currentKey = currentKey.Name
        end
        local syncToggle = kbConfig.SyncToggleState ~= false
        local kbCallback = kbConfig.Callback or function() end

        local KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Name = "KeybindBadge"
        KeybindBtn.AutoButtonColor = false
        KeybindBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        KeybindBtn.Size = UDim2.new(0, 0, 0, 22)
        KeybindBtn.AutomaticSize = Enum.AutomaticSize.X
        KeybindBtn.LayoutOrder = 20
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
        local listenConn

        KeybindBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            KbLabel.Text = "[ ... ]"
            Tween(KbStroke, TweenInfo.new(0.2), {Color = switchOnColor})

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
                    if listenConn then
                        listenConn:Disconnect()
                        listenConn = nil
                    end
                    kbCallback(currentKey, state)
                end
            end)
        end)

        Maid:GiveTask(UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed or listening then return end
            if UserInputService:GetFocusedTextBox() then return end
            if currentKey == "None" or currentKey == "" then return end

            local matched = false
            if currentKey == "MB1" and input.UserInputType == Enum.UserInputType.MouseButton1 then
                matched = true
            elseif currentKey == "MB2" and input.UserInputType == Enum.UserInputType.MouseButton2 then
                matched = true
            elseif currentKey == "MB3" and input.UserInputType == Enum.UserInputType.MouseButton3 then
                matched = true
            elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
                matched = true
            end

            if matched then
                if syncToggle then
                    ToggleState()
                end
                kbCallback(currentKey, state)
            end
        end))

        local KBObject = {}
        function KBObject:Set(newKey)
            currentKey = typeof(newKey) == "EnumItem" and newKey.Name or tostring(newKey)
            KbLabel.Text = currentKey
            kbCallback(currentKey, state)
        end
        function KBObject:Get()
            return currentKey
        end
        return KBObject
    end
    ToggleObject.AddBind = ToggleObject.AddKeybind

    function ToggleObject:AddDropdown(ddConfig, ddFlag)
        ddConfig = ddConfig or {}
        local options = ddConfig.Options or {}
        local currentOption = ddConfig.CurrentValue or ddConfig.Default or (options[1] or "None")
        local ddCallback = ddConfig.Callback or function() end

        local DropBtn = Instance.new("TextButton")
        DropBtn.Name = "MiniDropdown"
        DropBtn.AutoButtonColor = false
        DropBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        DropBtn.Size = UDim2.new(0, 0, 0, 22)
        DropBtn.AutomaticSize = Enum.AutomaticSize.X
        DropBtn.LayoutOrder = 5
        DropBtn.Text = ""
        DropBtn.Parent = RightControls

        local Dc = Instance.new("UICorner")
        Dc.CornerRadius = UDim.new(0, 5)
        Dc.Parent = DropBtn

        local Ds = Instance.new("UIStroke")
        Ds.Color = Color3.fromRGB(48, 48, 48)
        Ds.Thickness = 1
        Ds.Parent = DropBtn

        local Dp = Instance.new("UIPadding")
        Dp.PaddingLeft = UDim.new(0, 8)
        Dp.PaddingRight = UDim.new(0, 8)
        Dp.Parent = DropBtn

        local Dl = Instance.new("TextLabel")
        Dl.BackgroundTransparency = 1
        Dl.Size = UDim2.new(1, 0, 1, 0)
        Dl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Dl.Text = tostring(currentOption) .. "  ▾"
        Dl.TextColor3 = Color3.fromRGB(240, 240, 245)
        Dl.TextSize = 12
        Dl.Parent = DropBtn

        local ddMenuOpen = false
        local menuFrame = nil

        local function closeDropdownMenu()
            if not ddMenuOpen then return end
            ddMenuOpen = false
            if menuFrame then
                menuFrame:Destroy()
                menuFrame = nil
            end
        end

        DropBtn.MouseButton1Click:Connect(function()
            if ddMenuOpen then
                closeDropdownMenu()
                return
            end
            local overlay = getRootOverlay(ToggleFrame)
            if not overlay then return end
            ddMenuOpen = true

            menuFrame = Instance.new("Frame")
            menuFrame.Name = "MiniDropdownMenu"
            menuFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            menuFrame.BorderSizePixel = 0
            menuFrame.ZIndex = 50010
            menuFrame.Parent = overlay

            local mc = Instance.new("UICorner")
            mc.CornerRadius = UDim.new(0, 6)
            mc.Parent = menuFrame

            local ms = Instance.new("UIStroke")
            ms.Color = Color3.fromRGB(48, 48, 48)
            ms.Parent = menuFrame

            local ml = Instance.new("UIListLayout")
            ml.SortOrder = Enum.SortOrder.LayoutOrder
            ml.Parent = menuFrame

            local screenGui = overlay.Parent
            local startX = DropBtn.AbsolutePosition.X - screenGui.AbsolutePosition.X
            local startY = (DropBtn.AbsolutePosition.Y - screenGui.AbsolutePosition.Y) + DropBtn.AbsoluteSize.Y + 4
            menuFrame.Position = UDim2.new(0, startX, 0, startY)
            menuFrame.Size = UDim2.new(0, math.max(DropBtn.AbsoluteSize.X, 90), 0, #options * 24 + 8)

            local mp = Instance.new("UIPadding")
            mp.PaddingTop = UDim.new(0, 4)
            mp.PaddingBottom = UDim.new(0, 4)
            mp.PaddingLeft = UDim.new(0, 4)
            mp.PaddingRight = UDim.new(0, 4)
            mp.Parent = menuFrame

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
                OptBtn.BackgroundTransparency = (opt == currentOption) and 0 or 1
                OptBtn.Size = UDim2.new(1, 0, 0, 22)
                OptBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                OptBtn.Text = opt
                OptBtn.TextColor3 = (opt == currentOption) and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(160, 160, 170)
                OptBtn.TextSize = 11
                OptBtn.ZIndex = 50011
                OptBtn.Parent = menuFrame

                local oc = Instance.new("UICorner")
                oc.CornerRadius = UDim.new(0, 4)
                oc.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    currentOption = opt
                    Dl.Text = tostring(currentOption) .. "  ▾"
                    closeDropdownMenu()
                    ddCallback(currentOption)
                end)
            end
        end)

        local DDObject = {}
        function DDObject:Set(newOpt)
            currentOption = newOpt
            Dl.Text = tostring(currentOption) .. "  ▾"
            ddCallback(currentOption)
        end
        function DDObject:Get()
            return currentOption
        end
        return DDObject
    end

    setmetatable(ToggleObject, {
        __index = function(_, key) return ToggleFrame[key] end,
        __newindex = function(_, key, value) ToggleFrame[key] = value end
    })

    return ToggleObject
end

return ToggleComponent
