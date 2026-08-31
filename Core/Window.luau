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
local Loading = require(script.Parent.Loading)

local Window = {}

function Window:CreateWindow(Config)
    local maid = Maid.new()
    
    local VoltUi = Instance.new("ScreenGui")
    VoltUi.Name = "VoltUi"
    VoltUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    VoltUi.IgnoreGuiInset = true
    VoltUi.ResetOnSpawn = false
    maid:GiveTask(VoltUi)
    
    Utility.ProtectGui(VoltUi)
    
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
    
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.AnchorPoint = Vector2.new(0, 0)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 0, 0, 30)
    PagesContainer.Size = UDim2.new(1, 0, 1, -50)
    PagesContainer.ClipsDescendants = true
    PagesContainer.Parent = Main
    
    local PageLayout = Instance.new("UIPageLayout")
    PageLayout.TweenTime = 0.4
    PageLayout.EasingStyle = Enum.EasingStyle.Quint
    PageLayout.EasingDirection = Enum.EasingDirection.Out
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.ScrollWheelInputEnabled = false
    PageLayout.TouchInputEnabled = false
    PageLayout.GamepadInputEnabled = false
    PageLayout.Parent = PagesContainer
    
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.LayoutOrder = 1
    Content.Parent = PagesContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.Padding = UDim.new(0, 3)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.Parent = Content
    
    local OnCollapse = Signal.new()
    maid:GiveTask(OnCollapse)
    
    local SidebarElements = Sidebar.Create(Content, maid, OnCollapse)
    

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
    
    maid:GiveTask(OnCollapse:Connect(function(isCollapsed)
        local SidebarTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if isCollapsed then
            Tween(MainContent, SidebarTweenInfo, {Size = UDim2.new(1, -51, 1, 0)})
        else
            Tween(MainContent, SidebarTweenInfo, {Size = UDim2.new(1, -201, 1, 0)})
        end
    end))
    
    local ExpiredOverlay = Instance.new("TextButton")
    ExpiredOverlay.Name = "ExpiredOverlay"
    ExpiredOverlay.Size = UDim2.new(1, 0, 1, 0)
    ExpiredOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    ExpiredOverlay.BackgroundTransparency = 0.5
    ExpiredOverlay.Text = ""
    ExpiredOverlay.AutoButtonColor = false
    ExpiredOverlay.ZIndex = 9999
    ExpiredOverlay.Visible = false
    ExpiredOverlay.Parent = MainContent
    
    local ExpiredText = Instance.new("TextLabel")
    ExpiredText.Size = UDim2.new(1, 0, 1, 0)
    ExpiredText.BackgroundTransparency = 1
    ExpiredText.Text = "Subscription Expired"
    ExpiredText.TextColor3 = Color3.new(1, 0.3, 0.3)
    ExpiredText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ExpiredText.TextSize = 24
    ExpiredText.ZIndex = 10000
    ExpiredText.Parent = ExpiredOverlay

    maid:GiveTask(ExpiredOverlay.MouseButton1Click:Connect(function()
        Notifications.Notify({
            Title = "Expired",
            Content = "Your subscription has expired. Please redeem a new key in the Account page.",
            Type = "Error",
            Duration = 3
        })
    end))

    Main.Visible = false
    
    local BottombarElements = Bottombar.Create(Main, maid)
    
    AccountPageElements = AccountPage.Create(PagesContainer, maid, function()
        PageLayout:JumpTo(Content)
        BottombarElements.Instance.Visible = true
        Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -50)})
        if Api.UserData and Api.UserData.remaining == "Expired" then
            ExpiredOverlay.Visible = true
        else
            ExpiredOverlay.Visible = false
        end
    end, Api)

    local loadingScreen = Loading.Create(VoltUi)

    local function OnLoginSuccess()
        loadingScreen:WaitForReady()
        Main.Visible = true
        if AccountPageElements and Api.UserData then
            AccountPageElements.UpdateData(Api.UserData)
            if Api.UserData.remaining == "Expired" then
                ExpiredOverlay.Visible = true
            else
                ExpiredOverlay.Visible = false
            end
        end
        loadingScreen:FadeOut()
    end

    local token = Api.GetToken()
    if token then
        task.spawn(function()
            local data = Api.FetchMe()
            if data then
                OnLoginSuccess()
            else
                loadingScreen:WaitForReady()
                LoginPage.Create(VoltUi, OnLoginSuccess)
                loadingScreen:FadeOut()
            end
        end)
    else
        loadingScreen:WaitForReady()
        LoginPage.Create(VoltUi, OnLoginSuccess)
        loadingScreen:FadeOut()
    end
    
    maid:GiveTask(SidebarElements.AccountBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(AccountPageElements.Instance)
        BottombarElements.Instance.Visible = false
        Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -30)})
    end))
    
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
        OnClose = OnClose,
        OnCollapse = OnCollapse
    }
    
    function WindowObject:CreateTab(Name, IconAsset)
        return Tabs.CreateTab(WindowObject, Name, IconAsset)
    end
    
    return WindowObject
end

return Window
