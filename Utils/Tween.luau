local TweenService = game:GetService("TweenService")

local Tween = {}

function Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

return Tween
