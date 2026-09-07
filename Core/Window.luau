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

    local requireAuth = (Config.KeySystem == true) or (Config.Login == true) or (Config.EnableAuth == true)
    local Api = nil
    if requireAuth then
        pcall(function()
            Api = require(Utils.Api)
        end)
    end

    local BottombarElements = Bottombar.Create(Main, maid)
    
    local AccountPageElements
    pcall(function()
        AccountPageElements = AccountPage.Create(PagesContainer, maid, function()
            PageLayout:JumpTo(Content)
            BottombarElements.Instance.Visible = true
            Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -50)})
            if Api and Api.UserData and Api.UserData.remaining == "Expired" then
                ExpiredOverlay.Visible = true
            else
                ExpiredOverlay.Visible = false
            end
        end, Api)
    end)

    local function OnLoginSuccess()
        Main.Visible = true
        if AccountPageElements and Api and Api.UserData then
            pcall(function()
                AccountPageElements.UpdateData(Api.UserData)
                if Api.UserData.remaining == "Expired" then
                    ExpiredOverlay.Visible = true
                else
                    ExpiredOverlay.Visible = false
                end
            end)
        end
    end

    if requireAuth and Api then
        local loadingScreen
        pcall(function()
            loadingScreen = Loading.Create(VoltUi)
        end)

        local token = nil
        pcall(function() token = Api.GetToken() end)

        if token then
            task.spawn(function()
                local data = nil
                pcall(function() data = Api.FetchMe() end)
                if data then
                    if loadingScreen then loadingScreen:WaitForReady() end
                    OnLoginSuccess()
                    if loadingScreen then loadingScreen:FadeOut() end
                else
                    if loadingScreen then loadingScreen:WaitForReady() end
                    LoginPage.Create(VoltUi, function()
                        OnLoginSuccess()
                    end)
                    if loadingScreen then loadingScreen:FadeOut() end
                end
            end)
        else
            if loadingScreen then loadingScreen:WaitForReady() end
            LoginPage.Create(VoltUi, function()
                OnLoginSuccess()
            end)
            if loadingScreen then loadingScreen:FadeOut() end
        end
    elseif Config.Loading or Config.LoadingScreen then
        local loadingScreen
        pcall(function()
            loadingScreen = Loading.Create(VoltUi)
        end)
        task.spawn(function()
            if loadingScreen then loadingScreen:WaitForReady() end
            Main.Visible = true
            if loadingScreen then loadingScreen:FadeOut() end
        end)
    else
        Main.Visible = true
    end
    
    maid:GiveTask(SidebarElements.AccountBtn.MouseButton1Click:Connect(function()
        if AccountPageElements and AccountPageElements.Instance then
            PageLayout:JumpTo(AccountPageElements.Instance)
            BottombarElements.Instance.Visible = false
            Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -30)})
        end
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
    
    function WindowObject:CreateTab(NameOrConfig, IconAsset)
        local tabName = NameOrConfig
        local tabIcon = IconAsset
        if type(NameOrConfig) == "table" then
            tabName = NameOrConfig.Name or NameOrConfig.Title or "Tab"
            tabIcon = NameOrConfig.Icon or NameOrConfig.IconAsset
        end
        return Tabs.CreateTab(WindowObject, tabName, tabIcon)
    end
    WindowObject.CreateTabSection = WindowObject.CreateTab
    WindowObject.AddTab = WindowObject.CreateTab
    
    function WindowObject:Notify(Config)
        return Notifications.Notify(Config)
    end

    function WindowObject:Notification(Config)
        return Notifications.Notify(Config)
    end

    function WindowObject:PromptDialog(Config)
        local dialogConfig = type(Config) == "string" and {Content = Config} or (Config or {})
        local titleText = dialogConfig.Title or dialogConfig.Name or "Prompt"
        local contentText = dialogConfig.Content or dialogConfig.Text or dialogConfig.Description or ""
        local buttons = dialogConfig.Buttons or {
            {Text = "Confirm", Callback = function() end},
            {Text = "Cancel", Callback = function() end}
        }

        local DialogBackdrop = Instance.new("TextButton")
        DialogBackdrop.Name = "PromptDialogBackdrop"
        DialogBackdrop.AutoButtonColor = false
        DialogBackdrop.Text = ""
        DialogBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        DialogBackdrop.BackgroundTransparency = 1
        DialogBackdrop.Size = UDim2.new(1, 0, 1, 0)
        DialogBackdrop.ZIndex = 60000
        DialogBackdrop.Parent = VoltUi

        local DialogCard = Instance.new("Frame")
        DialogCard.Name = "DialogCard"
        DialogCard.BackgroundColor3 = Color3.fromRGB(18, 17, 23)
        DialogCard.BorderSizePixel = 0
        DialogCard.AnchorPoint = Vector2.new(0.5, 0.5)
        DialogCard.Position = UDim2.new(0.5, 0, 0.5, 0)
        DialogCard.Size = UDim2.new(0, 360, 0, 0)
        DialogCard.AutomaticSize = Enum.AutomaticSize.Y
        DialogCard.ClipsDescendants = true
        DialogCard.ZIndex = 60001
        DialogCard.Parent = DialogBackdrop

        local DialogCorner = Instance.new("UICorner")
        DialogCorner.CornerRadius = UDim.new(0, 8)
        DialogCorner.Parent = DialogCard

        local DialogStroke = Instance.new("UIStroke")
        DialogStroke.Color = Color3.fromRGB(48, 45, 58)
        DialogStroke.Thickness = 1
        DialogStroke.Parent = DialogCard

        local CardScale = Instance.new("UIScale")
        CardScale.Scale = 0.9
        CardScale.Parent = DialogCard

        local CardLayout = Instance.new("UIListLayout")
        CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
        CardLayout.Padding = UDim.new(0, 10)
        CardLayout.Parent = DialogCard

        local CardPadding = Instance.new("UIPadding")
        CardPadding.PaddingTop = UDim.new(0, 14)
        CardPadding.PaddingBottom = UDim.new(0, 14)
        CardPadding.PaddingLeft = UDim.new(0, 16)
        CardPadding.PaddingRight = UDim.new(0, 16)
        CardPadding.Parent = DialogCard

        local HeaderRow = Instance.new("Frame")
        HeaderRow.Name = "HeaderRow"
        HeaderRow.BackgroundTransparency = 1
        HeaderRow.Size = UDim2.new(1, 0, 0, 20)
        HeaderRow.Parent = DialogCard

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, -25, 1, 0)
        TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        TitleLabel.Text = titleText
        TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 60002
        TitleLabel.Parent = HeaderRow

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Name = "Close"
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Position = UDim2.new(1, -16, 0, 0)
        CloseBtn.Size = UDim2.new(0, 16, 0, 16)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
        CloseBtn.TextSize = 12
        CloseBtn.ZIndex = 60002
        CloseBtn.Parent = HeaderRow

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Name = "Content"
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Size = UDim2.new(1, 0, 0, 0)
        ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
        ContentLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        ContentLabel.Text = contentText
        ContentLabel.TextColor3 = Color3.fromRGB(170, 170, 180)
        ContentLabel.TextSize = 13
        ContentLabel.TextWrapped = true
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.ZIndex = 60002
        ContentLabel.Parent = DialogCard

        local ButtonRow = Instance.new("Frame")
        ButtonRow.Name = "ButtonRow"
        ButtonRow.BackgroundTransparency = 1
        ButtonRow.Size = UDim2.new(1, 0, 0, 30)
        ButtonRow.ZIndex = 60002
        ButtonRow.Parent = DialogCard

        local ButtonLayout = Instance.new("UIListLayout")
        ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
        ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        ButtonLayout.Padding = UDim.new(0, 8)
        ButtonLayout.Parent = ButtonRow

        local closing = false
        local function closeDialog()
            if closing then return end
            closing = true
            Tween(DialogBackdrop, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(CardScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.85})
            task.delay(0.2, function()
                DialogBackdrop:Destroy()
            end)
        end

        CloseBtn.MouseButton1Click:Connect(closeDialog)

        for i, btnData in ipairs(buttons) do
            local bText = btnData.Text or btnData.Title or btnData.Name or "Button"
            local bCb = btnData.Callback or function() end
            local isPrimary = (i == 1 and #buttons > 1)

            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Name = bText
            ActionBtn.AutoButtonColor = false
            ActionBtn.BackgroundColor3 = isPrimary and Color3.fromRGB(35, 33, 45) or Color3.fromRGB(24, 23, 30)
            ActionBtn.Size = UDim2.new(0, 0, 1, 0)
            ActionBtn.AutomaticSize = Enum.AutomaticSize.X
            ActionBtn.Text = ""
            ActionBtn.ZIndex = 60003
            ActionBtn.Parent = ButtonRow

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ActionBtn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = isPrimary and Color3.fromRGB(180, 175, 230) or Color3.fromRGB(48, 45, 58)
            BtnStroke.Thickness = 1
            BtnStroke.Parent = ActionBtn

            local BtnPadding = Instance.new("UIPadding")
            BtnPadding.PaddingLeft = UDim.new(0, 14)
            BtnPadding.PaddingRight = UDim.new(0, 14)
            BtnPadding.Parent = ActionBtn

            local BtnLabel = Instance.new("TextLabel")
            BtnLabel.Name = "Text"
            BtnLabel.BackgroundTransparency = 1
            BtnLabel.Size = UDim2.new(1, 0, 1, 0)
            BtnLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            BtnLabel.Text = bText
            BtnLabel.TextColor3 = isPrimary and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(180, 180, 190)
            BtnLabel.TextSize = 12
            BtnLabel.ZIndex = 60004
            BtnLabel.Parent = ActionBtn

            ActionBtn.MouseButton1Click:Connect(function()
                bCb()
                closeDialog()
            end)
        end

        Tween(DialogBackdrop, TweenInfo.new(0.2), {BackgroundTransparency = 0.5})
        Tween(CardScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})

        return {
            Close = closeDialog
        }
    end
    WindowObject.Dialog = WindowObject.PromptDialog
    
    return WindowObject
end

return Window
