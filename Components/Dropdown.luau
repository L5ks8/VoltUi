local DropdownComponent = {}
local TweenService = game:GetService("TweenService")
local ThemeManager = require(script.Parent.Parent.Core.Theme)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

function DropdownComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or "Dropdown"
    local descText = config.Description or ""
    local hoverText = config.HoverText or ""
    local options = config.Options or {}
    local isMulti = config.MultipleOptions or config.Multiselect or false
    local isLarge = config.Large or false
    local cb = config.Callback or function() end

    local selectedSingle = ""
    local selectedMulti = {}

    local defaultVal = config.CurrentOption or config.CurrentValue or config.Default
    if isMulti then
        if type(defaultVal) == "table" then
            for k, v in pairs(defaultVal) do
                if type(k) == "number" then
                    selectedMulti[tostring(v)] = true
                elseif v == true then
                    selectedMulti[tostring(k)] = true
                end
            end
        elseif type(defaultVal) == "string" and defaultVal ~= "" then
            selectedMulti[defaultVal] = true
        end
    else
        selectedSingle = (defaultVal and defaultVal ~= "") and defaultVal or (options[1] or "")
    end

    local function getMultiList()
        local list = {}
        for _, opt in ipairs(options) do
            if selectedMulti[opt] then
                table.insert(list, opt)
            end
        end
        return list
    end

    local function getDisplayText()
        if isMulti then
            local list = getMultiList()
            if #list == 0 then
                return config.Placeholder or "Select options..."
            end
            return table.concat(list, ", ")
        else
            return selectedSingle ~= "" and selectedSingle or (config.Placeholder or "Select...")
        end
    end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = headerText
    ThemeManager:Register(DropdownFrame, "BackgroundColor3", "SecondaryBackground")
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.BorderSizePixel = 0

    local height = 42
    if isLarge then
        height = descText == "" and 60 or 75
    else
        height = descText == "" and 42 or 52
    end
    DropdownFrame.Size = UDim2.new(1, 0, 0, height)
    DropdownFrame.Parent = TabContent

    local MainLayout = Instance.new("UIListLayout")
    MainLayout.FillDirection = isLarge and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = DropdownFrame

    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = isLarge and UDim2.new(1, 0, 0, descText == "" and 26 or 40) or UDim2.new(1, -150, 1, 0)
    TextContainer.Parent = DropdownFrame

    local TextLayout = Instance.new("UIListLayout")
    TextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TextLayout.Padding = UDim.new(0, 2)
    TextLayout.Parent = TextContainer

    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 14)
    if isLarge then
        TextPadding.PaddingTop = UDim.new(0, 4)
    end
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

    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Name = "DropdownContainer"
    DropdownContainer.BackgroundTransparency = 1
    DropdownContainer.LayoutOrder = 1
    DropdownContainer.Size = isLarge and UDim2.new(1, 0, 0, 32) or UDim2.new(0, 150, 1, 0)
    DropdownContainer.Parent = DropdownFrame

    local DropdownContainerLayout = Instance.new("UIListLayout")
    DropdownContainerLayout.FillDirection = Enum.FillDirection.Horizontal
    DropdownContainerLayout.HorizontalAlignment = isLarge and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Right
    DropdownContainerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    DropdownContainerLayout.Parent = DropdownContainer

    local DropdownContainerPadding = Instance.new("UIPadding")
    if not isLarge then
        DropdownContainerPadding.PaddingRight = UDim.new(0, 14)
    end
    DropdownContainerPadding.Parent = DropdownContainer

    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Name = "DropdownBtn"
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    DropdownBtn.Size = isLarge and UDim2.new(1, -28, 0, 28) or UDim2.new(0, 136, 0, 26)
    DropdownBtn.Text = ""
    DropdownBtn.AutoButtonColor = false
    DropdownBtn.Parent = DropdownContainer

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownBtn

    local DropdownStroke = Instance.new("UIStroke")
    ThemeManager:Register(DropdownStroke, "Color", "StrokeColor")
    DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DropdownStroke.Parent = DropdownBtn

    local DropdownText = Instance.new("TextLabel")
    DropdownText.Name = "SelectedText"
    DropdownText.BackgroundTransparency = 1
    DropdownText.Size = UDim2.new(1, -30, 1, 0)
    DropdownText.Position = UDim2.new(0, 10, 0, 0)
    DropdownText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    DropdownText.Text = getDisplayText()
    ThemeManager:Register(DropdownText, "TextColor3", "TextPrimary")
    DropdownText.TextSize = 12
    DropdownText.TextXAlignment = Enum.TextXAlignment.Left
    DropdownText.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownText.Parent = DropdownBtn

    local ChevronIcon = Instance.new("ImageLabel")
    ChevronIcon.Name = "Icon"
    ChevronIcon.BackgroundTransparency = 1
    ChevronIcon.Position = UDim2.new(1, -22, 0.5, -8)
    ChevronIcon.Size = UDim2.new(0, 16, 0, 16)
    ChevronIcon.Image = "rbxassetid://6031091004"
    ThemeManager:Register(ChevronIcon, "ImageColor3", "TextSecondary")
    ChevronIcon.Parent = DropdownBtn

    local Tooltip
    local MouseMoveConn
    if hoverText ~= "" then
        Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Tooltip.BackgroundTransparency = 1
        Tooltip.Size = UDim2.new(0, 0, 0, 22)
        Tooltip.AutomaticSize = Enum.AutomaticSize.X
        Tooltip.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Tooltip.Text = hoverText
        ThemeManager:Register(Tooltip, "TextColor3", "TextPrimary")
        Tooltip.TextSize = 12
        Tooltip.TextTransparency = 1
        Tooltip.ZIndex = 100000
        Tooltip.Visible = false

        local ScreenGui = TabContent:FindFirstAncestorOfClass("ScreenGui")
        Tooltip.Parent = ScreenGui or DropdownFrame

        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip

        local TooltipStroke = Instance.new("UIStroke")
        ThemeManager:Register(TooltipStroke, "Color", "StrokeColor")
        TooltipStroke.Transparency = 1
        TooltipStroke.Parent = Tooltip

        local TooltipPadding = Instance.new("UIPadding")
        TooltipPadding.PaddingLeft = UDim.new(0, 8)
        TooltipPadding.PaddingRight = UDim.new(0, 8)
        TooltipPadding.Parent = Tooltip
    end

    local MenuOpen = false
    local DropdownMenu
    local DropdownOverlay

    local function CloseDropdown()
        if not MenuOpen then return end
        MenuOpen = false

        if TabContent and TabContent:IsA("ScrollingFrame") then
            TabContent.ScrollingEnabled = wasScrollingEnabled
        end

        Tween(ChevronIcon, TweenInfo.new(0.2), {Rotation = 0})
        Tween(DropdownStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(48, 48, 48)})

        if DropdownMenu then
            Tween(DropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, 0)})
            task.delay(0.2, function()
                if not MenuOpen and DropdownMenu then
                    DropdownMenu:Destroy()
                    DropdownMenu = nil
                end
            end)
        end

        if DropdownOverlay then
            DropdownOverlay:Destroy()
            DropdownOverlay = nil
        end
    end
    local wasScrollingEnabled = false

    local function OpenDropdown()
        if MenuOpen then return end
        local ScreenGui = TabContent:FindFirstAncestorOfClass("ScreenGui")
        if not ScreenGui then return end
        MenuOpen = true

        if TabContent and TabContent:IsA("ScrollingFrame") then
            wasScrollingEnabled = TabContent.ScrollingEnabled
            TabContent.ScrollingEnabled = false
        end

        Tween(ChevronIcon, TweenInfo.new(0.2), {Rotation = 180})
        Tween(DropdownStroke, TweenInfo.new(0.2), {Color = config.AccentColor or Color3.fromRGB(245, 245, 245)})

        DropdownOverlay = Instance.new("TextButton")
        DropdownOverlay.Name = "DropdownOverlay"
        DropdownOverlay.BackgroundTransparency = 1
        DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
        DropdownOverlay.ZIndex = 10000
        DropdownOverlay.Text = ""
        DropdownOverlay.Parent = ScreenGui

        DropdownOverlay.MouseButton1Click:Connect(function()
            CloseDropdown()
        end)

        DropdownMenu = Instance.new("Frame")
        DropdownMenu.Name = "DropdownMenu"
        ThemeManager:Register(DropdownMenu, "BackgroundColor3", "SecondaryBackground")
        DropdownMenu.BorderSizePixel = 0
        DropdownMenu.ClipsDescendants = true
        local startX = DropdownBtn.AbsolutePosition.X - ScreenGui.AbsolutePosition.X
        local startY = (DropdownBtn.AbsolutePosition.Y - ScreenGui.AbsolutePosition.Y) + DropdownBtn.AbsoluteSize.Y + 4
        DropdownMenu.Position = UDim2.new(0, startX, 0, startY)
        DropdownMenu.Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, 0)
        DropdownMenu.ZIndex = 10001
        DropdownMenu.Parent = ScreenGui

        local MenuCorner = Instance.new("UICorner")
        MenuCorner.CornerRadius = UDim.new(0, 6)
        MenuCorner.Parent = DropdownMenu

        local MenuStroke = Instance.new("UIStroke")
        ThemeManager:Register(MenuStroke, "Color", "StrokeColor")
        MenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        MenuStroke.Parent = DropdownMenu

        local ScrollFrame = Instance.new("ScrollingFrame")
        ScrollFrame.BackgroundTransparency = 1
        ScrollFrame.BorderSizePixel = 0
        ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
        ScrollFrame.ScrollBarThickness = 2
        ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        ScrollFrame.ZIndex = 10002
        ScrollFrame.Parent = DropdownMenu

        local ScrollLayout = Instance.new("UIListLayout")
        ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollLayout.Padding = UDim.new(0, 2)
        ScrollLayout.Parent = ScrollFrame

        local ScrollPadding = Instance.new("UIPadding")
        ScrollPadding.PaddingTop = UDim.new(0, 4)
        ScrollPadding.PaddingBottom = UDim.new(0, 4)
        ScrollPadding.PaddingLeft = UDim.new(0, 4)
        ScrollPadding.PaddingRight = UDim.new(0, 4)
        ScrollPadding.Parent = ScrollFrame

        local targetHeight = 8

        for _, option in ipairs(options) do
            local isSelected = isMulti and (selectedMulti[option] == true) or (selectedSingle == option)

            local OptBtn = Instance.new("TextButton")
            OptBtn.Name = option
            ThemeManager:Register(OptBtn, "BackgroundColor3", "TertiaryBackground")
            OptBtn.BackgroundTransparency = isSelected and 0 or 1
            OptBtn.Size = UDim2.new(1, 0, 0, 26)
            OptBtn.Text = ""
            OptBtn.AutoButtonColor = false
            OptBtn.ZIndex = 10003
            OptBtn.Parent = ScrollFrame

            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 4)
            OptCorner.Parent = OptBtn

            local OptStroke = Instance.new("UIStroke")
            OptStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            OptStroke.Color = Color3.fromRGB(55, 55, 55)
            OptStroke.Transparency = isSelected and 0 or 1
            OptStroke.Parent = OptBtn

            local OptText = Instance.new("TextLabel")
            OptText.BackgroundTransparency = 1
            OptText.Size = UDim2.new(1, -30, 1, 0)
            OptText.Position = UDim2.new(0, 8, 0, 0)
            OptText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            OptText.Text = option
            OptText.TextColor3 = isSelected and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(150, 150, 160)
            OptText.TextSize = 12
            OptText.TextXAlignment = Enum.TextXAlignment.Left
            OptText.TextTruncate = Enum.TextTruncate.AtEnd
            OptText.ZIndex = 10004
            OptText.Parent = OptBtn

            local Checkmark = Instance.new("ImageLabel")
            Checkmark.Name = "Checkmark"
            Checkmark.BackgroundTransparency = 1
            Checkmark.Position = UDim2.new(1, -22, 0.5, -7)
            Checkmark.Size = UDim2.new(0, 14, 0, 14)
            Checkmark.Image = "rbxassetid://118922551501473"
            Checkmark.ImageColor3 = config.AccentColor or Color3.fromRGB(245, 245, 245)
            Checkmark.ZIndex = 10004
            Checkmark.Visible = isSelected
            Checkmark.Parent = OptBtn

            OptBtn.MouseEnter:Connect(function()
                local active = isMulti and selectedMulti[option] or (selectedSingle == option)
                if not active then
                    Tween(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6})
                    Tween(OptText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(240, 240, 245)})
                end
            end)

            OptBtn.MouseLeave:Connect(function()
                local active = isMulti and selectedMulti[option] or (selectedSingle == option)
                if not active then
                    Tween(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1})
                    Tween(OptText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150, 150, 160)})
                end
            end)

            OptBtn.MouseButton1Click:Connect(function()
                if isMulti then
                    selectedMulti[option] = not selectedMulti[option]
                    local currentActive = selectedMulti[option]
                    Checkmark.Visible = currentActive
                    Tween(OptBtn, TweenInfo.new(0.15), {BackgroundTransparency = currentActive and 0 or 1})
                    Tween(OptStroke, TweenInfo.new(0.15), {Transparency = currentActive and 0 or 1})
                    Tween(OptText, TweenInfo.new(0.15), {TextColor3 = currentActive and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(150, 150, 160)})

                    DropdownText.Text = getDisplayText()
                    cb(getMultiList())
                else
                    selectedSingle = option
                    DropdownText.Text = option
                    cb(selectedSingle)
                    CloseDropdown()
                end
            end)

            targetHeight = targetHeight + 28
        end

        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, targetHeight)
        local maxHeight = math.clamp(targetHeight, 28, 160)

        Tween(DropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, maxHeight)})
    end

    Maid:GiveTask(DropdownBtn.MouseButton1Click:Connect(function()
        if MenuOpen then
            CloseDropdown()
        else
            OpenDropdown()
        end
    end))

    Maid:GiveTask(DropdownFrame.MouseEnter:Connect(function()
        if not isLarge then
            Tween(DropdownFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85})
        end
        if Tooltip then
            Tooltip.Visible = true
            Tween(Tooltip, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextTransparency = 0})
            Tween(Tooltip.UIStroke, TweenInfo.new(0.2), {Transparency = 0})

            if MouseMoveConn then MouseMoveConn:Disconnect() end
            MouseMoveConn = RunService.RenderStepped:Connect(function()
                Tooltip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 15)
            end)
        end
    end))

    Maid:GiveTask(DropdownFrame.MouseLeave:Connect(function()
        if not isLarge then
            Tween(DropdownFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        end
        if Tooltip then
            Tween(Tooltip, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1})
            Tween(Tooltip.UIStroke, TweenInfo.new(0.2), {Transparency = 1})

            if MouseMoveConn then
                MouseMoveConn:Disconnect()
                MouseMoveConn = nil
            end

            task.delay(0.2, function()
                if Tooltip.BackgroundTransparency == 1 then
                    Tooltip.Visible = false
                end
            end)
        end
    end))

    Maid:GiveTask(function()
        CloseDropdown()
        if MouseMoveConn then
            MouseMoveConn:Disconnect()
        end
        if Tooltip then
            Tooltip:Destroy()
        end
    end)

    local DropdownObject = {}
    DropdownObject.Instance = DropdownFrame

    function DropdownObject:Set(newVal)
        if isMulti then
            selectedMulti = {}
            if type(newVal) == "table" then
                for k, v in pairs(newVal) do
                    if type(k) == "number" then
                        selectedMulti[tostring(v)] = true
                    elseif v == true then
                        selectedMulti[tostring(k)] = true
                    end
                end
            elseif type(newVal) == "string" and newVal ~= "" then
                selectedMulti[newVal] = true
            end
            DropdownText.Text = getDisplayText()
            cb(getMultiList())
        else
            selectedSingle = tostring(newVal)
            DropdownText.Text = selectedSingle
            cb(selectedSingle)
        end
    end

    function DropdownObject:Get()
        if isMulti then
            return getMultiList()
        else
            return selectedSingle
        end
    end

    function DropdownObject:Refresh(newOptions, newDefault)
        options = newOptions or {}
        if newDefault ~= nil then
            self:Set(newDefault)
        else
            DropdownText.Text = getDisplayText()
        end
        if MenuOpen then
            CloseDropdown()
            task.delay(0.25, OpenDropdown)
        end
    end

    setmetatable(DropdownObject, {
        __index = function(_, key) return DropdownFrame[key] end,
        __newindex = function(_, key, value) DropdownFrame[key] = value end
    })

    return DropdownObject
end

return DropdownComponent
