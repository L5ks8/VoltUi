local Utils = script.Parent.Parent.Utils
local Maid = require(Utils.Maid)
local Signal = require(Utils.Signal)
local Tween = require(Utils.Tween)
local Utility = require(Utils.Utility)
local ThemeManager = require(script.Parent.Theme)

local Api = nil
pcall(function()
    Api = require(Utils.Api)
end)

local Topbar = require(script.Parent.Topbar)
local Sidebar = require(script.Parent.Sidebar)
local Bottombar = require(script.Parent.Bottombar)
local Minimized = require(script.Parent.Minimized)
local CloseWarn = require(script.Parent.CloseWarn)
local AccountPage = require(script.Parent.AccountPage)
local LoginPage = require(script.Parent.LoginPage)
local Notifications = require(script.Parent.Notifications)
local Tabs = require(script.Parent.Tabs)
local Loading = require(script.Parent.Loading)
local Intro = require(script.Parent.Intro)

local Window = {}

function Window:CreateWindow(Config)
    local maid = Maid.new()
    
    local VoltUi = Instance.new("ScreenGui")
    VoltUi.Name = "VoltUi"
    VoltUi.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    VoltUi.IgnoreGuiInset = true
    VoltUi.ResetOnSpawn = false
    maid:GiveTask(VoltUi)
    
    Utility.ProtectGui(VoltUi)
    
    local showLoading = true
    local loadingScreen
    if showLoading then
        local introScreen = Intro.Create(VoltUi)
        introScreen:WaitForReady()
        introScreen:FadeOut()
        task.wait(0.5)
        
        loadingScreen = Loading.Create(VoltUi)
        loadingScreen:SetStatus("Initializing Volt...")
        loadingScreen:SetProgress(0.1)
        task.wait(0)
    end
    
    Notifications.Init(VoltUi)
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    ThemeManager:Register(Main, "BackgroundColor3", "MainBackground")
    Main.BorderColor3 = Color3.new(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = false
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 800, 0, 600)
    Main.Visible = false
    Main.Parent = VoltUi
    
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    ThemeManager:Register(UIStroke, "Color", "StrokeColor")
    UIStroke.Parent = Main
    
    local MainScale = Instance.new("UIScale")
    MainScale.Parent = Main
    
    if loadingScreen then loadingScreen:SetStatus("Loading Topbar...") loadingScreen:SetProgress(0.25) task.wait(0) end
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
    
    local OnCollapse = Signal.new()
    maid:GiveTask(OnCollapse)
    
    if loadingScreen then loadingScreen:SetStatus("Loading Sidebar...") loadingScreen:SetProgress(0.40) task.wait(0) end
    local SidebarElements = Sidebar.Create(Content, maid, OnCollapse)
    

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
    MainContent.Position = UDim2.new(0, 207, 0, 0)
    MainContent.Size = UDim2.new(1, -207, 1, 0)
    MainContent.LayoutOrder = 2
    MainContent.Parent = Content
    
    maid:GiveTask(OnCollapse:Connect(function(isCollapsed)
        local SidebarTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if isCollapsed then
            Tween(MainContent, SidebarTweenInfo, {Size = UDim2.new(1, -57, 1, 0)})
        else
            Tween(MainContent, SidebarTweenInfo, {Size = UDim2.new(1, -207, 1, 0)})
        end
    end))
    
    local ExpiredOverlay = Instance.new("TextButton")
    ExpiredOverlay.Name = "ExpiredOverlay"
    ExpiredOverlay.Size = UDim2.new(1, 0, 1, 0)
    ExpiredOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    ExpiredOverlay.BackgroundTransparency = 0.5
    ExpiredOverlay.Text = ""
    ExpiredOverlay.AutoButtonColor = false
    ExpiredOverlay.ZIndex = 9999
    ExpiredOverlay.Visible = false
    ExpiredOverlay.Parent = MainContent
    
    local ExpiredText = Instance.new("TextLabel")
    ExpiredText.Size = UDim2.new(1, 0, 1, 0)
    ExpiredText.BackgroundTransparency = 1
    ExpiredText.Text = "Subscription Expired"
    ExpiredText.TextColor3 = Color3.new(1, 0.3, 0.3)
    ExpiredText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ExpiredText.TextSize = 24
    ExpiredText.ZIndex = 10000
    ExpiredText.Parent = ExpiredOverlay

    maid:GiveTask(ExpiredOverlay.MouseButton1Click:Connect(function()
        Notifications.Notify({
            Title = "Expired",
            Content = "Your subscription has expired. Please redeem a new key in the Account page.",
            Type = "Error",
            Duration = 3
        })
    end))

    local isStandaloneKey = (Config.StandaloneKey == true) or (Config.SimpleKey == true) or (Config.KeyOnly == true)
    local isAuthSystem = (Config.KeySystem == true) or (Config.Login == true) or (Config.Auth == true) or (Config.EnableAuth == true) or (Config.KeySettings ~= nil and not isStandaloneKey)

    if not Api then
        pcall(function()
            Api = require(Utils.Api)
        end)
    end

    local tokenExists = false
    if Api then
        pcall(function() tokenExists = (Api.GetToken() ~= nil) end)
    end
    
    if not tokenExists then
        isAuthSystem = true
    end

    if loadingScreen then loadingScreen:SetStatus("Loading Bottombar...") loadingScreen:SetProgress(0.55) task.wait(0) end
    local BottombarElements = Bottombar.Create(Main, maid)
    
    local OnLoginSuccess
    local WindowObject = {}

    if loadingScreen then loadingScreen:SetStatus("Loading Core Components...") loadingScreen:SetProgress(0.70) task.wait(0) end
    local AccountPageElements
    pcall(function()
        AccountPageElements = AccountPage.Create(PagesContainer, maid, function()
            WindowObject:OpenHome()
        end, Api, function()
            LoginPage.Create(VoltUi, function()
                OnLoginSuccess()
            end)
        end)
    end)
    
    if loadingScreen then loadingScreen:SetStatus("Loading Settings...") loadingScreen:SetProgress(0.80) task.wait(0) end
    local SettingsPage = require(script.Parent.SettingsPage)
    local SettingsPageElements
    local success, err = pcall(function()
        SettingsPageElements = SettingsPage.Create(PagesContainer, maid, function()
            WindowObject:OpenHome()
        end, Config)
    end)
    if not success then
        warn("[VoltUi] Failed to create Settings Page: " .. tostring(err))
    end
    
    -- Connect Sidebar clicks
    maid:GiveTask(SidebarElements.HomeBtn.MouseButton1Click:Connect(function()
        if WindowObject and WindowObject.OpenHome then
            WindowObject:OpenHome()
        end
    end))
    maid:GiveTask(SidebarElements.AccountBtn.MouseButton1Click:Connect(function()
        if WindowObject and WindowObject.OpenAccount then
            WindowObject:OpenAccount()
        end
    end))
    maid:GiveTask(SidebarElements.SettingsBtn.MouseButton1Click:Connect(function()
        if SettingsPageElements and SettingsPageElements.Instance then
            PageLayout:JumpTo(SettingsPageElements.Instance)
            BottombarElements.Instance.Visible = false
            Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -30)})
        end
    end))

    local function RefreshAccountData()
        if not Api then
            pcall(function() Api = require(Utils.Api) end)
        end
        if Api and Api.UserData and AccountPageElements and AccountPageElements.UpdateData then
            pcall(function() AccountPageElements.UpdateData(Api.UserData) end)
        end
        task.spawn(function()
            if Api and Api.FetchMe then
                local freshData = Api.FetchMe()
                if freshData and AccountPageElements and AccountPageElements.UpdateData then
                    pcall(function() AccountPageElements.UpdateData(freshData) end)
                elseif (not freshData) and (not Api.UserData) and AccountPageElements and AccountPageElements.UpdateData then
                    pcall(function() AccountPageElements.UpdateData(nil) end)
                end
            elseif (not Api or not Api.UserData) and AccountPageElements and AccountPageElements.UpdateData then
                pcall(function() AccountPageElements.UpdateData(nil) end)
            end
        end)
    end

    task.spawn(function()
        RefreshAccountData()
    end)

    OnLoginSuccess = function()
        Main.Visible = true
        RefreshAccountData()
        if Api and Api.UserData and Api.UserData.remaining == "Expired" then
            ExpiredOverlay.Visible = true
        else
            ExpiredOverlay.Visible = false
        end
    end

    local function ShowKeySystem(onSuccess)
        local ks = Config.KeySettings or {}
        local validKeys = {}
        if type(ks.Key) == "table" then
            for _, k in ipairs(ks.Key) do validKeys[tostring(k)] = true end
        elseif type(ks.Key) == "string" then
            validKeys[ks.Key] = true
        end
        if type(ks.Keys) == "table" then
            for _, k in ipairs(ks.Keys) do validKeys[tostring(k)] = true end
        elseif type(ks.Keys) == "string" then
            validKeys[ks.Keys] = true
        end
        if type(Config.Key) == "string" then
            validKeys[Config.Key] = true
        elseif type(Config.Key) == "table" then
            for _, k in ipairs(Config.Key) do validKeys[tostring(k)] = true end
        end

        local function verifyOnline(k)
            local postFunc = (request and function(u, b) return request({Url = u, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = b}) end)
                          or (http_request and function(u, b) return http_request({Url = u, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = b}) end)
                          or (syn and syn.request and function(u, b) return syn.request({Url = u, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = b}) end)
            if postFunc then
                local HttpService = game:GetService("HttpService")
                local body = HttpService:JSONEncode({ key = k })
                local ok, res = pcall(postFunc, "https://volthub-18b3.onrender.com/check-key", body)
                if ok and res and res.Body then
                    local decOk, dec = pcall(function() return HttpService:JSONDecode(res.Body) end)
                    if decOk and dec and dec.valid == true then
                        return true, dec.message or "Key verified!"
                    elseif decOk and dec and dec.message then
                        return false, dec.message
                    end
                end
            end
            return false, nil
        end

        local fileName = (ks.FileName or "VoltKey") .. ".txt"
        if ks.SaveKey and isfile and isfile(fileName) then
            local saved = readfile(fileName)
            if saved and saved ~= "" then
                if validKeys[saved] then
                    Notifications.Notify({
                        Title = "Key System",
                        Content = "Saved key loaded successfully!",
                        Duration = 2.5
                    })
                    onSuccess()
                    return
                else
                    local onlineOk = verifyOnline(saved)
                    if onlineOk then
                        Notifications.Notify({
                            Title = "Key System",
                            Content = "Saved key verified!",
                            Duration = 2.5
                        })
                        onSuccess()
                        return
                    end
                end
            end
        end

        local KeyBackdrop = Instance.new("Frame")
        KeyBackdrop.Name = "VoltKeyBackdrop"
        KeyBackdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        KeyBackdrop.BackgroundTransparency = 0.35
        KeyBackdrop.BorderSizePixel = 0
        KeyBackdrop.Size = UDim2.new(1, 0, 1, 0)
        KeyBackdrop.ZIndex = 80000
        KeyBackdrop.Parent = VoltUi

        local KeyCard = Instance.new("Frame")
        KeyCard.Name = "KeyCard"
        KeyCard.AnchorPoint = Vector2.new(0.5, 0.5)
        KeyCard.Position = UDim2.new(0.5, 0, 0.5, 0)
        KeyCard.Size = UDim2.new(0, 420, 0, 0)
        KeyCard.AutomaticSize = Enum.AutomaticSize.Y
        KeyCard.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        KeyCard.BorderSizePixel = 0
        KeyCard.ZIndex = 80001
        KeyCard.Parent = KeyBackdrop

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = KeyCard

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(48, 48, 48)
        Stroke.Thickness = 1.2
        Stroke.Parent = KeyCard

        local Padding = Instance.new("UIPadding")
        Padding.PaddingTop = UDim.new(0, 20)
        Padding.PaddingBottom = UDim.new(0, 20)
        Padding.PaddingLeft = UDim.new(0, 22)
        Padding.PaddingRight = UDim.new(0, 22)
        Padding.Parent = KeyCard

        local Layout = Instance.new("UIListLayout")
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 12)
        Layout.Parent = KeyCard

        local HeaderRow = Instance.new("Frame")
        HeaderRow.BackgroundTransparency = 1
        HeaderRow.Size = UDim2.new(1, 0, 0, 34)
        HeaderRow.LayoutOrder = 1
        HeaderRow.Parent = KeyCard

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Size = UDim2.new(1, -30, 0, 18)
        TitleLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        TitleLbl.Text = ks.Title or Config.Name or Config.Title or "Volt UI"
        TitleLbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        TitleLbl.TextSize = 16
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Parent = HeaderRow

        local SubtitleLbl = Instance.new("TextLabel")
        SubtitleLbl.BackgroundTransparency = 1
        SubtitleLbl.Position = UDim2.new(0, 0, 0, 18)
        SubtitleLbl.Size = UDim2.new(1, -30, 0, 14)
        SubtitleLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        SubtitleLbl.Text = ks.Subtitle or "Key System"
        SubtitleLbl.TextColor3 = Color3.fromRGB(140, 140, 155)
        SubtitleLbl.TextSize = 12
        SubtitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        SubtitleLbl.Parent = HeaderRow

        local CloseBtn = Instance.new("ImageButton")
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.AnchorPoint = Vector2.new(1, 0)
        CloseBtn.Position = UDim2.new(1, 0, 0, 0)
        CloseBtn.Size = UDim2.new(0, 20, 0, 20)
        CloseBtn.Image = "rbxassetid://121170570745612"
        CloseBtn.ImageColor3 = Color3.fromRGB(150, 150, 160)
        CloseBtn.Parent = HeaderRow
        CloseBtn.MouseButton1Click:Connect(function()
            KeyBackdrop:Destroy()
            VoltUi:Destroy()
        end)

        if ks.Note and ks.Note ~= "" then
            local NoteLbl = Instance.new("TextLabel")
            NoteLbl.BackgroundTransparency = 1
            NoteLbl.Size = UDim2.new(1, 0, 0, 0)
            NoteLbl.AutomaticSize = Enum.AutomaticSize.Y
            NoteLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            NoteLbl.Text = ks.Note
            NoteLbl.TextColor3 = Color3.fromRGB(170, 170, 180)
            NoteLbl.TextSize = 12
            NoteLbl.TextWrapped = true
            NoteLbl.TextXAlignment = Enum.TextXAlignment.Left
            NoteLbl.LayoutOrder = 2
            NoteLbl.Parent = KeyCard
        end

        local InputFrame = Instance.new("Frame")
        InputFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        InputFrame.Size = UDim2.new(1, 0, 0, 36)
        InputFrame.LayoutOrder = 3
        InputFrame.Parent = KeyCard

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = InputFrame

        local InputStroke = Instance.new("UIStroke")
        InputStroke.Color = Color3.fromRGB(48, 48, 48)
        InputStroke.Thickness = 1
        InputStroke.Parent = InputFrame

        local InputBox = Instance.new("TextBox")
        InputBox.BackgroundTransparency = 1
        InputBox.Position = UDim2.new(0, 12, 0, 0)
        InputBox.Size = UDim2.new(1, -24, 1, 0)
        InputBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        InputBox.PlaceholderText = "Enter key here..."
        InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
        InputBox.Text = ""
        InputBox.TextColor3 = Color3.fromRGB(240, 240, 245)
        InputBox.TextSize = 13
        InputBox.ClearTextOnFocus = false
        InputBox.Parent = InputFrame

        local ButtonsRow = Instance.new("Frame")
        ButtonsRow.BackgroundTransparency = 1
        ButtonsRow.Size = UDim2.new(1, 0, 0, 34)
        ButtonsRow.LayoutOrder = 4
        ButtonsRow.Parent = KeyCard

        local BtnLayout = Instance.new("UIListLayout")
        BtnLayout.FillDirection = Enum.FillDirection.Horizontal
        BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        BtnLayout.Padding = UDim.new(0, 10)
        BtnLayout.Parent = ButtonsRow

        local keyLink = ks.KeyLink or ks.URL or ks.Link or (Config.Discord and Config.Discord.Invite and ("https://discord.gg/" .. Config.Discord.Invite))
        if keyLink and keyLink ~= "" then
            local GetBtn = Instance.new("TextButton")
            GetBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            GetBtn.Size = UDim2.new(0, 100, 1, 0)
            GetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            GetBtn.Text = "Get Key"
            GetBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
            GetBtn.TextSize = 12
            GetBtn.Parent = ButtonsRow

            local GetCorner = Instance.new("UICorner")
            GetCorner.CornerRadius = UDim.new(0, 6)
            GetCorner.Parent = GetBtn

            local GetStroke = Instance.new("UIStroke")
            GetStroke.Color = Color3.fromRGB(48, 48, 48)
            GetStroke.Thickness = 1
            GetStroke.Parent = GetBtn

            GetBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(keyLink)
                    Notifications.Notify({
                        Title = "Key System",
                        Content = "Key link copied to clipboard!",
                        Duration = 3
                    })
                else
                    Notifications.Notify({
                        Title = "Key Link",
                        Content = keyLink,
                        Duration = 5
                    })
                end
            end)
        end

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        SubmitBtn.Size = UDim2.new(0, 110, 1, 0)
        SubmitBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        SubmitBtn.Text = "Submit Key"
        SubmitBtn.TextColor3 = Color3.fromRGB(24, 24, 24)
        SubmitBtn.TextSize = 12
        SubmitBtn.Parent = ButtonsRow

        local SubCorner = Instance.new("UICorner")
        SubCorner.CornerRadius = UDim.new(0, 6)
        SubCorner.Parent = SubmitBtn

        local function checkKey()
            local entered = InputBox.Text
            if entered == "" then return end

            local isValid = false
            local msg = nil

            if validKeys[entered] then
                isValid = true
            else
                local onlineOk, onlineMsg = verifyOnline(entered)
                if onlineOk then
                    isValid = true
                    msg = onlineMsg
                else
                    msg = onlineMsg
                end
            end

            if isValid then
                if ks.SaveKey and writefile then
                    pcall(function()
                        writefile(fileName, entered)
                    end)
                end
                Notifications.Notify({
                    Title = "Success",
                    Content = msg or "Key accepted! Welcome.",
                    Duration = 2.5
                })
                Tween(KeyBackdrop, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                task.wait(0.3)
                KeyBackdrop:Destroy()
                onSuccess()
            else
                InputStroke.Color = Color3.fromRGB(240, 70, 70)
                Notifications.Notify({
                    Title = "Invalid Key",
                    Content = msg or "The key you entered is incorrect.",
                    Duration = 3
                })
                task.delay(1.5, function()
                    if InputStroke and InputStroke.Parent then
                        InputStroke.Color = Color3.fromRGB(48, 48, 48)
                    end
                end)
            end
        end

        SubmitBtn.MouseButton1Click:Connect(checkKey)
        InputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then checkKey() end
        end)
    end

    if isAuthSystem then
        if loadingScreen then loadingScreen:SetStatus("Checking OS & Version...") loadingScreen:SetProgress(0.85) task.wait(0) end
        if not Api then
            pcall(function() Api = require(Utils.Api) end)
        end
        if loadingScreen then loadingScreen:SetStatus("Connecting API...") loadingScreen:SetProgress(0.90) task.wait(0) end

        local token = nil
        if Api then
            pcall(function() token = Api.GetToken() end)
        end

        if token and Api then
            task.spawn(function()
                local data = nil
                pcall(function() data = Api.FetchMe() end)
                if data then
                    if loadingScreen then loadingScreen:SetStatus("Finalizing UI...") loadingScreen:SetProgress(1) task.wait(0.5) end
                    OnLoginSuccess()
                    if loadingScreen then loadingScreen:FadeOut() end
                else
                    if loadingScreen then loadingScreen:SetStatus("Finalizing UI...") loadingScreen:SetProgress(1) task.wait(0.5) end
                    LoginPage.Create(VoltUi, function()
                        OnLoginSuccess()
                    end)
                    if loadingScreen then loadingScreen:FadeOut() end
                end
            end)
        else
            task.spawn(function()
                if loadingScreen then loadingScreen:SetStatus("Finalizing UI...") loadingScreen:SetProgress(1) task.wait(0.5) end
                LoginPage.Create(VoltUi, function()
                    OnLoginSuccess()
                end)
                if loadingScreen then loadingScreen:FadeOut() end
            end)
        end
    elseif isStandaloneKey then
        task.spawn(function()
            if loadingScreen then loadingScreen:SetStatus("Finalizing UI...") loadingScreen:SetProgress(1) task.wait(0.5) end
            ShowKeySystem(function() OnLoginSuccess() end)
            if loadingScreen then loadingScreen:FadeOut() end
        end)
    else
        task.spawn(function()
            if loadingScreen then loadingScreen:SetStatus("Finalizing UI...") loadingScreen:SetProgress(1) task.wait(0.5) end
            Main.Visible = true
            if loadingScreen then loadingScreen:FadeOut() end
        end)
    end
    
    maid:GiveTask(SidebarElements.AccountBtn.MouseButton1Click:Connect(function()
        if AccountPageElements and AccountPageElements.Instance then
            PageLayout:JumpTo(AccountPageElements.Instance)
            BottombarElements.Instance.Visible = false
            Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -30)})
            RefreshAccountData()
        end
    end))
    
    if SidebarElements.HomeBtn then
        maid:GiveTask(SidebarElements.HomeBtn.MouseButton1Click:Connect(function()
            PageLayout:JumpTo(Content)
            BottombarElements.Instance.Visible = true
            Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -50)})
        end))
    end
    
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
    
    WindowObject = {
        Instance = VoltUi,
        Main = Main,
        Topbar = TopbarElements,
        Sidebar = SidebarElements,
        Bottombar = BottombarElements,
        ContentContainer = MainContent,
        PageLayout = PageLayout,
        PagesContainer = PagesContainer,
        Content = Content,
        AccountPage = AccountPageElements,
        Maid = maid,
        OnClose = OnClose,
        OnCollapse = OnCollapse
    }
    
    function WindowObject:CreateTab(NameOrConfig, IconAsset)
        local tabName = NameOrConfig
        local tabIcon = IconAsset
        if type(NameOrConfig) == "table" then
            tabName = NameOrConfig.Name or NameOrConfig.Title or "Tab"
            tabIcon = NameOrConfig.Icon or NameOrConfig.IconAsset
        end
        return Tabs.CreateTab(WindowObject, tabName, tabIcon)
    end
    WindowObject.CreateTabSection = WindowObject.CreateTab
    WindowObject.AddTab = WindowObject.CreateTab

    function WindowObject:OpenAccount()
        if AccountPageElements and AccountPageElements.Instance then
            PageLayout:JumpTo(AccountPageElements.Instance)
            BottombarElements.Instance.Visible = false
            Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -30)})
            RefreshAccountData()
        end
    end

    function WindowObject:OpenHome()
        PageLayout:JumpTo(Content)
        BottombarElements.Instance.Visible = true
        Tween(PagesContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, -50)})
        if Api and Api.UserData and Api.UserData.remaining == "Expired" then
            ExpiredOverlay.Visible = true
        else
            ExpiredOverlay.Visible = false
        end
    end
    
    function WindowObject:Notify(Config)
        return Notifications.Notify(Config)
    end

    function WindowObject:Notification(Config)
        return Notifications.Notify(Config)
    end

    function WindowObject:PromptDialog(Config)
        local dialogConfig = type(Config) == "string" and {Content = Config} or (Config or {})
        local titleText = dialogConfig.Title or dialogConfig.Name or "Prompt"
        local contentText = dialogConfig.Content or dialogConfig.Text or dialogConfig.Description or ""
        local buttons = dialogConfig.Buttons or {
            {Text = "Confirm", Callback = function() end},
            {Text = "Cancel", Callback = function() end}
        }

        local DialogBackdrop = Instance.new("TextButton")
        DialogBackdrop.Name = "PromptDialogBackdrop"
        DialogBackdrop.AutoButtonColor = false
        DialogBackdrop.Text = ""
        DialogBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        DialogBackdrop.BackgroundTransparency = 1
        DialogBackdrop.Size = UDim2.new(1, 0, 1, 0)
        DialogBackdrop.ZIndex = 60000
        DialogBackdrop.Parent = VoltUi

        local DialogCard = Instance.new("Frame")
        DialogCard.Name = "DialogCard"
        DialogCard.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        DialogCard.BorderSizePixel = 0
        DialogCard.AnchorPoint = Vector2.new(0.5, 0.5)
        DialogCard.Position = UDim2.new(0.5, 0, 0.5, 0)
        DialogCard.Size = UDim2.new(0, 360, 0, 0)
        DialogCard.AutomaticSize = Enum.AutomaticSize.Y
        DialogCard.ClipsDescendants = true
        DialogCard.ZIndex = 60001
        DialogCard.Parent = DialogBackdrop

        local DialogCorner = Instance.new("UICorner")
        DialogCorner.CornerRadius = UDim.new(0, 8)
        DialogCorner.Parent = DialogCard

        local DialogStroke = Instance.new("UIStroke")
        DialogStroke.Color = Color3.fromRGB(48, 48, 48)
        DialogStroke.Thickness = 1
        DialogStroke.Parent = DialogCard

        local CardScale = Instance.new("UIScale")
        CardScale.Scale = 0.9
        CardScale.Parent = DialogCard

        local CardLayout = Instance.new("UIListLayout")
        CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
        CardLayout.Padding = UDim.new(0, 10)
        CardLayout.Parent = DialogCard

        local CardPadding = Instance.new("UIPadding")
        CardPadding.PaddingTop = UDim.new(0, 14)
        CardPadding.PaddingBottom = UDim.new(0, 14)
        CardPadding.PaddingLeft = UDim.new(0, 16)
        CardPadding.PaddingRight = UDim.new(0, 16)
        CardPadding.Parent = DialogCard

        local HeaderRow = Instance.new("Frame")
        HeaderRow.Name = "HeaderRow"
        HeaderRow.BackgroundTransparency = 1
        HeaderRow.Size = UDim2.new(1, 0, 0, 20)
        HeaderRow.Parent = DialogCard

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, -25, 1, 0)
        TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        TitleLabel.Text = titleText
        TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 60002
        TitleLabel.Parent = HeaderRow

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Name = "Close"
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Position = UDim2.new(1, -16, 0, 0)
        CloseBtn.Size = UDim2.new(0, 16, 0, 16)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
        CloseBtn.TextSize = 12
        CloseBtn.ZIndex = 60002
        CloseBtn.Parent = HeaderRow

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Name = "Content"
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Size = UDim2.new(1, 0, 0, 0)
        ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
        ContentLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        ContentLabel.Text = contentText
        ContentLabel.TextColor3 = Color3.fromRGB(170, 170, 180)
        ContentLabel.TextSize = 13
        ContentLabel.TextWrapped = true
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.ZIndex = 60002
        ContentLabel.Parent = DialogCard

        local ButtonRow = Instance.new("Frame")
        ButtonRow.Name = "ButtonRow"
        ButtonRow.BackgroundTransparency = 1
        ButtonRow.Size = UDim2.new(1, 0, 0, 30)
        ButtonRow.ZIndex = 60002
        ButtonRow.Parent = DialogCard

        local ButtonLayout = Instance.new("UIListLayout")
        ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
        ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        ButtonLayout.Padding = UDim.new(0, 8)
        ButtonLayout.Parent = ButtonRow

        local closing = false
        local function closeDialog()
            if closing then return end
            closing = true
            Tween(DialogBackdrop, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            Tween(CardScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.85})
            task.delay(0.2, function()
                DialogBackdrop:Destroy()
            end)
        end

        CloseBtn.MouseButton1Click:Connect(closeDialog)

        for i, btnData in ipairs(buttons) do
            local bText = btnData.Text or btnData.Title or btnData.Name or "Button"
            local bCb = btnData.Callback or function() end
            local isPrimary = (i == 1 and #buttons > 1)

            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Name = bText
            ActionBtn.AutoButtonColor = false
            ActionBtn.BackgroundColor3 = isPrimary and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(28, 28, 28)
            ActionBtn.Size = UDim2.new(0, 0, 1, 0)
            ActionBtn.AutomaticSize = Enum.AutomaticSize.X
            ActionBtn.Text = ""
            ActionBtn.ZIndex = 60003
            ActionBtn.Parent = ButtonRow

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ActionBtn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = isPrimary and (Config.AccentColor or Color3.fromRGB(245, 245, 245)) or Color3.fromRGB(48, 48, 48)
            BtnStroke.Thickness = 1
            BtnStroke.Parent = ActionBtn

            local BtnPadding = Instance.new("UIPadding")
            BtnPadding.PaddingLeft = UDim.new(0, 14)
            BtnPadding.PaddingRight = UDim.new(0, 14)
            BtnPadding.Parent = ActionBtn

            local BtnLabel = Instance.new("TextLabel")
            BtnLabel.Name = "Text"
            BtnLabel.BackgroundTransparency = 1
            BtnLabel.Size = UDim2.new(1, 0, 1, 0)
            BtnLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            BtnLabel.Text = bText
            BtnLabel.TextColor3 = isPrimary and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(180, 180, 190)
            BtnLabel.TextSize = 12
            BtnLabel.ZIndex = 60004
            BtnLabel.Parent = ActionBtn

            ActionBtn.MouseButton1Click:Connect(function()
                bCb()
                closeDialog()
            end)
        end

        Tween(DialogBackdrop, TweenInfo.new(0.2), {BackgroundTransparency = 0.5})
        Tween(CardScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})

        return {
            Close = closeDialog
        }
    end
    WindowObject.Dialog = WindowObject.PromptDialog
    
    return WindowObject
end

return Window
