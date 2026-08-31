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

function Api.RedeemKey(key)
    if not Api.GetToken() then return false, "Not authenticated" end
    local res = Api.Request("/user/redeem", "POST", { licenseKey = key, key = key })
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
    local iconAsset = isError and "rbxassetid://85824584748112" or "rbxassetid://10651060934"
    
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

function AccountPage.Create(Content, Maid, BackCallback, Api)
    local Page = Instance.new("Frame")
    Page.Name = "AccountPage"
    Page.AnchorPoint = Vector2.new(0.5, 0.5)
    Page.BackgroundColor3 = Color3.new(0.067, 0.067, 0.067)
    Page.BorderColor3 = Color3.new(0, 0, 0)
    Page.BorderSizePixel = 0
    Page.Position = UDim2.new(0.5, 0, 0.518, 0)
    Page.Size = UDim2.new(0, 800, 0, 570)
    Page.LayoutOrder = 2
    Page.Parent = Content

    local PageCorner = Instance.new("UICorner")
    PageCorner.CornerRadius = UDim.new(0, 0)
    PageCorner.Parent = Page

    local PageStroke = Instance.new("UIStroke")
    PageStroke.Color = Color3.new(0.353, 0.353, 0.353)
    PageStroke.Parent = Page

    local Actions = Instance.new("Frame")
    Actions.Name = "Actions"
    Actions.BackgroundColor3 = Color3.new(1, 1, 1)
    Actions.BackgroundTransparency = 1
    Actions.BorderColor3 = Color3.new(0, 0, 0)
    Actions.BorderSizePixel = 0
    Actions.Size = UDim2.new(0, 800, 0, 35)
    Actions.Parent = Page

    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
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
    ReturnButton.Size = UDim2.new(0, 35, 0, 35)
    ReturnButton.Parent = Actions

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

    local AccountText = Instance.new("TextLabel")
    AccountText.BackgroundColor3 = Color3.new(1, 1, 1)
    AccountText.BackgroundTransparency = 1
    AccountText.BorderColor3 = Color3.new(0, 0, 0)
    AccountText.BorderSizePixel = 0
    AccountText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    AccountText.Size = UDim2.new(0, 200, 0, 35)
    AccountText.Text = "Account"
    AccountText.TextColor3 = Color3.new(0.71, 0.71, 0.71)
    AccountText.TextSize = 14
    AccountText.TextXAlignment = Enum.TextXAlignment.Left
    AccountText.Parent = Actions

    local AccountTextPadding = Instance.new("UIPadding")
    AccountTextPadding.PaddingLeft = UDim.new(0, 5)
    AccountTextPadding.Parent = AccountText

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderColor3 = Color3.new(0, 0, 0)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.LayoutOrder = 1
    ContentFrame.Position = UDim2.new(0, 0, 0.061, 0)
    ContentFrame.Size = UDim2.new(0, 800, 0, 535)
    ContentFrame.Parent = Page

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContentLayout.Parent = ContentFrame

    local AccountPageFrame = Instance.new("Frame")
    AccountPageFrame.Name = "AccountPage"
    AccountPageFrame.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    AccountPageFrame.BorderColor3 = Color3.new(0, 0, 0)
    AccountPageFrame.BorderSizePixel = 0
    AccountPageFrame.Position = UDim2.new(0.038, 0, 0.03, 0)
    AccountPageFrame.Size = UDim2.new(0, 770, 0, 505)
    AccountPageFrame.Parent = ContentFrame

    local AccountPageCorner = Instance.new("UICorner")
    AccountPageCorner.Parent = AccountPageFrame

    local AccountPageStroke = Instance.new("UIStroke")
    AccountPageStroke.Color = Color3.new(0.149, 0.149, 0.149)
    AccountPageStroke.Parent = AccountPageFrame

    local AccountPageLayout = Instance.new("UIListLayout")
    AccountPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    AccountPageLayout.Parent = AccountPageFrame

    local Userinfo = Instance.new("Frame")
    Userinfo.Name = "Userinfo"
    Userinfo.BackgroundColor3 = Color3.new(1, 1, 1)
    Userinfo.BackgroundTransparency = 1
    Userinfo.BorderColor3 = Color3.new(0, 0, 0)
    Userinfo.BorderSizePixel = 0
    Userinfo.Size = UDim2.new(0, 770, 0, 80)
    Userinfo.Parent = AccountPageFrame

    local UserinfoCorner = Instance.new("UICorner")
    UserinfoCorner.BottomLeftRadius = UDim.new(0, 0)
    UserinfoCorner.BottomRightRadius = UDim.new(0, 0)
    UserinfoCorner.Parent = Userinfo

    local UserinfoStroke = Instance.new("UIStroke")
    UserinfoStroke.Color = Color3.new(0.149, 0.149, 0.149)
    UserinfoStroke.Parent = Userinfo

    local UserinfoLayout = Instance.new("UIListLayout")
    UserinfoLayout.FillDirection = Enum.FillDirection.Horizontal
    UserinfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UserinfoLayout.Parent = Userinfo

    local Profile = Instance.new("Frame")
    Profile.Name = "Profile"
    Profile.BackgroundColor3 = Color3.new(1, 1, 1)
    Profile.BackgroundTransparency = 1
    Profile.BorderColor3 = Color3.new(0, 0, 0)
    Profile.BorderSizePixel = 0
    Profile.Size = UDim2.new(0, 80, 0, 80)
    Profile.Parent = Userinfo

    local ProfileLayout = Instance.new("UIListLayout")
    ProfileLayout.FillDirection = Enum.FillDirection.Horizontal
    ProfileLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ProfileLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ProfileLayout.Parent = Profile

    local ProfileImage = Instance.new("ImageButton")
    ProfileImage.Name = "Frame"
    ProfileImage.Active = false
    ProfileImage.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
    ProfileImage.BorderColor3 = Color3.new(0, 0, 0)
    ProfileImage.BorderSizePixel = 0
    ProfileImage.Selectable = false
    ProfileImage.Size = UDim2.new(0, 50, 0, 50)
    ProfileImage.Parent = Profile

    local ProfileImageCorner = Instance.new("UICorner")
    ProfileImageCorner.Parent = ProfileImage

    local ProfileImageStroke = Instance.new("UIStroke")
    ProfileImageStroke.Color = Color3.new(0.31, 0.31, 0.31)
    ProfileImageStroke.Parent = ProfileImage

    local Info = Instance.new("Frame")
    Info.Name = "Info"
    Info.BackgroundColor3 = Color3.new(1, 1, 1)
    Info.BackgroundTransparency = 1
    Info.BorderColor3 = Color3.new(0, 0, 0)
    Info.BorderSizePixel = 0
    Info.Position = UDim2.new(0.104, 0, 0, 0)
    Info.Size = UDim2.new(0, 500, 0, 80)
    Info.Parent = Userinfo

    local InfoLayoutInner = Instance.new("UIListLayout")
    InfoLayoutInner.FillDirection = Enum.FillDirection.Horizontal
    InfoLayoutInner.HorizontalAlignment = Enum.HorizontalAlignment.Center
    InfoLayoutInner.SortOrder = Enum.SortOrder.LayoutOrder
    InfoLayoutInner.VerticalAlignment = Enum.VerticalAlignment.Center
    InfoLayoutInner.Parent = Info

    local InfoContainer = Instance.new("Frame")
    InfoContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    InfoContainer.BackgroundTransparency = 1
    InfoContainer.BorderColor3 = Color3.new(0, 0, 0)
    InfoContainer.BorderSizePixel = 0
    InfoContainer.Size = UDim2.new(0, 500, 0, 50)
    InfoContainer.Parent = Info

    local InfoContainerLayout = Instance.new("UIListLayout")
    InfoContainerLayout.FillDirection = Enum.FillDirection.Horizontal
    InfoContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InfoContainerLayout.Parent = InfoContainer

    local TextContainer = Instance.new("Frame")
    TextContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    TextContainer.BackgroundTransparency = 1
    TextContainer.BorderColor3 = Color3.new(0, 0, 0)
    TextContainer.BorderSizePixel = 0
    TextContainer.Size = UDim2.new(0, 150, 0, 50)
    TextContainer.Parent = InfoContainer

    local TextContainerLayout = Instance.new("UIListLayout")
    TextContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextContainerLayout.Parent = TextContainer

    local UsernameContainer = Instance.new("Frame")
    UsernameContainer.Name = "UsernameContainer"
    UsernameContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    UsernameContainer.BackgroundTransparency = 1
    UsernameContainer.BorderColor3 = Color3.new(0, 0, 0)
    UsernameContainer.BorderSizePixel = 0
    UsernameContainer.Size = UDim2.new(1, 0, 0, 25)
    UsernameContainer.Parent = TextContainer
    
    local UsernameContainerLayout = Instance.new("UIListLayout")
    UsernameContainerLayout.FillDirection = Enum.FillDirection.Horizontal
    UsernameContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UsernameContainerLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UsernameContainerLayout.Padding = UDim.new(0, 8)
    UsernameContainerLayout.Parent = UsernameContainer

    local Username = Instance.new("TextLabel")
    Username.Name = "Name"
    Username.BackgroundColor3 = Color3.new(1, 1, 1)
    Username.BackgroundTransparency = 1
    Username.BorderColor3 = Color3.new(0, 0, 0)
    Username.BorderSizePixel = 0
    Username.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Username.AutomaticSize = Enum.AutomaticSize.XY
    Username.Size = UDim2.new(0, 0, 0, 25)
    Username.Text = "Username"
    Username.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Username.TextSize = 20
    Username.TextXAlignment = Enum.TextXAlignment.Left
    Username.TextYAlignment = Enum.TextYAlignment.Bottom
    Username.Parent = UsernameContainer

    local HiddenId = Instance.new("TextBox")
    HiddenId.Name = "HiddenId"
    HiddenId.BackgroundColor3 = Color3.new(1, 1, 1)
    HiddenId.BackgroundTransparency = 1
    HiddenId.BorderColor3 = Color3.new(0, 0, 0)
    HiddenId.BorderSizePixel = 0
    HiddenId.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    HiddenId.AutomaticSize = Enum.AutomaticSize.XY
    HiddenId.Size = UDim2.new(0, 0, 0, 22)
    HiddenId.Text = "********"
    HiddenId.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    HiddenId.TextSize = 14
    HiddenId.TextXAlignment = Enum.TextXAlignment.Left
    HiddenId.TextYAlignment = Enum.TextYAlignment.Bottom
    HiddenId.TextEditable = false
    HiddenId.ClearTextOnFocus = false
    HiddenId.Parent = UsernameContainer

    local MemberSince = Instance.new("TextLabel")
    MemberSince.Name = "MemberSince"
    MemberSince.BackgroundColor3 = Color3.new(1, 1, 1)
    MemberSince.BackgroundTransparency = 1
    MemberSince.BorderColor3 = Color3.new(0, 0, 0)
    MemberSince.BorderSizePixel = 0
    MemberSince.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    MemberSince.Size = UDim2.new(0, 150, 0, 25)
    MemberSince.Text = "Member since Jul 24, 2026"
    MemberSince.TextColor3 = Color3.new(0.439, 0.439, 0.439)
    MemberSince.TextSize = 14
    MemberSince.TextXAlignment = Enum.TextXAlignment.Left
    MemberSince.Parent = TextContainer

    local License = Instance.new("Frame")
    License.Name = "License"
    License.BackgroundColor3 = Color3.new(1, 1, 1)
    License.BackgroundTransparency = 1
    License.BorderColor3 = Color3.new(0, 0, 0)
    License.BorderSizePixel = 0
    License.LayoutOrder = 1
    License.Position = UDim2.new(0, 0, 0.158, 0)
    License.Size = UDim2.new(0, 770, 0, 280)
    License.Parent = AccountPageFrame

    local LicenseStroke = Instance.new("UIStroke")
    LicenseStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    LicenseStroke.Color = Color3.new(0.149, 0.149, 0.149)
    LicenseStroke.Parent = License

    local LicenseLayout = Instance.new("UIListLayout")
    LicenseLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LicenseLayout.Parent = License

    local LicenseHeader = Instance.new("Frame")
    LicenseHeader.BackgroundColor3 = Color3.new(1, 1, 1)
    LicenseHeader.BackgroundTransparency = 1
    LicenseHeader.BorderColor3 = Color3.new(0, 0, 0)
    LicenseHeader.BorderSizePixel = 0
    LicenseHeader.Size = UDim2.new(0, 770, 0, 50)
    LicenseHeader.Parent = License

    local LicenseHeaderStroke = Instance.new("UIStroke")
    LicenseHeaderStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    LicenseHeaderStroke.Color = Color3.new(0.149, 0.149, 0.149)
    LicenseHeaderStroke.Parent = LicenseHeader

    local LicenseHeaderLayout = Instance.new("UIListLayout")
    LicenseHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    LicenseHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LicenseHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LicenseHeaderLayout.Parent = LicenseHeader

    local LicenseInfo = Instance.new("Frame")
    LicenseInfo.Name = "Info"
    LicenseInfo.BackgroundColor3 = Color3.new(1, 1, 1)
    LicenseInfo.BackgroundTransparency = 1
    LicenseInfo.BorderColor3 = Color3.new(0, 0, 0)
    LicenseInfo.BorderSizePixel = 0
    LicenseInfo.Size = UDim2.new(0, 220, 0, 50)
    LicenseInfo.Parent = LicenseHeader

    local LicenseInfoLayout = Instance.new("UIListLayout")
    LicenseInfoLayout.FillDirection = Enum.FillDirection.Horizontal
    LicenseInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LicenseInfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LicenseInfoLayout.Parent = LicenseInfo

    local LicenseIcon = Instance.new("ImageLabel")
    LicenseIcon.Name = "Icon"
    LicenseIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    LicenseIcon.BackgroundTransparency = 1
    LicenseIcon.BorderColor3 = Color3.new(0, 0, 0)
    LicenseIcon.BorderSizePixel = 0
    LicenseIcon.Image = "rbxassetid://74647898678278"
    LicenseIcon.Size = UDim2.new(0, 35, 0, 35)
    LicenseIcon.Parent = LicenseInfo

    local LicenseInfoPadding = Instance.new("UIPadding")
    LicenseInfoPadding.PaddingLeft = UDim.new(0, 9)
    LicenseInfoPadding.Parent = LicenseInfo

    local LicenseText = Instance.new("Frame")
    LicenseText.Name = "Text"
    LicenseText.BackgroundColor3 = Color3.new(1, 1, 1)
    LicenseText.BackgroundTransparency = 1
    LicenseText.BorderColor3 = Color3.new(0, 0, 0)
    LicenseText.BorderSizePixel = 0
    LicenseText.Position = UDim2.new(0.142, 0, 0, 0)
    LicenseText.Size = UDim2.new(0, 181, 0, 50)
    LicenseText.Parent = LicenseInfo

    local LicenseTextLayout = Instance.new("UIListLayout")
    LicenseTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LicenseTextLayout.Parent = LicenseText

    local LicensesLabel = Instance.new("TextLabel")
    LicensesLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    LicensesLabel.BackgroundTransparency = 1
    LicensesLabel.BorderColor3 = Color3.new(0, 0, 0)
    LicensesLabel.BorderSizePixel = 0
    LicensesLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LicensesLabel.Size = UDim2.new(0, 200, 0, 25)
    LicensesLabel.Text = "Licenses"
    LicensesLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    LicensesLabel.TextSize = 16
    LicensesLabel.TextXAlignment = Enum.TextXAlignment.Left
    LicensesLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    LicensesLabel.Parent = LicenseText

    local LicensesDesc = Instance.new("TextLabel")
    LicensesDesc.BackgroundColor3 = Color3.new(1, 1, 1)
    LicensesDesc.BackgroundTransparency = 1
    LicensesDesc.BorderColor3 = Color3.new(0, 0, 0)
    LicensesDesc.BorderSizePixel = 0
    LicensesDesc.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    LicensesDesc.Size = UDim2.new(0, 200, 0, 25)
    LicensesDesc.Text = "Subscription and Claimed keys"
    LicensesDesc.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    LicensesDesc.TextSize = 15
    LicensesDesc.TextXAlignment = Enum.TextXAlignment.Left
    LicensesDesc.TextYAlignment = Enum.TextYAlignment.Top
    LicensesDesc.Parent = LicenseText

    local LicenseTextPadding = Instance.new("UIPadding")
    LicenseTextPadding.PaddingLeft = UDim.new(0, 5)
    LicenseTextPadding.Parent = LicenseText

    local Redeem = Instance.new("Frame")
    Redeem.Name = "Redeem"
    Redeem.BackgroundColor3 = Color3.new(1, 1, 1)
    Redeem.BackgroundTransparency = 1
    Redeem.BorderColor3 = Color3.new(0, 0, 0)
    Redeem.BorderSizePixel = 0
    Redeem.Position = UDim2.new(0.286, 0, 0, 0)
    Redeem.Size = UDim2.new(0, 550, 0, 50)
    Redeem.Parent = LicenseHeader

    local RedeemLayout = Instance.new("UIListLayout")
    RedeemLayout.FillDirection = Enum.FillDirection.Horizontal
    RedeemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RedeemLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RedeemLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RedeemLayout.Parent = Redeem

    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "Input"
    InputFrame.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    InputFrame.BorderColor3 = Color3.new(0, 0, 0)
    InputFrame.BorderSizePixel = 0
    InputFrame.Position = UDim2.new(0.236, 0, 0, 0)
    InputFrame.Size = UDim2.new(0, 320, 0, 35)
    InputFrame.Parent = Redeem

    local InputCorner = Instance.new("UICorner")
    InputCorner.Parent = InputFrame

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.new(0.208, 0.208, 0.208)
    InputStroke.Parent = InputFrame

    local TextBox = Instance.new("TextBox")
    TextBox.BackgroundColor3 = Color3.new(1, 1, 1)
    TextBox.BackgroundTransparency = 1
    TextBox.BorderColor3 = Color3.new(0, 0, 0)
    TextBox.BorderSizePixel = 0
    TextBox.CursorPosition = -1
    TextBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextBox.Size = UDim2.new(1, 0, 1, 0)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    TextBox.TextSize = 17
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.Parent = InputFrame

    local TextBoxPadding = Instance.new("UIPadding")
    TextBoxPadding.PaddingLeft = UDim.new(0, 7)
    TextBoxPadding.Parent = TextBox

    local ClaimFrame = Instance.new("Frame")
    ClaimFrame.Name = "Claim"
    ClaimFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    ClaimFrame.BackgroundTransparency = 1
    ClaimFrame.BorderColor3 = Color3.new(0, 0, 0)
    ClaimFrame.BorderSizePixel = 0
    ClaimFrame.LayoutOrder = 1
    ClaimFrame.Size = UDim2.new(0, 100, 0, 50)
    ClaimFrame.Parent = Redeem

    local ClaimFrameLayout = Instance.new("UIListLayout")
    ClaimFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    ClaimFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ClaimFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ClaimFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ClaimFrameLayout.Parent = ClaimFrame

    local ClaimButtonFrame = Instance.new("Frame")
    ClaimButtonFrame.Name = "Button"
    ClaimButtonFrame.Active = true
    ClaimButtonFrame.BackgroundColor3 = Color3.new(0.149, 0.149, 0.149)
    ClaimButtonFrame.BorderColor3 = Color3.new(0.298, 0.298, 0.298)
    ClaimButtonFrame.BorderSizePixel = 0
    ClaimButtonFrame.Selectable = true
    ClaimButtonFrame.Size = UDim2.new(0, 70, 0, 35)
    ClaimButtonFrame.Parent = ClaimFrame

    local ClaimButtonFrameCorner = Instance.new("UICorner")
    ClaimButtonFrameCorner.Parent = ClaimButtonFrame

    local ClaimButtonFrameStroke = Instance.new("UIStroke")
    ClaimButtonFrameStroke.Color = Color3.new(0.247, 0.247, 0.247)
    ClaimButtonFrameStroke.Parent = ClaimButtonFrame

    local ClaimButton = Instance.new("TextButton")
    ClaimButton.BackgroundColor3 = Color3.new(0.149, 0.149, 0.149)
    ClaimButton.BorderColor3 = Color3.new(0.298, 0.298, 0.298)
    ClaimButton.BorderSizePixel = 0
    ClaimButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ClaimButton.Size = UDim2.new(0, 70, 0, 35)
    ClaimButton.Text = "Claim"
    ClaimButton.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ClaimButton.TextSize = 16
    ClaimButton.Parent = ClaimButtonFrame

    local ClaimButtonCorner = Instance.new("UICorner")
    ClaimButtonCorner.Parent = ClaimButton

    local DetailsFrame = Instance.new("Frame")
    DetailsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    DetailsFrame.BackgroundTransparency = 1
    DetailsFrame.BorderColor3 = Color3.new(0, 0, 0)
    DetailsFrame.BorderSizePixel = 0
    DetailsFrame.Position = UDim2.new(0, 0, 0.179, 0)
    DetailsFrame.Size = UDim2.new(0, 770, 0, 230)
    DetailsFrame.Parent = License

    local DetailsFrameLayout = Instance.new("UIListLayout")
    DetailsFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    DetailsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DetailsFrameLayout.Parent = DetailsFrame

    local StatusFrame = Instance.new("Frame")
    StatusFrame.Name = "Status"
    StatusFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusFrame.BackgroundTransparency = 1
    StatusFrame.BorderColor3 = Color3.new(0, 0, 0)
    StatusFrame.BorderSizePixel = 0
    StatusFrame.Size = UDim2.new(0, 200, 0, 230)
    StatusFrame.Parent = DetailsFrame

    local StatusFrameLayout = Instance.new("UIListLayout")
    StatusFrameLayout.FillDirection = Enum.FillDirection.Horizontal
    StatusFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    StatusFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatusFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StatusFrameLayout.Parent = StatusFrame

    local StatusInner = Instance.new("Frame")
    StatusInner.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusInner.BackgroundTransparency = 1
    StatusInner.BorderColor3 = Color3.new(0, 0, 0)
    StatusInner.BorderSizePixel = 0
    StatusInner.Size = UDim2.new(0, 190, 0, 210)
    StatusInner.Parent = StatusFrame

    local StatusInnerCorner = Instance.new("UICorner")
    StatusInnerCorner.Parent = StatusInner

    local StatusInnerStroke = Instance.new("UIStroke")
    StatusInnerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    StatusInnerStroke.Color = Color3.new(0.149, 0.149, 0.149)
    StatusInnerStroke.Parent = StatusInner

    local StatusInnerLayout = Instance.new("UIListLayout")
    StatusInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatusInnerLayout.Parent = StatusInner

    local StatusText = Instance.new("Frame")
    StatusText.Name = "Text"
    StatusText.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusText.BackgroundTransparency = 1
    StatusText.BorderColor3 = Color3.new(0, 0, 0)
    StatusText.BorderSizePixel = 0
    StatusText.Size = UDim2.new(0, 190, 0, 50)
    StatusText.Parent = StatusInner

    local StatusTextLayout = Instance.new("UIListLayout")
    StatusTextLayout.FillDirection = Enum.FillDirection.Horizontal
    StatusTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatusTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StatusTextLayout.Parent = StatusText

    local StatusTextInfo = Instance.new("Frame")
    StatusTextInfo.Name = "Info"
    StatusTextInfo.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusTextInfo.BackgroundTransparency = 1
    StatusTextInfo.BorderColor3 = Color3.new(0, 0, 0)
    StatusTextInfo.BorderSizePixel = 0
    StatusTextInfo.Size = UDim2.new(0.688, 0, 1, 0)
    StatusTextInfo.Parent = StatusText

    local StatusTextInfoLayout = Instance.new("UIListLayout")
    StatusTextInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatusTextInfoLayout.Parent = StatusTextInfo

    local VoltLabel = Instance.new("TextLabel")
    VoltLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    VoltLabel.BackgroundTransparency = 1
    VoltLabel.BorderColor3 = Color3.new(0, 0, 0)
    VoltLabel.BorderSizePixel = 0
    VoltLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    VoltLabel.Size = UDim2.new(0, 110, 0, 22)
    VoltLabel.Text = "Volt"
    VoltLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    VoltLabel.TextSize = 16
    VoltLabel.TextXAlignment = Enum.TextXAlignment.Left
    VoltLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    VoltLabel.Parent = StatusTextInfo

    local VoltLabelPadding = Instance.new("UIPadding")
    VoltLabelPadding.PaddingLeft = UDim.new(0, 9)
    VoltLabelPadding.Parent = VoltLabel

    local VoltSubLabel = Instance.new("TextLabel")
    VoltSubLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    VoltSubLabel.BackgroundTransparency = 1
    VoltSubLabel.BorderColor3 = Color3.new(0, 0, 0)
    VoltSubLabel.BorderSizePixel = 0
    VoltSubLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    VoltSubLabel.Size = UDim2.new(0, 110, 0, 22)
    VoltSubLabel.Text = "Current subscription"
    VoltSubLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    VoltSubLabel.TextSize = 14
    VoltSubLabel.TextXAlignment = Enum.TextXAlignment.Left
    VoltSubLabel.TextYAlignment = Enum.TextYAlignment.Top
    VoltSubLabel.Parent = StatusTextInfo

    local VoltSubLabelPadding = Instance.new("UIPadding")
    VoltSubLabelPadding.PaddingLeft = UDim.new(0, 9)
    VoltSubLabelPadding.Parent = VoltSubLabel

    local StatusBadgeFrame = Instance.new("Frame")
    StatusBadgeFrame.Name = "Status"
    StatusBadgeFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusBadgeFrame.BackgroundTransparency = 1
    StatusBadgeFrame.BorderColor3 = Color3.new(0, 0, 0)
    StatusBadgeFrame.BorderSizePixel = 0
    StatusBadgeFrame.Position = UDim2.new(0.688, 0, 0, 0)
    StatusBadgeFrame.Size = UDim2.new(0, 50, 0, 45)
    StatusBadgeFrame.Parent = StatusText

    local StatusBadgeFrameLayout = Instance.new("UIListLayout")
    StatusBadgeFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    StatusBadgeFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatusBadgeFrameLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StatusBadgeFrameLayout.Parent = StatusBadgeFrame

    local StatusBadge = Instance.new("Frame")
    StatusBadge.BackgroundColor3 = Color3.new(0.173, 0.173, 0.173)
    StatusBadge.BorderColor3 = Color3.new(0, 0, 0)
    StatusBadge.BorderSizePixel = 0
    StatusBadge.Size = UDim2.new(0, 40, 0, 20)
    StatusBadge.Parent = StatusBadgeFrame

    local StatusBadgeStroke = Instance.new("UIStroke")
    StatusBadgeStroke.Color = Color3.new(0.353, 0.353, 0.353)
    StatusBadgeStroke.Parent = StatusBadge

    local StatusBadgeCorner = Instance.new("UICorner")
    StatusBadgeCorner.BottomLeftRadius = UDim.new(0, 4)
    StatusBadgeCorner.BottomRightRadius = UDim.new(0, 4)
    StatusBadgeCorner.CornerRadius = UDim.new(0, 4)
    StatusBadgeCorner.TopLeftRadius = UDim.new(0, 4)
    StatusBadgeCorner.TopRightRadius = UDim.new(0, 4)
    StatusBadgeCorner.Parent = StatusBadge

    local StatusBadgeText = Instance.new("TextLabel")
    StatusBadgeText.BackgroundColor3 = Color3.new(1, 1, 1)
    StatusBadgeText.BackgroundTransparency = 1
    StatusBadgeText.BorderColor3 = Color3.new(0, 0, 0)
    StatusBadgeText.BorderSizePixel = 0
    StatusBadgeText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    StatusBadgeText.Size = UDim2.new(1, 0, 1, 0)
    StatusBadgeText.Text = "Active"
    StatusBadgeText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    StatusBadgeText.TextSize = 14
    StatusBadgeText.Parent = StatusBadge

    local StatsFrame = Instance.new("Frame")
    StatsFrame.Name = "Stats"
    StatsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    StatsFrame.BackgroundTransparency = 1
    StatsFrame.BorderColor3 = Color3.new(0, 0, 0)
    StatsFrame.BorderSizePixel = 0
    StatsFrame.LayoutOrder = 1
    StatsFrame.Position = UDim2.new(0, 0, 0.237, 0)
    StatsFrame.Size = UDim2.new(0, 190, 0, 160)
    StatsFrame.Parent = StatusInner

    local StatsFrameLayout = Instance.new("UIListLayout")
    StatsFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    StatsFrameLayout.Padding = UDim.new(0, 5)
    StatsFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatsFrameLayout.Parent = StatsFrame

    local RemainingFrame = Instance.new("Frame")
    RemainingFrame.Name = "Remaining"
    RemainingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    RemainingFrame.BackgroundTransparency = 1
    RemainingFrame.BorderColor3 = Color3.new(0, 0, 0)
    RemainingFrame.BorderSizePixel = 0
    RemainingFrame.Size = UDim2.new(0, 175, 0, 45)
    RemainingFrame.Parent = StatsFrame

    local RemainingCorner = Instance.new("UICorner")
    RemainingCorner.Parent = RemainingFrame

    local RemainingStroke = Instance.new("UIStroke")
    RemainingStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    RemainingStroke.Color = Color3.new(0.149, 0.149, 0.149)
    RemainingStroke.Parent = RemainingFrame

    local RemainingLayout = Instance.new("UIListLayout")
    RemainingLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RemainingLayout.Parent = RemainingFrame

    local RemainingLabel = Instance.new("TextLabel")
    RemainingLabel.Name = "Remaining"
    RemainingLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    RemainingLabel.BackgroundTransparency = 1
    RemainingLabel.BorderColor3 = Color3.new(0, 0, 0)
    RemainingLabel.BorderSizePixel = 0
    RemainingLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    RemainingLabel.Size = UDim2.new(0, 175, 0, 22)
    RemainingLabel.Text = "Remaining"
    RemainingLabel.TextColor3 = Color3.new(0.451, 0.451, 0.451)
    RemainingLabel.TextSize = 14
    RemainingLabel.TextXAlignment = Enum.TextXAlignment.Left
    RemainingLabel.Parent = RemainingFrame

    local RemainingLabelPadding = Instance.new("UIPadding")
    RemainingLabelPadding.PaddingLeft = UDim.new(0, 9)
    RemainingLabelPadding.Parent = RemainingLabel

    local RemainingValue = Instance.new("TextLabel")
    RemainingValue.Name = "Value"
    RemainingValue.BackgroundColor3 = Color3.new(1, 1, 1)
    RemainingValue.BackgroundTransparency = 1
    RemainingValue.BorderColor3 = Color3.new(0, 0, 0)
    RemainingValue.BorderSizePixel = 0
    RemainingValue.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    RemainingValue.LayoutOrder = 1
    RemainingValue.Size = UDim2.new(0, 175, 0, 22)
    RemainingValue.Text = "1 month"
    RemainingValue.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    RemainingValue.TextSize = 20
    RemainingValue.TextXAlignment = Enum.TextXAlignment.Left
    RemainingValue.TextYAlignment = Enum.TextYAlignment.Top
    RemainingValue.Parent = RemainingFrame

    local RemainingValuePadding = Instance.new("UIPadding")
    RemainingValuePadding.PaddingLeft = UDim.new(0, 9)
    RemainingValuePadding.Parent = RemainingValue

    local EndsFrame = Instance.new("Frame")
    EndsFrame.Name = "Ends"
    EndsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    EndsFrame.BackgroundTransparency = 1
    EndsFrame.BorderColor3 = Color3.new(0, 0, 0)
    EndsFrame.BorderSizePixel = 0
    EndsFrame.LayoutOrder = 2
    EndsFrame.Size = UDim2.new(0, 175, 0, 45)
    EndsFrame.Parent = StatsFrame

    local EndsStroke = Instance.new("UIStroke")
    EndsStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    EndsStroke.Color = Color3.new(0.149, 0.149, 0.149)
    EndsStroke.Parent = EndsFrame

    local EndsCorner = Instance.new("UICorner")
    EndsCorner.Parent = EndsFrame

    local EndsLayout = Instance.new("UIListLayout")
    EndsLayout.FillDirection = Enum.FillDirection.Horizontal
    EndsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    EndsLayout.Parent = EndsFrame

    local EndsIconFrame = Instance.new("Frame")
    EndsIconFrame.Name = "Icon"
    EndsIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    EndsIconFrame.BackgroundTransparency = 1
    EndsIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    EndsIconFrame.BorderSizePixel = 0
    EndsIconFrame.Size = UDim2.new(0, 45, 0, 45)
    EndsIconFrame.Parent = EndsFrame

    local EndsIconLayout = Instance.new("UIListLayout")
    EndsIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    EndsIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    EndsIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    EndsIconLayout.Parent = EndsIconFrame

    local EndsIcon = Instance.new("ImageLabel")
    EndsIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    EndsIcon.BackgroundTransparency = 1
    EndsIcon.BorderColor3 = Color3.new(0, 0, 0)
    EndsIcon.BorderSizePixel = 0
    EndsIcon.Image = "rbxassetid://91439385685471"
    EndsIcon.Size = UDim2.new(0, 20, 0, 20)
    EndsIcon.Parent = EndsIconFrame

    local EndsTextFrame = Instance.new("Frame")
    EndsTextFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    EndsTextFrame.BackgroundTransparency = 1
    EndsTextFrame.BorderColor3 = Color3.new(0, 0, 0)
    EndsTextFrame.BorderSizePixel = 0
    EndsTextFrame.LayoutOrder = 1
    EndsTextFrame.Position = UDim2.new(0.257, 0, 0, 0)
    EndsTextFrame.Size = UDim2.new(0, 130, 0, 45)
    EndsTextFrame.Parent = EndsFrame

    local EndsTextLayout = Instance.new("UIListLayout")
    EndsTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    EndsTextLayout.Parent = EndsTextFrame

    local EndsLabel = Instance.new("TextLabel")
    EndsLabel.Name = "Ends"
    EndsLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    EndsLabel.BackgroundTransparency = 1
    EndsLabel.BorderColor3 = Color3.new(0, 0, 0)
    EndsLabel.BorderSizePixel = 0
    EndsLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    EndsLabel.Size = UDim2.new(0, 130, 0, 22)
    EndsLabel.Text = "Ends"
    EndsLabel.TextColor3 = Color3.new(0.451, 0.451, 0.451)
    EndsLabel.TextSize = 14
    EndsLabel.TextXAlignment = Enum.TextXAlignment.Left
    EndsLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    EndsLabel.Parent = EndsTextFrame

    local EndsValue = Instance.new("TextLabel")
    EndsValue.Name = "Value"
    EndsValue.BackgroundColor3 = Color3.new(1, 1, 1)
    EndsValue.BackgroundTransparency = 1
    EndsValue.BorderColor3 = Color3.new(0, 0, 0)
    EndsValue.BorderSizePixel = 0
    EndsValue.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    EndsValue.LayoutOrder = 1
    EndsValue.Size = UDim2.new(0, 130, 0, 22)
    EndsValue.Text = "38.8.2026"
    EndsValue.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    EndsValue.TextSize = 16
    EndsValue.TextXAlignment = Enum.TextXAlignment.Left
    EndsValue.TextYAlignment = Enum.TextYAlignment.Top
    EndsValue.Parent = EndsTextFrame

    local StartedFrame = Instance.new("Frame")
    StartedFrame.Name = "Started"
    StartedFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    StartedFrame.BackgroundTransparency = 1
    StartedFrame.BorderColor3 = Color3.new(0, 0, 0)
    StartedFrame.BorderSizePixel = 0
    StartedFrame.LayoutOrder = 1
    StartedFrame.Size = UDim2.new(0, 175, 0, 45)
    StartedFrame.Parent = StatsFrame

    local StartedStroke = Instance.new("UIStroke")
    StartedStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    StartedStroke.Color = Color3.new(0.149, 0.149, 0.149)
    StartedStroke.Parent = StartedFrame

    local StartedCorner = Instance.new("UICorner")
    StartedCorner.Parent = StartedFrame

    local StartedLayout = Instance.new("UIListLayout")
    StartedLayout.FillDirection = Enum.FillDirection.Horizontal
    StartedLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StartedLayout.Parent = StartedFrame

    local StartedIconFrame = Instance.new("Frame")
    StartedIconFrame.Name = "Icon"
    StartedIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    StartedIconFrame.BackgroundTransparency = 1
    StartedIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    StartedIconFrame.BorderSizePixel = 0
    StartedIconFrame.Size = UDim2.new(0, 45, 0, 45)
    StartedIconFrame.Parent = StartedFrame

    local StartedIconLayout = Instance.new("UIListLayout")
    StartedIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    StartedIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StartedIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    StartedIconLayout.Parent = StartedIconFrame

    local StartedIcon = Instance.new("ImageLabel")
    StartedIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    StartedIcon.BackgroundTransparency = 1
    StartedIcon.BorderColor3 = Color3.new(0, 0, 0)
    StartedIcon.BorderSizePixel = 0
    StartedIcon.Image = "rbxassetid://72188977548072"
    StartedIcon.Size = UDim2.new(0, 20, 0, 20)
    StartedIcon.Parent = StartedIconFrame

    local StartedTextFrame = Instance.new("Frame")
    StartedTextFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    StartedTextFrame.BackgroundTransparency = 1
    StartedTextFrame.BorderColor3 = Color3.new(0, 0, 0)
    StartedTextFrame.BorderSizePixel = 0
    StartedTextFrame.LayoutOrder = 1
    StartedTextFrame.Position = UDim2.new(0.257, 0, 0, 0)
    StartedTextFrame.Size = UDim2.new(0, 130, 0, 45)
    StartedTextFrame.Parent = StartedFrame

    local StartedTextLayout = Instance.new("UIListLayout")
    StartedTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StartedTextLayout.Parent = StartedTextFrame

    local StartedLabel = Instance.new("TextLabel")
    StartedLabel.Name = "Started"
    StartedLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    StartedLabel.BackgroundTransparency = 1
    StartedLabel.BorderColor3 = Color3.new(0, 0, 0)
    StartedLabel.BorderSizePixel = 0
    StartedLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    StartedLabel.Size = UDim2.new(0, 130, 0, 22)
    StartedLabel.Text = "Started"
    StartedLabel.TextColor3 = Color3.new(0.451, 0.451, 0.451)
    StartedLabel.TextSize = 14
    StartedLabel.TextXAlignment = Enum.TextXAlignment.Left
    StartedLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    StartedLabel.Parent = StartedTextFrame

    local StartedValue = Instance.new("TextLabel")
    StartedValue.Name = "Value"
    StartedValue.BackgroundColor3 = Color3.new(1, 1, 1)
    StartedValue.BackgroundTransparency = 1
    StartedValue.BorderColor3 = Color3.new(0, 0, 0)
    StartedValue.BorderSizePixel = 0
    StartedValue.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    StartedValue.LayoutOrder = 1
    StartedValue.Size = UDim2.new(0, 130, 0, 22)
    StartedValue.Text = "30.8.2026"
    StartedValue.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    StartedValue.TextSize = 16
    StartedValue.TextXAlignment = Enum.TextXAlignment.Left
    StartedValue.TextYAlignment = Enum.TextYAlignment.Top
    StartedValue.Parent = StartedTextFrame

    local ClaimedKeysFrame = Instance.new("Frame")
    ClaimedKeysFrame.Name = "ClaimedKeys"
    ClaimedKeysFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    ClaimedKeysFrame.BackgroundTransparency = 1
    ClaimedKeysFrame.BorderColor3 = Color3.new(0, 0, 0)
    ClaimedKeysFrame.BorderSizePixel = 0
    ClaimedKeysFrame.Position = UDim2.new(0.26, 0, 0, 0)
    ClaimedKeysFrame.Size = UDim2.new(0.74, 0, 1, 0)
    ClaimedKeysFrame.Parent = DetailsFrame

    local ClaimedKeysLayout = Instance.new("UIListLayout")
    ClaimedKeysLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ClaimedKeysLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ClaimedKeysLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ClaimedKeysLayout.Parent = ClaimedKeysFrame

    local KeysFrame = Instance.new("Frame")
    KeysFrame.Name = "Keys"
    KeysFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    KeysFrame.BackgroundTransparency = 1
    KeysFrame.BorderColor3 = Color3.new(0, 0, 0)
    KeysFrame.BorderSizePixel = 0
    KeysFrame.Position = UDim2.new(0, 0, 0.043, 0)
    KeysFrame.Size = UDim2.new(0, 555, 0, 210)
    KeysFrame.Parent = ClaimedKeysFrame

    local KeysStroke = Instance.new("UIStroke")
    KeysStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    KeysStroke.Color = Color3.new(0.149, 0.149, 0.149)
    KeysStroke.Parent = KeysFrame

    local KeysLayout2 = Instance.new("UIListLayout")
    KeysLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    KeysLayout2.Parent = KeysFrame

    local KeysCorner = Instance.new("UICorner")
    KeysCorner.Parent = KeysFrame

    local KeysTextFrame = Instance.new("Frame")
    KeysTextFrame.Name = "Text"
    KeysTextFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    KeysTextFrame.BackgroundTransparency = 1
    KeysTextFrame.BorderColor3 = Color3.new(0, 0, 0)
    KeysTextFrame.BorderSizePixel = 0
    KeysTextFrame.Size = UDim2.new(0, 555, 0, 30)
    KeysTextFrame.Parent = KeysFrame

    local KeysTextLayout = Instance.new("UIListLayout")
    KeysTextLayout.FillDirection = Enum.FillDirection.Horizontal
    KeysTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    KeysTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    KeysTextLayout.Parent = KeysTextFrame

    local KeysIconFrame = Instance.new("Frame")
    KeysIconFrame.Name = "Icon"
    KeysIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    KeysIconFrame.BackgroundTransparency = 1
    KeysIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    KeysIconFrame.BorderSizePixel = 0
    KeysIconFrame.Size = UDim2.new(0, 30, 0, 30)
    KeysIconFrame.Parent = KeysTextFrame

    local KeysIconLayout = Instance.new("UIListLayout")
    KeysIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    KeysIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    KeysIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    KeysIconLayout.Parent = KeysIconFrame

    local KeysIcon = Instance.new("ImageLabel")
    KeysIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    KeysIcon.BackgroundTransparency = 1
    KeysIcon.BorderColor3 = Color3.new(0, 0, 0)
    KeysIcon.BorderSizePixel = 0
    KeysIcon.Image = "rbxassetid://113646711739432"
    KeysIcon.Size = UDim2.new(0, 18, 0, 18)
    KeysIcon.Parent = KeysIconFrame

    local KeysTitle = Instance.new("TextLabel")
    KeysTitle.Name = "Text"
    KeysTitle.BackgroundColor3 = Color3.new(1, 1, 1)
    KeysTitle.BackgroundTransparency = 1
    KeysTitle.BorderColor3 = Color3.new(0, 0, 0)
    KeysTitle.BorderSizePixel = 0
    KeysTitle.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    KeysTitle.LayoutOrder = 1
    KeysTitle.Size = UDim2.new(0, 100, 0, 30)
    KeysTitle.Text = "Claimed keys"
    KeysTitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    KeysTitle.TextSize = 15
    KeysTitle.TextXAlignment = Enum.TextXAlignment.Left
    KeysTitle.Parent = KeysTextFrame

    local KeysTextStroke = Instance.new("UIStroke")
    KeysTextStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    KeysTextStroke.Color = Color3.new(0.149, 0.149, 0.149)
    KeysTextStroke.Parent = KeysTextFrame

    local KeysTextCorner = Instance.new("UICorner")
    KeysTextCorner.BottomLeftRadius = UDim.new(0, 0)
    KeysTextCorner.BottomRightRadius = UDim.new(0, 0)
    KeysTextCorner.Parent = KeysTextFrame

    local CountFrame = Instance.new("Frame")
    CountFrame.Name = "Count"
    CountFrame.BackgroundColor3 = Color3.new(0.173, 0.173, 0.173)
    CountFrame.BorderColor3 = Color3.new(0, 0, 0)
    CountFrame.BorderSizePixel = 0
    CountFrame.LayoutOrder = 3
    CountFrame.Size = UDim2.new(0, 20, 0, 20)
    CountFrame.Parent = KeysTextFrame

    local CountCorner = Instance.new("UICorner")
    CountCorner.BottomLeftRadius = UDim.new(0, 5)
    CountCorner.BottomRightRadius = UDim.new(0, 5)
    CountCorner.CornerRadius = UDim.new(0, 5)
    CountCorner.TopLeftRadius = UDim.new(0, 5)
    CountCorner.TopRightRadius = UDim.new(0, 5)
    CountCorner.Parent = CountFrame

    local CountStroke = Instance.new("UIStroke")
    CountStroke.Color = Color3.new(0.353, 0.353, 0.353)
    CountStroke.Parent = CountFrame

    local CountLabel = Instance.new("TextLabel")
    CountLabel.Name = "Count"
    CountLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    CountLabel.BackgroundTransparency = 1
    CountLabel.BorderColor3 = Color3.new(0, 0, 0)
    CountLabel.BorderSizePixel = 0
    CountLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    CountLabel.Size = UDim2.new(1, 0, 1, 0)
    CountLabel.Text = "1"
    CountLabel.TextColor3 = Color3.new(0.557, 0.557, 0.557)
    CountLabel.TextSize = 15
    CountLabel.Parent = CountFrame

    local Filler = Instance.new("Frame")
    Filler.Name = "Filler"
    Filler.BackgroundColor3 = Color3.new(1, 1, 1)
    Filler.BackgroundTransparency = 1
    Filler.BorderColor3 = Color3.new(0, 0, 0)
    Filler.BorderSizePixel = 0
    Filler.LayoutOrder = 2
    Filler.Size = UDim2.new(0, 395, 0, 30)
    Filler.Parent = KeysTextFrame

    local Claimed = Instance.new("Frame")
    Claimed.Name = "Claimed"
    Claimed.BackgroundColor3 = Color3.new(1, 1, 1)
    Claimed.BackgroundTransparency = 1
    Claimed.BorderColor3 = Color3.new(0, 0, 0)
    Claimed.BorderSizePixel = 0
    Claimed.Position = UDim2.new(0, 0, 0.143, 0)
    Claimed.Size = UDim2.new(0, 555, 0, 180)
    Claimed.Parent = KeysFrame

    local ClaimedLayout = Instance.new("UIListLayout")
    ClaimedLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ClaimedLayout.Parent = Claimed

    local ExampleKey = Instance.new("Frame")
    ExampleKey.Name = "ExampleKey"
    ExampleKey.BackgroundColor3 = Color3.new(1, 1, 1)
    ExampleKey.BackgroundTransparency = 1
    ExampleKey.BorderColor3 = Color3.new(0, 0, 0)
    ExampleKey.BorderSizePixel = 0
    ExampleKey.Size = UDim2.new(0, 555, 0, 50)
    ExampleKey.Parent = Claimed

    local Security = Instance.new("Frame")
    Security.Name = "Security"
    Security.BackgroundColor3 = Color3.new(1, 1, 1)
    Security.BackgroundTransparency = 1
    Security.BorderColor3 = Color3.new(0, 0, 0)
    Security.BorderSizePixel = 0
    Security.LayoutOrder = 2
    Security.Position = UDim2.new(0, 0, 0.713, 0)
    Security.Size = UDim2.new(0, 770, 0, 145)
    Security.Parent = AccountPageFrame

    local SecurityLayout = Instance.new("UIListLayout")
    SecurityLayout.Padding = UDim.new(0, 10)
    SecurityLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecurityLayout.Parent = Security

    local SecurityText = Instance.new("Frame")
    SecurityText.Name = "Text"
    SecurityText.BackgroundColor3 = Color3.new(1, 1, 1)
    SecurityText.BackgroundTransparency = 1
    SecurityText.BorderColor3 = Color3.new(0, 0, 0)
    SecurityText.BorderSizePixel = 0
    SecurityText.Size = UDim2.new(0, 770, 0, 40)
    SecurityText.Parent = Security

    local SecurityIconFrame = Instance.new("Frame")
    SecurityIconFrame.Name = "Icon"
    SecurityIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    SecurityIconFrame.BackgroundTransparency = 1
    SecurityIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    SecurityIconFrame.BorderSizePixel = 0
    SecurityIconFrame.Size = UDim2.new(0, 40, 0, 40)
    SecurityIconFrame.Parent = SecurityText

    local SecurityIconLayout = Instance.new("UIListLayout")
    SecurityIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SecurityIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecurityIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SecurityIconLayout.Parent = SecurityIconFrame

    local SecurityIcon = Instance.new("ImageLabel")
    SecurityIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    SecurityIcon.BackgroundTransparency = 1
    SecurityIcon.BorderColor3 = Color3.new(0, 0, 0)
    SecurityIcon.BorderSizePixel = 0
    SecurityIcon.Image = "rbxassetid://104512588477874"
    SecurityIcon.ImageTransparency = 0.3
    SecurityIcon.Size = UDim2.new(0, 25, 0, 25)
    SecurityIcon.Parent = SecurityIconFrame

    local SecurityTextLayout = Instance.new("UIListLayout")
    SecurityTextLayout.FillDirection = Enum.FillDirection.Horizontal
    SecurityTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecurityTextLayout.Parent = SecurityText

    local SecurityInfo = Instance.new("Frame")
    SecurityInfo.Name = "Info"
    SecurityInfo.BackgroundColor3 = Color3.new(1, 1, 1)
    SecurityInfo.BackgroundTransparency = 1
    SecurityInfo.BorderColor3 = Color3.new(0, 0, 0)
    SecurityInfo.BorderSizePixel = 0
    SecurityInfo.Position = UDim2.new(0.052, 0, 0, 0)
    SecurityInfo.Size = UDim2.new(0, 200, 0, 40)
    SecurityInfo.Parent = SecurityText

    local SecurityInfoLayout = Instance.new("UIListLayout")
    SecurityInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecurityInfoLayout.Parent = SecurityInfo

    local SecurityLabel = Instance.new("TextLabel")
    SecurityLabel.Name = "Security"
    SecurityLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    SecurityLabel.BackgroundTransparency = 1
    SecurityLabel.BorderColor3 = Color3.new(0, 0, 0)
    SecurityLabel.BorderSizePixel = 0
    SecurityLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SecurityLabel.Size = UDim2.new(0, 200, 0, 20)
    SecurityLabel.Text = "Security"
    SecurityLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    SecurityLabel.TextSize = 15
    SecurityLabel.TextXAlignment = Enum.TextXAlignment.Left
    SecurityLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    SecurityLabel.Parent = SecurityInfo

    local SecuritySmallText = Instance.new("TextLabel")
    SecuritySmallText.Name = "SmallText"
    SecuritySmallText.BackgroundColor3 = Color3.new(1, 1, 1)
    SecuritySmallText.BackgroundTransparency = 1
    SecuritySmallText.BorderColor3 = Color3.new(0, 0, 0)
    SecuritySmallText.BorderSizePixel = 0
    SecuritySmallText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    SecuritySmallText.LayoutOrder = 1
    SecuritySmallText.Size = UDim2.new(0, 200, 0, 20)
    SecuritySmallText.Text = "Session controlls"
    SecuritySmallText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    SecuritySmallText.TextSize = 14
    SecuritySmallText.TextXAlignment = Enum.TextXAlignment.Left
    SecuritySmallText.TextYAlignment = Enum.TextYAlignment.Top
    SecuritySmallText.Parent = SecurityInfo

    local SecurityContent = Instance.new("Frame")
    SecurityContent.BackgroundColor3 = Color3.new(1, 1, 1)
    SecurityContent.BackgroundTransparency = 1
    SecurityContent.BorderColor3 = Color3.new(0, 0, 0)
    SecurityContent.BorderSizePixel = 0
    SecurityContent.Position = UDim2.new(0, 0, 0.345, 0)
    SecurityContent.Size = UDim2.new(0, 770, 0, 95)
    SecurityContent.Parent = Security

    local LogoutFrame = Instance.new("Frame")
    LogoutFrame.Name = "Logout"
    LogoutFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutFrame.BackgroundTransparency = 1
    LogoutFrame.BorderColor3 = Color3.new(0, 0, 0)
    LogoutFrame.BorderSizePixel = 0
    LogoutFrame.LayoutOrder = 1
    LogoutFrame.Position = UDim2.new(0, 0, 0.345, 0)
    LogoutFrame.Size = UDim2.new(0, 390, 0, 90)
    LogoutFrame.Parent = SecurityContent

    local LogoutCorner = Instance.new("UICorner")
    LogoutCorner.Parent = LogoutFrame

    local LogoutStroke = Instance.new("UIStroke")
    LogoutStroke.Color = Color3.new(0.149, 0.149, 0.149)
    LogoutStroke.Parent = LogoutFrame

    local LogoutLayout = Instance.new("UIListLayout")
    LogoutLayout.FillDirection = Enum.FillDirection.Horizontal
    LogoutLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoutLayout.Parent = LogoutFrame

    local LogoutTextFrame = Instance.new("Frame")
    LogoutTextFrame.Name = "Text"
    LogoutTextFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutTextFrame.BackgroundTransparency = 1
    LogoutTextFrame.BorderColor3 = Color3.new(0, 0, 0)
    LogoutTextFrame.BorderSizePixel = 0
    LogoutTextFrame.Size = UDim2.new(0, 195, 0, 50)
    LogoutTextFrame.Parent = LogoutFrame

    local LogoutTextLayout = Instance.new("UIListLayout")
    LogoutTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoutTextLayout.Parent = LogoutTextFrame

    local LogoutHeader = Instance.new("TextLabel")
    LogoutHeader.Name = "Header"
    LogoutHeader.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutHeader.BackgroundTransparency = 1
    LogoutHeader.BorderColor3 = Color3.new(0, 0, 0)
    LogoutHeader.BorderSizePixel = 0
    LogoutHeader.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LogoutHeader.Size = UDim2.new(0, 195, 0, 25)
    LogoutHeader.Text = "Sign out"
    LogoutHeader.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    LogoutHeader.TextSize = 15
    LogoutHeader.TextXAlignment = Enum.TextXAlignment.Left
    LogoutHeader.TextYAlignment = Enum.TextYAlignment.Bottom
    LogoutHeader.Parent = LogoutTextFrame

    local LogoutDesc = Instance.new("TextLabel")
    LogoutDesc.Name = "Description"
    LogoutDesc.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutDesc.BackgroundTransparency = 1
    LogoutDesc.BorderColor3 = Color3.new(0, 0, 0)
    LogoutDesc.BorderSizePixel = 0
    LogoutDesc.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    LogoutDesc.LayoutOrder = 1
    LogoutDesc.Size = UDim2.new(0, 195, 0, 25)
    LogoutDesc.Text = "End the session on this device"
    LogoutDesc.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    LogoutDesc.TextSize = 14
    LogoutDesc.TextXAlignment = Enum.TextXAlignment.Left
    LogoutDesc.TextYAlignment = Enum.TextYAlignment.Top
    LogoutDesc.Parent = LogoutTextFrame

    local LogoutTextPadding = Instance.new("UIPadding")
    LogoutTextPadding.PaddingLeft = UDim.new(0, 8)
    LogoutTextPadding.Parent = LogoutTextFrame

    local LogoutButtonContainer = Instance.new("Frame")
    LogoutButtonContainer.Name = "Button"
    LogoutButtonContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutButtonContainer.BackgroundTransparency = 1
    LogoutButtonContainer.BorderColor3 = Color3.new(0, 0, 0)
    LogoutButtonContainer.BorderSizePixel = 0
    LogoutButtonContainer.Position = UDim2.new(0.505, 0, -0.2, 0)
    LogoutButtonContainer.Size = UDim2.new(0, 195, 0, 50)
    LogoutButtonContainer.Parent = LogoutFrame

    local LogoutButtonContainerLayout = Instance.new("UIListLayout")
    LogoutButtonContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    LogoutButtonContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoutButtonContainerLayout.Parent = LogoutButtonContainer

    local LogoutButtonInner = Instance.new("Frame")
    LogoutButtonInner.Active = true
    LogoutButtonInner.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutButtonInner.BackgroundTransparency = 1
    LogoutButtonInner.BorderColor3 = Color3.new(0, 0, 0)
    LogoutButtonInner.BorderSizePixel = 0
    LogoutButtonInner.Position = UDim2.new(0.59, 0, 0, 0)
    LogoutButtonInner.Selectable = true
    LogoutButtonInner.Size = UDim2.new(0, 80, 0, 50)
    LogoutButtonInner.Parent = LogoutButtonContainer

    local LogoutButtonInnerLayout = Instance.new("UIListLayout")
    LogoutButtonInnerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LogoutButtonInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoutButtonInnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LogoutButtonInnerLayout.Parent = LogoutButtonInner

    local LogoutButton = Instance.new("ImageButton")
    LogoutButton.BackgroundColor3 = Color3.new(0.816, 0.243, 0.243)
    LogoutButton.BackgroundTransparency = 0.7
    LogoutButton.BorderColor3 = Color3.new(0, 0, 0)
    LogoutButton.BorderSizePixel = 0
    LogoutButton.Size = UDim2.new(0, 70, 0, 25)
    LogoutButton.Parent = LogoutButtonInner

    local LogoutButtonCorner = Instance.new("UICorner")
    LogoutButtonCorner.BottomLeftRadius = UDim.new(0, 4)
    LogoutButtonCorner.BottomRightRadius = UDim.new(0, 4)
    LogoutButtonCorner.CornerRadius = UDim.new(0, 4)
    LogoutButtonCorner.TopLeftRadius = UDim.new(0, 4)
    LogoutButtonCorner.TopRightRadius = UDim.new(0, 4)
    LogoutButtonCorner.Parent = LogoutButton

    local LogoutButtonLayout = Instance.new("UIListLayout")
    LogoutButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    LogoutButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoutButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LogoutButtonLayout.Parent = LogoutButton

    local LogoutButtonIconFrame = Instance.new("Frame")
    LogoutButtonIconFrame.Name = "Icon"
    LogoutButtonIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutButtonIconFrame.BackgroundTransparency = 1
    LogoutButtonIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    LogoutButtonIconFrame.BorderSizePixel = 0
    LogoutButtonIconFrame.Size = UDim2.new(0, 20, 0, 20)
    LogoutButtonIconFrame.Parent = LogoutButton

    local LogoutButtonIconLayout = Instance.new("UIListLayout")
    LogoutButtonIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LogoutButtonIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoutButtonIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LogoutButtonIconLayout.Parent = LogoutButtonIconFrame

    local LogoutButtonIcon = Instance.new("ImageLabel")
    LogoutButtonIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutButtonIcon.BackgroundTransparency = 1
    LogoutButtonIcon.BorderColor3 = Color3.new(0, 0, 0)
    LogoutButtonIcon.BorderSizePixel = 0
    LogoutButtonIcon.Image = "rbxassetid://83408923775191"
    LogoutButtonIcon.ImageColor3 = Color3.new(0.816, 0.243, 0.243)
    LogoutButtonIcon.Size = UDim2.new(0, 15, 0, 15)
    LogoutButtonIcon.Parent = LogoutButtonIconFrame

    local LogoutButtonText = Instance.new("TextLabel")
    LogoutButtonText.Name = "Description"
    LogoutButtonText.BackgroundColor3 = Color3.new(1, 1, 1)
    LogoutButtonText.BackgroundTransparency = 1
    LogoutButtonText.BorderColor3 = Color3.new(0, 0, 0)
    LogoutButtonText.BorderSizePixel = 0
    LogoutButtonText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LogoutButtonText.Size = UDim2.new(0, 50, 0, 30)
    LogoutButtonText.Text = "Sign Out"
    LogoutButtonText.TextColor3 = Color3.new(0.816, 0.243, 0.243)
    LogoutButtonText.TextSize = 14
    LogoutButtonText.TextXAlignment = Enum.TextXAlignment.Left
    LogoutButtonText.Parent = LogoutButton

    local LogoutButtonTextPadding = Instance.new("UIPadding")
    LogoutButtonTextPadding.PaddingLeft = UDim.new(0, 1)
    LogoutButtonTextPadding.Parent = LogoutButtonText

    local LogoutButtonStroke = Instance.new("UIStroke")
    LogoutButtonStroke.Color = Color3.new(0.816, 0.243, 0.243)
    LogoutButtonStroke.Parent = LogoutButton

    local SecurityContentLayout = Instance.new("UIListLayout")
    SecurityContentLayout.FillDirection = Enum.FillDirection.Horizontal
    SecurityContentLayout.Padding = UDim.new(0, 10)
    SecurityContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SecurityContentLayout.Parent = SecurityContent

    local SecurityContentPadding = Instance.new("UIPadding")
    SecurityContentPadding.PaddingLeft = UDim.new(0, 9)
    SecurityContentPadding.Parent = SecurityContent

    Maid:GiveTask(LogoutButton.MouseButton1Click:Connect(function()
        if Api and Api.SaveToken then
            Api.SaveToken("")
        end
        local success, player = pcall(function() return game:GetService("Players").LocalPlayer end)
        if success and player then
            player:Kick("Successfully signed out")
        end
    end))

    local PageData = {}
    
    Maid:GiveTask(ClaimButton.MouseButton1Click:Connect(function()
        if PageData.IsLifetime then
            Notifications.Notify({
                Title = "Error",
                Content = "You cannot claim keys while having a Lifetime subscription.",
                Type = "Error",
                Duration = 4
            })
            return
        end
        local key = TextBox.Text
        if key and key ~= "" then
            ClaimButton.Text = "..."
            task.spawn(function()
                if Api and Api.RedeemKey then
                    local success, msg = Api.RedeemKey(key)
                    if success then
                        TextBox.Text = ""
                        local newData = Api.FetchMe()
                        if newData and PageData.UpdateData then
                            PageData.UpdateData(newData)
                        end
                    else
                        TextBox.Text = tostring(msg) or "Failed"
                        task.wait(2)
                        TextBox.Text = ""
                    end
                end
                ClaimButton.Text = "Claim"
            end)
        end
    end))

    PageData.Instance = Page
    PageData.UpdateData = function(data)
            if data and data.username then
                Username.Text = data.username
            else
                local success, name = pcall(function() return game:GetService("Players").LocalPlayer.Name end)
                Username.Text = success and name or "Username"
            end
            
            if data and data._id then
                HiddenId.Visible = true
                HiddenId.Text = "********"
                local idRevealed = false
                Maid:GiveTask(HiddenId.Focused:Connect(function()
                    if not idRevealed then
                        idRevealed = true
                        HiddenId.Text = tostring(data._id)
                    end
                end))
            else
                HiddenId.Visible = false
            end
            
            if data and data.createdAt then
                local dateStr = string.match(tostring(data.createdAt), "^(%d+%-%d+%-%d+)") or tostring(data.createdAt)
                MemberSince.Text = "Member since " .. dateStr
            else
                MemberSince.Text = "Member since Jul 24, 2026"
            end
            
            local subEnd = data.subscriptionEnd or data.expiresAt or data.endsAt
            local subStart = data.subscriptionStart or data.startedAt or data.createdAt
            local remainingStr = data.remaining
            local isActive = false
            local isLifetime = (subEnd == nil)
            
            if data.subscription and type(data.subscription) == "table" then
                local sub = data.subscription
                subEnd = subEnd or sub.expiresAt or sub.endsAt or sub.subscriptionEnd
                subStart = subStart or sub.startedAt or sub.createdAt
                remainingStr = remainingStr or sub.remaining
                if sub.active ~= nil then isActive = sub.active end
                if subEnd then isLifetime = false end
            end
            
            if subEnd or isLifetime then isActive = true end
            PageData.IsLifetime = isLifetime
            
            if isActive then
                StatusBadgeText.Text = "Active"
                StatusBadgeText.TextColor3 = Color3.new(0.4, 0.8, 0.4)
                
                if isLifetime then
                    EndsValue.Text = "Lifetime"
                    RemainingValue.Text = "Lifetime"
                else
                    local endStr = string.match(tostring(subEnd), "^(%d+%-%d+%-%d+)") or tostring(subEnd)
                    EndsValue.Text = endStr
                    RemainingValue.Text = remainingStr and tostring(remainingStr) or "Active"
                end
                
                if subStart then
                    local startStr = string.match(tostring(subStart), "^(%d+%-%d+%-%d+)") or tostring(subStart)
                    StartedValue.Text = startStr
                else
                    StartedValue.Text = "N/A"
                end
            else
                StatusBadgeText.Text = "Inactive"
                StatusBadgeText.TextColor3 = Color3.new(0.6, 0.6, 0.6)
                RemainingValue.Text = "None"
                StartedValue.Text = "N/A"
                EndsValue.Text = "N/A"
            end
            
            for _, child in ipairs(Claimed:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end
            
            local keysData = data.keys or data.key or data.claimedKeys or data.claimedkey or data.claimedKey or data.licenses or data.licenseKeys or data.usedKey or data.license
            if data.subscription and type(data.subscription) == "table" then
                keysData = keysData or data.subscription.keys or data.subscription.key or data.subscription.claimedKeys or data.subscription.claimedkey or data.subscription.claimedKey
            end
            
            local keyList = {}
            if data.licenseObjects and type(data.licenseObjects) == "table" then
                keyList = data.licenseObjects
            else
                if type(keysData) == "table" then
                    for _, k in ipairs(keysData) do table.insert(keyList, { key = k }) end
                elseif type(keysData) == "string" then
                    keyList = {{ key = keysData }}
                end
            end
            
            CountLabel.Text = tostring(#keyList)
            
            
            
            for _, licenseObj in ipairs(keyList) do
                local keyStr = type(licenseObj) == "string" and licenseObj or licenseObj.key
                
                local KeyItem = Instance.new("Frame")
                KeyItem.Name = "KeyItem"
                KeyItem.BackgroundColor3 = Color3.new(0.16, 0.16, 0.16)
                KeyItem.BackgroundTransparency = 1
                KeyItem.BorderSizePixel = 0
                KeyItem.Size = UDim2.new(0, 555, 0, 50)
                KeyItem.Parent = Claimed
                
                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 6)
                KeyCorner.Parent = KeyItem
                
                local HoverButton = Instance.new("TextButton")
                HoverButton.BackgroundTransparency = 1
                HoverButton.Text = ""
                HoverButton.Size = UDim2.new(1, 0, 1, 0)
                HoverButton.ZIndex = 5
                HoverButton.Parent = KeyItem
                
                Maid:GiveTask(HoverButton.MouseEnter:Connect(function()
                    Tween(KeyItem, TweenInfo.new(0.2), {BackgroundTransparency = 0})
                end))
                Maid:GiveTask(HoverButton.MouseLeave:Connect(function()
                    Tween(KeyItem, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                end))
                
                local KeyLabel = Instance.new("TextLabel")
                KeyLabel.BackgroundTransparency = 1
                KeyLabel.Size = UDim2.new(1, -100, 0, 25)
                KeyLabel.Position = UDim2.new(0, 10, 0, 5)
                KeyLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                KeyLabel.TextSize = 15
                KeyLabel.TextColor3 = Color3.fromRGB(130, 190, 255)
                KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeyLabel.Text = tostring(keyStr)
                KeyLabel.Parent = KeyItem
                
                local DetailsLabel = Instance.new("TextLabel")
                DetailsLabel.BackgroundTransparency = 1
                DetailsLabel.Size = UDim2.new(1, -100, 0, 15)
                DetailsLabel.Position = UDim2.new(0, 10, 0, 30)
                DetailsLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                DetailsLabel.TextSize = 13
                DetailsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                DetailsLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local claimedStr = type(licenseObj) == "table" and licenseObj.claimedStr or "N/A"
                local expiresStr = type(licenseObj) == "table" and licenseObj.expiresStr or "N/A"
                DetailsLabel.Text = "Claimed " .. claimedStr .. "   Expires " .. expiresStr
                DetailsLabel.Parent = KeyItem
                
                local BadgeFrame = Instance.new("Frame")
                BadgeFrame.AnchorPoint = Vector2.new(1, 0.5)
                BadgeFrame.Position = UDim2.new(1, -10, 0.5, 0)
                BadgeFrame.Size = UDim2.new(0, 70, 0, 22)
                BadgeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                BadgeFrame.Parent = KeyItem
                Instance.new("UICorner", BadgeFrame).CornerRadius = UDim.new(0, 4)
                
                local BadgeStroke = Instance.new("UIStroke")
                BadgeStroke.Color = Color3.fromRGB(80, 80, 80)
                BadgeStroke.Parent = BadgeFrame
                
                local BadgeText = Instance.new("TextLabel")
                BadgeText.BackgroundTransparency = 1
                BadgeText.Size = UDim2.new(1, 0, 1, 0)
                BadgeText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                BadgeText.TextSize = 13
                BadgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                local badgeName = "unknown"
                if type(licenseObj) == "table" then
                    if licenseObj.durationMs == nil then badgeName = "lifetime"
                    elseif licenseObj.durationMs then
                        local days = math.floor(licenseObj.durationMs / (1000 * 60 * 60 * 24))
                        if days == 30 or days == 31 then badgeName = "monthly"
                        elseif days == 7 then badgeName = "weekly"
                        elseif days == 1 then badgeName = "daily"
                        elseif days < 1 then badgeName = "hourly"
                        else badgeName = tostring(days).." days" end
                    end
                end
                BadgeText.Text = badgeName
                BadgeText.Parent = BadgeFrame
            end
            
            local success, userId = pcall(function() return game:GetService("Players").LocalPlayer.UserId end)
            if success and userId then
                ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"
            end
        end
    return PageData
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
    SidebarFrame.ZIndex = 50
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
    TopbarFrame.ZIndex = 50
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
    
    local BottombarElements = Bottombar.Create(Main, maid)
    
    local AccountPageElements
    AccountPageElements = AccountPage.Create(PagesContainer, maid, function()
        PageLayout:JumpTo(Content)
        BottombarElements.Instance.Visible = true
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
        BottombarElements.Instance.Visible = false
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

