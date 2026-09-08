local TweenService = game:GetService("TweenService")
local Themes = {
    ["Volt Light"] = require(script.Parent.Parent.Themes.Light),
    ["My Volt Dark"] = require(script.Parent.Parent.Themes.Dark),
    ["Ocean"] = require(script.Parent.Parent.Themes.Ocean),
    ["Forest"] = require(script.Parent.Parent.Themes.Forest),
    ["Sunset"] = require(script.Parent.Parent.Themes.Sunset),
    ["Midnight"] = require(script.Parent.Parent.Themes.Midnight),
    ["Void"] = require(script.Parent.Parent.Themes.Void)
}

local SharedState = shared.VoltUiThemeState
if type(SharedState) ~= "table" then
    SharedState = {
        CurrentThemeName = "My Volt Dark",
        RegisteredElements = {}
    }
    shared.VoltUiThemeState = SharedState
end

local ThemeManager = {}

function ThemeManager:GetColor(colorKey)
    local theme = Themes[SharedState.CurrentThemeName]
    return theme and theme[colorKey] or Color3.new(1, 1, 1)
end

function ThemeManager:Register(instance, property, colorKey)
    if not instance or typeof(property) ~= "string" or typeof(colorKey) ~= "string" then return end
    
    table.insert(SharedState.RegisteredElements, {
        Instance = instance,
        Property = property,
        ColorKey = colorKey
    })
    
    pcall(function()
        instance[property] = self:GetColor(colorKey)
    end)
end

function ThemeManager:SetTheme(themeName)
    if not Themes[themeName] then return end
    SharedState.CurrentThemeName = themeName
    
    for _, ref in ipairs(SharedState.RegisteredElements) do
        pcall(function()
            if ref.Instance and ref.Instance.Parent then
                local targetColor = self:GetColor(ref.ColorKey)
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(ref.Instance, tweenInfo, {[ref.Property] = targetColor})
                tween:Play()
            end
        end)
    end
end

return ThemeManager
