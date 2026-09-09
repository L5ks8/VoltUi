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
    Main.Name = "LoadingScreen"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 800, 0, 600)
    Main.ZIndex = 99999
    Main.Parent = ParentGui
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 45)
    MainStroke.Thickness = 1
    MainStroke.Parent = Main
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    local introBox = Instance.new("Frame")
    introBox.BackgroundTransparency = 1
    introBox.AnchorPoint = Vector2.new(0.5, 0.5)
    introBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    introBox.Size = UDim2.new(0, 400, 0, 100)
    introBox.ZIndex = 100000
    introBox.Parent = Main

    local il = Instance.new("UIListLayout")
    il.FillDirection = Enum.FillDirection.Horizontal
    il.HorizontalAlignment = Enum.HorizontalAlignment.Center
    il.SortOrder = Enum.SortOrder.LayoutOrder
    il.VerticalAlignment = Enum.VerticalAlignment.Center
    il.Parent = introBox

    local ic = Instance.new("ImageLabel")
    ic.BackgroundTransparency = 1
    ic.BorderSizePixel = 0
    ic.Image = "rbxassetid://71942076965693"
    ic.Size = UDim2.new(0, 90, 0, 90)
    ic.ImageTransparency = 1
    ic.ZIndex = 100000
    ic.Parent = introBox

    local tx = Instance.new("TextLabel")
    tx.BackgroundTransparency = 1
    tx.BorderSizePixel = 0
    tx.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    tx.Size = UDim2.new(0, 0, 0, 90)
    tx.Text = "olt"
    tx.TextColor3 = Color3.new(0.984, 0.984, 0.984)
    tx.TextSize = 68
    tx.TextXAlignment = Enum.TextXAlignment.Left
    tx.ClipsDescendants = true
    tx.MaxVisibleGraphemes = 0
    tx.ZIndex = 100000
    tx.Parent = introBox

    local BarContainer = Instance.new("Frame")
    BarContainer.Name = "Bar"
    BarContainer.BackgroundTransparency = 1
    BarContainer.LayoutOrder = 1
    BarContainer.Size = UDim2.new(0, 360, 0, 40)
    BarContainer.AnchorPoint = Vector2.new(0.5, 0)
    BarContainer.Position = UDim2.new(0.5, 0, 0.55, 0)
    BarContainer.Parent = Main
    
    local BarLayout = Instance.new("UIListLayout")
    BarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BarLayout.Padding = UDim.new(0, 8)
    BarLayout.Parent = BarContainer
    
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(1, 0, 0, 16)
    TextContainer.Parent = BarContainer
    
    local LoadingText = Instance.new("TextLabel")
    LoadingText.BackgroundTransparency = 1
    LoadingText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    LoadingText.Size = UDim2.new(1, -50, 1, 0)
    LoadingText.Text = "Loading Ui ..."
    LoadingText.TextColor3 = Color3.fromRGB(180, 180, 180)
    LoadingText.TextSize = 13
    LoadingText.TextXAlignment = Enum.TextXAlignment.Left
    LoadingText.TextYAlignment = Enum.TextYAlignment.Bottom
    LoadingText.TextTransparency = 1
    LoadingText.Parent = TextContainer
    
    local PctText = Instance.new("TextLabel")
    PctText.BackgroundTransparency = 1
    PctText.AnchorPoint = Vector2.new(1, 0)
    PctText.Position = UDim2.new(1, 0, 0, 0)
    PctText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PctText.Size = UDim2.new(0, 50, 1, 0)
    PctText.Text = "0%"
    PctText.TextColor3 = Color3.fromRGB(245, 245, 245)
    PctText.TextSize = 13
    PctText.TextXAlignment = Enum.TextXAlignment.Right
    PctText.TextYAlignment = Enum.TextYAlignment.Bottom
    PctText.TextTransparency = 1
    PctText.Parent = TextContainer

    local BarBg = Instance.new("Frame")
    BarBg.BackgroundTransparency = 1
    BarBg.LayoutOrder = 1
    BarBg.Size = UDim2.new(1, 0, 0, 4)
    BarBg.Parent = BarContainer
    
    local BarFillBg = Instance.new("Frame")
    BarFillBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    BarFillBg.BackgroundTransparency = 1
    BarFillBg.BorderSizePixel = 0
    BarFillBg.Size = UDim2.new(1, 0, 1, 0)
    BarFillBg.Parent = BarBg
    
    local BarFillBgCorner = Instance.new("UICorner")
    BarFillBgCorner.CornerRadius = UDim.new(1, 0)
    BarFillBgCorner.Parent = BarFillBg
    
    local BarFill = Instance.new("Frame")
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BarFill.BackgroundTransparency = 1
    BarFill.BorderSizePixel = 0
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.Parent = BarFillBg
    
    local BarFillCorner = Instance.new("UICorner")
    BarFillCorner.CornerRadius = UDim.new(1, 0)
    BarFillCorner.Parent = BarFill
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    UIGradient.Parent = BarFill

    local obj = {Faded = false}
    
    task.spawn(function()
        task.wait(0.2)
        Tween(ic, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
        task.wait(1)
        task.wait(0.2)
        Tween(tx, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 150, 0, 100)})
        task.wait(0.8)
        for i = 1, 3 do
            tx.MaxVisibleGraphemes = i
            task.wait(0.15)
        end
        task.wait(0.8)
        
        Tween(introBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.45, 0)})
        
        Tween(BarFillBg, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        Tween(BarFill, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        Tween(LoadingText, TweenInfo.new(0.3), {TextTransparency = 0})
        Tween(PctText, TweenInfo.new(0.3), {TextTransparency = 0})
        task.wait(0.3)
        
        while not obj.Faded and Main and Main.Parent do
            Tween(ic, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.4})
            task.wait(1)
            Tween(ic, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0})
            task.wait(1)
        end
    end)
    
    function obj:SetProgress(pct)
        if self.Faded then return end
        pct = math.clamp(pct, 0, 1)
        Tween(BarFill, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(pct, 0, 1, 0)})
        PctText.Text = tostring(math.floor(pct * 100)) .. "%"
    end
    
    function obj:SetStatus(text)
        if self.Faded then return end
        LoadingText.Text = text
    end
    
    function obj:FadeOut()
        if self.Faded then return end
        self.Faded = true
        
        task.spawn(function()
            Tween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            Tween(MainStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
            Tween(ic, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
            Tween(tx, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            Tween(BarFillBg, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            Tween(BarFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            Tween(LoadingText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            Tween(PctText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
            
            task.wait(0.5)
            Main:Destroy()
        end)
    end
    
    return obj
end

return Loading
