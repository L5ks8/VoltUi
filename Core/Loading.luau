local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)

local Loading = {}

function Loading.Create(ParentGui)
    local Main = Instance.new("Frame")
    Main.Name = "Loading"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 800, 0, 600)
    Main.ZIndex = 99999
    Main.Parent = ParentGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Parent = Main
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main
    
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.BackgroundColor3 = Color3.new(1, 1, 1)
    Icon.BackgroundTransparency = 1
    Icon.BorderColor3 = Color3.new(0, 0, 0)
    Icon.BorderSizePixel = 0
    Icon.Image = "rbxassetid://71942076965693"
    Icon.Size = UDim2.new(0, 100, 0, 100)
    Icon.ImageTransparency = 1
    Icon.ZIndex = 100000
    Icon.Parent = Main
    
    local Text = Instance.new("TextLabel")
    Text.Name = "Text"
    Text.BackgroundColor3 = Color3.new(1, 1, 1)
    Text.BackgroundTransparency = 1
    Text.BorderColor3 = Color3.new(0, 0, 0)
    Text.BorderSizePixel = 0
    Text.FontFace = Font.new("rbxasset://fonts/families/LegacyArial.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Text.Size = UDim2.new(0, 0, 0, 100)
    Text.Text = "olt"
    Text.TextColor3 = Color3.new(0.984, 0.984, 0.984)
    Text.TextSize = 76
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.ClipsDescendants = true
    Text.MaxVisibleGraphemes = 0
    Text.ZIndex = 100000
    Text.Parent = Main

    local ReadyEvent = Instance.new("BindableEvent")
    local obj = {IsReady = false, Faded = false, ReadyEvent = ReadyEvent}
    
    task.spawn(function()
        -- Preload the icon image so the animation doesn't play while the image is still downloading!
        local ContentProvider = game:GetService("ContentProvider")
        pcall(function()
            ContentProvider:PreloadAsync({Icon})
        end)
        
        task.wait(0.2)
        
        Tween(Icon, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
        task.wait(1)
        
        task.wait(0.2)
        
        Tween(Text, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 150, 0, 100)})
        task.wait(0.8)
        
        for i = 1, 3 do
            Text.MaxVisibleGraphemes = i
            task.wait(0.15)
        end
        
        task.wait(0.8)
        obj.IsReady = true
        ReadyEvent:Fire()
    end)
    
    function obj:WaitForReady()
        if not self.IsReady then
            self.ReadyEvent.Event:Wait()
        end
    end
    
    function obj:FadeOut()
        if self.Faded then return end
        self.Faded = true
        
        task.spawn(function()
            Tween(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
            Tween(Text, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            
            task.wait(0.3)
            
            -- Then fade out the solid background to smoothly reveal the UI behind it
            Tween(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            task.wait(0.4)
            
            Main:Destroy()
        end)
    end
    
    return obj
end

return Loading
