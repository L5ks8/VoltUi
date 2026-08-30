local Window = {}
local Topbar = require(script.Parent.Topbar)
local Sidebar = require(script.Parent.Sidebar)
local Bottombar = require(script.Parent.Bottombar)

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
    Content.AnchorPoint = Vector2.new(0.5, 0.5)
    Content.BackgroundColor3 = Color3.new(1, 1, 1)
    Content.BackgroundTransparency = 1
    Content.BorderColor3 = Color3.new(0, 0, 0)
    Content.BorderSizePixel = 0
    Content.LayoutOrder = 1
    Content.Position = UDim2.new(0.5, 0, 0.508, 0)
    Content.Size = UDim2.new(0, 800, 0, 550)
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
    MainContent.Position = UDim2.new(0.254, 0, 0.004, 0)
    MainContent.Size = UDim2.new(0, 597, 0, 550)
    MainContent.Parent = Content
    
    local MainContentStroke = Instance.new("UIStroke")
    MainContentStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    MainContentStroke.Color = Color3.new(0.216, 0.216, 0.216)
    MainContentStroke.Parent = MainContent
    
    local BottombarElements = Bottombar.Create(Main)
    
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
