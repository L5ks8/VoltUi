local Tween = require(script.Parent.Parent.Utils.Tween)
local Tabs = require(script.Parent.Tabs)
local SettingsManager = require(script.Parent.Parent.Utils.SettingsManager)

local SettingsPage = {}

function SettingsPage.Create(Content, Maid, BackCallback, WindowConfig)
    local Page = Instance.new("Frame")
    Page.Name = "SettingsPage"
    Page.AnchorPoint = Vector2.new(0, 0)
    Page.BackgroundColor3 = Color3.new(0.067, 0.067, 0.067)
    Page.BorderColor3 = Color3.new(0, 0, 0)
    Page.BorderSizePixel = 0
    Page.Position = UDim2.new(0, 0, 0, 0)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
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

    -- Topbar for Settings
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

    -- Main Content Area of Settings Page
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
    
    -- Sidebar for Settings
    local SettingsSidebar = Instance.new("Frame")
    SettingsSidebar.Name = "Sidebar"
    SettingsSidebar.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    SettingsSidebar.BorderColor3 = Color3.new(0, 0, 0)
    SettingsSidebar.BorderSizePixel = 0
    SettingsSidebar.Size = UDim2.new(0, 0, 1, 0)
    SettingsSidebar.Visible = false
    SettingsSidebar.LayoutOrder = 0
    SettingsSidebar.Parent = ContentFrame
    
    -- Search bar in sidebar
    local SearchContainer = Instance.new("Frame")
    SearchContainer.Name = "SearchContainer"
    SearchContainer.BackgroundTransparency = 1
    SearchContainer.Size = UDim2.new(1, 0, 0, 45)
    SearchContainer.Parent = SettingsSidebar
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    SearchBox.Size = UDim2.new(1, -20, 0, 26)
    SearchBox.Position = UDim2.new(0, 10, 0, 10)
    SearchBox.PlaceholderText = "Search settings"
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(210, 210, 215)
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
    SearchBox.TextSize = 12
    SearchBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = SearchContainer
    
    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 28)
    SearchPadding.Parent = SearchBox
    
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://134267746401089" -- Search icon
    SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 160)
    SearchIcon.Size = UDim2.new(0, 14, 0, 14)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
    SearchIcon.Parent = SearchBox
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 4)
    SearchCorner.Parent = SearchBox
    
    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Color3.fromRGB(48, 48, 48)
    SearchStroke.Parent = SearchBox
    
    -- Tabs Container in sidebar
    local SettingsTabsContainer = Instance.new("ScrollingFrame")
    SettingsTabsContainer.Name = "TabsContainer"
    SettingsTabsContainer.BackgroundTransparency = 1
    SettingsTabsContainer.BorderSizePixel = 0
    SettingsTabsContainer.Size = UDim2.new(1, 0, 1, -95) -- 45 (Search) + 50 (Reset button)
    SettingsTabsContainer.Position = UDim2.new(0, 0, 0, 45)
    SettingsTabsContainer.ScrollBarThickness = 0
    SettingsTabsContainer.Parent = SettingsSidebar
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 4)
    TabsLayout.Parent = SettingsTabsContainer
    
    -- Reset Settings Button
    local ResetBtn = Instance.new("TextButton")
    ResetBtn.Name = "ResetSettings"
    ResetBtn.BackgroundColor3 = Color3.fromRGB(36, 24, 24)
    ResetBtn.Size = UDim2.new(1, -20, 0, 30)
    ResetBtn.Position = UDim2.new(0, 10, 1, -40)
    ResetBtn.Text = "Reset Settings"
    ResetBtn.TextColor3 = Color3.fromRGB(240, 120, 120)
    ResetBtn.TextSize = 13
    ResetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ResetBtn.Parent = SettingsSidebar
    
    local ResetCorner = Instance.new("UICorner")
    ResetCorner.CornerRadius = UDim.new(0, 4)
    ResetCorner.Parent = ResetBtn
    
    local ResetStroke = Instance.new("UIStroke")
    ResetStroke.Color = Color3.fromRGB(80, 30, 30)
    ResetStroke.Parent = ResetBtn
    
    local SidebarSeparator = Instance.new("Frame")
    SidebarSeparator.Name = "SidebarSeparator"
    SidebarSeparator.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    SidebarSeparator.BorderSizePixel = 0
    SidebarSeparator.Size = UDim2.new(0, 1, 1, 0)
    SidebarSeparator.Visible = false
    SidebarSeparator.LayoutOrder = 1
    SidebarSeparator.Parent = ContentFrame
    
    local MainSettingsContent = Instance.new("Frame")
    MainSettingsContent.Name = "MainContent"
    MainSettingsContent.BackgroundTransparency = 1
    MainSettingsContent.Size = UDim2.new(1, 0, 1, 0)
    MainSettingsContent.ClipsDescendants = true
    MainSettingsContent.LayoutOrder = 2
    MainSettingsContent.Parent = ContentFrame
    
    local SettingsWindowObject = {
        Maid = Maid,
        Sidebar = { TabsContainer = SettingsTabsContainer },
        ContentContainer = MainSettingsContent
    }

    -- Custom CreateTab function for settings
    local ActiveTab = nil
    local TabContentRefs = {}
    local tabTransitionToken = 0

    local function CreateSettingsTab(name, icon, indent)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.BackgroundColor3 = Color3.new(1, 1, 1)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, -6 - (indent or 0), 0, 30)
        TabBtn.Position = UDim2.new(0, 6 + (indent or 0), 0, 0)
        TabBtn.Text = ""
        TabBtn.Parent = SettingsTabsContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn
        
        local TabTitle = Instance.new("TextLabel")
        TabTitle.BackgroundTransparency = 1
        TabTitle.Size = UDim2.new(1, -20, 1, 0)
        TabTitle.Position = UDim2.new(0, icon and 32 or 14, 0, 0)
        TabTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
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
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Color3.new(0.2, 0.2, 0.2)
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
        
        table.insert(TabContentRefs, {Btn = TabBtn, Title = TabTitle, Content = TabContent})
        
        local function SelectTab()
            if ActiveTab == TabBtn then return end
            local prevTab = ActiveTab
            ActiveTab = TabBtn
            tabTransitionToken = tabTransitionToken + 1
            local currentToken = tabTransitionToken
            
            for _, ref in ipairs(TabContentRefs) do
                if ref.Btn == TabBtn then
                    Tween(ref.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95})
                    Tween(ref.Title, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)})
                else
                    Tween(ref.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                    Tween(ref.Title, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.6, 0.6, 0.6)})
                end
            end

            -- Outgoing tab animation
            if prevTab then
                for _, ref in ipairs(TabContentRefs) do
                    if ref.Btn == prevTab then
                        local oldContent = ref.Content
                        local oldScale = oldContent:FindFirstChildOfClass("UIScale")
                        if not oldScale then
                            oldScale = Instance.new("UIScale")
                            oldScale.Parent = oldContent
                        end
                        Tween(oldContent, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Position = UDim2.new(0, 0, 0, -8)
                        })
                        Tween(oldScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Scale = 0.985
                        })
                        task.delay(0.14, function()
                            if tabTransitionToken == currentToken or ActiveTab ~= prevTab then
                                oldContent.Visible = false
                                oldContent.Position = UDim2.new(0, 0, 0, 0)
                                oldScale.Scale = 1
                            end
                        end)
                        break
                    end
                end
            end

            -- Incoming tab animation
            local scale = TabContent:FindFirstChildOfClass("UIScale")
            if not scale then
                scale = Instance.new("UIScale")
                scale.Parent = TabContent
            end

            if prevTab then
                TabContent.Position = UDim2.new(0, 0, 0, 14)
                scale.Scale = 0.97
                TabContent.Visible = true
                Tween(TabContent, TweenInfo.new(0.28, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                })
                Tween(scale, TweenInfo.new(0.28, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                    Scale = 1
                })
            else
                TabContent.Position = UDim2.new(0, 0, 0, 0)
                scale.Scale = 1
                TabContent.Visible = true
            end
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

    -- Create Tabs
    CreateSettingsTab("Editor", "rbxassetid://134267746401089") -- Replace with correct icon
    local AppearanceTab, AppearanceBtn = CreateSettingsTab("Appearance", "rbxassetid://1234567890") -- Replace with correct icon
    CreateSettingsTab("Client", "rbxassetid://1234567890")
    
    -- Sub-tabs for Client
    CreateSettingsTab("General", nil, 14)
    CreateSettingsTab("Multi-Instance", nil, 14)
    CreateSettingsTab("Decompiler", nil, 14)
    CreateSettingsTab("Save Instance", nil, 14)
    
    CreateSettingsTab("Workbench", "rbxassetid://1234567890")

    -- Activate Appearance tab by default for now
    AppearanceTab:Select()
    


    return {
        Instance = Page
    }
end

return SettingsPage

