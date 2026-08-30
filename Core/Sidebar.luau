local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)

local Sidebar = {}

function Sidebar.Create(Content, maid)
    local SidebarFrame = Instance.new("Frame")
    SidebarFrame.Name = "Sidebar"
    SidebarFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    SidebarFrame.BorderColor3 = Color3.new(0, 0, 0)
    SidebarFrame.BorderSizePixel = 0
    SidebarFrame.Size = UDim2.new(0, 200, 1, 0)
    SidebarFrame.Parent = Content
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = SidebarFrame
    
    local SidebarActions = Instance.new("Frame")
    SidebarActions.Name = "Actions"
    SidebarActions.BackgroundColor3 = Color3.new(1, 1, 1)
    SidebarActions.BackgroundTransparency = 1
    SidebarActions.BorderColor3 = Color3.new(0, 0, 0)
    SidebarActions.BorderSizePixel = 0
    SidebarActions.Size = UDim2.new(0, 200, 0, 35)
    SidebarActions.Parent = SidebarFrame
    
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
    HomeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    HomeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    HomeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    HomeIcon.BackgroundTransparency = 1
    HomeIcon.BorderColor3 = Color3.new(0, 0, 0)
    HomeIcon.BorderSizePixel = 0
    HomeIcon.Image = "rbxassetid://94685968948870"
    HomeIcon.ImageTransparency = 0.2
    HomeIcon.Size = UDim2.new(0, 20, 0, 20)
    HomeIcon.Parent = Home
    
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
    AccountIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    AccountIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    AccountIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    AccountIcon.BackgroundTransparency = 1
    AccountIcon.BorderColor3 = Color3.new(0, 0, 0)
    AccountIcon.BorderSizePixel = 0
    AccountIcon.Image = "rbxassetid://134568818132029"
    AccountIcon.ImageTransparency = 0.1
    AccountIcon.Size = UDim2.new(0, 15, 0, 15)
    AccountIcon.Parent = Account
    
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
    SettingsIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    SettingsIcon.BackgroundTransparency = 1
    SettingsIcon.BorderColor3 = Color3.new(0, 0, 0)
    SettingsIcon.BorderSizePixel = 0
    SettingsIcon.Image = "rbxassetid://95898765113869"
    SettingsIcon.Size = UDim2.new(0, 15, 0, 15)
    SettingsIcon.Parent = Settings
    
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
    CollapseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CollapseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CollapseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    CollapseIcon.BackgroundTransparency = 1
    CollapseIcon.BorderColor3 = Color3.new(0, 0, 0)
    CollapseIcon.BorderSizePixel = 0
    CollapseIcon.Image = "rbxassetid://93526157530558"
    CollapseIcon.ImageTransparency = 0.3
    CollapseIcon.Rotation = -180
    CollapseIcon.Size = UDim2.new(0, 20, 0, 20)
    CollapseIcon.Parent = Collapse
    
    local SidebarFiller2 = Instance.new("Frame")
    SidebarFiller2.Name = "Filler"
    SidebarFiller2.BackgroundColor3 = Color3.new(1, 1, 1)
    SidebarFiller2.BackgroundTransparency = 1
    SidebarFiller2.BorderColor3 = Color3.new(0, 0, 0)
    SidebarFiller2.BorderSizePixel = 0
    SidebarFiller2.LayoutOrder = 2
    SidebarFiller2.Position = UDim2.new(0, 0, 0.131, 0)
    SidebarFiller2.Size = UDim2.new(0, 200, 0, 5)
    SidebarFiller2.Parent = SidebarFrame
    
    local HoverColor = Color3.fromRGB(45, 45, 45)
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local function ApplyHover(button, text)
        button.AutoButtonColor = false
        button.BackgroundColor3 = HoverColor
        button.BackgroundTransparency = 1
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = button
        
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.BackgroundTransparency = 1
        Tooltip.AnchorPoint = Vector2.new(0.5, 0)
        Tooltip.Position = UDim2.new(0.5, 0, 1.1, 0)
        Tooltip.Size = UDim2.new(0, 50, 0, 15)
        Tooltip.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Tooltip.Text = text
        Tooltip.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        Tooltip.TextSize = 12
        Tooltip.TextTransparency = 1
        Tooltip.ZIndex = 10
        Tooltip.Visible = false
        Tooltip.Parent = button
        
        local icon = button:FindFirstChildOfClass("ImageLabel")
        if icon then icon.Active = false end
        
        maid:GiveTask(button.MouseEnter:Connect(function()
            Tween(button, TweenInfoObj, {BackgroundTransparency = 0})
            Tooltip.Visible = true
            Tween(Tooltip, TweenInfoObj, {TextTransparency = 0})
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = 0}) end
        end))
        
        maid:GiveTask(button.MouseLeave:Connect(function()
            Tween(button, TweenInfoObj, {BackgroundTransparency = 1})
            local t1 = Tween(Tooltip, TweenInfoObj, {TextTransparency = 1})
            
            local defTrans = 0
            if button.Name == "Home" then defTrans = 0.2
            elseif button.Name == "Account" then defTrans = 0.1
            elseif button.Name == "Collapse" then defTrans = 0.3
            end
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = defTrans}) end
            
            maid:GiveTask(t1.Completed:Connect(function()
                if Tooltip.TextTransparency == 1 then
                    Tooltip.Visible = false
                end
            end))
        end))
    end
    
    ApplyHover(Home, "Home")
    ApplyHover(Account, "Account")
    ApplyHover(Settings, "Settings")
    ApplyHover(Collapse, "Collapse")
    
    local Searchbar = Instance.new("Frame")
    Searchbar.Name = "Searchbar"
    Searchbar.BackgroundColor3 = Color3.new(1, 1, 1)
    Searchbar.BackgroundTransparency = 1
    Searchbar.BorderColor3 = Color3.new(0, 0, 0)
    Searchbar.BorderSizePixel = 0
    Searchbar.LayoutOrder = 1
    Searchbar.Position = UDim2.new(0, 0, 0.064, 0)
    Searchbar.Size = UDim2.new(0, 200, 0, 35)
    Searchbar.Parent = SidebarFrame
    
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
    
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "Tabs"
    TabsContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.BorderColor3 = Color3.new(0, 0, 0)
    TabsContainer.BorderSizePixel = 0
    TabsContainer.LayoutOrder = 3
    TabsContainer.Position = UDim2.new(0, 0, 0.136, 0)
    TabsContainer.Size = UDim2.new(0, 200, 1, -75)
    TabsContainer.Parent = SidebarFrame
    
    local TabsTopBorder = Instance.new("Frame")
    TabsTopBorder.Name = "TopBorder"
    TabsTopBorder.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    TabsTopBorder.BorderSizePixel = 0
    TabsTopBorder.Size = UDim2.new(1, 0, 0, 1)
    TabsTopBorder.Parent = TabsContainer
    
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
    
    return {
        Instance = SidebarFrame,
        TabsContainer = TabsScrolling,
        SearchInput = SearchInput
    }
end

return Sidebar
