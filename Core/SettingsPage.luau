local Tween = require(script.Parent.Parent.Utils.Tween)
local Tabs = require(script.Parent.Tabs)
local SettingsManager = require(script.Parent.Parent.Utils.SettingsManager)

local SettingsPage = {}

function SettingsPage.Create(Content, Maid, BackCallback, WindowConfig)
    local Page = Instance.new("Frame")
    Page.Name = "SettingsPage"
    Page.AnchorPoint = Vector2.new(0.5, 0.5)
    Page.BackgroundColor3 = Color3.new(0.067, 0.067, 0.067)
    Page.BorderColor3 = Color3.new(0, 0, 0)
    Page.BorderSizePixel = 0
    Page.Position = UDim2.new(0.5, 0, 0.518, 0)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.LayoutOrder = 3
    Page.Parent = Content

    local PageCorner = Instance.new("UICorner")
    PageCorner.CornerRadius = UDim.new(0, 8)
    PageCorner.TopLeftRadius = UDim.new(0, 0)
    PageCorner.TopRightRadius = UDim.new(0, 0)
    PageCorner.Parent = Page

    local PageStroke = Instance.new("UIStroke")
    PageStroke.Color = Color3.new(0.353, 0.353, 0.353)
    PageStroke.Parent = Page

    --Topbar
    local Actions = Instance.new("Frame")
    Actions.Name = "Actions"
    Actions.BackgroundColor3 = Color3.new(1, 1, 1)
    Actions.BackgroundTransparency = 1
    Actions.BorderColor3 = Color3.new(0, 0, 0)
    Actions.BorderSizePixel = 0
    Actions.Size = UDim2.new(1, 0, 0, 35)
    Actions.Parent = Page

    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsLayout.Padding = UDim.new(0, 5)
    ActionsLayout.Parent = Actions

    local ActionsStroke = Instance.new("UIStroke")
    ActionsStroke.BorderStrokePosition = Enum.BorderStrokePosition.Center
    ActionsStroke.Color = Color3.new(0.149, 0.149, 0.149)
    ActionsStroke.Parent = Actions

    local ReturnButton = Instance.new("ImageButton")
    ReturnButton.Name = "Return"
    ReturnButton.BackgroundColor3 = Color3.new(1, 1, 1)
    ReturnButton.BackgroundTransparency = 1
    ReturnButton.BorderColor3 = Color3.new(0, 0, 0)
    ReturnButton.BorderSizePixel = 0
    ReturnButton.Size = UDim2.new(0, 28, 0, 28)
    ReturnButton.Parent = Actions
    
    local ReturnCorner = Instance.new("UICorner")
    ReturnCorner.CornerRadius = UDim.new(0, 6)
    ReturnCorner.Parent = ReturnButton

    local ReturnLayout = Instance.new("UIListLayout")
    ReturnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ReturnLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    ReturnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ReturnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ReturnLayout.Parent = ReturnButton

    local ReturnIcon = Instance.new("ImageLabel")
    ReturnIcon.Name = "Icon"
    ReturnIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    ReturnIcon.BackgroundTransparency = 1
    ReturnIcon.BorderColor3 = Color3.new(0, 0, 0)
    ReturnIcon.BorderSizePixel = 0
    ReturnIcon.Image = "rbxassetid://93526157530558"
    ReturnIcon.ImageTransparency = 0.3
    ReturnIcon.Size = UDim2.new(0, 25, 0, 25)
    ReturnIcon.Parent = ReturnButton

    if BackCallback then
        Maid:GiveTask(ReturnButton.MouseButton1Click:Connect(BackCallback))
    end
    
    Maid:GiveTask(ReturnButton.MouseEnter:Connect(function()
        Tween(ReturnButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9})
    end))
    Maid:GiveTask(ReturnButton.MouseLeave:Connect(function()
        Tween(ReturnButton, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end))

    local SettingsText = Instance.new("TextLabel")
    SettingsText.BackgroundColor3 = Color3.new(1, 1, 1)
    SettingsText.BackgroundTransparency = 1
    SettingsText.BorderColor3 = Color3.new(0, 0, 0)
    SettingsText.BorderSizePixel = 0
    SettingsText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SettingsText.Size = UDim2.new(0, 200, 0, 35)
    SettingsText.Text = "Settings"
    SettingsText.TextColor3 = Color3.new(0.71, 0.71, 0.71)
    SettingsText.TextSize = 14
    SettingsText.TextXAlignment = Enum.TextXAlignment.Left
    SettingsText.Parent = Actions

    local SettingsTextPadding = Instance.new("UIPadding")
    SettingsTextPadding.PaddingLeft = UDim.new(0, 5)
    SettingsTextPadding.Parent = SettingsText

    --Content
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderColor3 = Color3.new(0, 0, 0)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 0, 0, 35)
    ContentFrame.Size = UDim2.new(1, 0, 1, -35)
    ContentFrame.Parent = Page

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.Padding = UDim.new(0, 3)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.Parent = ContentFrame
    
    --Sidebar
    local SettingsSidebar = Instance.new("Frame")
    SettingsSidebar.Name = "Sidebar"
    SettingsSidebar.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    SettingsSidebar.BorderColor3 = Color3.new(0, 0, 0)
    SettingsSidebar.BorderSizePixel = 0
    SettingsSidebar.Size = UDim2.new(0, 200, 1, 0)
    SettingsSidebar.LayoutOrder = 0
    SettingsSidebar.Parent = ContentFrame
    
    --Search
    local SearchContainer = Instance.new("Frame")
    SearchContainer.Name = "SearchContainer"
    SearchContainer.BackgroundTransparency = 1
    SearchContainer.Size = UDim2.new(1, 0, 0, 45)
    SearchContainer.Parent = SettingsSidebar
    
    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.BackgroundColor3 = Color3.new(0.094, 0.094, 0.094)
    SearchBox.BorderColor3 = Color3.new(0, 0, 0)
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0, 10, 0, 8)
    SearchBox.Size = UDim2.new(1, -20, 0, 30)
    SearchBox.Parent = SearchContainer
    
    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    SearchStroke.Color = Color3.new(0.216, 0.216, 0.216)
    SearchStroke.Parent = SearchBox
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 5)
    SearchCorner.Parent = SearchBox
    
    local SearchInnerLayout = Instance.new("UIListLayout")
    SearchInnerLayout.FillDirection = Enum.FillDirection.Horizontal
    SearchInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchInnerLayout.Parent = SearchBox
    
    local SearchIconFrame = Instance.new("Frame")
    SearchIconFrame.Name = "Icon"
    SearchIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    SearchIconFrame.BackgroundTransparency = 1
    SearchIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    SearchIconFrame.BorderSizePixel = 0
    SearchIconFrame.Size = UDim2.new(0, 30, 0, 30)
    SearchIconFrame.Parent = SearchBox
    
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

    local SearchInput = Instance.new("TextBox")
    SearchInput.BackgroundColor3 = Color3.new(1, 1, 1)
    SearchInput.BackgroundTransparency = 1
    SearchInput.BorderColor3 = Color3.new(0, 0, 0)
    SearchInput.BorderSizePixel = 0
    SearchInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SearchInput.LayoutOrder = 1
    SearchInput.Size = UDim2.new(1, -30, 1, 0)
    SearchInput.PlaceholderText = "Search settings"
    SearchInput.Text = ""
    SearchInput.TextColor3 = Color3.new(0.478, 0.478, 0.478)
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = SearchBox
    
    local SearchInputPadding = Instance.new("UIPadding")
    SearchInputPadding.PaddingLeft = UDim.new(0, 4)
    SearchInputPadding.Parent = SearchInput
    
    local SearchDivider = Instance.new("Frame")
    SearchDivider.Name = "SearchDivider"
    SearchDivider.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    SearchDivider.BorderSizePixel = 0
    SearchDivider.Position = UDim2.new(0, 0, 0, 45)
    SearchDivider.Size = UDim2.new(1, 0, 0, 1)
    SearchDivider.Parent = SettingsSidebar
    
    --TabsContainer
    local SettingsTabsContainer = Instance.new("ScrollingFrame")
    SettingsTabsContainer.Name = "TabsContainer"
    SettingsTabsContainer.BackgroundTransparency = 1
    SettingsTabsContainer.BorderSizePixel = 0
    SettingsTabsContainer.Size = UDim2.new(1, 0, 1, -95)
    SettingsTabsContainer.Position = UDim2.new(0, 0, 0, 45)
    SettingsTabsContainer.ScrollBarThickness = 0
    SettingsTabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    SettingsTabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SettingsTabsContainer.Parent = SettingsSidebar
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 4)
    TabsLayout.Parent = SettingsTabsContainer
    
    --ResetBtn
    local ResetBtn = Instance.new("TextButton")
    ResetBtn.Name = "ResetSettings"
    ResetBtn.BackgroundColor3 = Color3.fromRGB(36, 24, 24)
    ResetBtn.Size = UDim2.new(1, -20, 0, 30)
    ResetBtn.Position = UDim2.new(0, 10, 1, -40)
    ResetBtn.Text = ""
    ResetBtn.AutoButtonColor = false
    ResetBtn.Parent = SettingsSidebar
    
    local ResetCorner = Instance.new("UICorner")
    ResetCorner.CornerRadius = UDim.new(0, 4)
    ResetCorner.Parent = ResetBtn
    
    local ResetStroke = Instance.new("UIStroke")
    ResetStroke.Color = Color3.fromRGB(180, 50, 50)
    ResetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ResetStroke.Parent = ResetBtn
    
    local ResetDivider = Instance.new("Frame")
    ResetDivider.Name = "ResetDivider"
    ResetDivider.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    ResetDivider.BorderSizePixel = 0
    ResetDivider.Size = UDim2.new(1, 0, 0, 1)
    ResetDivider.Position = UDim2.new(0, 0, 1, -50)
    ResetDivider.Parent = SettingsSidebar
    
    local ResetLayout = Instance.new("UIListLayout")
    ResetLayout.FillDirection = Enum.FillDirection.Horizontal
    ResetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ResetLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ResetLayout.Padding = UDim.new(0, 6)
    ResetLayout.Parent = ResetBtn
    
    local ResetIcon = Instance.new("ImageLabel")
    ResetIcon.BackgroundTransparency = 1
    ResetIcon.Size = UDim2.new(0, 14, 0, 14)
    ResetIcon.Image = "rbxassetid://140708438269602"
    ResetIcon.ImageColor3 = Color3.fromRGB(240, 120, 120)
    ResetIcon.Parent = ResetBtn
    
    local ResetTextLabel = Instance.new("TextLabel")
    ResetTextLabel.BackgroundTransparency = 1
    ResetTextLabel.Size = UDim2.new(0, 0, 1, 0)
    ResetTextLabel.AutomaticSize = Enum.AutomaticSize.X
    ResetTextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ResetTextLabel.Text = "Reset Settings"
    ResetTextLabel.TextColor3 = Color3.fromRGB(240, 120, 120)
    ResetTextLabel.TextSize = 13
    ResetTextLabel.Parent = ResetBtn
    
    Maid:GiveTask(ResetBtn.MouseEnter:Connect(function()
        Tween(ResetBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(48, 28, 28)})
    end))
    Maid:GiveTask(ResetBtn.MouseLeave:Connect(function()
        Tween(ResetBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(36, 24, 24)})
    end))
    
    local SidebarSeparator = Instance.new("Frame")
    SidebarSeparator.Name = "SidebarSeparator"
    SidebarSeparator.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    SidebarSeparator.BorderSizePixel = 0
    SidebarSeparator.Size = UDim2.new(0, 1, 1, 0)
    SidebarSeparator.LayoutOrder = 1
    SidebarSeparator.Parent = ContentFrame
    
    local MainSettingsContent = Instance.new("Frame")
    MainSettingsContent.Name = "MainContent"
    MainSettingsContent.BackgroundTransparency = 1
    MainSettingsContent.Size = UDim2.new(1, -207, 1, 0)
    MainSettingsContent.LayoutOrder = 2
    MainSettingsContent.Parent = ContentFrame
    
    local SettingsWindowObject = {
        Maid = Maid,
        Sidebar = { TabsContainer = SettingsTabsContainer },
        ContentContainer = MainSettingsContent,
        PageLayout = Instance.new("UIPageLayout", MainSettingsContent)
    }
    SettingsWindowObject.PageLayout.TweenTime = 0.3
    SettingsWindowObject.PageLayout.EasingStyle = Enum.EasingStyle.Quint
    SettingsWindowObject.PageLayout.EasingDirection = Enum.EasingDirection.Out
    SettingsWindowObject.PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsWindowObject.PageLayout.ScrollWheelInputEnabled = false
    SettingsWindowObject.PageLayout.TouchInputEnabled = false
    SettingsWindowObject.PageLayout.GamepadInputEnabled = false

    --CreateTab
    local ActiveTab = nil
    local TabContentRefs = {}
    local function CreateSettingsTab(name, icon, indent)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.BackgroundColor3 = Color3.new(1, 1, 1)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -20 - (indent or 0), 0, 30)
        TabBtn.Position = UDim2.new(0, 10 + (indent or 0), 0, 0)
        TabBtn.Text = ""
        TabBtn.Parent = SettingsTabsContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn
        
        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Color3.new(1, 1, 1)
        TabStroke.Transparency = 1
        TabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        TabStroke.Parent = TabBtn
        
        local TabTitle = Instance.new("TextLabel")
        TabTitle.BackgroundTransparency = 1
        TabTitle.Size = UDim2.new(1, -20, 1, 0)
        TabTitle.Position = UDim2.new(0, icon and 32 or 14, 0, 0)
        TabTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        TabTitle.Text = name
        TabTitle.TextColor3 = Color3.new(0.6, 0.6, 0.6)
        TabTitle.TextSize = 13
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.Parent = TabBtn
        
        if icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.BackgroundTransparency = 1
            TabIcon.Size = UDim2.new(0, 14, 0, 14)
            TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            TabIcon.Position = UDim2.new(0, 16, 0.5, 0)
            TabIcon.Image = icon
            TabIcon.ImageColor3 = Color3.new(0.6, 0.6, 0.6)
            TabIcon.Parent = TabBtn
        end
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Color3.new(0.2, 0.2, 0.2)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = MainSettingsContent
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 14)
        ContentLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 4)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        table.insert(TabContentRefs, {Btn = TabBtn, Title = TabTitle, Content = TabContent, Stroke = TabStroke})
        
        local function SelectTab()
            if ActiveTab == TabBtn then return end
            ActiveTab = TabBtn
            
            for _, ref in ipairs(TabContentRefs) do
                Tween(ref.Stroke, TweenInfo.new(0.2), {Transparency = 1})
                Tween(ref.Title, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.6, 0.6, 0.6)})
            end
            
            Tween(TabStroke, TweenInfo.new(0.2), {Transparency = 0.9})
            Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)})
            SettingsWindowObject.PageLayout:JumpTo(TabContent)
        end
        Maid:GiveTask(TabBtn.MouseButton1Click:Connect(SelectTab))
        
        local TabMethods = {}
        function TabMethods:AddSection(...)
            local Sections = require(script.Parent.Sections)
            return Sections.CreateSection(TabContent, Maid, ...)
        end
        function TabMethods:Select()
            SelectTab()
        end
        
        return TabMethods, TabBtn
    end

    --Tabs
    local AppearanceTab, AppearanceBtn = CreateSettingsTab("Appearance", "rbxassetid://113398745327842")

    --Select
    AppearanceTab:Select()
    
    --Theme
    local ThemeSection = AppearanceTab:AddSection("Theme", "Choose, manage, and customize the full UI.")
    
    --FetchThemes
    local themesList = {"My Volt Dark", "Volt Light", "Midnight Blue"}
    if listfiles then
        pcall(function()
            local files = listfiles("VoltHub/Themes")
            if files and #files > 0 then
                themesList = {}
                for _, file in ipairs(files) do
                    local fileName = file:match("([^/\\]+)%.json$") or file:match("([^/\\]+)$")
                    table.insert(themesList, fileName)
                end
            end
        end)
    end

    local ThemeDropdown = ThemeSection:CreateDropdown({
        Name = "Active Theme",
        Description = "Choose the active theme.",
        Options = themesList,
        CurrentValue = SettingsManager.GetSetting("ActiveTheme") or themesList[1] or "My Volt Dark",
        Callback = function(Option)
            SettingsManager.SaveSettings({ ActiveTheme = Option })
        end
    })
    
    local ActionRow = Instance.new("Frame")
    ActionRow.Name = "ActionRow"
    ActionRow.BackgroundTransparency = 1
    ActionRow.Size = UDim2.new(1, 0, 0, 48)
    ActionRow.Parent = ThemeSection.Instance
    
    local ActionLayout = Instance.new("UIListLayout")
    ActionLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionLayout.Padding = UDim.new(0, 16)
    ActionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ActionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionLayout.Parent = ActionRow
    
    local ActionPadding = Instance.new("UIPadding")
    ActionPadding.PaddingLeft = UDim.new(0, 14)
    ActionPadding.PaddingTop = UDim.new(0, 10)
    ActionPadding.PaddingBottom = UDim.new(0, 10)
    ActionPadding.Parent = ActionRow
    
    local function CreateActionButton(name, icon, isRed)
        local Btn = Instance.new("TextButton")
        Btn.BackgroundTransparency = 1
        Btn.Size = UDim2.new(0, 0, 0, 26)
        Btn.AutomaticSize = Enum.AutomaticSize.X
        Btn.Text = ""
        Btn.AutoButtonColor = false
        Btn.Parent = ActionRow
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Btn
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = isRed and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(48, 48, 48)
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Parent = Btn
        
        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.Padding = UDim.new(0, 6)
        Layout.Parent = Btn
        
        local BtnPadding = Instance.new("UIPadding")
        BtnPadding.PaddingLeft = UDim.new(0, 12)
        BtnPadding.PaddingRight = UDim.new(0, 12)
        BtnPadding.Parent = Btn
        
        local IconLabel = Instance.new("ImageLabel")
        IconLabel.BackgroundTransparency = 1
        IconLabel.Size = UDim2.new(0, 12, 0, 12)
        IconLabel.Image = icon
        IconLabel.ImageColor3 = isRed and Color3.fromRGB(240, 100, 100) or Color3.fromRGB(180, 180, 190)
        IconLabel.Parent = Btn
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(0, 0, 1, 0)
        TextLabel.AutomaticSize = Enum.AutomaticSize.X
        TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        TextLabel.Text = name
        TextLabel.TextColor3 = isRed and Color3.fromRGB(240, 100, 100) or Color3.fromRGB(180, 180, 190)
        TextLabel.TextSize = 12
        TextLabel.Parent = Btn
        
        local hoverColor = isRed and Color3.fromRGB(40, 20, 20) or Color3.fromRGB(36, 36, 36)
        Maid:GiveTask(Btn.MouseEnter:Connect(function()
            Tween(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0, BackgroundColor3 = hoverColor})
        end))
        Maid:GiveTask(Btn.MouseLeave:Connect(function()
            Tween(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1})
        end))
        
        return Btn
    end
    
    CreateActionButton("Export", "rbxassetid://72679188953780", false)
    CreateActionButton("Import", "rbxassetid://131957981720349", false)
    CreateActionButton("Delete", "rbxassetid://93603266402801", true)
    
    local ThemeDetailsSection = AppearanceTab:AddSection("Theme Details", "Choose the light/dark base.")
    
    --ModeToggle
    local ModeRow = Instance.new("Frame")
    ModeRow.Name = "ModeRow"
    ModeRow.BackgroundTransparency = 1
    ModeRow.Size = UDim2.new(1, 0, 0, 56)
    ModeRow.Parent = ThemeDetailsSection.Instance
    
    local ModePadding = Instance.new("UIPadding")
    ModePadding.PaddingLeft = UDim.new(0, 14)
    ModePadding.PaddingRight = UDim.new(0, 14)
    ModePadding.PaddingBottom = UDim.new(0, 12)
    ModePadding.Parent = ModeRow
    
    local ModeTitle = Instance.new("TextLabel")
    ModeTitle.BackgroundTransparency = 1
    ModeTitle.Size = UDim2.new(1, 0, 0, 20)
    ModeTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ModeTitle.Text = "Mode"
    ModeTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    ModeTitle.TextSize = 13
    ModeTitle.TextXAlignment = Enum.TextXAlignment.Left
    ModeTitle.Parent = ModeRow
    
    local ModeContainer = Instance.new("Frame")
    ModeContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ModeContainer.Size = UDim2.new(1, 0, 0, 24)
    ModeContainer.Position = UDim2.new(0, 0, 0, 24)
    ModeContainer.Parent = ModeRow
    
    local ModeCorner = Instance.new("UICorner")
    ModeCorner.CornerRadius = UDim.new(0, 6)
    ModeCorner.Parent = ModeContainer
    
    local ModeStroke = Instance.new("UIStroke")
    ModeStroke.Color = Color3.fromRGB(48, 48, 48)
    ModeStroke.Parent = ModeContainer
    
    local DarkBtn = Instance.new("TextButton")
    DarkBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    DarkBtn.Size = UDim2.new(0.5, 0, 1, 0)
    DarkBtn.Text = "Dark"
    DarkBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    DarkBtn.TextSize = 12
    DarkBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    DarkBtn.Parent = ModeContainer
    
    local DarkCorner = Instance.new("UICorner")
    DarkCorner.CornerRadius = UDim.new(0, 6)
    DarkCorner.Parent = DarkBtn
    
    local LightBtn = Instance.new("TextButton")
    LightBtn.BackgroundTransparency = 1
    LightBtn.Position = UDim2.new(0.5, 0, 0, 0)
    LightBtn.Size = UDim2.new(0.5, 0, 1, 0)
    LightBtn.Text = "Light"
    LightBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    LightBtn.TextSize = 12
    LightBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    LightBtn.Parent = ModeContainer
    
    local LightCorner = Instance.new("UICorner")
    LightCorner.CornerRadius = UDim.new(0, 6)
    LightCorner.Parent = LightBtn
    
    --Logic
    local currentMode = SettingsManager.GetSetting("Mode") or "Dark"
    
    if currentMode == "Light" then
        LightBtn.BackgroundTransparency = 0
        LightBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
        DarkBtn.BackgroundTransparency = 1
        DarkBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    end
    
    Maid:GiveTask(DarkBtn.MouseButton1Click:Connect(function()
        if currentMode == "Dark" then return end
        currentMode = "Dark"
        SettingsManager.SaveSettings({ Mode = "Dark" })
        Tween(DarkBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(240, 240, 245)})
        Tween(LightBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 160)})
    end))
    Maid:GiveTask(LightBtn.MouseButton1Click:Connect(function()
        if currentMode == "Light" then return end
        currentMode = "Light"
        SettingsManager.SaveSettings({ Mode = "Light" })
        Tween(LightBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(240, 240, 245)})
        Tween(DarkBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 160)})
    end))

    return {
        Instance = Page
    }
end

return SettingsPage
