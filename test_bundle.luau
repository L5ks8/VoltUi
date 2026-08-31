-- [[ Utils/Tween.luau ]] --
local TweenService = game:GetService("TweenService")

local Tween = {}

function Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end



-- [[ Utils/Api.luau ]] --
local HttpService = game:GetService("HttpService")

local Api = {}
Api.BaseUrl = "https://voltui.onrender.com/api"
Api.Token = nil
Api.UserData = nil

function Api.Request(endpoint, method, body)
    local requestFunc = request or http_request or (http and http.request) or syn and syn.request
    if not requestFunc then
        warn("HTTP Requests are not supported by this executor.")
        return nil
    end

    local headers = {
        ["Content-Type"] = "application/json"
    }
    if Api.Token then
        headers["Authorization"] = "Bearer " .. Api.Token
    end

    local options = {
        Url = Api.BaseUrl .. endpoint,
        Method = method or "GET",
        Headers = headers
    }
    if body then
        options.Body = HttpService:JSONEncode(body)
    end

    local success, res = pcall(function()
        return requestFunc(options)
    end)

    if success and res and res.Body then
        local decodeSuccess, decoded = pcall(function()
            return HttpService:JSONDecode(res.Body)
        end)
        if decodeSuccess then 
            return decoded 
        else
            return { error = "Server returned invalid JSON: " .. tostring(res.Body) }
        end
    end
    return nil
end

function Api.GetHWID()
    -- Some executors support getting HWID
    local gethwid = gethwid or get_hwid or function() return "DUMMY_HWID_123" end
    local success, hwid = pcall(gethwid)
    if success and hwid then return hwid end
    return "DUMMY_HWID_123"
end

function Api.GetToken()
    if Api.Token then return Api.Token end
    local readfileFunc = readfile or (file and file.Read) or nil
    if readfileFunc then
        local success, token = pcall(function() return readfileFunc("VoltToken.txt") end)
        if success and token and token ~= "" then
            Api.Token = token
            return token
        end
    end
    return nil
end

function Api.SaveToken(token)
    Api.Token = token
    local writefileFunc = writefile or (file and file.Write) or nil
    if writefileFunc then
        pcall(function() writefileFunc("VoltToken.txt", token) end)
    end
end

function Api.Login(username, password)
    local hwid = Api.GetHWID()
    local res = Api.Request("/auth/login", "POST", {
        username = username,
        password = password,
        hwid = hwid
    })

    if res and res.token then
        Api.SaveToken(res.token)
        return true, "Success"
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.Register(username, password, licenseKey)
    local hwid = Api.GetHWID()
    local res = Api.Request("/auth/register", "POST", {
        username = username,
        password = password,
        licenseKey = licenseKey,
        hwid = hwid
    })

    if res and res.message then
        return true, res.message
    elseif res and res.error then
        return false, res.error
    end
    return false, "Connection Error"
end

function Api.FetchMe()
    if not Api.GetToken() then return nil end
    local meRes = Api.Request("/user/me", "GET")
    if meRes and meRes.user then
        Api.UserData = meRes.user
        return Api.UserData
    end
    return nil
end



-- [[ Themes/Dark.luau ]] --
local DarkTheme = {
    MainBackground = Color3.new(0.075, 0.075, 0.075),
    SecondaryBackground = Color3.new(0.11, 0.11, 0.11),
    TertiaryBackground = Color3.new(0.094, 0.094, 0.094),
    
    StrokeColor = Color3.new(0.216, 0.216, 0.216),
    HighlightStrokeColor = Color3.new(0.353, 0.353, 0.353),
    
    TextPrimary = Color3.new(0.537, 0.537, 0.537),
    TextSecondary = Color3.new(0.478, 0.478, 0.478),
    
    IconColor = Color3.new(1, 1, 1)
}



-- [[ Components/Button.luau ]] --


-- [[ Components/Toggle.luau ]] --


-- [[ Components/Dropdown.luau ]] --


-- [[ Components/Slider.luau ]] --


-- [[ Core/Notifications.luau ]] --

local Notifications = {}
Notifications.Container = nil

-- Configuration
local Config = {
    Width = 320,
    BaseHeight = 65,
    Padding = 15,
    Gap = 10,
    SuccessColor = Color3.fromRGB(39, 174, 96),
    SuccessIconBg = Color3.fromRGB(25, 45, 35),
    ErrorColor = Color3.fromRGB(231, 76, 60),
    ErrorIconBg = Color3.fromRGB(55, 25, 25),
    BgColor = Color3.fromRGB(20, 25, 22),
    StrokeColor = Color3.fromRGB(40, 50, 45)
}

function Notifications.Init(ParentGui)
    local Container = Instance.new("Frame")
    Container.Name = "NotificationContainer"
    Container.BackgroundTransparency = 1
    Container.AnchorPoint = Vector2.new(1, 1)
    Container.Position = UDim2.new(1, -20, 1, -20)
    Container.Size = UDim2.new(0, Config.Width, 1, -40)
    Container.ZIndex = 100
    Container.ClipsDescendants = false
    Container.Parent = ParentGui

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Padding = UDim.new(0, Config.Gap)
    Layout.Parent = Container

    Notifications.Container = Container
end

function Notifications.Notify(options)
    if not Notifications.Container then return end

    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 3
    local type = options.Type or "Success" -- "Success" or "Error"

    local isError = (type == "Error")
    local mainColor = isError and Config.ErrorColor or Config.SuccessColor
    local iconBgColor = isError and Config.ErrorIconBg or Config.SuccessIconBg
    local iconAsset = isError and "rbxassetid://97388232453690" or "rbxassetid://10651060934" -- X or Check

    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
    Notif.BackgroundColor3 = Config.BgColor
    Notif.Size = UDim2.new(1, 0, 0, Config.BaseHeight)
    Notif.Position = UDim2.new(1, Config.Width + 50, 0, 0) -- Start off-screen right
    Notif.BackgroundTransparency = 0.05
    Notif.Parent = Notifications.Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Config.StrokeColor
    Stroke.Parent = Notif

    -- Icon Background
    local IconBg = Instance.new("Frame")
    IconBg.BackgroundColor3 = iconBgColor
    IconBg.Size = UDim2.new(0, 30, 0, 30)
    IconBg.Position = UDim2.new(0, Config.Padding, 0.5, -15)
    IconBg.Parent = Notif
    Instance.new("UICorner", IconBg).CornerRadius = UDim.new(0, 6)

    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Image = iconAsset
    Icon.ImageColor3 = mainColor
    Icon.Parent = IconBg

    -- Title
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Size = UDim2.new(1, -90, 0, 18)
    TitleLbl.Position = UDim2.new(0, Config.Padding + 40, 0, 14)
    TitleLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.new(1, 1, 1)
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Notif

    -- Content
    local ContentLbl = Instance.new("TextLabel")
    ContentLbl.BackgroundTransparency = 1
    ContentLbl.Size = UDim2.new(1, -90, 0, 14)
    ContentLbl.Position = UDim2.new(0, Config.Padding + 40, 0, 34)
    ContentLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ContentLbl.Text = content
    ContentLbl.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    ContentLbl.TextSize = 12
    ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
    ContentLbl.TextWrapped = true
    ContentLbl.Parent = Notif

    -- Close Button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, -Config.Padding, 0.5, 0)
    CloseBtn.Image = "rbxassetid://121170570745612" -- X icon
    CloseBtn.ImageColor3 = Color3.new(0.5, 0.5, 0.5)
    CloseBtn.Parent = Notif

    local closed = false

    local function CloseNotif()
        if closed then return end
        closed = true
        Tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, Config.Width + 50, 0, 0)})
        task.delay(0.3, function()
            Notif:Destroy()
        end)
    end

    CloseBtn.MouseButton1Click:Connect(CloseNotif)

    -- Animate In
    Tween(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})

    -- Auto Close
    task.delay(duration, CloseNotif)
end



-- [[ Core/AccountPage.luau ]] --

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



-- [[ Core/LoginPage.luau ]] --

local LoginPage = {}

function LoginPage.Create(ParentGui, OnSuccess)
    local Page = Instance.new("Frame")
    Page.Name = "LoginPage"
    Page.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06) -- Dark background
    Page.BorderSizePixel = 0
    Page.AnchorPoint = Vector2.new(0.5, 0.5)
    Page.Position = UDim2.new(0.5, 0, 0.5, 0)
    Page.Size = UDim2.new(0, 800, 0, 600)
    Page.ZIndex = 50
    Page.Parent = ParentGui
    
    Instance.new("UICorner", Page)
    local PageStroke = Instance.new("UIStroke", Page)
    PageStroke.Color = Color3.new(0.216, 0.216, 0.216)
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 400, 0, 500)
    Container.Parent = Page
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Container)
    Stroke.Color = Color3.new(0.15, 0.15, 0.15)
    
    -- Headers
    local LogoContainer = Instance.new("Frame", Container)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Size = UDim2.new(1, 0, 0, 50)
    LogoContainer.Position = UDim2.new(0, 0, 0, 30)

    local LogoLayout = Instance.new("UIListLayout", LogoContainer)
    LogoLayout.FillDirection = Enum.FillDirection.Horizontal
    LogoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LogoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LogoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoLayout.Padding = UDim.new(0, 8)

    local LogoImg = Instance.new("ImageLabel", LogoContainer)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Size = UDim2.new(0, 24, 0, 24)
    LogoImg.Image = "rbxassetid://71942076965693"
    LogoImg.LayoutOrder = 1

    local LogoText = Instance.new("TextLabel", LogoContainer)
    LogoText.BackgroundTransparency = 1
    LogoText.Size = UDim2.new(0, 50, 0, 50)
    LogoText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LogoText.Text = "Volt"
    LogoText.TextColor3 = Color3.new(1, 1, 1)
    LogoText.TextSize = 24
    LogoText.LayoutOrder = 2
    LogoText.TextXAlignment = Enum.TextXAlignment.Left
    
    local Title = Instance.new("TextLabel", Container)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 80)
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Title.Text = "Welcome to Volt"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    
    local Subtitle = Instance.new("TextLabel", Container)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0, 110)
    Subtitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    Subtitle.Text = "Sign in to access your Lua development environment"
    Subtitle.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    Subtitle.TextSize = 12
    
    -- Error Label
    local ErrorLabel = Instance.new("TextLabel", Container)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
    ErrorLabel.Position = UDim2.new(0, 0, 0, 140)
    ErrorLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ErrorLabel.Text = ""
    ErrorLabel.TextColor3 = Color3.new(1, 0.3, 0.3)
    ErrorLabel.TextSize = 12
    
    -- Inputs Container
    local InputFrame = Instance.new("Frame", Container)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Size = UDim2.new(1, -60, 0, 200)
    InputFrame.Position = UDim2.new(0, 30, 0, 170)
    
    local InputLayout = Instance.new("UIListLayout", InputFrame)
    InputLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InputLayout.Padding = UDim.new(0, 15)
    
    local function CreateInput(name, placeholder, isPassword)
        local frame = Instance.new("Frame", InputFrame)
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, 0, 0, 60)
        
        local label = Instance.new("TextLabel", frame)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 20)
        label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        label.Text = name
        label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local boxBg = Instance.new("Frame", frame)
        boxBg.BackgroundColor3 = Color3.new(0.07, 0.07, 0.07)
        boxBg.Size = UDim2.new(1, 0, 0, 35)
        boxBg.Position = UDim2.new(0, 0, 0, 25)
        Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 4)
        local boxStroke = Instance.new("UIStroke", boxBg)
        boxStroke.Color = Color3.new(0.2, 0.2, 0.2)
        
        local box = Instance.new("TextBox", boxBg)
        box.BackgroundTransparency = 1
        box.Size = UDim2.new(1, -20, 1, 0)
        box.Position = UDim2.new(0, 10, 0, 0)
        box.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        box.PlaceholderText = placeholder
        box.Text = ""
        box.TextColor3 = Color3.new(1, 1, 1)
        box.TextSize = 12
        box.TextXAlignment = Enum.TextXAlignment.Left
        
        if isPassword then
            -- Note: Native Roblox TextBox doesn't support password masking natively easily without Text property manipulation, 
            -- but for this snippet we'll assume standard clear text or we could mask it manually.
            -- To keep it simple we just hide it manually or don't mask it in this prototype.
            -- In a real scenario we use Text property trick.
        end
        
        return frame, box
    end
    
    local userFrame, userBox = CreateInput("Username or Email", "Enter your username or email", false)
    local passFrame, passBox = CreateInput("Password", "Enter your password", true)
    
    local ActionBtn = Instance.new("TextButton", Container)
    ActionBtn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    ActionBtn.Size = UDim2.new(1, -60, 0, 40)
    ActionBtn.Position = UDim2.new(0, 30, 1, -120)
    ActionBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ActionBtn.Text = "Sign In"
    ActionBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ActionBtn.TextSize = 14
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)
    
    local SwitchBtn = Instance.new("TextButton", Container)
    SwitchBtn.BackgroundTransparency = 1
    SwitchBtn.Size = UDim2.new(1, 0, 0, 20)
    SwitchBtn.Position = UDim2.new(0, 0, 1, -50)
    SwitchBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    SwitchBtn.Text = "Don't have an account? Create one here"
    SwitchBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    SwitchBtn.TextSize = 11
    
    -- Register Specific Fields
    local keyFrame, keyBox = CreateInput("License Key", "XXXX-XXXX-XXXX-XXXX", false)
    
    keyFrame.Visible = false
    
    local isLogin = true
    
    SwitchBtn.MouseButton1Click:Connect(function()
        isLogin = not isLogin
        if isLogin then
            Title.Text = "Welcome to Volt"
            Subtitle.Text = "Sign in to access your Lua development environment"
            ActionBtn.Text = "Sign In"
            SwitchBtn.Text = "Don't have an account? Create one here"
            
            userFrame.Visible = true
            passFrame.Visible = true
            keyFrame.Visible = false
            Container.Size = UDim2.new(0, 400, 0, 500)
            ActionBtn.Position = UDim2.new(0, 30, 1, -120)
        else
            Title.Text = "Join Volt"
            Subtitle.Text = "Create your account to start Lua development"
            ActionBtn.Text = "Create Account"
            SwitchBtn.Text = "Already have an account? Sign in here"
            
            userFrame.Visible = true
            keyFrame.Visible = true
            passFrame.Visible = true
            
            -- Adjust Layout Order
            userFrame.LayoutOrder = 1
            keyFrame.LayoutOrder = 2
            passFrame.LayoutOrder = 3
            
            Container.Size = UDim2.new(0, 400, 0, 580)
            ActionBtn.Position = UDim2.new(0, 30, 1, -120)
        end
        ErrorLabel.Text = ""
    end)
    
    ActionBtn.MouseButton1Click:Connect(function()
        ActionBtn.Text = "Please wait..."
        ErrorLabel.Text = ""
        
        task.spawn(function()
            if isLogin then
                local success, msg = Api.Login(userBox.Text, passBox.Text)
                if success then
                    -- Load Data
                    Api.FetchMe()
                    Notifications.Notify({ Title = "Login Successful", Content = "Welcome back!", Type = "Success" })
                    Page.Visible = false
                    if OnSuccess then OnSuccess() end
                else
                    Notifications.Notify({ Title = "Login Failed", Content = msg or "Invalid credentials", Type = "Error" })
                    ActionBtn.Text = "Sign In"
                end
            else
                local success, msg = Api.Register(userBox.Text, passBox.Text, keyBox.Text)
                if success then
                    -- Registration success, now login
                    local succ2, msg2 = Api.Login(userBox.Text, passBox.Text)
                    if succ2 then
                        Api.FetchMe()
                        Notifications.Notify({ Title = "Registration Successful", Content = "Welcome to Volt!", Type = "Success" })
                        Page.Visible = false
                        if OnSuccess then OnSuccess() end
                    else
                        Notifications.Notify({ Title = "Auto-Login Failed", Content = msg2, Type = "Error" })
                        ActionBtn.Text = "Create Account"
                    end
                else
                    Notifications.Notify({ Title = "Registration Failed", Content = msg or "Check your inputs", Type = "Error" })
                    ActionBtn.Text = "Create Account"
                end
            end
        end)
    end)
    
    return Page
end



-- [[ Core/Window.luau ]] --


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
    
    local AccountPageElements = AccountPage.Create(Content, maid, function()
        SidebarElements.Instance.Visible = true
        SidebarSeparator.Visible = true
        MainContent.Visible = true
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
        SidebarElements.Instance.Visible = false
        SidebarSeparator.Visible = false
        MainContent.Visible = false
        AccountPageElements.Instance.Visible = true
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
    
    Utility.ProtectGui(VoltUi)
    
    return WindowObject
end



-- [[ Library.luau ]] --
local Library = {}

function Library:CreateWindow(Config)
    return Window:CreateWindow(Config)
end



return Library
