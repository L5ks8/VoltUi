local Utils = script.Parent.Parent.Utils
local Maid = require(Utils.Maid)
local Signal = require(Utils.Signal)
local Tween = require(Utils.Tween)
local Utility = require(Utils.Utility)

local Topbar = require(script.Parent.Topbar)
local Sidebar = require(script.Parent.Sidebar)
local Bottombar = require(script.Parent.Bottombar)
local Minimized = require(script.Parent.Minimized)
local CloseWarn = require(script.Parent.CloseWarn)
local AccountPage = require(script.Parent.AccountPage)
local LoginPage = require(script.Parent.LoginPage)
local Notifications = require(script.Parent.Notifications)
local Tabs = require(script.Parent.Tabs)

local Window = {}

function Window:CreateWindow(Config)
    local maid = Maid.new()
    
    local VoltUi = Instance.new("ScreenGui")
    VoltUi.Name = "VoltUi"
    VoltUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    VoltUi.ResetOnSpawn = false
    maid:GiveTask(VoltUi)
    
    Notifications.Init(VoltUi)
    
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
    UIStroke.Color = Color3.new(0.216, 0.216, 0.216)
    UIStroke.Parent = Main
    
    local MainScale = Instance.new("UIScale")
    MainScale.Parent = Main
    
    local TopbarElements = Topbar.Create(Main, Config, maid)
    
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
    
    local SidebarElements = Sidebar.Create(Content, maid)
    
    local SidebarSeparator = Instance.new("Frame")
    SidebarSeparator.Name = "SidebarSeparator"
    SidebarSeparator.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    SidebarSeparator.BorderSizePixel = 0
    SidebarSeparator.Size = UDim2.new(0, 1, 1, 0)
    SidebarSeparator.LayoutOrder = 1
    SidebarSeparator.Parent = Content
    
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.BackgroundColor3 = Color3.new(1, 1, 1)
    MainContent.BackgroundTransparency = 1
    MainContent.BorderColor3 = Color3.new(0, 0, 0)
    MainContent.BorderSizePixel = 0
    MainContent.Position = UDim2.new(0, 201, 0, 0)
    MainContent.Size = UDim2.new(1, -201, 1, 0)
    MainContent.LayoutOrder = 2
    MainContent.Parent = Content
    
    -- Authenticate and fetch user data
    Main.Visible = false
    
    local AccountPageElements
    AccountPageElements = AccountPage.Create(Content, maid, function()
        -- Slide Out
        Tween(AccountPageElements.Instance, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 30)})
        
        SidebarElements.Instance.Visible = true
        SidebarSeparator.Visible = true
        MainContent.Visible = true
        
        task.delay(0.4, function()
            AccountPageElements.Instance.Visible = false
        end)
    end, Api)

    local function OnLoginSuccess()
        Main.Visible = true
        if AccountPageElements and Api.UserData then
            AccountPageElements.UpdateData(Api.UserData)
        end
    end

    local token = Api.GetToken()
    if token then
        -- Auto login with saved token
        task.spawn(function()
            local data = Api.FetchMe()
            if data then
                OnLoginSuccess()
            else
                -- Token invalid, show login
                LoginPage.Create(VoltUi, OnLoginSuccess)
            end
        end)
    else
        LoginPage.Create(VoltUi, OnLoginSuccess)
    end
    
    maid:GiveTask(SidebarElements.AccountBtn.MouseButton1Click:Connect(function()
        AccountPageElements.Instance.Position = UDim2.new(1, 0, 0, 30)
        AccountPageElements.Instance.Visible = true
        
        -- Slide In
        Tween(AccountPageElements.Instance, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 30)})
        
        task.delay(0.2, function()
            SidebarElements.Instance.Visible = false
            SidebarSeparator.Visible = false
            MainContent.Visible = false
        end)
    end))
    
    local BottombarElements = Bottombar.Create(Main, maid)
    
    local ClosePrompt = CloseWarn.Create(VoltUi, maid, function()
        maid:DoCleaning()
    end, function()
        
    end)
    
    local isFullscreen = false
    local originalSize = Main.Size
    local originalPosition = Main.Position
    
    local isMinimized = false
    local preMinimizePos = Main.Position
    local MinimizeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local MinimizedBtn
    MinimizedBtn = Minimized.Create(VoltUi, maid, function()
        isMinimized = false
        Main.Visible = true
        Tween(MainScale, MinimizeTweenInfo, {Scale = 1})
        Tween(Main, MinimizeTweenInfo, {
            Position = isFullscreen and UDim2.new(0.5, 0, 0.5, 0) or preMinimizePos
        })
    end)
    
    local FullscreenTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    maid:GiveTask(TopbarElements.FullscreenButton.MouseButton1Click:Connect(function()
        isFullscreen = not isFullscreen
        if isFullscreen then
            originalSize = Main.Size
            originalPosition = Main.Position
            Tween(Main, FullscreenTweenInfo, {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
        else
            Tween(Main, FullscreenTweenInfo, {
                Size = originalSize,
                Position = originalPosition
            })
        end
    end))
    
    maid:GiveTask(TopbarElements.MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = true
        preMinimizePos = Main.Position
        
        MinimizedBtn.Visible = true
        Tween(MainScale, MinimizeTweenInfo, {Scale = 0})
        local tw = Tween(Main, MinimizeTweenInfo, {
            Position = MinimizedBtn.Position
        })
        maid:GiveTask(tw.Completed:Connect(function()
            if isMinimized then
                Main.Visible = false
            end
        end))
    end))
    
    maid:GiveTask(TopbarElements.CloseButton.MouseButton1Click:Connect(function()
        ClosePrompt.Visible = true
    end))
    
    local OnClose = Signal.new()
    maid:GiveTask(OnClose)
    
    local WindowObject = {
        Instance = VoltUi,
        Main = Main,
        Topbar = TopbarElements,
        Sidebar = SidebarElements,
        Bottombar = BottombarElements,
        ContentContainer = MainContent,
        Maid = maid,
        OnClose = OnClose
    }
    
    function WindowObject:CreateTab(Name, IconAsset)
        return Tabs.CreateTab(WindowObject, Name, IconAsset)
    end
    
    Utility.ProtectGui(VoltUi)
    
    return WindowObject
end

return Window
