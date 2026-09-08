local TweenService = game:GetService("TweenService")
local Themes = {
    ["Volt Light"] = require(script.Parent.Parent.Themes.Light),
    ["My Volt Dark"] = require(script.Parent.Parent.Themes.Dark),
    ["Midnight Blue"] = require(script.Parent.Parent.Themes.Dark) -- Placeholder for Midnight Blue
}

local ThemeManager = {
    CurrentThemeName = "My Volt Dark",
    RegisteredElements = {}
}

-- Returns the color for a specific key in the current theme
function ThemeManager:GetColor(colorKey)
    local theme = Themes[self.CurrentThemeName]
    return theme and theme[colorKey] or Color3.new(1, 1, 1)
end

-- Registers a UI element to automatically update when the theme changes
function ThemeManager:Register(instance, property, colorKey)
    table.insert(self.RegisteredElements, {
        Instance = instance,
        Property = property,
        ColorKey = colorKey
    })
    
    -- Apply immediately
    pcall(function()
        instance[property] = self:GetColor(colorKey)
    end)
end

-- Updates all registered elements to match the selected theme
function ThemeManager:SetTheme(themeName)
    if not Themes[themeName] then return end
    self.CurrentThemeName = themeName
    
    for _, ref in ipairs(self.RegisteredElements) do
        if ref.Instance and ref.Instance.Parent then
            local targetColor = self:GetColor(ref.ColorKey)
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(ref.Instance, tweenInfo, {[ref.Property] = targetColor})
            tween:Play()
        end
    end
end

return ThemeManager
