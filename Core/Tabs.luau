local Utils = script.Parent.Parent.Utils
local Components = script.Parent.Parent.Components
local Core = script.Parent
local Tween = require(Utils.Tween)
local Sections = require(Core.Sections)
local ThemeManager = require(Core.Theme)

local Tabs = {}
Tabs.ActiveTab = nil
Tabs.Instances = {}

function Tabs.CreateTab(WindowObject, Name, IconAsset)
    local SidebarContainer = WindowObject.Sidebar.TabsContainer
    local ContentContainer = WindowObject.ContentContainer
    local Maid = WindowObject.Maid
    
    local isFirstTab = (#Tabs.Instances == 0)
    
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = Name
    TabBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, -6, 0, 34)
    TabBtn.Position = UDim2.new(0, 6, 0, 0)
    TabBtn.Text = ""
    TabBtn.ClipsDescendants = true
    TabBtn.Parent = SidebarContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    local iconStr = ""
    if IconAsset then
        if type(IconAsset) == "number" then
            iconStr = "rbxassetid://" .. tostring(IconAsset)
        elseif type(IconAsset) == "string" and IconAsset ~= "" then
            if string.find(IconAsset, "://") then
                iconStr = IconAsset
            else
                iconStr = "rbxassetid://" .. IconAsset
            end
        end
    end

    local hasIcon = (iconStr ~= "")
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.BackgroundTransparency = 1
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    TabIcon.Position = UDim2.new(0, 20, 0.5, 0)
    TabIcon.Image = iconStr
    ThemeManager:Register(TabIcon, "ImageColor3", "TextSecondary")
    TabIcon.Visible = hasIcon
    TabIcon.Parent = TabBtn
    
    local TabTitle = Instance.new("TextLabel")
    TabTitle.BackgroundTransparency = 1
    TabTitle.Size = hasIcon and UDim2.new(1, -45, 1, 0) or UDim2.new(1, -20, 1, 0)
    TabTitle.Position = hasIcon and UDim2.new(0, 38, 0, 0) or UDim2.new(0, 14, 0, 0)
    TabTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TabTitle.Text = Name
    ThemeManager:Register(TabTitle, "TextColor3", "TextSecondary")
    TabTitle.TextSize = 13
    TabTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabTitle.Parent = TabBtn
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = Name .. "Content"
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.ScrollBarThickness = 0
    ThemeManager:Register(TabContent, "ScrollBarImageColor3", "StrokeColor")
    TabContent.Visible = isFirstTab
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.None
    TabContent.ScrollingEnabled = false
    TabContent.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    TabContent.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 4)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.Parent = TabContent

    local function UpdateContentScroll()
        local contentHeight = ContentLayout.AbsoluteContentSize.Y + ContentPadding.PaddingTop.Offset + ContentPadding.PaddingBottom.Offset + 10
        local frameHeight = TabContent.AbsoluteSize.Y
        if frameHeight > 0 and contentHeight > frameHeight then
            TabContent.ScrollingEnabled = true
            TabContent.ScrollBarThickness = 2
            TabContent.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        else
            TabContent.ScrollingEnabled = false
            TabContent.ScrollBarThickness = 0
            TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            TabContent.CanvasPosition = Vector2.new(0, 0)
        end
    end

    Maid:GiveTask(ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateContentScroll))
    Maid:GiveTask(TabContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateContentScroll))
    Maid:GiveTask(TabContent.ChildAdded:Connect(function(child)
        if child:IsA("GuiObject") then
            Maid:GiveTask(child:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateContentScroll))
        end
        task.defer(UpdateContentScroll)
    end))
    Maid:GiveTask(TabContent.ChildRemoved:Connect(function()
        task.defer(UpdateContentScroll)
    end))
    task.defer(UpdateContentScroll)
    
    local TabObj = {
        Button = TabBtn,
        Content = TabContent
    }
    
    table.insert(Tabs.Instances, TabObj)
    
    local function ActivateTab()
        if WindowObject.PageLayout and WindowObject.Content then
            WindowObject.PageLayout:JumpTo(WindowObject.Content)
            if WindowObject.Bottombar and WindowObject.Bottombar.Instance then
                WindowObject.Bottombar.Instance.Visible = true
            end
            if WindowObject.PagesContainer then
                Tween(WindowObject.PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -50)})
            end
        end

        if Tabs.ActiveTab == TabObj then return end
        
        for _, otherTab in ipairs(Tabs.Instances) do
            otherTab.Content.Visible = false
            Tween(otherTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(otherTab.Button:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.2), {TextColor3 = ThemeManager:GetColor("TextSecondary")})
            Tween(otherTab.Button:FindFirstChildOfClass("ImageLabel"), TweenInfo.new(0.2), {ImageColor3 = ThemeManager:GetColor("TextSecondary")})
        end
        
        Tabs.ActiveTab = TabObj
        TabContent.Visible = true
        task.defer(UpdateContentScroll)
        
        Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95})
        Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = ThemeManager:GetColor("TextPrimary")})
        Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = ThemeManager:GetColor("TextPrimary")})
        
        if WindowObject.Bottombar and WindowObject.Bottombar.TabdisplayName then
            WindowObject.Bottombar.TabdisplayName.Text = Name
        end
    end
    
    Maid:GiveTask(TabBtn.MouseButton1Click:Connect(ActivateTab))
    
    Maid:GiveTask(TabBtn.MouseEnter:Connect(function()
        if Tabs.ActiveTab ~= TabObj then
            Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.98})
            Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = ThemeManager:GetColor("TextPrimary")})
        end
    end))
    Maid:GiveTask(TabBtn.MouseLeave:Connect(function()
        if Tabs.ActiveTab ~= TabObj then
            Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = ThemeManager:GetColor("TextSecondary")})
        end
    end))
    
    if WindowObject.OnCollapse then
        Maid:GiveTask(WindowObject.OnCollapse:Connect(function(isCollapsed)
            local SidebarTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if isCollapsed then
                Tween(TabBtn, SidebarTweenInfo, {Size = UDim2.new(0, 34, 0, 34)})
                Tween(TabIcon, SidebarTweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
                TabTitle.Visible = false
            else
                Tween(TabBtn, SidebarTweenInfo, {Size = UDim2.new(1, -20, 0, 34)})
                Tween(TabIcon, SidebarTweenInfo, {Position = UDim2.new(0, 20, 0.5, 0)})
                TabTitle.Visible = true
            end
        end))
    end
    
    if isFirstTab then
        ActivateTab()
    end
    
    local TabMethods = {}
    
    function TabMethods:CreateSection(TitleOrConfig, Description)
        local title = TitleOrConfig
        local desc = Description
        if type(TitleOrConfig) == "table" then
            title = TitleOrConfig.Title or TitleOrConfig.Name or TitleOrConfig.Header
            desc = TitleOrConfig.Description or Description
        end
        return Sections.CreateSection(TabContent, Maid, title, desc)
    end
    TabMethods.CreateGroupbox = TabMethods.CreateSection
    TabMethods.AddSection = TabMethods.CreateSection
    TabMethods.AddGroupbox = TabMethods.CreateSection

    local defaultSection = nil
    local function getDefaultSection()
        if not defaultSection then
            defaultSection = Sections.CreateSection(TabContent, Maid, "", "")
        end
        return defaultSection
    end

    function TabMethods:CreateButton(...) return getDefaultSection():CreateButton(...) end
    function TabMethods:CreateToggle(...) return getDefaultSection():CreateToggle(...) end
    function TabMethods:CreateCheckbox(...) return getDefaultSection():CreateCheckbox(...) end
    function TabMethods:CreateSlider(...) return getDefaultSection():CreateSlider(...) end
    function TabMethods:CreateInput(...) return getDefaultSection():CreateInput(...) end
    TabMethods.CreateTextBox = TabMethods.CreateInput
    function TabMethods:CreateDropdown(...) return getDefaultSection():CreateDropdown(...) end
    function TabMethods:CreateColorPicker(...) return getDefaultSection():CreateColorPicker(...) end
    function TabMethods:CreateKeybind(...) return getDefaultSection():CreateKeybind(...) end
    TabMethods.CreateBind = TabMethods.CreateKeybind
    function TabMethods:CreateLabel(...) return getDefaultSection():CreateLabel(...) end
    function TabMethods:CreateParagraph(...) return getDefaultSection():CreateParagraph(...) end
    function TabMethods:CreateDivider(...) return getDefaultSection():CreateDivider(...) end

    TabMethods.AddButton = TabMethods.CreateButton
    TabMethods.AddToggle = TabMethods.CreateToggle
    TabMethods.AddCheckbox = TabMethods.CreateCheckbox
    TabMethods.AddSlider = TabMethods.CreateSlider
    TabMethods.AddInput = TabMethods.CreateInput
    TabMethods.AddTextBox = TabMethods.CreateInput
    TabMethods.AddDropdown = TabMethods.CreateDropdown
    TabMethods.AddColorPicker = TabMethods.CreateColorPicker
    TabMethods.AddKeybind = TabMethods.CreateKeybind
    TabMethods.AddBind = TabMethods.CreateKeybind
    TabMethods.AddLabel = TabMethods.CreateLabel
    TabMethods.AddParagraph = TabMethods.CreateParagraph
    TabMethods.AddDivider = TabMethods.CreateDivider
    
    return TabMethods
end

return Tabs
