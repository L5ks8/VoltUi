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



-- [[ Utils/Signal.luau ]] --
local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._bindableEvent = Instance.new("BindableEvent")
    return self
end

function Signal:Connect(callback)
    return self._bindableEvent.Event:Connect(function(...)
        callback(...)
    end)
end

function Signal:Fire(...)
    self._bindableEvent:Fire(...)
end

function Signal:Wait()
    return self._bindableEvent.Event:Wait()
end

function Signal:Destroy()
    if self._bindableEvent then
        self._bindableEvent:Destroy()
        self._bindableEvent = nil
    end
end



-- [[ Utils/Maid.luau ]] --
local Maid = {}
Maid.__index = Maid

function Maid.new()
    local self = setmetatable({}, Maid)
    self._tasks = {}
    return self
end

function Maid:GiveTask(task)
    if not task then return end
    local taskId = #self._tasks + 1
    self._tasks[taskId] = task
    return taskId
end

function Maid:DoCleaning()
    local tasks = self._tasks
    for index, task in pairs(tasks) do
        if typeof(task) == "RBXScriptConnection" then
            task:Disconnect()
        elseif typeof(task) == "function" then
            task()
        elseif typeof(task) == "table" and type(task.Destroy) == "function" then
            task:Destroy()
        elseif typeof(task) == "Instance" then
            task:Destroy()
        end
        tasks[index] = nil
    end
end

function Maid:Destroy()
    self:DoCleaning()
end



-- [[ Utils/Utility.luau ]] --
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Utility = {}

function Utility.ProtectGui(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        local success = pcall(function()
            gui.Parent = CoreGui
        end)
        if not success then
            gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end
end

function Utility.MakeDraggable(dragRegion, targetInstance, maid)
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(targetInstance, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end
    
    local inputBegan = dragRegion.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetInstance.Position
            
            local changed
            changed = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if changed then changed:Disconnect() end
                end
            end)
        end
    end)
    
    local inputChanged = dragRegion.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    local userInputChanged = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    if maid then
        maid:GiveTask(inputBegan)
        maid:GiveTask(inputChanged)
        maid:GiveTask(userInputChanged)
    end
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



-- [[ Themes/Light.luau ]] --


-- [[ Components/Button.luau ]] --


-- [[ Components/Toggle.luau ]] --


-- [[ Components/Slider.luau ]] --


-- [[ Components/Dropdown.luau ]] --


-- [[ Components/Paragraph.luau ]] --


-- [[ Components/Label.luau ]] --


-- [[ Components/Input.luau ]] --


-- [[ Core/Sections.luau ]] --


-- [[ Core/Notifications.luau ]] --



local Notifications = {}
Notifications.Container = nil

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
    local type = options.Type or "Success"

    local isError = (string.lower(type) == "error")
    local mainColor = isError and Config.ErrorColor or Config.SuccessColor
    local iconAsset = isError and "rbxassetid://97388232453690" or "rbxassetid://10651060934"
    
    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "NotificationWrapper"
    Wrapper.BackgroundTransparency = 1
    Wrapper.Size = UDim2.new(1, 0, 0, Config.BaseHeight)
    Wrapper.Parent = Notifications.Container

    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
    Notif.BackgroundColor3 = Config.BgColor
    Notif.Size = UDim2.new(1, 0, 1, 0)
    Notif.Position = UDim2.new(1, Config.Width, 0, 0)
    Notif.BackgroundTransparency = 0.05
    Notif.Parent = Wrapper
    
    local Accent = Instance.new("Frame")
    Accent.Name = "Accent"
    Accent.BackgroundColor3 = mainColor
    Accent.BorderSizePixel = 0
    Accent.Size = UDim2.new(0, 3, 1, 0)
    Accent.Parent = Notif
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 6)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Notif

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Config.StrokeColor
    Stroke.Parent = Notif

    local IconBg = Instance.new("Frame")
    IconBg.BackgroundTransparency = 1
    IconBg.Size = UDim2.new(0, 30, 0, 30)
    IconBg.Position = UDim2.new(0, Config.Padding, 0.5, -15)
    IconBg.Parent = Notif

    local Icon = Instance.new("ImageLabel")
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Image = iconAsset
    Icon.ImageColor3 = Color3.new(1, 1, 1)
    Icon.Parent = IconBg

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

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, -Config.Padding, 0.5, 0)
    CloseBtn.Image = "rbxassetid://121170570745612"
    CloseBtn.ImageColor3 = Color3.new(0.5, 0.5, 0.5)
    CloseBtn.Parent = Notif

    local closed = false

    local function CloseNotif()
        if closed then return end
        closed = true
        Tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, Config.Width, 0, 0)})
        task.delay(0.3, function()
            Wrapper:Destroy()
        end)
    end

    CloseBtn.MouseButton1Click:Connect(CloseNotif)

    Tween(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})

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
    Page.Position = UDim2.new(0, 0, 0, 0)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.LayoutOrder = 2
    Page.Visible = true
    Page.ZIndex = 1
    Page.Parent = Content
    
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
    BackBtn.Image = "rbxassetid://93526157530558"
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
        if BackCallback then BackCallback() end
    end))
    
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
    local actualID = "No ID Available"
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
    
    local LicensesRow = Instance.new("Frame")
    LicensesRow.Name = "LicensesRow"
    LicensesRow.BackgroundTransparency = 1
    LicensesRow.Size = UDim2.new(1, 0, 0, 35)
    LicensesRow.Parent = Scroll
    
    local LicIcon = Instance.new("ImageLabel")
    LicIcon.BackgroundTransparency = 1
    LicIcon.Size = UDim2.new(0, 16, 0, 16)
    LicIcon.Position = UDim2.new(0, 0, 0, 0)
    LicIcon.Image = "rbxassetid://79413295774210"
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
    LicTextBox.Size = UDim2.new(0, 170, 1, -5)
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
    
    local function CreateKeyItem(keyText, keyType)
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
        KeyCode.Text = keyText
        KeyCode.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        KeyCode.TextSize = 11
        KeyCode.TextXAlignment = Enum.TextXAlignment.Left
        KeyCode.Parent = KeyItem
        
        local KeyDates = Instance.new("TextLabel")
        KeyDates.BackgroundTransparency = 1
        KeyDates.Size = UDim2.new(1, 0, 0, 14)
        KeyDates.Position = UDim2.new(0, 5, 0, 18)
        KeyDates.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        KeyDates.Text = keyType .. " Key"
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
        TypeText.Text = string.lower(keyType)
        TypeText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        TypeText.TextSize = 10
        TypeText.Parent = TypeBadge
    end
    
    CreateKeyItem("Voltontop", "Lifetime")
    
    local SecHeader = Instance.new("Frame")
    SecHeader.Name = "SecurityHeader"
    SecHeader.BackgroundTransparency = 1
    SecHeader.Size = UDim2.new(1, 0, 0, 35)
    SecHeader.Parent = Scroll
    
    local SecIcon = Instance.new("ImageLabel")
    SecIcon.BackgroundTransparency = 1
    SecIcon.Size = UDim2.new(0, 16, 0, 16)
    SecIcon.Image = "rbxassetid://104512588477874"
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
    PassBtn.Size = UDim2.new(0, 130, 0, 26)
    PassBtn.AnchorPoint = Vector2.new(1, 0.5)
    PassBtn.Position = UDim2.new(1, -15, 0.5, 0)
    PassBtn.Text = ""
    PassBtn.Parent = PassCard
    Instance.new("UICorner", PassBtn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", PassBtn).Color = Color3.new(0.3, 0.3, 0.3)
    
    local PassBtnIcon = Instance.new("ImageLabel")
    PassBtnIcon.BackgroundTransparency = 1
    PassBtnIcon.Size = UDim2.new(0, 14, 0, 14)
    PassBtnIcon.Position = UDim2.new(0, 8, 0.5, -7)
    PassBtnIcon.Image = "rbxassetid://10709769508"
    PassBtnIcon.ImageColor3 = Color3.new(0.8, 0.8, 0.8)
    PassBtnIcon.Parent = PassBtn
    
    local PassBtnText = Instance.new("TextLabel")
    PassBtnText.BackgroundTransparency = 1
    PassBtnText.Size = UDim2.new(1, -30, 1, 0)
    PassBtnText.Position = UDim2.new(0, 26, 0, 0)
    PassBtnText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    PassBtnText.Text = "Change Password"
    PassBtnText.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    PassBtnText.TextSize = 11
    PassBtnText.TextXAlignment = Enum.TextXAlignment.Left
    PassBtnText.Parent = PassBtn
    
    maid:GiveTask(PassBtn.MouseEnter:Connect(function() Tween(PassBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)}) end))
    maid:GiveTask(PassBtn.MouseLeave:Connect(function() Tween(PassBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)}) end))
    
    maid:GiveTask(PassBtn.MouseButton1Click:Connect(function()
        print("Change Password clicked!")
    end))
    
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
    OutBtn.Size = UDim2.new(0, 90, 0, 26)
    OutBtn.AnchorPoint = Vector2.new(1, 0.5)
    OutBtn.Position = UDim2.new(1, -15, 0.5, 0)
    OutBtn.Text = ""
    OutBtn.Parent = OutCard
    Instance.new("UICorner", OutBtn).CornerRadius = UDim.new(0, 4)
    local OutStroke = Instance.new("UIStroke", OutBtn)
    OutStroke.Color = Color3.new(0.5, 0.1, 0.1)
    
    local OutBtnIcon = Instance.new("ImageLabel")
    OutBtnIcon.BackgroundTransparency = 1
    OutBtnIcon.Size = UDim2.new(0, 14, 0, 14)
    OutBtnIcon.Position = UDim2.new(0, 8, 0.5, -7)
    OutBtnIcon.Image = "rbxassetid://83408923775191"
    OutBtnIcon.ImageColor3 = Color3.new(1, 0.3, 0.3)
    OutBtnIcon.Parent = OutBtn
    
    local OutBtnText = Instance.new("TextLabel")
    OutBtnText.BackgroundTransparency = 1
    OutBtnText.Size = UDim2.new(1, -30, 1, 0)
    OutBtnText.Position = UDim2.new(0, 26, 0, 0)
    OutBtnText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    OutBtnText.Text = "Sign Out"
    OutBtnText.TextColor3 = Color3.new(1, 0.3, 0.3)
    OutBtnText.TextSize = 11
    OutBtnText.TextXAlignment = Enum.TextXAlignment.Left
    OutBtnText.Parent = OutBtn
    
    maid:GiveTask(OutBtn.MouseEnter:Connect(function() Tween(OutBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.2, 0.1, 0.1)}) end))
    maid:GiveTask(OutBtn.MouseLeave:Connect(function() Tween(OutBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.15, 0.05, 0.05)}) end))

    maid:GiveTask(OutBtn.MouseButton1Click:Connect(function()
        if Api and Api.SaveToken then
            Api.SaveToken("")
            Api.Token = nil
        end
        game.Players.LocalPlayer:Kick("You have successfully signed out.")
    end))
    
    local function UpdateData(data)
        if not data then return end
        
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
        
        local isLifetime = true
        
        RemVal.Text = "Lifetime"
        StartVal.Text = data.createdAt and string.sub(data.createdAt, 1, 10) or "N/A"
        EndVal.Text = "Never"
        OrigVal.Text = "Never"
        ActiveText.Text = "Active"
        ActiveBadge.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
        
        maid:GiveTask(ClaimBtn.MouseButton1Click:Connect(function()
            if isLifetime then
                
                Notifications.Notify({ Title = "Claim Failed", Content = "You already have a Lifetime subscription!", Type = "Error" })
                return
            end
            
            local keyText = LicTextBox.Text
            if keyText == "" then return end
            
            LicTextBox.Text = ""
            CreateKeyItem(keyText, "Premium")
            
            
            Notifications.Notify({ Title = "Key Claimed", Content = "Your subscription time has been extended.", Type = "Success" })
            
        end))
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
    Page.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
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
    
    local ErrorLabel = Instance.new("TextLabel", Container)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
    ErrorLabel.Position = UDim2.new(0, 0, 0, 140)
    ErrorLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ErrorLabel.Text = ""
    ErrorLabel.TextColor3 = Color3.new(1, 0.3, 0.3)
    ErrorLabel.TextSize = 12
    
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



-- [[ Core/CloseWarn.luau ]] --



local CloseWarn = {}

function CloseWarn.Create(ParentGui, maid, ConfirmCallback, CancelCallback)
    local Main = Instance.new("Frame")
    Main.Name = "CloseWarn"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.475, 0)
    Main.Size = UDim2.new(0, 200, 0, 108)
    Main.ZIndex = 100
    Main.Visible = false
    Main.Parent = ParentGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main
    
    local Question = Instance.new("Frame")
    Question.Name = "Question"
    Question.BackgroundColor3 = Color3.new(1, 1, 1)
    Question.BackgroundTransparency = 1
    Question.BorderColor3 = Color3.new(0, 0, 0)
    Question.BorderSizePixel = 0
    Question.Size = UDim2.new(0, 200, 0, 59)
    Question.Parent = Main
    
    local QuestionText = Instance.new("TextLabel")
    QuestionText.BackgroundColor3 = Color3.new(1, 1, 1)
    QuestionText.BackgroundTransparency = 1
    QuestionText.BorderColor3 = Color3.new(0, 0, 0)
    QuestionText.BorderSizePixel = 0
    QuestionText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    QuestionText.LineHeight = 1.5
    QuestionText.Size = UDim2.new(1, 0, 1, 0)
    QuestionText.Text = "Are you Sure you want to close this Window ?"
    QuestionText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    QuestionText.TextSize = 14
    QuestionText.TextWrapped = true
    QuestionText.Parent = Question
    
    local QuestionStroke = Instance.new("UIStroke")
    QuestionStroke.Color = Color3.new(0.353, 0.353, 0.353)
    QuestionStroke.Parent = Question
    
    local QuestionCorner = Instance.new("UICorner")
    QuestionCorner.BottomLeftRadius = UDim.new(0, 0)
    QuestionCorner.BottomRightRadius = UDim.new(0, 0)
    QuestionCorner.Parent = Question
    
    local Buttons = Instance.new("Frame")
    Buttons.Name = "Buttons"
    Buttons.BackgroundColor3 = Color3.new(1, 1, 1)
    Buttons.BackgroundTransparency = 1
    Buttons.BorderColor3 = Color3.new(0, 0, 0)
    Buttons.BorderSizePixel = 0
    Buttons.LayoutOrder = 1
    Buttons.Position = UDim2.new(0, 0, 0.546, 0)
    Buttons.Size = UDim2.new(0, 200, 0, 49)
    Buttons.Parent = Main
    
    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ButtonsLayout.Padding = UDim.new(0, 9)
    ButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ButtonsLayout.Parent = Buttons
    
    local Confirm = Instance.new("TextButton")
    Confirm.Name = "Confirm"
    Confirm.BackgroundColor3 = Color3.new(1, 1, 1)
    Confirm.BackgroundTransparency = 1
    Confirm.BorderColor3 = Color3.new(0, 0, 0)
    Confirm.BorderSizePixel = 0
    Confirm.Size = UDim2.new(0, 80, 0, 30)
    Confirm.Text = ""
    Confirm.Parent = Buttons
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.Parent = Confirm
    
    local ConfirmLayout = Instance.new("UIListLayout")
    ConfirmLayout.FillDirection = Enum.FillDirection.Horizontal
    ConfirmLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ConfirmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ConfirmLayout.Parent = Confirm
    
    local ConfirmText = Instance.new("TextLabel")
    ConfirmText.BackgroundColor3 = Color3.new(1, 1, 1)
    ConfirmText.BackgroundTransparency = 1
    ConfirmText.BorderColor3 = Color3.new(0, 0, 0)
    ConfirmText.BorderSizePixel = 0
    ConfirmText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ConfirmText.Size = UDim2.new(1, 0, 1, 0)
    ConfirmText.Text = "Confirm"
    ConfirmText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    ConfirmText.TextSize = 14
    ConfirmText.Parent = Confirm
    
    local Cancel = Instance.new("TextButton")
    Cancel.Name = "Cancel"
    Cancel.BackgroundColor3 = Color3.new(1, 1, 1)
    Cancel.BackgroundTransparency = 1
    Cancel.BorderColor3 = Color3.new(0, 0, 0)
    Cancel.BorderSizePixel = 0
    Cancel.LayoutOrder = 1
    Cancel.Size = UDim2.new(0, 80, 0, 30)
    Cancel.Text = ""
    Cancel.Parent = Buttons
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.Parent = Cancel
    
    local CancelLayout = Instance.new("UIListLayout")
    CancelLayout.FillDirection = Enum.FillDirection.Horizontal
    CancelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CancelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    CancelLayout.Parent = Cancel
    
    local CancelText = Instance.new("TextLabel")
    CancelText.BackgroundColor3 = Color3.new(1, 1, 1)
    CancelText.BackgroundTransparency = 1
    CancelText.BorderColor3 = Color3.new(0, 0, 0)
    CancelText.BorderSizePixel = 0
    CancelText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    CancelText.Size = UDim2.new(1, 0, 1, 0)
    CancelText.Text = "Cancel"
    CancelText.TextColor3 = Color3.new(0.529, 0.529, 0.529)
    CancelText.TextSize = 14
    CancelText.Parent = Cancel
    
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.new(0.353, 0.353, 0.353)
    MainStroke.Parent = Main
    
    local HoverRed = Color3.fromRGB(235, 70, 70)
    local HoverGreen = Color3.fromRGB(70, 235, 70)
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    maid:GiveTask(Confirm.MouseEnter:Connect(function()
        Tween(Confirm, TweenInfoObj, {BackgroundTransparency = 0, BackgroundColor3 = HoverGreen})
    end))
    maid:GiveTask(Confirm.MouseLeave:Connect(function()
        Tween(Confirm, TweenInfoObj, {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1)})
    end))
    
    maid:GiveTask(Cancel.MouseEnter:Connect(function()
        Tween(Cancel, TweenInfoObj, {BackgroundTransparency = 0, BackgroundColor3 = HoverRed})
    end))
    maid:GiveTask(Cancel.MouseLeave:Connect(function()
        Tween(Cancel, TweenInfoObj, {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1)})
    end))
    
    maid:GiveTask(Confirm.MouseButton1Click:Connect(function()
        Main.Visible = false
        if ConfirmCallback then ConfirmCallback() end
    end))
    
    maid:GiveTask(Cancel.MouseButton1Click:Connect(function()
        Main.Visible = false
        if CancelCallback then CancelCallback() end
    end))
    
    return Main
end



-- [[ Core/Minimized.luau ]] --



local Minimized = {}

function Minimized.Create(ParentGui, maid, RestoreCallback)
    local Frame = Instance.new("ImageButton")
    Frame.Name = "Minimized"
    Frame.Active = true
    Frame.AnchorPoint = Vector2.new(0.1, 0.3)
    Frame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    Frame.BorderColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.064, 0, 0.083, 0)
    Frame.Selectable = false
    Frame.Size = UDim2.new(0, 70, 0, 70)
    Frame.Visible = false
    Frame.AutoButtonColor = false
    Frame.Parent = ParentGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Frame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Parent = Frame
    
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Image = "rbxassetid://71942076965693"
    ImageLabel.Position = UDim2.new(-0.3, 0, 0.143, 0)
    ImageLabel.Size = UDim2.new(0, 45, 0, 45)
    ImageLabel.Parent = Frame
    
    maid:GiveTask(Frame.MouseButton1Click:Connect(function()
        Frame.Visible = false
        if RestoreCallback then RestoreCallback() end
    end))
    
    Utility.MakeDraggable(Frame, Frame, maid)
    
    return Frame
end



-- [[ Core/Bottombar.luau ]] --
local Bottombar = {}

function Bottombar.Create(Main, maid)
    local BottombarFrame = Instance.new("Frame")
    BottombarFrame.Name = "Bottombar"
    BottombarFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    BottombarFrame.BorderColor3 = Color3.new(0, 0, 0)
    BottombarFrame.BorderSizePixel = 0
    BottombarFrame.LayoutOrder = 2
    BottombarFrame.Position = UDim2.new(0, 0, 1, -20)
    BottombarFrame.Size = UDim2.new(1, 0, 0, 20)
    BottombarFrame.Parent = Main
    
    local BottombarCorner = Instance.new("UICorner")
    BottombarCorner.TopLeftRadius = UDim.new(0, 0)
    BottombarCorner.TopRightRadius = UDim.new(0, 0)
    BottombarCorner.Parent = BottombarFrame
    
    local BottombarBorder = Instance.new("Frame")
    BottombarBorder.Name = "Border"
    BottombarBorder.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    BottombarBorder.BorderSizePixel = 0
    BottombarBorder.Position = UDim2.new(0, 0, 0, 0)
    BottombarBorder.Size = UDim2.new(1, 0, 0, 1)
    BottombarBorder.Parent = BottombarFrame
    
    local Tabdisplay = Instance.new("Frame")
    Tabdisplay.Name = "Tabdisplay"
    Tabdisplay.BackgroundColor3 = Color3.new(1, 1, 1)
    Tabdisplay.BackgroundTransparency = 1
    Tabdisplay.BorderColor3 = Color3.new(0, 0, 0)
    Tabdisplay.BorderSizePixel = 0
    Tabdisplay.Size = UDim2.new(0, 100, 0, 20)
    Tabdisplay.Parent = BottombarFrame
    
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
    Info.Parent = BottombarFrame
    
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
    
    return {
        Instance = BottombarFrame,
        TabdisplayName = TabdisplayName
    }
end



-- [[ Core/Sidebar.luau ]] --



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
    SidebarActions.ZIndex = 10
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
        button.BackgroundTransparency = 1
        
        local HoverBox = Instance.new("Frame")
        HoverBox.Name = "HoverBox"
        HoverBox.AnchorPoint = Vector2.new(0.5, 0.5)
        HoverBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        HoverBox.Size = UDim2.new(0, 30, 0, 30)
        HoverBox.BackgroundColor3 = HoverColor
        HoverBox.BackgroundTransparency = 1
        HoverBox.BorderSizePixel = 0
        HoverBox.ZIndex = 0
        HoverBox.Parent = button
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = HoverBox
        
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
        Tooltip.BackgroundTransparency = 1
        Tooltip.AnchorPoint = Vector2.new(0.5, 0)
        Tooltip.Position = UDim2.new(0.5, 0, 1, 4)
        Tooltip.Size = UDim2.new(0, 0, 0, 18)
        Tooltip.AutomaticSize = Enum.AutomaticSize.X
        Tooltip.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Tooltip.Text = text
        Tooltip.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        Tooltip.TextSize = 12
        Tooltip.TextTransparency = 1
        Tooltip.ZIndex = 10
        Tooltip.Visible = false
        Tooltip.Parent = button
        
        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip
        
        local TooltipPadding = Instance.new("UIPadding")
        TooltipPadding.PaddingLeft = UDim.new(0, 6)
        TooltipPadding.PaddingRight = UDim.new(0, 6)
        TooltipPadding.Parent = Tooltip
        
        local TooltipStroke = Instance.new("UIStroke")
        TooltipStroke.Color = Color3.new(0.216, 0.216, 0.216)
        TooltipStroke.Transparency = 1
        TooltipStroke.Parent = Tooltip
        
        local icon = button:FindFirstChildOfClass("ImageLabel")
        if icon then icon.Active = false end
        
        maid:GiveTask(button.MouseEnter:Connect(function()
            Tween(HoverBox, TweenInfoObj, {BackgroundTransparency = 0})
            Tooltip.Visible = true
            Tween(Tooltip, TweenInfoObj, {TextTransparency = 0, BackgroundTransparency = 0})
            Tween(TooltipStroke, TweenInfoObj, {Transparency = 0})
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = 0}) end
        end))
        
        maid:GiveTask(button.MouseLeave:Connect(function()
            Tween(HoverBox, TweenInfoObj, {BackgroundTransparency = 1})
            local t1 = Tween(Tooltip, TweenInfoObj, {TextTransparency = 1, BackgroundTransparency = 1})
            Tween(TooltipStroke, TweenInfoObj, {Transparency = 1})
            
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
    SearchInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
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
        SearchInput = SearchInput,
        AccountBtn = Account
    }
end



-- [[ Core/Topbar.luau ]] --




local Topbar = {}

function Topbar.Create(Main, Config, maid)
    local Title = Config.Title or "Volt - 1.0.0"
    
    local TopbarFrame = Instance.new("Frame")
    TopbarFrame.Name = "Topbar"
    TopbarFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
    TopbarFrame.BorderColor3 = Color3.new(0, 0, 0)
    TopbarFrame.BorderSizePixel = 0
    TopbarFrame.Size = UDim2.new(1, 0, 0, 30)
    TopbarFrame.Parent = Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.BottomLeftRadius = UDim.new(0, 0)
    TopbarCorner.BottomRightRadius = UDim.new(0, 0)
    TopbarCorner.Parent = TopbarFrame
    
    local TopbarBorder = Instance.new("Frame")
    TopbarBorder.Name = "Border"
    TopbarBorder.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
    TopbarBorder.BorderSizePixel = 0
    TopbarBorder.Position = UDim2.new(0, 0, 1, -1)
    TopbarBorder.Size = UDim2.new(1, 0, 0, 1)
    TopbarBorder.Parent = TopbarFrame
    
    local TopbarIcon = Instance.new("Frame")
    TopbarIcon.Name = "Icon"
    TopbarIcon.AnchorPoint = Vector2.new(0, 0.5)
    TopbarIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    TopbarIcon.BackgroundTransparency = 1
    TopbarIcon.BorderColor3 = Color3.new(0, 0, 0)
    TopbarIcon.BorderSizePixel = 0
    TopbarIcon.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarIcon.Size = UDim2.new(0, 30, 0, 30)
    TopbarIcon.Parent = TopbarFrame
    
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
    Actions.AnchorPoint = Vector2.new(1, 0)
    Actions.BackgroundColor3 = Color3.new(1, 1, 1)
    Actions.BackgroundTransparency = 1
    Actions.BorderColor3 = Color3.new(0, 0, 0)
    Actions.BorderSizePixel = 0
    Actions.Position = UDim2.new(1, 0, 0, 0)
    Actions.Size = UDim2.new(0, 114, 0, 30)
    Actions.Parent = TopbarFrame
    
    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsLayout.Parent = Actions
    
    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.AutoButtonColor = false
    Minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Minimize.BackgroundTransparency = 1
    Minimize.BorderColor3 = Color3.new(0, 0, 0)
    Minimize.BorderSizePixel = 0
    Minimize.Size = UDim2.new(0, 37, 0, 30)
    Minimize.Text = ""
    Minimize.Parent = Actions
    
    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.Active = false
    MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.BorderColor3 = Color3.new(0, 0, 0)
    MinimizeIcon.BorderSizePixel = 0
    MinimizeIcon.Image = "rbxassetid://109304937949559"
    MinimizeIcon.ImageTransparency = 0.3
    MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinimizeIcon.Size = UDim2.new(0, 30, 0, 30)
    MinimizeIcon.Parent = Minimize
    
    local Fullscreen = Instance.new("TextButton")
    Fullscreen.Name = "Fullscreen"
    Fullscreen.AutoButtonColor = false
    Fullscreen.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Fullscreen.BackgroundTransparency = 1
    Fullscreen.BorderColor3 = Color3.new(0, 0, 0)
    Fullscreen.BorderSizePixel = 0
    Fullscreen.LayoutOrder = 1
    Fullscreen.Size = UDim2.new(0, 37, 0, 30)
    Fullscreen.Text = ""
    Fullscreen.Parent = Actions
    
    local FullscreenIcon = Instance.new("ImageLabel")
    FullscreenIcon.Active = false
    FullscreenIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FullscreenIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    FullscreenIcon.BackgroundTransparency = 1
    FullscreenIcon.BorderColor3 = Color3.new(0, 0, 0)
    FullscreenIcon.BorderSizePixel = 0
    FullscreenIcon.Image = "rbxassetid://89144063792928"
    FullscreenIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    FullscreenIcon.Size = UDim2.new(0, 23, 0, 23)
    FullscreenIcon.Parent = Fullscreen
    
    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.AutoButtonColor = false
    Close.BackgroundColor3 = Color3.fromRGB(235, 70, 70)
    Close.BackgroundTransparency = 1
    Close.BorderColor3 = Color3.new(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.LayoutOrder = 2
    Close.Size = UDim2.new(0, 40, 0, 30)
    Close.Text = ""
    Close.Parent = Actions
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 0)
    CloseCorner.TopRightRadius = UDim.new(0, 8)
    CloseCorner.Parent = Close
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Active = false
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.BorderColor3 = Color3.new(0, 0, 0)
    CloseIcon.BorderSizePixel = 0
    CloseIcon.Image = "rbxassetid://121170570745612"
    CloseIcon.ImageTransparency = 0.3
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size = UDim2.new(0, 30, 0, 30)
    CloseIcon.Parent = Close
    
    local Version = Instance.new("Frame")
    Version.Name = "Version"
    Version.AnchorPoint = Vector2.new(0.5, 0.5)
    Version.BackgroundColor3 = Color3.new(1, 1, 1)
    Version.BackgroundTransparency = 1
    Version.BorderColor3 = Color3.new(0, 0, 0)
    Version.BorderSizePixel = 0
    Version.Position = UDim2.new(0.5, 0, 0.5, 0)
    Version.Size = UDim2.new(0, 100, 0, 30)
    Version.Parent = TopbarFrame
    
    local VersionText = Instance.new("TextLabel")
    VersionText.Name = "Text"
    VersionText.BackgroundColor3 = Color3.new(1, 1, 1)
    VersionText.BackgroundTransparency = 1
    VersionText.BorderColor3 = Color3.new(0, 0, 0)
    VersionText.BorderSizePixel = 0
    VersionText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    VersionText.Size = UDim2.new(1, 0, 1, 0)
    VersionText.Text = Title
    VersionText.TextColor3 = Color3.new(0.537, 0.537, 0.537)
    VersionText.TextSize = 13
    VersionText.Parent = Version
    
    local TweenInfoObj = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function ApplyHover(button, text, hoverColor)
        button.AutoButtonColor = false
        button.BackgroundTransparency = 1
        
        local HoverBox = Instance.new("Frame")
        HoverBox.Name = "HoverBox"
        HoverBox.AnchorPoint = Vector2.new(0.5, 0.5)
        HoverBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        HoverBox.Size = UDim2.new(1, 0, 1, 0)
        HoverBox.BackgroundColor3 = hoverColor
        HoverBox.BackgroundTransparency = 1
        HoverBox.BorderSizePixel = 0
        HoverBox.ZIndex = 0
        HoverBox.Parent = button
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = button.Name == "Close" and UDim.new(0, 0) or UDim.new(0, 6)
        if button.Name == "Close" then
            Corner.TopRightRadius = UDim.new(0, 8)
        end
        Corner.Parent = HoverBox
        
        local Tooltip = Instance.new("TextLabel")
        Tooltip.Name = "Tooltip"
        Tooltip.BackgroundColor3 = Color3.new(0.075, 0.075, 0.075)
        Tooltip.BackgroundTransparency = 1
        Tooltip.AnchorPoint = Vector2.new(0.5, 0)
        Tooltip.Position = UDim2.new(0.5, 0, 1, 4)
        Tooltip.Size = UDim2.new(0, 0, 0, 18)
        Tooltip.AutomaticSize = Enum.AutomaticSize.X
        Tooltip.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Tooltip.Text = text
        Tooltip.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        Tooltip.TextSize = 12
        Tooltip.TextTransparency = 1
        Tooltip.ZIndex = 10
        Tooltip.Visible = false
        Tooltip.Parent = button
        
        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip
        
        local TooltipPadding = Instance.new("UIPadding")
        TooltipPadding.PaddingLeft = UDim.new(0, 6)
        TooltipPadding.PaddingRight = UDim.new(0, 6)
        TooltipPadding.Parent = Tooltip
        
        local TooltipStroke = Instance.new("UIStroke")
        TooltipStroke.Color = Color3.new(0.216, 0.216, 0.216)
        TooltipStroke.Transparency = 1
        TooltipStroke.Parent = Tooltip
        
        local icon = button:FindFirstChildOfClass("ImageLabel")
        if icon then icon.Active = false end
        
        -- State tracking for hover to prevent flicker when moving quickly
        local isHovering = false
        
        maid:GiveTask(button.MouseEnter:Connect(function()
            isHovering = true
            Tooltip.Visible = true
            Tween(HoverBox, TweenInfoObj, {BackgroundTransparency = 0})
            Tween(Tooltip, TweenInfoObj, {BackgroundTransparency = 0, TextTransparency = 0})
            Tween(TooltipStroke, TweenInfoObj, {Transparency = 0})
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = 0}) end
        end))
        
        maid:GiveTask(button.MouseLeave:Connect(function()
            isHovering = false
            Tween(HoverBox, TweenInfoObj, {BackgroundTransparency = 1})
            Tween(Tooltip, TweenInfoObj, {BackgroundTransparency = 1, TextTransparency = 1})
            Tween(TooltipStroke, TweenInfoObj, {Transparency = 1})
            if icon then Tween(icon, TweenInfoObj, {ImageTransparency = 0.3}) end
            task.delay(0.2, function()
                if not isHovering then
                    Tooltip.Visible = false
                end
            end)
        end))
    end
    
    ApplyHover(Minimize, "Minimize", Color3.fromRGB(45, 45, 45))
    ApplyHover(Fullscreen, "Fullscreen", Color3.fromRGB(45, 45, 45))
    ApplyHover(Close, "Close", Color3.fromRGB(235, 70, 70))
    
    Utility.MakeDraggable(TopbarFrame, Main, maid)
    
    return {
        Instance = TopbarFrame,
        CloseButton = Close,
        MinimizeButton = Minimize,
        FullscreenButton = Fullscreen
    }
end



-- [[ Core/Theme.luau ]] --


-- [[ Core/Tabs.luau ]] --



local Tabs = {}
Tabs.ActiveTab = nil
Tabs.Instances = {}

function Tabs.CreateTab(WindowObject, Name, IconAsset)
    local SidebarContainer = WindowObject.Sidebar.TabsContainer
    local ContentContainer = WindowObject.ContentContainer
    local Maid = WindowObject.Maid
    
    local isFirstTab = (#Tabs.Instances == 0)
    
    -- 1. Create the Tab Button in Sidebar
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = Name
    TabBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, -20, 0, 32)
    TabBtn.Position = UDim2.new(0, 10, 0, 0)
    TabBtn.Text = ""
    TabBtn.Parent = SidebarContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.BackgroundTransparency = 1
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.AnchorPoint = Vector2.new(0, 0.5)
    TabIcon.Position = UDim2.new(0, 12, 0.5, 0)
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
    
    local function ActivateTab()
        if Tabs.ActiveTab == TabObj then return end
        
        for _, otherTab in ipairs(Tabs.Instances) do
            otherTab.Content.Visible = false
            Tween(otherTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(otherTab.Button:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.2), {TextColor3 = Color3.new(0.6, 0.6, 0.6)})
            Tween(otherTab.Button:FindFirstChildOfClass("ImageLabel"), TweenInfo.new(0.2), {ImageColor3 = Color3.new(0.6, 0.6, 0.6)})
        end
        
        Tabs.ActiveTab = TabObj
        TabContent.Visible = true
        
        Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95})
        Tween(TabTitle, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)})
        Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1, 1, 1)})
    end
    
    Maid:GiveTask(TabBtn.MouseButton1Click:Connect(ActivateTab))
    
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
    
    if isFirstTab then
        ActivateTab()
    end
    
    local TabMethods = {}
    
    function TabMethods:CreateButton(Config)
        local btnConfig = type(Config) == "string" and {Name = Config} or Config
        local btnName = btnConfig.Name or "Button"
        local cb = btnConfig.Callback or function() end
        
        local BtnFrame = Instance.new("Frame")
        BtnFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        BtnFrame.Size = UDim2.new(1, 0, 0, 42)
        BtnFrame.Parent = TabContent
        Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", BtnFrame).Color = Color3.new(0.15, 0.15, 0.15)
        
        local Title = Instance.new("TextLabel")
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, -20, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Title.Text = btnName
        Title.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = BtnFrame
        
        local ClickBtn = Instance.new("TextButton")
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Size = UDim2.new(1, 0, 1, 0)
        ClickBtn.Text = ""
        ClickBtn.Parent = BtnFrame
        
        Maid:GiveTask(ClickBtn.MouseButton1Click:Connect(function()
            cb()
        end))
        
        Maid:GiveTask(ClickBtn.MouseEnter:Connect(function()
            Tween(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)})
            Tween(BtnFrame:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Color = Color3.new(0.2, 0.2, 0.2)})
        end))
        
        Maid:GiveTask(ClickBtn.MouseLeave:Connect(function()
            Tween(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)})
            Tween(BtnFrame:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Color = Color3.new(0.15, 0.15, 0.15)})
        end))
        
        Maid:GiveTask(ClickBtn.MouseButton1Down:Connect(function()
            Tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)})
        end))
        
        Maid:GiveTask(ClickBtn.MouseButton1Up:Connect(function()
            Tween(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)})
        end))
        
        return BtnFrame
    end
    
    return TabMethods
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
    
    Main.Visible = false
    
    local AccountPageElements
    AccountPageElements = AccountPage.Create(PagesContainer, maid, function()
        PageLayout:JumpTo(Content)
    end, Api)

    local function OnLoginSuccess()
        Main.Visible = true
        if AccountPageElements and Api.UserData then
            AccountPageElements.UpdateData(Api.UserData)
        end
    end

    local token = Api.GetToken()
    if token then
        task.spawn(function()
            local data = Api.FetchMe()
            if data then
                OnLoginSuccess()
            else
                LoginPage.Create(VoltUi, OnLoginSuccess)
            end
        end)
    else
        LoginPage.Create(VoltUi, OnLoginSuccess)
    end
    
    maid:GiveTask(SidebarElements.AccountBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(AccountPageElements.Instance)
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
    
    function WindowObject:CreateTab(Name, IconAsset)
        return Tabs.CreateTab(WindowObject, Name, IconAsset)
    end
    
    Utility.ProtectGui(VoltUi)
    
    return WindowObject
end



-- [[ Library.luau ]] --
local Library = {}


function Library:CreateWindow(Config)
    return Window:CreateWindow(Config)
end




local Window = Library:CreateWindow({
    Name = "VoltUi",
    LoadingTitle = "VoltUi Interface",
    LoadingSubtitle = "by L5ks8",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VoltUiTest",
        FileName = "Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "VoltUi",
        Subtitle = "Key System",
        Note = "Bitte gib deinen Key ein (z.B. Voltontop)",
        FileName = "VoltKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = "Voltontop"
    }
})

local MainTab = Window:CreateTab("Main", "rbxassetid://4483345998")

local Button = MainTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Erfolg! Die UI funktioniert!")
    end
})

