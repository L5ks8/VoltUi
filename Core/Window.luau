local Window = {}
local Utility = require(script.Parent.Parent.Utils.Utility)

function Window:CreateWindow(Config)
    local Title = Config.Title or "Volt - 1.0.0"
    
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
    
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Topbar.BorderColor3 = Color3.new(0, 0, 0)
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(0, 800, 0, 30)
    Topbar.Parent = Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.BottomLeftRadius = UDim.new(0, 0)
    TopbarCorner.BottomRightRadius = UDim.new(0, 0)
    TopbarCorner.Parent = Topbar
    
    local TopbarStroke = Instance.new("UIStroke")
    TopbarStroke.Color = Color3.new(0.216, 0.216, 0.216)
    TopbarStroke.Parent = Topbar
    
    local TopbarIcon = Instance.new("Frame")
    TopbarIcon.Name = "Icon"
    TopbarIcon.AnchorPoint = Vector2.new(0, 0.5)
    TopbarIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    TopbarIcon.BackgroundTransparency = 1
    TopbarIcon.BorderColor3 = Color3.new(0, 0, 0)
    TopbarIcon.BorderSizePixel = 0
    TopbarIcon.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarIcon.Size = UDim2.new(0, 30, 0, 30)
    TopbarIcon.Parent = Topbar
    
    local TopbarLogo = Instance.new("ImageLabel")
    TopbarLogo.Name = "Logo"
    TopbarLogo.BackgroundColor3 = Color3.new(1, 1, 1)
    TopbarLogo.BackgroundTransparency = 1
    TopbarLogo.BorderColor3 = Color3.new(0, 0, 0)
    TopbarLogo.BorderSizePixel = 0
    TopbarLogo.Image = "rbxassetid://71942076965693"
    TopbarLogo.Size = UDim2.new(0, 20, 0, 20)
    TopbarLogo.Parent = TopbarIcon
    
    local TopbarIconLayout = Instance.new("UIListLayout")
    TopbarIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TopbarIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TopbarIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TopbarIconLayout.Parent = TopbarIcon
    
    local Actions = Instance.new("Frame")
    Actions.Name = "Actions"
    Actions.BackgroundColor3 = Color3.new(1, 1, 1)
    Actions.BackgroundTransparency = 1
    Actions.BorderColor3 = Color3.new(0, 0, 0)
    Actions.BorderSizePixel = 0
    Actions.Position = UDim2.new(0.861, 0, 0, 0)
    Actions.Size = UDim2.new(0, 111, 0, 30)
    Actions.Parent = Topbar
    
    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsLayout.Parent = Actions
    
    local Minimize = Instance.new("ImageButton")
    Minimize.Name = "Minimize"
    Minimize.BackgroundColor3 = Color3.new(1, 1, 1)
    Minimize.BackgroundTransparency = 1
    Minimize.BorderColor3 = Color3.new(0, 0, 0)
    Minimize.BorderSizePixel = 0
    Minimize.Size = UDim2.new(0, 37, 0, 30)
    Minimize.Parent = Actions
    
    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.BorderColor3 = Color3.new(0, 0, 0)
    MinimizeIcon.BorderSizePixel = 0
    MinimizeIcon.Image = "rbxassetid://109304937949559"
    MinimizeIcon.ImageTransparency = 0.3
    MinimizeIcon.Size = UDim2.new(0, 30, 0, 30)
    MinimizeIcon.Parent = Minimize
    
    local MinimizeLayout = Instance.new("UIListLayout")
    MinimizeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MinimizeLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    MinimizeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MinimizeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    MinimizeLayout.Parent = Minimize
    
    local Fullscreen = Instance.new("ImageButton")
    Fullscreen.Name = "Fullscreen"
    Fullscreen.BackgroundColor3 = Color3.new(1, 1, 1)
    Fullscreen.BackgroundTransparency = 1
    Fullscreen.BorderColor3 = Color3.new(0, 0, 0)
    Fullscreen.BorderSizePixel = 0
    Fullscreen.LayoutOrder = 1
    Fullscreen.Size = UDim2.new(0, 37, 0, 30)
    Fullscreen.Parent = Actions
    
    local FullscreenIcon = Instance.new("ImageLabel")
    FullscreenIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    FullscreenIcon.BackgroundTransparency = 1
    FullscreenIcon.BorderColor3 = Color3.new(0, 0, 0)
    FullscreenIcon.BorderSizePixel = 0
    FullscreenIcon.Image = "rbxassetid://89144063792928"
    FullscreenIcon.Size = UDim2.new(0, 23, 0, 23)
    FullscreenIcon.Parent = Fullscreen
    
    local FullscreenLayout = Instance.new("UIListLayout")
    FullscreenLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    FullscreenLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    FullscreenLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FullscreenLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    FullscreenLayout.Parent = Fullscreen
    
    local Close = Instance.new("ImageButton")
    Close.Name = "Close"
    Close.BackgroundColor3 = Color3.new(1, 1, 1)
    Close.BackgroundTransparency = 1
    Close.BorderColor3 = Color3.new(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.HoverImage = "rbxassetid://0"
    Close.LayoutOrder = 2
    Close.Size = UDim2.new(0.324, 0, 1, 0)
    Close.Parent = Actions
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.BorderColor3 = Color3.new(0, 0, 0)
    CloseIcon.BorderSizePixel = 0
    CloseIcon.Image = "rbxassetid://121170570745612"
    CloseIcon.ImageTransparency = 0.3
    CloseIcon.Size = UDim2.new(0, 30, 0, 30)
    CloseIcon.Parent = Close
    
    local CloseLayout = Instance.new("UIListLayout")
    CloseLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CloseLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CloseLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    CloseLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceAround
    CloseLayout.Parent = Close
    
    local Version = Instance.new("Frame")
    Version.Name = "Version"
    Version.AnchorPoint = Vector2.new(0.5, 0.5)
    Version.BackgroundColor3 = Color3.new(1, 1, 1)
    Version.BackgroundTransparency = 1
    Version.BorderColor3 = Color3.new(0, 0, 0)
    Version.BorderSizePixel = 0
    Version.Position = UDim2.new(0.5, 0, 0.5, 0)
    Version.Size = UDim2.new(0, 100, 0, 30)
    Version.Parent = Topbar
    
    local VersionText = Instance.new("TextLabel")
    VersionText.Name = "Text"
    VersionText.BackgroundColor3 = Color3.new(1, 1, 1)
    VersionText.BackgroundTransparency = 1
    VersionText.BorderColor3 = Color3.new(0, 0, 0)
    VersionText.BorderSizePixel = 0
    VersionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    VersionText.Size = UDim2.new(1, 0, 1, 0)
    VersionText.Text = Title
    VersionText.TextColor3 = Color3.new(0.537, 0.537, 0.537)
    VersionText.TextSize = 13
    VersionText.Parent = Version
    
    local Bottombar = Instance.new("Frame")
    Bottombar.Name = "Bottombar"
    Bottombar.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Bottombar.BorderColor3 = Color3.new(0, 0, 0)
    Bottombar.BorderSizePixel = 0
    Bottombar.LayoutOrder = 2
    Bottombar.Position = UDim2.new(0, 0, 0.967, 0)
    Bottombar.Rotation = -0.01
    Bottombar.Size = UDim2.new(0, 800, 0, 20)
    Bottombar.Parent = Main
    
    local BottombarStroke = Instance.new("UIStroke")
    BottombarStroke.Color = Color3.new(0.216, 0.216, 0.216)
    BottombarStroke.Parent = Bottombar
    
    local BottombarCorner = Instance.new("UICorner")
    BottombarCorner.CornerRadius = UDim.new(0, 0)
    BottombarCorner.TopLeftRadius = UDim.new(0, 0)
    BottombarCorner.TopRightRadius = UDim.new(0, 0)
    BottombarCorner.Parent = Bottombar
    
    local Tabdisplay = Instance.new("Frame")
    Tabdisplay.Name = "Tabdisplay"
    Tabdisplay.BackgroundColor3 = Color3.new(1, 1, 1)
    Tabdisplay.BackgroundTransparency = 1
    Tabdisplay.BorderColor3 = Color3.new(0, 0, 0)
    Tabdisplay.BorderSizePixel = 0
    Tabdisplay.Size = UDim2.new(0, 100, 0, 20)
    Tabdisplay.Parent = Bottombar
    
    local TabdisplayIcon = Instance.new("TextLabel")
    TabdisplayIcon.Name = "Icon"
    TabdisplayIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    TabdisplayIcon.BackgroundTransparency = 1
    TabdisplayIcon.BorderColor3 = Color3.new(0, 0, 0)
    TabdisplayIcon.BorderSizePixel = 0
    TabdisplayIcon.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TabdisplayIcon.Size = UDim2.new(0.2, 0, 1, 0)
    TabdisplayIcon.Text = "< ⁄ >"
    TabdisplayIcon.TextColor3 = Color3.new(0.51, 0.51, 0.51)
    TabdisplayIcon.TextDirection = Enum.TextDirection.RightToLeft
    TabdisplayIcon.TextSize = 13
    TabdisplayIcon.TextXAlignment = Enum.TextXAlignment.Right
    TabdisplayIcon.Parent = Tabdisplay
    
    local TabdisplayName = Instance.new("TextLabel")
    TabdisplayName.Name = "TabName"
    TabdisplayName.BackgroundColor3 = Color3.new(1, 1, 1)
    TabdisplayName.BackgroundTransparency = 1
    TabdisplayName.BorderColor3 = Color3.new(0.353, 0.353, 0.353)
    TabdisplayName.BorderSizePixel = 0
    TabdisplayName.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TabdisplayName.LayoutOrder = 1
    TabdisplayName.Size = UDim2.new(1, 0, 1, 0)
    TabdisplayName.Text = "No Tab Selected"
    TabdisplayName.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    TabdisplayName.TextSize = 14
    TabdisplayName.TextXAlignment = Enum.TextXAlignment.Left
    TabdisplayName.Parent = Tabdisplay
    
    local TabdisplayNamePadding = Instance.new("UIPadding")
    TabdisplayNamePadding.PaddingLeft = UDim.new(0, 3)
    TabdisplayNamePadding.Parent = TabdisplayName
    
    local TabdisplayLayout = Instance.new("UIListLayout")
    TabdisplayLayout.FillDirection = Enum.FillDirection.Horizontal
    TabdisplayLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabdisplayLayout.Parent = Tabdisplay
    
    local Info = Instance.new("Frame")
    Info.Name = "Info"
    Info.BackgroundColor3 = Color3.new(1, 1, 1)
    Info.BackgroundTransparency = 1
    Info.BorderColor3 = Color3.new(0, 0, 0)
    Info.BorderSizePixel = 0
    Info.Position = UDim2.new(0.775, 0, 0, 0)
    Info.Size = UDim2.new(0, 180, 0, 20)
    Info.Parent = Bottombar
    
    local InfoLayout = Instance.new("UIListLayout")
    InfoLayout.FillDirection = Enum.FillDirection.Horizontal
    InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InfoLayout.Parent = Info
    
    local Status = Instance.new("Frame")
    Status.Name = "Status"
    Status.AnchorPoint = Vector2.new(1, 0.5)
    Status.BackgroundColor3 = Color3.new(1, 1, 1)
    Status.BackgroundTransparency = 1
    Status.BorderColor3 = Color3.new(0, 0, 0)
    Status.BorderSizePixel = 0
    Status.LayoutOrder = 1
    Status.Position = UDim2.new(1, 0, 0.5, 0)
    Status.Size = UDim2.new(0, 85, 0, 20)
    Status.Parent = Info
    
    local StatusIcon = Instance.new("ImageLabel")
    StatusIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusIcon.BackgroundTransparency = 1
    StatusIcon.BorderColor3 = Color3.new(0, 0, 0)
    StatusIcon.BorderSizePixel = 0
    StatusIcon.Image = "rbxassetid://102114288213902"
    StatusIcon.Size = UDim2.new(0, 20, 0, 20)
    StatusIcon.Parent = Status
    
    local StatusText = Instance.new("TextLabel")
    StatusText.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusText.BackgroundTransparency = 1
    StatusText.BorderColor3 = Color3.new(0, 0, 0)
    StatusText.BorderSizePixel = 0
    StatusText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    StatusText.LayoutOrder = 1
    StatusText.Position = UDim2.new(0.2, 0, 0, 0)
    StatusText.Size = UDim2.new(0.8, 0, 1, 0)
    StatusText.Text = "Connected"
    StatusText.TextColor3 = Color3.new(0.482, 0.482, 0.482)
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = Status
    
    local StatusTextPadding = Instance.new("UIPadding")
    StatusTextPadding.PaddingLeft = UDim.new(0, 5)
    StatusTextPadding.Parent = StatusText
    
    local StatusLayout = Instance.new("UIListLayout")
    StatusLayout.FillDirection = Enum.FillDirection.Horizontal
    StatusLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatusLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StatusLayout.Parent = Status
    
    local Gamename = Instance.new("Frame")
    Gamename.Name = "Gamename"
    Gamename.BackgroundColor3 = Color3.new(1, 1, 1)
    Gamename.BackgroundTransparency = 1
    Gamename.BorderColor3 = Color3.new(0, 0, 0)
    Gamename.BorderSizePixel = 0
    Gamename.Size = UDim2.new(0, 95, 0, 20)
    Gamename.Parent = Info
    
    local GamenameText = Instance.new("TextLabel")
    GamenameText.Name = "Name"
    GamenameText.AnchorPoint = Vector2.new(0.5, 0.5)
    GamenameText.BackgroundColor3 = Color3.new(1, 1, 1)
    GamenameText.BackgroundTransparency = 1
    GamenameText.BorderColor3 = Color3.new(0, 0, 0)
    GamenameText.BorderSizePixel = 0
    GamenameText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    GamenameText.Position = UDim2.new(0.5, 0, 0.5, 0)
    GamenameText.Size = UDim2.new(1, 0, 1, 0)
    local Success, GameNameResult = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    GamenameText.Text = Success and GameNameResult or "Unknown Game"
    GamenameText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    GamenameText.TextSize = 14
    GamenameText.Parent = Gamename
    
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
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Sidebar.BorderColor3 = Color3.new(0, 0, 0)
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 200, 0, 550)
    Sidebar.Parent = Content
    
    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    SidebarStroke.Color = Color3.new(0.216, 0.216, 0.216)
    SidebarStroke.Parent = Sidebar
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar
    
    local SidebarActions = Instance.new("Frame")
    SidebarActions.Name = "Actions"
    SidebarActions.BackgroundColor3 = Color3.new(1, 1, 1)
    SidebarActions.BackgroundTransparency = 1
    SidebarActions.BorderColor3 = Color3.new(0, 0, 0)
    SidebarActions.BorderSizePixel = 0
    SidebarActions.Size = UDim2.new(0, 200, 0, 35)
    SidebarActions.Parent = Sidebar
    
    local SidebarActionsLayout = Instance.new("UIListLayout")
    SidebarActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    SidebarActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarActionsLayout.Parent = SidebarActions
    
    local Home = Instance.new("ImageButton")
    Home.Name = "Home"
    Home.BackgroundColor3 = Color3.new(1, 1, 1)
    Home.BackgroundTransparency = 1
    Home.BorderColor3 = Color3.new(0, 0, 0)
    Home.BorderSizePixel = 0
    Home.Size = UDim2.new(0, 35, 0, 35)
    Home.Parent = SidebarActions
    
    local HomeIcon = Instance.new("ImageLabel")
    HomeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    HomeIcon.BackgroundTransparency = 1
    HomeIcon.BorderColor3 = Color3.new(0, 0, 0)
    HomeIcon.BorderSizePixel = 0
    HomeIcon.Image = "rbxassetid://94685968948870"
    HomeIcon.ImageTransparency = 0.2
    HomeIcon.Size = UDim2.new(0, 20, 0, 20)
    HomeIcon.Parent = Home
    
    local HomeLayout = Instance.new("UIListLayout")
    HomeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    HomeLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    HomeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    HomeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    HomeLayout.Parent = Home
    
    local Account = Instance.new("ImageButton")
    Account.Name = "Account"
    Account.BackgroundColor3 = Color3.new(1, 1, 1)
    Account.BackgroundTransparency = 1
    Account.BorderColor3 = Color3.new(0, 0, 0)
    Account.BorderSizePixel = 0
    Account.LayoutOrder = 1
    Account.Size = UDim2.new(0, 35, 0, 35)
    Account.Parent = SidebarActions
    
    local AccountIcon = Instance.new("ImageLabel")
    AccountIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    AccountIcon.BackgroundTransparency = 1
    AccountIcon.BorderColor3 = Color3.new(0, 0, 0)
    AccountIcon.BorderSizePixel = 0
    AccountIcon.Image = "rbxassetid://134568818132029"
    AccountIcon.ImageTransparency = 0.1
    AccountIcon.Size = UDim2.new(0, 15, 0, 15)
    AccountIcon.Parent = Account
    
    local AccountLayout = Instance.new("UIListLayout")
    AccountLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    AccountLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    AccountLayout.SortOrder = Enum.SortOrder.LayoutOrder
    AccountLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    AccountLayout.Parent = Account
    
    local Settings = Instance.new("ImageButton")
    Settings.Name = "Settings"
    Settings.BackgroundColor3 = Color3.new(1, 1, 1)
    Settings.BackgroundTransparency = 1
    Settings.BorderColor3 = Color3.new(0, 0, 0)
    Settings.BorderSizePixel = 0
    Settings.LayoutOrder = 2
    Settings.Size = UDim2.new(0, 35, 0, 35)
    Settings.Parent = SidebarActions
    
    local SettingsIcon = Instance.new("ImageLabel")
    SettingsIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    SettingsIcon.BackgroundTransparency = 1
    SettingsIcon.BorderColor3 = Color3.new(0, 0, 0)
    SettingsIcon.BorderSizePixel = 0
    SettingsIcon.Image = "rbxassetid://95898765113869"
    SettingsIcon.Size = UDim2.new(0, 15, 0, 15)
    SettingsIcon.Parent = Settings
    
    local SettingsLayout = Instance.new("UIListLayout")
    SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SettingsLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SettingsLayout.Parent = Settings
    
    local SidebarFiller = Instance.new("Frame")
    SidebarFiller.Name = "Filler"
    SidebarFiller.BackgroundColor3 = Color3.new(1, 1, 1)
    SidebarFiller.BackgroundTransparency = 1
    SidebarFiller.BorderColor3 = Color3.new(0, 0, 0)
    SidebarFiller.BorderSizePixel = 0
    SidebarFiller.LayoutOrder = 3
    SidebarFiller.Position = UDim2.new(0.525, 0, 0, 0)
    SidebarFiller.Size = UDim2.new(0, 60, 0, 35)
    SidebarFiller.Parent = SidebarActions
    
    local Collapse = Instance.new("ImageButton")
    Collapse.Name = "Collapse"
    Collapse.BackgroundColor3 = Color3.new(1, 1, 1)
    Collapse.BackgroundTransparency = 1
    Collapse.BorderColor3 = Color3.new(0, 0, 0)
    Collapse.BorderSizePixel = 0
    Collapse.LayoutOrder = 4
    Collapse.Position = UDim2.new(0.525, 0, 0, 0)
    Collapse.Size = UDim2.new(0, 35, 0, 35)
    Collapse.Parent = SidebarActions
    
    local CollapseIcon = Instance.new("ImageLabel")
    CollapseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    CollapseIcon.BackgroundTransparency = 1
    CollapseIcon.BorderColor3 = Color3.new(0, 0, 0)
    CollapseIcon.BorderSizePixel = 0
    CollapseIcon.Image = "rbxassetid://93526157530558"
    CollapseIcon.ImageTransparency = 0.3
    CollapseIcon.Rotation = -180
    CollapseIcon.Size = UDim2.new(0, 20, 0, 20)
    CollapseIcon.Parent = Collapse
    
    local CollapseLayout = Instance.new("UIListLayout")
    CollapseLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CollapseLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    CollapseLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CollapseLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    CollapseLayout.Parent = Collapse
    
    local Searchbar = Instance.new("Frame")
    Searchbar.Name = "Searchbar"
    Searchbar.BackgroundColor3 = Color3.new(1, 1, 1)
    Searchbar.BackgroundTransparency = 1
    Searchbar.BorderColor3 = Color3.new(0, 0, 0)
    Searchbar.BorderSizePixel = 0
    Searchbar.LayoutOrder = 1
    Searchbar.Position = UDim2.new(0, 0, 0.064, 0)
    Searchbar.Size = UDim2.new(0, 200, 0, 35)
    Searchbar.Parent = Sidebar
    
    local SearchbarLayout = Instance.new("UIListLayout")
    SearchbarLayout.FillDirection = Enum.FillDirection.Horizontal
    SearchbarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SearchbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SearchbarLayout.Parent = Searchbar
    
    local Search = Instance.new("Frame")
    Search.Name = "Search"
    Search.BackgroundColor3 = Color3.new(0.094, 0.094, 0.094)
    Search.BorderColor3 = Color3.new(0, 0, 0)
    Search.BorderSizePixel = 0
    Search.Size = UDim2.new(0, 180, 0, 30)
    Search.Parent = Searchbar
    
    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    SearchStroke.Color = Color3.new(0.216, 0.216, 0.216)
    SearchStroke.Parent = Search
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 5)
    SearchCorner.Parent = Search
    
    local SearchInnerLayout = Instance.new("UIListLayout")
    SearchInnerLayout.FillDirection = Enum.FillDirection.Horizontal
    SearchInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchInnerLayout.Parent = Search
    
    local SearchInput = Instance.new("TextBox")
    SearchInput.BackgroundColor3 = Color3.new(1, 1, 1)
    SearchInput.BackgroundTransparency = 1
    SearchInput.BorderColor3 = Color3.new(0, 0, 0)
    SearchInput.BorderSizePixel = 0
    SearchInput.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SearchInput.LayoutOrder = 1
    SearchInput.Position = UDim2.new(0.167, 0, 0, 0)
    SearchInput.Size = UDim2.new(0.833, 0, 1, 0)
    SearchInput.Text = "Search..."
    SearchInput.TextColor3 = Color3.new(0.478, 0.478, 0.478)
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = Search
    
    local SearchInputPadding = Instance.new("UIPadding")
    SearchInputPadding.PaddingLeft = UDim.new(0, 4)
    SearchInputPadding.Parent = SearchInput
    
    local SearchIconFrame = Instance.new("Frame")
    SearchIconFrame.Name = "Icon"
    SearchIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    SearchIconFrame.BackgroundTransparency = 1
    SearchIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    SearchIconFrame.BorderSizePixel = 0
    SearchIconFrame.Size = UDim2.new(0, 30, 0, 30)
    SearchIconFrame.Parent = Search
    
    local SearchIconLabel = Instance.new("ImageLabel")
    SearchIconLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    SearchIconLabel.BackgroundTransparency = 1
    SearchIconLabel.BorderColor3 = Color3.new(0, 0, 0)
    SearchIconLabel.BorderSizePixel = 0
    SearchIconLabel.Image = "rbxassetid://88107177696245"
    SearchIconLabel.ImageTransparency = 0.3
    SearchIconLabel.Size = UDim2.new(0, 16, 0, 16)
    SearchIconLabel.Parent = SearchIconFrame
    
    local SearchIconFrameLayout = Instance.new("UIListLayout")
    SearchIconFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    SearchIconFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SearchIconFrameLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    SearchIconFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchIconFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SearchIconFrameLayout.Parent = SearchIconFrame
    
    local SidebarFiller2 = Instance.new("Frame")
    SidebarFiller2.Name = "Filler"
    SidebarFiller2.BackgroundColor3 = Color3.new(1, 1, 1)
    SidebarFiller2.BackgroundTransparency = 1
    SidebarFiller2.BorderColor3 = Color3.new(0, 0, 0)
    SidebarFiller2.BorderSizePixel = 0
    SidebarFiller2.LayoutOrder = 2
    SidebarFiller2.Position = UDim2.new(0, 0, 0.131, 0)
    SidebarFiller2.Size = UDim2.new(0, 200, 0, 5)
    SidebarFiller2.Parent = Sidebar
    
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "Tabs"
    TabsContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.BorderColor3 = Color3.new(0, 0, 0)
    TabsContainer.BorderSizePixel = 0
    TabsContainer.LayoutOrder = 3
    TabsContainer.Position = UDim2.new(0, 0, 0.136, 0)
    TabsContainer.Size = UDim2.new(0, 200, 0, 475)
    TabsContainer.Parent = Sidebar
    
    local TabsStroke = Instance.new("UIStroke")
    TabsStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    TabsStroke.Color = Color3.new(0.216, 0.216, 0.216)
    TabsStroke.Parent = TabsContainer
    
    local TabsScrolling = Instance.new("ScrollingFrame")
    TabsScrolling.Active = true
    TabsScrolling.BackgroundColor3 = Color3.new(1, 1, 1)
    TabsScrolling.BackgroundTransparency = 1
    TabsScrolling.BorderColor3 = Color3.new(0, 0, 0)
    TabsScrolling.BorderSizePixel = 0
    TabsScrolling.ScrollBarImageColor3 = Color3.new(0.137, 0.137, 0.137)
    TabsScrolling.ScrollBarImageTransparency = 1
    TabsScrolling.Size = UDim2.new(1, 0, 1, 0)
    TabsScrolling.Parent = TabsContainer
    
    local TabsScrollingLayout = Instance.new("UIListLayout")
    TabsScrollingLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsScrollingLayout.Parent = TabsScrolling
    
    local TabsScrollingPadding = Instance.new("UIPadding")
    TabsScrollingPadding.PaddingTop = UDim.new(0, 9)
    TabsScrollingPadding.Parent = TabsScrolling
    
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
    
    local WindowObject = {
        Instance = VoltUi,
        Main = Main,
        TabsContainer = TabsScrolling,
        ContentContainer = MainContent,
        TabdisplayName = TabdisplayName
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
