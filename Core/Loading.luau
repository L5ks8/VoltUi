local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)
local RunService = game:GetService("RunService")
local ThemeManager = require(script.Parent.Theme)

local Loading = {}

function Loading.Create(ParentGui)
    local Main = Instance.new("Frame")
    Main.Name = "LoadingScreen"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 800, 0, 600)
    Main.ZIndex = 99999
    Main.Parent = ParentGui
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.new(0.353, 0.353, 0.353)
    MainStroke.Parent = Main
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = Main
    
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MainLayout.Padding = UDim.new(0, 100)
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = Main
    
    local MainPadding = Instance.new("UIPadding")
    MainPadding.PaddingTop = UDim.new(0, 160)
    MainPadding.Parent = Main
    
    local Icon = Instance.new("Frame")
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 200, 0, 200)
    Icon.Parent = Main
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = Icon
    
    local IconStroke = Instance.new("UIStroke")
    IconStroke.Thickness = 8
    IconStroke.Color = Color3.fromRGB(255, 255, 255)
    IconStroke.Parent = Icon
    
    local IconGrad = Instance.new("UIGradient")
    IconGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    IconGrad.Parent = IconStroke
    
    local BarContainer = Instance.new("Frame")
    BarContainer.Name = "Bar"
    BarContainer.BackgroundTransparency = 1
    BarContainer.LayoutOrder = 1
    BarContainer.Size = UDim2.new(0, 730, 0, 100)
    BarContainer.Parent = Main
    
    local BarLayout = Instance.new("UIListLayout")
    BarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BarLayout.Parent = BarContainer
    
    local BarBg = Instance.new("Frame")
    BarBg.BackgroundTransparency = 1
    BarBg.LayoutOrder = 1
    BarBg.Size = UDim2.new(0, 730, 0, 50)
    BarBg.Parent = BarContainer
    
    local BarFillBg = Instance.new("Frame")
    BarFillBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BarFillBg.Size = UDim2.new(1, 0, 0.4, 0)
    BarFillBg.AnchorPoint = Vector2.new(0, 0.5)
    BarFillBg.Position = UDim2.new(0, 0, 0.5, 0)
    BarFillBg.Parent = BarBg
    
    local BarFillBgCorner = Instance.new("UICorner")
    BarFillBgCorner.CornerRadius = UDim.new(1, 0)
    BarFillBgCorner.Parent = BarFillBg
    
    local BarFill = Instance.new("Frame")
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.Parent = BarFillBg
    
    local BarFillCorner = Instance.new("UICorner")
    BarFillCorner.CornerRadius = UDim.new(1, 0)
    BarFillCorner.Parent = BarFill
    
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "Text"
    TextContainer.BackgroundTransparency = 1
    TextContainer.Size = UDim2.new(0, 730, 0, 50)
    TextContainer.Parent = BarContainer
    
    local TextLayout = Instance.new("UIListLayout")
    TextLayout.FillDirection = Enum.FillDirection.Horizontal
    TextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextLayout.Parent = TextContainer
    
    local LoadingText = Instance.new("TextLabel")
    LoadingText.BackgroundTransparency = 1
    LoadingText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LoadingText.Size = UDim2.new(0, 600, 0, 50)
    LoadingText.Text = "Loading Ui ..."
    LoadingText.TextColor3 = Color3.new(1, 1, 1)
    LoadingText.TextSize = 25
    LoadingText.TextXAlignment = Enum.TextXAlignment.Left
    LoadingText.TextYAlignment = Enum.TextYAlignment.Bottom
    LoadingText.Parent = TextContainer
    
    local PctContainer = Instance.new("Frame")
    PctContainer.Name = "Percentage"
    PctContainer.BackgroundTransparency = 1
    PctContainer.Size = UDim2.new(0, 130, 0, 50)
    PctContainer.Parent = TextContainer
    
    local PctText = Instance.new("TextLabel")
    PctText.BackgroundTransparency = 1
    PctText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PctText.Size = UDim2.new(1, 0, 1, 0)
    PctText.Text = "0%"
    PctText.TextColor3 = Color3.new(1, 1, 1)
    PctText.TextSize = 25
    PctText.TextXAlignment = Enum.TextXAlignment.Right
    PctText.TextYAlignment = Enum.TextYAlignment.Bottom
    PctText.Parent = PctContainer

    local obj = {Faded = false}
    local renderConn
    
    -- Animate circle
    renderConn = RunService.RenderStepped:Connect(function(dt)
        if obj.Faded then
            renderConn:Disconnect()
            return
        end
        IconGrad.Rotation = (IconGrad.Rotation + dt * 360) % 360
    end)
    
    function obj:SetProgress(pct)
        if self.Faded then return end
        pct = math.clamp(pct, 0, 1)
        Tween(BarFill, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(pct, 0, 1, 0)})
        PctText.Text = tostring(math.floor(pct * 100)) .. "%"
    end
    
    function obj:FadeOut()
        if self.Faded then return end
        self.Faded = true
        
        if renderConn then
            renderConn:Disconnect()
            renderConn = nil
        end
        
        task.spawn(function()
            Tween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            Tween(MainStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
            Tween(IconStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
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
