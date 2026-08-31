local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)

local AccountPage = {}

function AccountPage.Create(Content, maid, BackCallback)
    local Page = Instance.new("Frame")
    Page.Name = "AccountPage"
    Page.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
    Page.BackgroundTransparency = 1
    Page.BorderColor3 = Color3.new(0, 0, 0)
    Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.ZIndex = 20
    Page.Parent = Content
    
    -- [ HEADER ]
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.Parent = Page
    
    local HeaderLayout = Instance.new("UIListLayout")
    HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    HeaderLayout.Padding = UDim.new(0, 10)
    HeaderLayout.Parent = Header
    
    local HeaderPadding = Instance.new("UIPadding")
    HeaderPadding.PaddingLeft = UDim.new(0, 15)
    HeaderPadding.Parent = Header
    
    local BackBtn = Instance.new("ImageButton")
    BackBtn.Name = "BackButton"
    BackBtn.BackgroundTransparency = 1
    BackBtn.Size = UDim2.new(0, 20, 0, 20)
    BackBtn.Image = "rbxassetid://93526157530558" -- Left Arrow Icon
    BackBtn.ImageColor3 = Color3.new(1, 1, 1)
    BackBtn.ImageTransparency = 0.4
    BackBtn.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(0, 100, 1, 0)
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Title.Text = "Account"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    maid:GiveTask(BackBtn.MouseEnter:Connect(function()
        Tween(BackBtn, TweenInfo.new(0.2), {ImageTransparency = 0})
    end))
    maid:GiveTask(BackBtn.MouseLeave:Connect(function()
        Tween(BackBtn, TweenInfo.new(0.2), {ImageTransparency = 0.4})
    end))
    maid:GiveTask(BackBtn.MouseButton1Click:Connect(function()
        Page.Visible = false
        if BackCallback then BackCallback() end
    end))
    
    -- [ SCROLLING CONTENT ]
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = "ScrollContent"
    Scroll.Active = true
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.Position = UDim2.new(0, 0, 0, 40)
    Scroll.Size = UDim2.new(1, 0, 1, -40)
    Scroll.ScrollBarImageColor3 = Color3.new(0.137, 0.137, 0.137)
    Scroll.ScrollBarThickness = 4
    Scroll.Parent = Page
    
    local ScrollLayout = Instance.new("UIListLayout")
    ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ScrollLayout.Padding = UDim.new(0, 15)
    ScrollLayout.Parent = Scroll
    
    local ScrollPadding = Instance.new("UIPadding")
    ScrollPadding.PaddingLeft = UDim.new(0, 15)
    ScrollPadding.PaddingRight = UDim.new(0, 15)
    ScrollPadding.PaddingBottom = UDim.new(0, 15)
    ScrollPadding.Parent = Scroll
    
    -- [ PROFILE CARD ]
    local ProfileCard = Instance.new("Frame")
    ProfileCard.Name = "ProfileCard"
    ProfileCard.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    ProfileCard.Size = UDim2.new(1, 0, 0, 70)
    ProfileCard.Parent = Scroll
    
    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 6)
    ProfileCorner.Parent = ProfileCard
    
    local ProfileStroke = Instance.new("UIStroke")
    ProfileStroke.Color = Color3.new(0.15, 0.15, 0.15)
    ProfileStroke.Parent = ProfileCard
    
    local ProfilePadding = Instance.new("UIPadding")
    ProfilePadding.PaddingTop = UDim.new(0, 10)
    ProfilePadding.PaddingBottom = UDim.new(0, 10)
    ProfilePadding.PaddingLeft = UDim.new(0, 15)
    ProfilePadding.PaddingRight = UDim.new(0, 15)
    ProfilePadding.Parent = ProfileCard
    
    local ProfileLayout = Instance.new("UIListLayout")
    ProfileLayout.FillDirection = Enum.FillDirection.Horizontal
    ProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ProfileLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ProfileLayout.Padding = UDim.new(0, 15)
    ProfileLayout.Parent = ProfileCard
    
    local AvatarBox = Instance.new("Frame")
    AvatarBox.Name = "AvatarBox"
    AvatarBox.BackgroundColor3 = Color3.new(0.137, 0.137, 0.137)
    AvatarBox.Size = UDim2.new(0, 40, 0, 40)
    AvatarBox.Parent = ProfileCard
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 6)
    AvatarCorner.Parent = AvatarBox
    
    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.new(0.2, 0.2, 0.2)
    AvatarStroke.Parent = AvatarBox
    
    local AvatarText = Instance.new("TextLabel")
    AvatarText.BackgroundTransparency = 1
    AvatarText.Size = UDim2.new(1, 0, 1, 0)
    AvatarText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    AvatarText.Text = "L"
    AvatarText.TextColor3 = Color3.new(1, 1, 1)
    AvatarText.TextSize = 18
    AvatarText.Parent = AvatarBox
    
    local ProfileInfo = Instance.new("Frame")
    ProfileInfo.Name = "ProfileInfo"
    ProfileInfo.BackgroundTransparency = 1
    ProfileInfo.Size = UDim2.new(1, -55, 1, 0)
    ProfileInfo.Parent = ProfileCard
    
    local InfoLayout = Instance.new("UIListLayout")
    InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    InfoLayout.Padding = UDim.new(0, 5)
    InfoLayout.Parent = ProfileInfo
    
    local NameRow = Instance.new("Frame")
    NameRow.Name = "NameRow"
    NameRow.BackgroundTransparency = 1
    NameRow.Size = UDim2.new(1, 0, 0, 16)
    NameRow.Parent = ProfileInfo
    
    local NameRowLayout = Instance.new("UIListLayout")
    NameRowLayout.FillDirection = Enum.FillDirection.Horizontal
    NameRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NameRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    NameRowLayout.Padding = UDim.new(0, 8)
    NameRowLayout.Parent = NameRow
    
    local Username = Instance.new("TextLabel")
    Username.BackgroundTransparency = 1
    Username.AutomaticSize = Enum.AutomaticSize.X
    Username.Size = UDim2.new(0, 0, 1, 0)
    Username.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Username.Text = "L5ks8"
    Username.TextColor3 = Color3.new(1, 1, 1)
    Username.TextSize = 14
    Username.Parent = NameRow
    
    local UserIDBtn = Instance.new("TextButton")
    UserIDBtn.Name = "UserID"
    UserIDBtn.BackgroundTransparency = 1
    UserIDBtn.AutomaticSize = Enum.AutomaticSize.X
    UserIDBtn.Size = UDim2.new(0, 0, 1, 0)
    UserIDBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    UserIDBtn.Text = "•••••••••••"
    UserIDBtn.TextColor3 = Color3.new(0.4, 0.4, 0.4)
    UserIDBtn.TextSize = 12
    UserIDBtn.Parent = NameRow
    
    local isRevealed = false
    local actualID = "No ID Available" -- Default
    maid:GiveTask(UserIDBtn.MouseButton1Click:Connect(function()
        isRevealed = not isRevealed
        if isRevealed then
            Tween(UserIDBtn, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.8, 0.8, 0.8)})
            UserIDBtn.Text = actualID
        else
            Tween(UserIDBtn, TweenInfo.new(0.2), {TextColor3 = Color3.new(0.4, 0.4, 0.4)})
            UserIDBtn.Text = "•••••••••••"
        end
    end))
    
    local BadgeRow = Instance.new("Frame")
    BadgeRow.Name = "BadgeRow"
    BadgeRow.BackgroundTransparency = 1
    BadgeRow.Size = UDim2.new(1, 0, 0, 16)
    BadgeRow.Parent = ProfileInfo
    
    local BadgeRowLayout = Instance.new("UIListLayout")
    BadgeRowLayout.FillDirection = Enum.FillDirection.Horizontal
    BadgeRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BadgeRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BadgeRowLayout.Padding = UDim.new(0, 8)
    BadgeRowLayout.Parent = BadgeRow
    
    local RoleBadge = Instance.new("Frame")
    RoleBadge.BackgroundColor3 = Color3.new(1,1,1)
    RoleBadge.BackgroundTransparency = 1
    RoleBadge.AutomaticSize = Enum.AutomaticSize.X
    RoleBadge.Size = UDim2.new(0, 0, 0, 16)
    RoleBadge.Parent = BadgeRow
    
    local RoleBadgeCorner = Instance.new("UICorner")
    RoleBadgeCorner.CornerRadius = UDim.new(0, 4)
    RoleBadgeCorner.Parent = RoleBadge
    
    local RoleBadgeStroke = Instance.new("UIStroke")
    RoleBadgeStroke.Color = Color3.new(0.3, 0.3, 0.3)
    RoleBadgeStroke.Parent = RoleBadge
    
    local RoleText = Instance.new("TextLabel")
    RoleText.BackgroundTransparency = 1
    RoleText.AutomaticSize = Enum.AutomaticSize.X
    RoleText.Size = UDim2.new(0, 0, 1, 0)
    RoleText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    RoleText.Text = "User"
    RoleText.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    RoleText.TextSize = 10
    RoleText.Parent = RoleBadge
    
    local RolePadding = Instance.new("UIPadding")
    RolePadding.PaddingLeft = UDim.new(0, 6)
    RolePadding.PaddingRight = UDim.new(0, 6)
    RolePadding.Parent = RoleBadge
    
    local JoinDate = Instance.new("TextLabel")
    JoinDate.BackgroundTransparency = 1
    JoinDate.AutomaticSize = Enum.AutomaticSize.X
    JoinDate.Size = UDim2.new(0, 0, 1, 0)
    JoinDate.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    JoinDate.Text = "Member since Jul 24, 2026"
    JoinDate.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    JoinDate.TextSize = 11
    JoinDate.Parent = BadgeRow
    
    -- [ LICENSES ROW ]
    local LicensesRow = Instance.new("Frame")
    LicensesRow.Name = "LicensesRow"
    LicensesRow.BackgroundTransparency = 1
    LicensesRow.Size = UDim2.new(1, 0, 0, 35)
    LicensesRow.Parent = Scroll
    
    -- Left Side (Icon + Text)
    local LicIcon = Instance.new("ImageLabel")
    LicIcon.BackgroundTransparency = 1
    LicIcon.Size = UDim2.new(0, 16, 0, 16)
    LicIcon.Position = UDim2.new(0, 0, 0, 0)
    LicIcon.Image = "rbxassetid://79413295774210" -- Updated License Icon
    LicIcon.ImageColor3 = Color3.new(0.8, 0.8, 0.8)
    LicIcon.Parent = LicensesRow
    
    local LicTitle = Instance.new("TextLabel")
    LicTitle.BackgroundTransparency = 1
    LicTitle.Size = UDim2.new(0, 200, 0, 16)
    LicTitle.Position = UDim2.new(0, 25, 0, 0)
    LicTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LicTitle.Text = "Licenses"
    LicTitle.TextColor3 = Color3.new(1, 1, 1)
    LicTitle.TextSize = 12
    LicTitle.TextXAlignment = Enum.TextXAlignment.Left
    LicTitle.Parent = LicensesRow
    
    local LicDesc = Instance.new("TextLabel")
    LicDesc.BackgroundTransparency = 1
    LicDesc.Size = UDim2.new(0, 200, 0, 14)
    LicDesc.Position = UDim2.new(0, 25, 0, 16)
    LicDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    LicDesc.Text = "Subscription and claimed keys"
    LicDesc.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    LicDesc.TextSize = 11
    LicDesc.TextXAlignment = Enum.TextXAlignment.Left
    LicDesc.Parent = LicensesRow
    
    -- Right Side (Input + Button)
    local RightContainer = Instance.new("Frame")
    RightContainer.BackgroundTransparency = 1
    RightContainer.Size = UDim2.new(0, 250, 1, 0)
    RightContainer.AnchorPoint = Vector2.new(1, 0)
    RightContainer.Position = UDim2.new(1, 0, 0, 0)
    RightContainer.Parent = LicensesRow
    
    local RightLayout = Instance.new("UIListLayout")
    RightLayout.FillDirection = Enum.FillDirection.Horizontal
    RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Padding = UDim.new(0, 10)
    RightLayout.Parent = RightContainer
    
    local LicTextBox = Instance.new("TextBox")
    LicTextBox.Name = "Input"
    LicTextBox.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
    LicTextBox.Size = UDim2.new(0, 170, 1, -5) -- slightly smaller height to center well
    LicTextBox.Position = UDim2.new(0, 0, 0, 2.5)
    LicTextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    LicTextBox.Text = ""
    LicTextBox.PlaceholderText = "Enter license key"
    LicTextBox.TextColor3 = Color3.new(1, 1, 1)
    LicTextBox.TextSize = 12
    LicTextBox.TextXAlignment = Enum.TextXAlignment.Left
    LicTextBox.LayoutOrder = 1
    LicTextBox.Parent = RightContainer
    
    local LicBoxCorner = Instance.new("UICorner")
    LicBoxCorner.CornerRadius = UDim.new(0, 4)
    LicBoxCorner.Parent = LicTextBox
    
    local LicBoxStroke = Instance.new("UIStroke")
    LicBoxStroke.Color = Color3.new(0.15, 0.15, 0.15)
    LicBoxStroke.Parent = LicTextBox
    
    local LicBoxPadding = Instance.new("UIPadding")
    LicBoxPadding.PaddingLeft = UDim.new(0, 10)
    LicBoxPadding.Parent = LicTextBox
    
    local ClaimBtn = Instance.new("TextButton")
    ClaimBtn.Name = "ClaimButton"
    ClaimBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    ClaimBtn.Size = UDim2.new(0, 70, 1, -5)
    ClaimBtn.Position = UDim2.new(0, 0, 0, 2.5)
    ClaimBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ClaimBtn.Text = "Claim"
    ClaimBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ClaimBtn.TextSize = 12
    ClaimBtn.LayoutOrder = 2
    ClaimBtn.Parent = RightContainer
    
    local ClaimCorner = Instance.new("UICorner")
    ClaimCorner.CornerRadius = UDim.new(0, 4)
    ClaimCorner.Parent = ClaimBtn
    
    local ClaimStroke = Instance.new("UIStroke")
    ClaimStroke.Color = Color3.new(0.2, 0.2, 0.2)
    ClaimStroke.Parent = ClaimBtn
    
    maid:GiveTask(ClaimBtn.MouseEnter:Connect(function() Tween(ClaimBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)}) end))
    maid:GiveTask(ClaimBtn.MouseLeave:Connect(function() Tween(ClaimBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)}) end))
    
    -- [ SUBSCRIPTIONS ROW ]
    local SubsRow = Instance.new("Frame")
    SubsRow.Name = "SubscriptionsRow"
    SubsRow.BackgroundTransparency = 1
    SubsRow.Size = UDim2.new(1, 0, 0, 280)
    SubsRow.Parent = Scroll
    
    local SubsLayout = Instance.new("UIListLayout")
    SubsLayout.FillDirection = Enum.FillDirection.Horizontal
    SubsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SubsLayout.Padding = UDim.new(0, 15)
    SubsLayout.Parent = SubsRow
    
    -- Left Card: Volt Sub
    local VoltCard = Instance.new("Frame")
    VoltCard.Name = "VoltCard"
    VoltCard.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    VoltCard.Size = UDim2.new(0.35, -7, 1, 0)
    VoltCard.Parent = SubsRow
    Instance.new("UICorner", VoltCard).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", VoltCard).Color = Color3.new(0.15, 0.15, 0.15)
    
    local VoltPadding = Instance.new("UIPadding")
    VoltPadding.PaddingTop = UDim.new(0, 15)
    VoltPadding.PaddingBottom = UDim.new(0, 15)
    VoltPadding.PaddingLeft = UDim.new(0, 15)
    VoltPadding.PaddingRight = UDim.new(0, 15)
    VoltPadding.Parent = VoltCard
    
    local VoltHeader = Instance.new("Frame")
    VoltHeader.BackgroundTransparency = 1
    VoltHeader.Size = UDim2.new(1, 0, 0, 30)
    VoltHeader.Parent = VoltCard
    
    local VoltTitle = Instance.new("TextLabel")
    VoltTitle.BackgroundTransparency = 1
    VoltTitle.Size = UDim2.new(1, 0, 0, 16)
    VoltTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    VoltTitle.Text = "Volt"
    VoltTitle.TextColor3 = Color3.new(1, 1, 1)
    VoltTitle.TextSize = 14
    VoltTitle.TextXAlignment = Enum.TextXAlignment.Left
    VoltTitle.Parent = VoltHeader
    
    local VoltDesc = Instance.new("TextLabel")
    VoltDesc.BackgroundTransparency = 1
    VoltDesc.Size = UDim2.new(1, 0, 0, 14)
    VoltDesc.Position = UDim2.new(0, 0, 0, 16)
    VoltDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    VoltDesc.Text = "Current subscription"
    VoltDesc.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    VoltDesc.TextSize = 11
    VoltDesc.TextXAlignment = Enum.TextXAlignment.Left
    VoltDesc.Parent = VoltHeader
    
    local ActiveBadge = Instance.new("Frame")
    ActiveBadge.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    ActiveBadge.Size = UDim2.new(0, 45, 0, 18)
    ActiveBadge.AnchorPoint = Vector2.new(1, 0)
    ActiveBadge.Position = UDim2.new(1, 0, 0, 0)
    ActiveBadge.Parent = VoltHeader
    Instance.new("UICorner", ActiveBadge).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", ActiveBadge).Color = Color3.new(0.3, 0.3, 0.3)
    
    local ActiveText = Instance.new("TextLabel")
    ActiveText.BackgroundTransparency = 1
    ActiveText.Size = UDim2.new(1, 0, 1, 0)
    ActiveText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ActiveText.Text = "Active"
    ActiveText.TextColor3 = Color3.new(1, 1, 1)
    ActiveText.TextSize = 10
    ActiveText.Parent = ActiveBadge
    
    local VoltList = Instance.new("UIListLayout")
    VoltList.SortOrder = Enum.SortOrder.LayoutOrder
    VoltList.Padding = UDim.new(0, 10)
    VoltList.Parent = VoltCard
    VoltHeader.LayoutOrder = 0
    
    local function CreateInfoBox(parent, title, val, isLarge)
        local box = Instance.new("Frame")
        box.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
        box.Size = UDim2.new(1, 0, 0, isLarge and 60 or 40)
        box.Parent = parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", box).Color = Color3.new(0.15, 0.15, 0.15)
        local pad = Instance.new("UIPadding", box)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingTop = UDim.new(0, isLarge and 10 or 6)
        
        local tLabel = Instance.new("TextLabel", box)
        tLabel.BackgroundTransparency = 1
        tLabel.Size = UDim2.new(1, 0, 0, 12)
        tLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        tLabel.Text = title
        tLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        tLabel.TextSize = 10
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local vLabel = Instance.new("TextLabel", box)
        vLabel.BackgroundTransparency = 1
        vLabel.Size = UDim2.new(1, 0, 0, isLarge and 20 or 14)
        vLabel.Position = UDim2.new(0, 0, 0, isLarge and 16 or 14)
        vLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", isLarge and Enum.FontWeight.Bold or Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        vLabel.Text = val
        vLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        vLabel.TextSize = isLarge and 16 or 12
        vLabel.TextXAlignment = Enum.TextXAlignment.Left
        return vLabel
    end
    
    local RemVal = CreateInfoBox(VoltCard, "Remaining", "Loading...", true)
    local StartVal = CreateInfoBox(VoltCard, "Started", "Loading...", false)
    local EndVal = CreateInfoBox(VoltCard, "Ends", "Loading...", false)
    local OrigVal = CreateInfoBox(VoltCard, "Original end", "Loading...", false)
    
    -- Right Card: Claimed Keys
    local KeysCard = Instance.new("Frame")
    KeysCard.Name = "KeysCard"
    KeysCard.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    KeysCard.Size = UDim2.new(0.65, -8, 1, 0)
    KeysCard.Parent = SubsRow
    Instance.new("UICorner", KeysCard).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", KeysCard).Color = Color3.new(0.15, 0.15, 0.15)
    
    local KeysPadding = Instance.new("UIPadding")
    KeysPadding.PaddingTop = UDim.new(0, 15)
    KeysPadding.PaddingBottom = UDim.new(0, 15)
    KeysPadding.PaddingLeft = UDim.new(0, 15)
    KeysPadding.PaddingRight = UDim.new(0, 15)
    KeysPadding.Parent = KeysCard
    
    local KeysHeader = Instance.new("Frame")
    KeysHeader.BackgroundTransparency = 1
    KeysHeader.Size = UDim2.new(1, 0, 0, 20)
    KeysHeader.Parent = KeysCard
    
    local KeyIcon = Instance.new("ImageLabel")
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.Size = UDim2.new(0, 16, 0, 16)
    KeyIcon.Image = "rbxassetid://113646711739432"
    KeyIcon.ImageColor3 = Color3.new(0.8, 0.8, 0.8)
    KeyIcon.Parent = KeysHeader
    
    local KeysTitle = Instance.new("TextLabel")
    KeysTitle.BackgroundTransparency = 1
    KeysTitle.Size = UDim2.new(1, -25, 1, 0)
    KeysTitle.Position = UDim2.new(0, 25, 0, 0)
    KeysTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    KeysTitle.Text = "Claimed keys"
    KeysTitle.TextColor3 = Color3.new(1, 1, 1)
    KeysTitle.TextSize = 13
    KeysTitle.TextXAlignment = Enum.TextXAlignment.Left
    KeysTitle.Parent = KeysHeader
    
    local CountBadge = Instance.new("Frame")
    CountBadge.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    CountBadge.Size = UDim2.new(0, 20, 0, 16)
    CountBadge.AnchorPoint = Vector2.new(1, 0.5)
    CountBadge.Position = UDim2.new(1, 0, 0.5, 0)
    CountBadge.Parent = KeysHeader
    Instance.new("UICorner", CountBadge).CornerRadius = UDim.new(0, 8)
    
    local CountText = Instance.new("TextLabel")
    CountText.BackgroundTransparency = 1
    CountText.Size = UDim2.new(1, 0, 1, 0)
    CountText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    CountText.Text = "1"
    CountText.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    CountText.TextSize = 10
    CountText.Parent = CountBadge
    
    local KeysLayout = Instance.new("UIListLayout")
    KeysLayout.SortOrder = Enum.SortOrder.LayoutOrder
    KeysLayout.Padding = UDim.new(0, 10)
    KeysLayout.Parent = KeysCard
    KeysHeader.LayoutOrder = 0
    
    -- Single Key Row
    local KeyItem = Instance.new("TextButton")
    KeyItem.Text = ""
    KeyItem.AutoButtonColor = false
    KeyItem.BackgroundTransparency = 1
    KeyItem.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    KeyItem.Size = UDim2.new(1, 10, 0, 40)
    KeyItem.Position = UDim2.new(0, -5, 0, 0)
    KeyItem.LayoutOrder = 1
    KeyItem.Parent = KeysCard
    Instance.new("UICorner", KeyItem).CornerRadius = UDim.new(0, 4)
    
    maid:GiveTask(KeyItem.MouseEnter:Connect(function() Tween(KeyItem, TweenInfo.new(0.2), {BackgroundTransparency = 0}) end))
    maid:GiveTask(KeyItem.MouseLeave:Connect(function() Tween(KeyItem, TweenInfo.new(0.2), {BackgroundTransparency = 1}) end))
    
    local KeyCode = Instance.new("TextLabel")
    KeyCode.BackgroundTransparency = 1
    KeyCode.Size = UDim2.new(1, -60, 0, 16)
    KeyCode.Position = UDim2.new(0, 5, 0, 0)
    KeyCode.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    KeyCode.Text = "Voltontop"
    KeyCode.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    KeyCode.TextSize = 11
    KeyCode.TextXAlignment = Enum.TextXAlignment.Left
    KeyCode.Parent = KeyItem
    
    local KeyDates = Instance.new("TextLabel")
    KeyDates.BackgroundTransparency = 1
    KeyDates.Size = UDim2.new(1, 0, 0, 14)
    KeyDates.Position = UDim2.new(0, 5, 0, 18)
    KeyDates.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    KeyDates.Text = "Lifetime Key"
    KeyDates.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    KeyDates.TextSize = 10
    KeyDates.TextXAlignment = Enum.TextXAlignment.Left
    KeyDates.Parent = KeyItem
    
    local TypeBadge = Instance.new("Frame")
    TypeBadge.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    TypeBadge.Size = UDim2.new(0, 50, 0, 18)
    TypeBadge.AnchorPoint = Vector2.new(1, 0.5)
    TypeBadge.Position = UDim2.new(1, -5, 0.5, 0)
    TypeBadge.Parent = KeyItem
    Instance.new("UICorner", TypeBadge).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", TypeBadge).Color = Color3.new(0.3, 0.3, 0.3)
    
    local TypeText = Instance.new("TextLabel")
    TypeText.BackgroundTransparency = 1
    TypeText.Size = UDim2.new(1, 0, 1, 0)
    TypeText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TypeText.Text = "lifetime"
    TypeText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    TypeText.TextSize = 10
    TypeText.Parent = TypeBadge
    
    -- [ SECURITY HEADER ]
    local SecHeader = Instance.new("Frame")
    SecHeader.Name = "SecurityHeader"
    SecHeader.BackgroundTransparency = 1
    SecHeader.Size = UDim2.new(1, 0, 0, 35)
    SecHeader.Parent = Scroll
    
    local SecIcon = Instance.new("ImageLabel")
    SecIcon.BackgroundTransparency = 1
    SecIcon.Size = UDim2.new(0, 16, 0, 16)
    SecIcon.Image = "rbxassetid://104512588477874" -- Security Icon
    SecIcon.ImageColor3 = Color3.new(0.8, 0.8, 0.8)
    SecIcon.Parent = SecHeader
    
    local SecTitle = Instance.new("TextLabel")
    SecTitle.BackgroundTransparency = 1
    SecTitle.Size = UDim2.new(1, -25, 0, 16)
    SecTitle.Position = UDim2.new(0, 25, 0, 0)
    SecTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SecTitle.Text = "Security"
    SecTitle.TextColor3 = Color3.new(1, 1, 1)
    SecTitle.TextSize = 12
    SecTitle.TextXAlignment = Enum.TextXAlignment.Left
    SecTitle.Parent = SecHeader
    
    local SecDesc = Instance.new("TextLabel")
    SecDesc.BackgroundTransparency = 1
    SecDesc.Size = UDim2.new(1, -25, 0, 14)
    SecDesc.Position = UDim2.new(0, 25, 0, 16)
    SecDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    SecDesc.Text = "Session and account controls"
    SecDesc.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    SecDesc.TextSize = 11
    SecDesc.TextXAlignment = Enum.TextXAlignment.Left
    SecDesc.Parent = SecHeader
    
    -- [ SECURITY CARDS ]
    local SecRow = Instance.new("Frame")
    SecRow.Name = "SecurityRow"
    SecRow.BackgroundTransparency = 1
    SecRow.Size = UDim2.new(1, 0, 0, 80)
    SecRow.Parent = Scroll
    
    local SecLayout = Instance.new("UIListLayout")
    SecLayout.FillDirection = Enum.FillDirection.Horizontal
    SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecLayout.Padding = UDim.new(0, 15)
    SecLayout.Parent = SecRow
    
    -- Change Password Card
    local PassCard = Instance.new("Frame")
    PassCard.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    PassCard.Size = UDim2.new(0.5, -7, 1, 0)
    PassCard.Parent = SecRow
    Instance.new("UICorner", PassCard).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", PassCard).Color = Color3.new(0.15, 0.15, 0.15)
    
    local PassPad = Instance.new("UIPadding", PassCard)
    PassPad.PaddingLeft = UDim.new(0, 15)
    PassPad.PaddingTop = UDim.new(0, 15)
    
    local PassTitle = Instance.new("TextLabel")
    PassTitle.BackgroundTransparency = 1
    PassTitle.Size = UDim2.new(1, 0, 0, 16)
    PassTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PassTitle.Text = "Change Password"
    PassTitle.TextColor3 = Color3.new(1, 1, 1)
    PassTitle.TextSize = 12
    PassTitle.TextXAlignment = Enum.TextXAlignment.Left
    PassTitle.Parent = PassCard
    
    local PassDesc = Instance.new("TextLabel")
    PassDesc.BackgroundTransparency = 1
    PassDesc.Size = UDim2.new(1, 0, 0, 14)
    PassDesc.Position = UDim2.new(0, 0, 0, 16)
    PassDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    PassDesc.Text = "Update your account password."
    PassDesc.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    PassDesc.TextSize = 11
    PassDesc.TextXAlignment = Enum.TextXAlignment.Left
    PassDesc.Parent = PassCard
    
    local PassBtn = Instance.new("TextButton")
    PassBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    PassBtn.Size = UDim2.new(0, 90, 0, 26)
    PassBtn.AnchorPoint = Vector2.new(1, 0.5)
    PassBtn.Position = UDim2.new(1, -15, 0.5, 0)
    PassBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    PassBtn.Text = "Change"
    PassBtn.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    PassBtn.TextSize = 11
    PassBtn.Parent = PassCard
    Instance.new("UICorner", PassBtn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", PassBtn).Color = Color3.new(0.3, 0.3, 0.3)
    
    maid:GiveTask(PassBtn.MouseEnter:Connect(function() Tween(PassBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)}) end))
    maid:GiveTask(PassBtn.MouseLeave:Connect(function() Tween(PassBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)}) end))
    
    -- Sign Out Card
    local OutCard = Instance.new("Frame")
    OutCard.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    OutCard.Size = UDim2.new(0.5, -8, 1, 0)
    OutCard.Parent = SecRow
    Instance.new("UICorner", OutCard).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", OutCard).Color = Color3.new(0.15, 0.15, 0.15)
    
    local OutPad = Instance.new("UIPadding", OutCard)
    OutPad.PaddingLeft = UDim.new(0, 15)
    OutPad.PaddingTop = UDim.new(0, 15)
    
    local OutTitle = Instance.new("TextLabel")
    OutTitle.BackgroundTransparency = 1
    OutTitle.Size = UDim2.new(1, 0, 0, 16)
    OutTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    OutTitle.Text = "Sign out"
    OutTitle.TextColor3 = Color3.new(1, 1, 1)
    OutTitle.TextSize = 12
    OutTitle.TextXAlignment = Enum.TextXAlignment.Left
    OutTitle.Parent = OutCard
    
    local OutDesc = Instance.new("TextLabel")
    OutDesc.BackgroundTransparency = 1
    OutDesc.Size = UDim2.new(1, 0, 0, 14)
    OutDesc.Position = UDim2.new(0, 0, 0, 16)
    OutDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    OutDesc.Text = "End the session on this device."
    OutDesc.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    OutDesc.TextSize = 11
    OutDesc.TextXAlignment = Enum.TextXAlignment.Left
    OutDesc.Parent = OutCard
    
    local OutBtn = Instance.new("TextButton")
    OutBtn.BackgroundColor3 = Color3.new(0.15, 0.05, 0.05)
    OutBtn.Size = UDim2.new(0, 80, 0, 26)
    OutBtn.AnchorPoint = Vector2.new(1, 0.5)
    OutBtn.Position = UDim2.new(1, -15, 0.5, 0)
    OutBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    OutBtn.Text = "Sign Out"
    OutBtn.TextColor3 = Color3.new(1, 0.3, 0.3)
    OutBtn.TextSize = 11
    OutBtn.Parent = OutCard
    Instance.new("UICorner", OutBtn).CornerRadius = UDim.new(0, 4)
    local OutStroke = Instance.new("UIStroke", OutBtn)
    OutStroke.Color = Color3.new(0.5, 0.1, 0.1)
    
    maid:GiveTask(OutBtn.MouseEnter:Connect(function() Tween(OutBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.2, 0.1, 0.1)}) end))
    maid:GiveTask(OutBtn.MouseLeave:Connect(function() Tween(OutBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.15, 0.05, 0.05)}) end))
    
    local function UpdateData(data)
        if not data then return end
        
        -- Update Profile
        if data.username then
            Username.Text = data.username
            AvatarText.Text = string.sub(data.username, 1, 1):upper()
        end
        if data._id then
            actualID = tostring(data._id)
            if isRevealed then UserIDBtn.Text = actualID end
        end
        if data.role then
            RoleText.Text = data.role:sub(1,1):upper() .. data.role:sub(2)
        end
        if data.createdAt then
            JoinDate.Text = "Member since " .. string.sub(data.createdAt, 1, 10)
        end
        
        -- Update Subscription (Hardcoded to Lifetime since everyone has Voltontop for now)
        RemVal.Text = "Lifetime"
        StartVal.Text = data.createdAt and string.sub(data.createdAt, 1, 10) or "N/A"
        EndVal.Text = "Never"
        OrigVal.Text = "Never"
        ActiveText.Text = "Active"
        ActiveBadge.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
    end

    return {
        Instance = Page,
        UpdateData = UpdateData
    }
end

return AccountPage
