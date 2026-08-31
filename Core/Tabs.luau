local Utils = script.Parent.Parent.Utils
local Components = script.Parent.Parent.Components
local Tween = require(Utils.Tween)
local ButtonComponent = require(Components.Button)

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
    TabBtn.Size = UDim2.new(1, -20, 0, 40)
    TabBtn.Position = UDim2.new(0, 10, 0, 0)
    TabBtn.Text = ""
    TabBtn.ClipsDescendants = true
    TabBtn.Parent = SidebarContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.BackgroundTransparency = 1
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    TabIcon.Position = UDim2.new(0, 20, 0.5, 0)
    TabIcon.Image = IconAsset or ""
    TabIcon.ImageColor3 = Color3.new(0.6, 0.6, 0.6)
    TabIcon.Parent = TabBtn
    
    local TabTitle = Instance.new("TextLabel")
    TabTitle.BackgroundTransparency = 1
    TabTitle.Size = UDim2.new(1, -45, 1, 0)
    TabTitle.Position = UDim2.new(0, 38, 0, 0)
    TabTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TabTitle.Text = Name
    TabTitle.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    TabTitle.TextSize = 13
    TabTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabTitle.Parent = TabBtn
    
    -- 2. Create Content ScrollingFrame
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = Name .. "Content"
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.ScrollBarThickness = 2
    TabContent.ScrollBarImageColor3 = Color3.new(0.2, 0.2, 0.2)
    TabContent.Visible = isFirstTab
    TabContent.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.Parent = TabContent
    
    local TabObj = {
        Button = TabBtn,
        Content = TabContent
    }
    
    table.insert(Tabs.Instances, TabObj)
    
    -- 3. Activation Logic
    local function ActivateTab()
        if Tabs.ActiveTab == TabObj then return end
        
        -- Deactivate all
        for _, otherTab in ipairs(Tabs.Instances) do
            otherTab.Content.Visible = false
            Tween(otherTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(otherTab.Button:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.2), {TextColor3 = Color3.new(0.6, 0.6, 0.6)})
            Tween(otherTab.Button:FindFirstChildOfClass("ImageLabel"), TweenInfo.new(0.2), {ImageColor3 = Color3.new(0.6, 0.6, 0.6)})
        end
        
        -- Activate this
        Tabs.ActiveTab = TabObj
        TabContent.Visible = true
        
        Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}) -- Slight highlight
        Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)})
        Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1, 1, 1)})
        
        if WindowObject.Bottombar and WindowObject.Bottombar.TabdisplayName then
            WindowObject.Bottombar.TabdisplayName.Text = Name
        end
    end
    
    Maid:GiveTask(TabBtn.MouseButton1Click:Connect(ActivateTab))
    
    -- Hover Effects
    Maid:GiveTask(TabBtn.MouseEnter:Connect(function()
        if Tabs.ActiveTab ~= TabObj then
            Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.98})
            Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.8, 0.8, 0.8)})
        end
    end))
    Maid:GiveTask(TabBtn.MouseLeave:Connect(function()
        if Tabs.ActiveTab ~= TabObj then
            Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.6, 0.6, 0.6)})
        end
    end))
    
    if WindowObject.OnCollapse then
        Maid:GiveTask(WindowObject.OnCollapse:Connect(function(isCollapsed)
            local SidebarTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if isCollapsed then
                Tween(TabBtn, SidebarTweenInfo, {Size = UDim2.new(0, 40, 0, 40)})
                Tween(TabIcon, SidebarTweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
                TabTitle.Visible = false
            else
                Tween(TabBtn, SidebarTweenInfo, {Size = UDim2.new(1, -20, 0, 40)})
                Tween(TabIcon, SidebarTweenInfo, {Position = UDim2.new(0, 20, 0.5, 0)})
                TabTitle.Visible = true
            end
        end))
    end
    
    if isFirstTab then
        ActivateTab()
    end
    
    -- 4. Expose Component Methods
    local TabMethods = {}
    
    function TabMethods:CreateButton(Config)
        return ButtonComponent.Create(TabContent, Maid, Config)
    end
    
    return TabMethods
end

return Tabs
