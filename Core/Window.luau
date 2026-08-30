local Window = {}
local Topbar = require(script.Parent.Topbar)
local Sidebar = require(script.Parent.Sidebar)
local Bottombar = require(script.Parent.Bottombar)
local CloseWarn = require(script.Parent.CloseWarn)
local Minimized = require(script.Parent.Minimized)
local TweenService = game:GetService("TweenService")
local Bottombar = require(script.Parent.Bottombar)
local CloseWarn = require(script.Parent.CloseWarn)

function Window:CreateWindow(Config)
    local VoltUi = Instance.new("ScreenGui")
    VoltUi.Name = "VoltUi"
    VoltUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    VoltUi.ResetOnSpawn = false
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = false
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 800, 0, 600)
    Main.Parent = VoltUi
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.new(0.353, 0.353, 0.353)
    UIStroke.Parent = Main
    
    local TopbarElements = Topbar.Create(Main, Config)
    
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.AnchorPoint = Vector2.new(0, 0)
    Content.BackgroundColor3 = Color3.new(1, 1, 1)
    Content.BackgroundTransparency = 1
    Content.BorderColor3 = Color3.new(0, 0, 0)
    Content.BorderSizePixel = 0
    Content.LayoutOrder = 1
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.Size = UDim2.new(1, 0, 1, -50)
    Content.Parent = Main
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.Padding = UDim.new(0, 3)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.Parent = Content
    
    local SidebarElements = Sidebar.Create(Content)
    
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.BackgroundColor3 = Color3.new(1, 1, 1)
    MainContent.BackgroundTransparency = 1
    MainContent.BorderColor3 = Color3.new(0, 0, 0)
    MainContent.BorderSizePixel = 0
    MainContent.Position = UDim2.new(0, 203, 0, 0)
    MainContent.Size = UDim2.new(1, -203, 1, 0)
    MainContent.Parent = Content
    
    local MainContentStroke = Instance.new("UIStroke")
    MainContentStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    MainContentStroke.Color = Color3.new(0.216, 0.216, 0.216)
    MainContentStroke.Parent = MainContent
    
    local BottombarElements = Bottombar.Create(Main)
    
    local ClosePrompt = CloseWarn.Create(VoltUi, function()
        VoltUi:Destroy()
    end, function()
        -- Cancel logic is already handled inside CloseWarn (makes itself invisible)
    end)
    
    local isFullscreen = false
    local originalSize = Main.Size
    local originalPosition = Main.Position
    local FullscreenTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local isMinimized = false
    local preMinimizeSize = Main.Size
    local preMinimizePos = Main.Position
    local MinimizeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local MinimizedBtn
    MinimizedBtn = Minimized.Create(VoltUi, function()
        isMinimized = false
        Main.Visible = true
        TweenService:Create(Main, MinimizeTweenInfo, {
            Size = isFullscreen and UDim2.new(1, 0, 1, 0) or preMinimizeSize,
            Position = isFullscreen and UDim2.new(0.5, 0, 0.5, 0) or preMinimizePos
        }):Play()
    end)
    
    TopbarElements.FullscreenButton.MouseButton1Click:Connect(function()
        isFullscreen = not isFullscreen
        if isFullscreen then
            originalSize = Main.Size
            originalPosition = Main.Position
            TweenService:Create(Main, FullscreenTweenInfo, {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        else
            TweenService:Create(Main, FullscreenTweenInfo, {
                Size = originalSize,
                Position = originalPosition
            }):Play()
        end
    end)
    
    TopbarElements.MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = true
        preMinimizeSize = Main.Size
        preMinimizePos = Main.Position
        
        MinimizedBtn.Visible = true
        local tw = TweenService:Create(Main, MinimizeTweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = MinimizedBtn.Position
        })
        tw.Completed:Connect(function()
            if isMinimized then
                Main.Visible = false
            end
        end)
        tw:Play()
    end)
    
    TopbarElements.CloseButton.MouseButton1Click:Connect(function()
        ClosePrompt.Visible = true
    end)
    
    local WindowObject = {
        Instance = VoltUi,
        Main = Main,
        Topbar = TopbarElements,
        Sidebar = SidebarElements,
        Bottombar = BottombarElements,
        ContentContainer = MainContent
    }
    
    if gethui then
        VoltUi.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(VoltUi)
        VoltUi.Parent = game:GetService("CoreGui")
    else
        local CoreGui = game:GetService("CoreGui")
        local success = pcall(function()
            VoltUi.Parent = CoreGui
        end)
        if not success then
            VoltUi.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    
    return WindowObject
end

return Window
