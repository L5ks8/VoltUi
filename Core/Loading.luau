local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function Tween(instance, tweenInfo, properties)
    local tw = TweenService:Create(instance, tweenInfo, properties)
    tw:Play()
    return tw
end

local Loading = {}

function Loading.Create(ParentGui)
    local Main = Instance.new("Frame")
    Main.Name = "VoltLoading_Absolute"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.ZIndex = 99999
    Main.Parent = ParentGui
    Main.ClipsDescendants = true

    local BgPercent = Instance.new("TextLabel")
    BgPercent.BackgroundTransparency = 1
    BgPercent.Size = UDim2.new(1, 0, 1, 0)
    BgPercent.Position = UDim2.new(0, 0, 0, 0)
    BgPercent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Black, Enum.FontStyle.Normal)
    BgPercent.Text = "0"
    BgPercent.TextColor3 = Color3.new(1, 1, 1)
    BgPercent.TextTransparency = 1
    BgPercent.TextSize = 500
    BgPercent.ZIndex = 100000
    BgPercent.Parent = Main

    local CenterBox = Instance.new("Frame")
    CenterBox.BackgroundTransparency = 1
    CenterBox.AnchorPoint = Vector2.new(0.5, 0.5)
    CenterBox.Position = UDim2.new(0.5, 0, 0.5, -20)
    CenterBox.Size = UDim2.new(0, 400, 0, 150)
    CenterBox.ZIndex = 100001
    CenterBox.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 12)
    Layout.Parent = CenterBox

    local Icon = Instance.new("ImageLabel")
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://71942076965693"
    Icon.Size = UDim2.new(0, 70, 0, 70)
    Icon.ImageColor3 = Color3.new(1, 1, 1)
    Icon.ImageTransparency = 1
    Icon.Parent = CenterBox

    local TextVolt = Instance.new("TextLabel")
    TextVolt.BackgroundTransparency = 1
    TextVolt.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextVolt.Text = "olt"
    TextVolt.TextColor3 = Color3.new(1, 1, 1)
    TextVolt.TextSize = 65
    TextVolt.Size = UDim2.new(0, 0, 0, 70)
    TextVolt.TextXAlignment = Enum.TextXAlignment.Left
    TextVolt.ClipsDescendants = true
    TextVolt.TextTransparency = 1
    TextVolt.Parent = CenterBox

    local BottomSection = Instance.new("Frame")
    BottomSection.BackgroundTransparency = 1
    BottomSection.AnchorPoint = Vector2.new(0.5, 1)
    BottomSection.Position = UDim2.new(0.5, 0, 1, -80)
    BottomSection.Size = UDim2.new(0.4, 0, 0, 40)
    BottomSection.ZIndex = 100001
    BottomSection.Parent = Main

    local StatusText = Instance.new("TextLabel")
    StatusText.BackgroundTransparency = 1
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0, 0)
    StatusText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    StatusText.Text = "WAITING FOR INITIALIZATION"
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.TextSize = 12
    StatusText.TextXAlignment = Enum.TextXAlignment.Center
    StatusText.TextTransparency = 1
    StatusText.Parent = BottomSection

    local LineTrack = Instance.new("Frame")
    LineTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LineTrack.BorderSizePixel = 0
    LineTrack.AnchorPoint = Vector2.new(0.5, 1)
    LineTrack.Position = UDim2.new(0.5, 0, 1, 0)
    LineTrack.Size = UDim2.new(1, 0, 0, 1)
    LineTrack.BackgroundTransparency = 1
    LineTrack.Parent = BottomSection

    local LineFill = Instance.new("Frame")
    LineFill.BackgroundColor3 = Color3.new(1, 1, 1)
    LineFill.BorderSizePixel = 0
    LineFill.AnchorPoint = Vector2.new(0.5, 0)
    LineFill.Position = UDim2.new(0.5, 0, 0, 0)
    LineFill.Size = UDim2.new(0, 0, 1, 0)
    LineFill.BackgroundTransparency = 1
    LineFill.Parent = LineTrack

    local ExactPercent = Instance.new("TextLabel")
    ExactPercent.BackgroundTransparency = 1
    ExactPercent.AnchorPoint = Vector2.new(0.5, 0)
    ExactPercent.Position = UDim2.new(0.5, 0, 1, 10)
    ExactPercent.Size = UDim2.new(1, 0, 0, 15)
    ExactPercent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ExactPercent.Text = "0%"
    ExactPercent.TextColor3 = Color3.new(1, 1, 1)
    ExactPercent.TextSize = 10
    ExactPercent.TextXAlignment = Enum.TextXAlignment.Center
    ExactPercent.TextTransparency = 1
    ExactPercent.Parent = BottomSection

    local obj = {Faded = false}
    
    task.spawn(function()
        Main.BackgroundTransparency = 1
        Tween(Main, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        
        task.wait(0.5)

        Icon.Position = UDim2.new(0, 0, 0, -20)
        Tween(Icon, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
        task.wait(0.7)

        TextVolt.TextTransparency = 0
        Tween(TextVolt, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 70)})
        task.wait(0.8)

        Tween(BgPercent, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0.96})
        Tween(LineTrack, TweenInfo.new(1), {BackgroundTransparency = 0})
        Tween(LineFill, TweenInfo.new(1), {BackgroundTransparency = 0})
        Tween(StatusText, TweenInfo.new(1), {TextTransparency = 0})
        Tween(ExactPercent, TweenInfo.new(1), {TextTransparency = 0.4})

        while not obj.Faded and Main and Main.Parent do
            Tween(LineTrack, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
            task.wait(1.5)
            if obj.Faded then break end
            Tween(LineTrack, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)})
            task.wait(1.5)
        end
    end)
    
    function obj:SetProgress(pct)
        if self.Faded then return end
        pct = math.clamp(pct, 0, 1)
        
        Tween(LineFill, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(pct, 0, 1, 0)})
        
        local displayPct = math.floor(pct * 100)
        ExactPercent.Text = tostring(displayPct) .. "%"
        
        BgPercent.Text = tostring(displayPct)
        
        Tween(Icon, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 74, 0, 74)})
        task.delay(0.1, function()
            if not self.Faded then
                Tween(Icon, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 70, 0, 70)})
            end
        end)
    end
    
    function obj:SetStatus(text)
        if self.Faded then return end
        Tween(StatusText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, Position = UDim2.new(0, 0, 0, -8)})
        task.wait(0.25)
        if self.Faded then return end
        StatusText.Text = string.upper(text)
        StatusText.Position = UDim2.new(0, 0, 0, 8)
        Tween(StatusText, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
    end
    
    function obj:FadeOut()
        if self.Faded then return end
        self.Faded = true
        
        task.spawn(function()
            Tween(CenterBox, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Size = UDim2.new(0, 500, 0, 150)})
            Tween(Icon, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {ImageTransparency = 1})
            Tween(TextVolt, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {TextTransparency = 1})
            
            Tween(BgPercent, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1, TextSize = 600})
            
            Tween(LineTrack, TweenInfo.new(0.4), {BackgroundTransparency = 1})
            Tween(LineFill, TweenInfo.new(0.4), {BackgroundTransparency = 1})
            Tween(StatusText, TweenInfo.new(0.4), {TextTransparency = 1})
            Tween(ExactPercent, TweenInfo.new(0.4), {TextTransparency = 1})
            
            task.wait(0.5)
            Tween(Main, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {BackgroundTransparency = 1})
            
            task.wait(0.8)
            Main:Destroy()
        end)
    end
    
    return obj
end

return Loading
