local ParagraphComponent = {}
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local ThemeManager = require(script.Parent.Parent.Core.Theme)

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

function ParagraphComponent.Create(TabContent, Maid, Config)
    local config = type(Config) == "string" and {Header = Config} or Config
    local headerText = config.Header or config.Name or config.Title or "Information"
    local contentText = config.Content or config.Text or ""
    local iconAsset = config.Icon

    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Name = headerText
    ThemeManager:Register(ParagraphFrame, "BackgroundColor3", "SecondaryBackground")
    ParagraphFrame.BackgroundTransparency = 0.4
    ParagraphFrame.BorderSizePixel = 0
    ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
    ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphFrame.Parent = TabContent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ParagraphFrame

    local Stroke = Instance.new("UIStroke")
    ThemeManager:Register(Stroke, "Color", "StrokeColor")
    Stroke.Thickness = 1
    Stroke.Parent = ParagraphFrame

    local MainLayout = Instance.new("UIListLayout")
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Padding = UDim.new(0, 4)
    MainLayout.Parent = ParagraphFrame

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.Parent = ParagraphFrame

    local HeaderRow = Instance.new("Frame")
    HeaderRow.Name = "HeaderRow"
    HeaderRow.BackgroundTransparency = 1
    HeaderRow.Size = UDim2.new(1, 0, 0, 18)
    HeaderRow.Parent = ParagraphFrame

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
        ThemeManager:Register(Icon, "ImageColor3", "IconColor")
        Icon.Parent = HeaderRow
    end

    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Header.Size = UDim2.new(1, -30, 1, 0)
    Header.Text = headerText
    ThemeManager:Register(Header, "TextColor3", "TextPrimary")
    Header.TextSize = 14
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.TextYAlignment = Enum.TextYAlignment.Center
    Header.Parent = HeaderRow

    local Content = Instance.new("TextLabel")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.Text = contentText
    ThemeManager:Register(Content, "TextColor3", "TextSecondary")
    Content.TextSize = 12
    Content.TextWrapped = true
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.Parent = ParagraphFrame

    local ParagraphObject = {}
    ParagraphObject.Instance = ParagraphFrame

    function ParagraphObject:Set(newSettings)
        if type(newSettings) == "string" then
            Content.Text = newSettings
        elseif type(newSettings) == "table" then
            if newSettings.Title or newSettings.Header or newSettings.Name then
                Header.Text = newSettings.Title or newSettings.Header or newSettings.Name
            end
            if newSettings.Content or newSettings.Text then
                Content.Text = newSettings.Content or newSettings.Text
            end
        end
    end

    setmetatable(ParagraphObject, {
        __index = function(_, key) return ParagraphFrame[key] end,
        __newindex = function(_, key, value) ParagraphFrame[key] = value end
    })

    return ParagraphObject
end

return ParagraphComponent
