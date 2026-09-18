local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Tween = require(script.Parent.Parent.Utils.Tween)
local Notifications = nil
pcall(function()
    Notifications = require(script.Parent.Notifications)
end)

local isfileFunc = isfile or (file and file.Exists) or nil
local readfileFunc = readfile or (file and file.Read) or nil
local writefileFunc = writefile or (file and file.Write) or nil
local makefolderFunc = makefolder or (file and file.CreateDir) or nil
local isfolderFunc = isfolder or (file and file.IsDir) or nil

local function CreateHeader(parent, iconAsset, titleText)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 18)
    header.LayoutOrder = 1
    header.Parent = parent

    local hLayout = Instance.new("UIListLayout")
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    hLayout.Padding = UDim.new(0, 6)
    hLayout.Parent = header

    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 15, 0, 15)
    icon.Image = iconAsset
    icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    icon.Parent = header

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.Size = UDim2.new(1, -22, 1, 0)
    title.Text = titleText
    title.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
end

local HomePage = {}

function HomePage.Create(Content, Maid, BackCallback, WindowObject, ApiParam)
    local Api = ApiParam
    if not Api then
        pcall(function()
            Api = require(script.Parent.Parent.Utils.Api)
        end)
    end


    local function SendNotification(options)
        if Notifications and Notifications.Notify then
            Notifications.Notify(options)
        elseif WindowObject and WindowObject.Notify then
            WindowObject:Notify(options)
        end
    end

    local NotificationsPopover = nil
    local ProfilePopover = nil
    local Page = Instance.new("Frame")
    Page.Name = "HomePage"
    Page.AnchorPoint = Vector2.new(0, 0)
    Page.BackgroundColor3 = Color3.new(0.067, 0.067, 0.067)
    Page.BorderColor3 = Color3.new(0, 0, 0)
    Page.BorderSizePixel = 0
    Page.Position = UDim2.new(0, 0, 0, 0)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.LayoutOrder = 0
    Page.Parent = Content

    local PageCorner = Instance.new("UICorner")
    PageCorner.CornerRadius = UDim.new(0, 8)
    PageCorner.Parent = Page

    local PageStroke = Instance.new("UIStroke")
    PageStroke.Color = Color3.new(0.149, 0.149, 0.149)
    PageStroke.Parent = Page

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = Page

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Color3.new(1, 1, 1)
    Topbar.BackgroundTransparency = 1
    Topbar.BorderColor3 = Color3.new(0, 0, 0)
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.LayoutOrder = 0
    Topbar.Parent = Page

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.BottomLeftRadius = UDim.new(0, 0)
    TopbarCorner.BottomRightRadius = UDim.new(0, 0)
    TopbarCorner.Parent = Topbar

    local SetNotifOpen = nil
    local SetProfileOpen = nil

    local ReturnButton = Instance.new("ImageButton")
    ReturnButton.Name = "Return"
    ReturnButton.BackgroundColor3 = Color3.new(1, 1, 1)
    ReturnButton.BackgroundTransparency = 1
    ReturnButton.BorderColor3 = Color3.new(0, 0, 0)
    ReturnButton.BorderSizePixel = 0
    ReturnButton.AnchorPoint = Vector2.new(0, 0.5)
    ReturnButton.Position = UDim2.new(0, 8, 0.5, 0)
    ReturnButton.Size = UDim2.new(0, 28, 0, 28)
    ReturnButton.Parent = Topbar

    local ReturnCorner = Instance.new("UICorner")
    ReturnCorner.CornerRadius = UDim.new(0, 6)
    ReturnCorner.Parent = ReturnButton

    local ReturnIcon = Instance.new("ImageLabel")
    ReturnIcon.Name = "Icon"
    ReturnIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    ReturnIcon.BackgroundTransparency = 1
    ReturnIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    ReturnIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    ReturnIcon.Image = "rbxassetid://93526157530558"
    ReturnIcon.ImageTransparency = 0.3
    ReturnIcon.Size = UDim2.new(0, 20, 0, 20)
    ReturnIcon.Parent = ReturnButton

    if BackCallback then
        Maid:GiveTask(ReturnButton.MouseButton1Click:Connect(function()
            if SetNotifOpen then SetNotifOpen(false) end
            if SetProfileOpen then SetProfileOpen(false) end
            BackCallback()
        end))
    end

    Maid:GiveTask(ReturnButton.MouseEnter:Connect(function()
        Tween(ReturnButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9})
    end))
    Maid:GiveTask(ReturnButton.MouseLeave:Connect(function()
        Tween(ReturnButton, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end))

    local PageTitle = Instance.new("TextLabel")
    PageTitle.Name = "Title"
    PageTitle.BackgroundColor3 = Color3.new(1, 1, 1)
    PageTitle.BackgroundTransparency = 1
    PageTitle.Position = UDim2.new(0, 44, 0, 0)
    PageTitle.Size = UDim2.new(0, 150, 1, 0)
    PageTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PageTitle.Text = "Home"
    PageTitle.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    PageTitle.TextSize = 18
    PageTitle.TextXAlignment = Enum.TextXAlignment.Left
    PageTitle.Parent = Topbar

    local Icons = Instance.new("Frame")
    Icons.Name = "Icons"
    Icons.BackgroundColor3 = Color3.new(1, 1, 1)
    Icons.BackgroundTransparency = 1
    Icons.BorderColor3 = Color3.new(0, 0, 0)
    Icons.BorderSizePixel = 0
    Icons.AnchorPoint = Vector2.new(1, 0)
    Icons.Position = UDim2.new(1, -10, 0, 0)
    Icons.Size = UDim2.new(0, 135, 0, 40)
    Icons.Parent = Topbar

    local IconsLayout = Instance.new("UIListLayout")
    IconsLayout.FillDirection = Enum.FillDirection.Horizontal
    IconsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    IconsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    IconsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    IconsLayout.Padding = UDim.new(0, 4)
    IconsLayout.Parent = Icons

    local MainFrame = (WindowObject and WindowObject.Main) or Content

    local NotificationsBtn = Instance.new("ImageButton")
    NotificationsBtn.Name = "Notifications"
    NotificationsBtn.AutoButtonColor = false
    NotificationsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotificationsBtn.BackgroundTransparency = 1
    NotificationsBtn.BorderColor3 = Color3.new(0, 0, 0)
    NotificationsBtn.BorderSizePixel = 0
    NotificationsBtn.Size = UDim2.new(0, 34, 0, 34)
    NotificationsBtn.Parent = Icons

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotificationsBtn

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(50, 50, 50)
    NotifStroke.Transparency = 1
    NotifStroke.Thickness = 1.4
    NotifStroke.Parent = NotificationsBtn

    local NotifIcon = Instance.new("ImageLabel")
    NotifIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    NotifIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    NotifIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.BorderColor3 = Color3.new(0, 0, 0)
    NotifIcon.BorderSizePixel = 0
    NotifIcon.Image = "rbxassetid://113899772841352"
    NotifIcon.ImageColor3 = Color3.fromRGB(220, 220, 220)
    NotifIcon.Size = UDim2.new(0, 20, 0, 20)
    NotifIcon.Parent = NotificationsBtn

    local NotifBadge = Instance.new("Frame")
    NotifBadge.Name = "Badge"
    NotifBadge.AnchorPoint = Vector2.new(0.5, 0.5)
    NotifBadge.Position = UDim2.new(1, -8, 0, 8)
    NotifBadge.Size = UDim2.new(0, 16, 0, 16)
    NotifBadge.BackgroundColor3 = Color3.fromRGB(235, 45, 45)
    NotifBadge.BorderSizePixel = 0
    NotifBadge.ZIndex = 1000
    NotifBadge.Visible = false
    NotifBadge.Parent = NotificationsBtn

    local NotifBadgeCorner = Instance.new("UICorner")
    NotifBadgeCorner.CornerRadius = UDim.new(1, 0)
    NotifBadgeCorner.Parent = NotifBadge

    local NotifBadgeStroke = Instance.new("UIStroke")
    NotifBadgeStroke.Color = Color3.fromRGB(25, 25, 25)
    NotifBadgeStroke.Thickness = 1.2
    NotifBadgeStroke.Parent = NotifBadge

    local NotifBadgeText = Instance.new("TextLabel")
    NotifBadgeText.Name = "Count"
    NotifBadgeText.AnchorPoint = Vector2.new(0.5, 0.5)
    NotifBadgeText.Position = UDim2.new(0.5, 0, 0.5, -1)
    NotifBadgeText.Size = UDim2.new(1, 0, 1, 0)
    NotifBadgeText.BackgroundTransparency = 1
    NotifBadgeText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NotifBadgeText.Text = "0"
    NotifBadgeText.TextColor3 = Color3.new(1, 1, 1)
    NotifBadgeText.TextSize = 10
    NotifBadgeText.TextXAlignment = Enum.TextXAlignment.Center
    NotifBadgeText.TextYAlignment = Enum.TextYAlignment.Center
    NotifBadgeText.ZIndex = 1001
    NotifBadgeText.Parent = NotifBadge

    local Tooltip = Instance.new("Frame")
    Tooltip.Name = "NotificationsTooltip"
    Tooltip.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Tooltip.BackgroundTransparency = 1
    Tooltip.AnchorPoint = Vector2.new(0.5, 0)
    Tooltip.Size = UDim2.new(0, 0, 0, 22)
    Tooltip.AutomaticSize = Enum.AutomaticSize.X
    Tooltip.BorderSizePixel = 0
    Tooltip.ZIndex = 60000
    Tooltip.Visible = false
    Tooltip.Parent = MainFrame

    local TooltipCorner = Instance.new("UICorner")
    TooltipCorner.CornerRadius = UDim.new(0, 5)
    TooltipCorner.Parent = Tooltip

    local TooltipPadding = Instance.new("UIPadding")
    TooltipPadding.PaddingLeft = UDim.new(0, 8)
    TooltipPadding.PaddingRight = UDim.new(0, 8)
    TooltipPadding.Parent = Tooltip

    local TooltipStroke = Instance.new("UIStroke")
    TooltipStroke.Color = Color3.fromRGB(48, 48, 48)
    TooltipStroke.Transparency = 1
    TooltipStroke.Parent = Tooltip

    local TooltipText = Instance.new("TextLabel")
    TooltipText.BackgroundTransparency = 1
    TooltipText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TooltipText.Text = "Notifications"
    TooltipText.TextColor3 = Color3.fromRGB(210, 210, 210)
    TooltipText.TextSize = 12
    TooltipText.TextTransparency = 1
    TooltipText.Size = UDim2.new(1, 0, 1, 0)
    TooltipText.AutomaticSize = Enum.AutomaticSize.X
    TooltipText.ZIndex = 60001
    TooltipText.Parent = Tooltip

    NotificationsPopover = Instance.new("CanvasGroup")
    NotificationsPopover.Name = "NotificationsPopover"
    NotificationsPopover.AnchorPoint = Vector2.new(1, 0)
    NotificationsPopover.Size = UDim2.new(0, 305, 0, 275)
    NotificationsPopover.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotificationsPopover.BorderSizePixel = 0
    NotificationsPopover.ZIndex = 50000
    NotificationsPopover.Visible = false
    NotificationsPopover.GroupTransparency = 1
    NotificationsPopover.ClipsDescendants = true
    NotificationsPopover.Parent = MainFrame

    local PopoverCorner = Instance.new("UICorner")
    PopoverCorner.CornerRadius = UDim.new(0, 10)
    PopoverCorner.Parent = NotificationsPopover

    local PopoverStroke = Instance.new("UIStroke")
    PopoverStroke.Color = Color3.fromRGB(45, 45, 45)
    PopoverStroke.Thickness = 1.2
    PopoverStroke.Parent = NotificationsPopover

    local PopoverHeader = Instance.new("Frame")
    PopoverHeader.Name = "Header"
    PopoverHeader.BackgroundTransparency = 1
    PopoverHeader.Size = UDim2.new(1, 0, 0, 44)
    PopoverHeader.ZIndex = 50001
    PopoverHeader.Parent = NotificationsPopover

    local PopoverTitle = Instance.new("TextLabel")
    PopoverTitle.Name = "Title"
    PopoverTitle.BackgroundTransparency = 1
    PopoverTitle.Position = UDim2.new(0, 16, 0, 0)
    PopoverTitle.Size = UDim2.new(0.5, 0, 1, 0)
    PopoverTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PopoverTitle.Text = "Notifications"
    PopoverTitle.TextColor3 = Color3.new(0.95, 0.95, 0.95)
    PopoverTitle.TextSize = 15
    PopoverTitle.TextXAlignment = Enum.TextXAlignment.Left
    PopoverTitle.ZIndex = 50002
    PopoverTitle.Parent = PopoverHeader

    local ClearAllBtn = Instance.new("TextButton")
    ClearAllBtn.Name = "ClearAll"
    ClearAllBtn.BackgroundTransparency = 1
    ClearAllBtn.AnchorPoint = Vector2.new(1, 0.5)
    ClearAllBtn.Position = UDim2.new(1, -14, 0.5, 0)
    ClearAllBtn.Size = UDim2.new(0, 80, 0, 26)
    ClearAllBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ClearAllBtn.Text = "✓  Clear all"
    ClearAllBtn.TextColor3 = Color3.fromRGB(130, 130, 130)
    ClearAllBtn.TextSize = 13
    ClearAllBtn.TextXAlignment = Enum.TextXAlignment.Right
    ClearAllBtn.ZIndex = 50002
    ClearAllBtn.Parent = PopoverHeader

    Maid:GiveTask(ClearAllBtn.MouseEnter:Connect(function()
        Tween(ClearAllBtn, TweenInfo.new(0.2), {TextColor3 = Color3.new(1, 1, 1)})
    end))
    Maid:GiveTask(ClearAllBtn.MouseLeave:Connect(function()
        Tween(ClearAllBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(130, 130, 130)})
    end))

    local PopoverDivider = Instance.new("Frame")
    PopoverDivider.Name = "Divider"
    PopoverDivider.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    PopoverDivider.BorderSizePixel = 0
    PopoverDivider.Position = UDim2.new(0, 0, 1, -1)
    PopoverDivider.Size = UDim2.new(1, 0, 0, 1)
    PopoverDivider.ZIndex = 50001
    PopoverDivider.Parent = PopoverHeader

    local PopoverBody = Instance.new("Frame")
    PopoverBody.Name = "Body"
    PopoverBody.BackgroundTransparency = 1
    PopoverBody.Position = UDim2.new(0, 0, 0, 44)
    PopoverBody.Size = UDim2.new(1, 0, 1, -44)
    PopoverBody.ZIndex = 50001
    PopoverBody.Parent = NotificationsPopover

    local EmptyState = Instance.new("Frame")
    EmptyState.Name = "EmptyState"
    EmptyState.BackgroundTransparency = 1
    EmptyState.Size = UDim2.new(1, 0, 1, 0)
    EmptyState.ZIndex = 50001
    EmptyState.Parent = PopoverBody

    local EmptyContent = Instance.new("Frame")
    EmptyContent.Name = "EmptyContent"
    EmptyContent.BackgroundTransparency = 1
    EmptyContent.AnchorPoint = Vector2.new(0.5, 0.5)
    EmptyContent.Position = UDim2.new(0.5, 0, 0.5, 0)
    EmptyContent.Size = UDim2.new(1, -32, 0, 134)
    EmptyContent.ZIndex = 50001
    EmptyContent.Parent = EmptyState

    local IconBox = Instance.new("Frame")
    IconBox.Name = "IconBox"
    IconBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    IconBox.BorderSizePixel = 0
    IconBox.AnchorPoint = Vector2.new(0.5, 0)
    IconBox.Position = UDim2.new(0.5, 0, 0, 0)
    IconBox.Size = UDim2.new(0, 58, 0, 58)
    IconBox.ZIndex = 50002
    IconBox.Parent = EmptyContent

    local IconBoxCorner = Instance.new("UICorner")
    IconBoxCorner.CornerRadius = UDim.new(0, 14)
    IconBoxCorner.Parent = IconBox

    local IconBoxStroke = Instance.new("UIStroke")
    IconBoxStroke.Color = Color3.fromRGB(42, 42, 42)
    IconBoxStroke.Thickness = 1
    IconBoxStroke.Parent = IconBox

    local IconBoxImg = Instance.new("ImageLabel")
    IconBoxImg.Name = "Icon"
    IconBoxImg.AnchorPoint = Vector2.new(0.5, 0.5)
    IconBoxImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconBoxImg.Size = UDim2.new(0, 28, 0, 28)
    IconBoxImg.BackgroundTransparency = 1
    IconBoxImg.Image = "rbxassetid://118205848671512"
    IconBoxImg.ImageColor3 = Color3.fromRGB(180, 180, 180)
    IconBoxImg.ZIndex = 50003
    IconBoxImg.Parent = IconBox

    local TextBox = Instance.new("Frame")
    TextBox.Name = "TextBox"
    TextBox.BackgroundTransparency = 1
    TextBox.AnchorPoint = Vector2.new(0.5, 0)
    TextBox.Position = UDim2.new(0.5, 0, 0, 70)
    TextBox.Size = UDim2.new(1, 0, 0, 60)
    TextBox.ZIndex = 50002
    TextBox.Parent = EmptyContent

    local CaughtUpTitle = Instance.new("TextLabel")
    CaughtUpTitle.Name = "Title"
    CaughtUpTitle.BackgroundTransparency = 1
    CaughtUpTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    CaughtUpTitle.AnchorPoint = Vector2.new(0.5, 0)
    CaughtUpTitle.Position = UDim2.new(0.5, 0, 0, 0)
    CaughtUpTitle.Size = UDim2.new(1, 0, 0, 20)
    CaughtUpTitle.Text = "You're all caught up"
    CaughtUpTitle.TextColor3 = Color3.new(0.95, 0.95, 0.95)
    CaughtUpTitle.TextSize = 16
    CaughtUpTitle.TextXAlignment = Enum.TextXAlignment.Center
    CaughtUpTitle.TextYAlignment = Enum.TextYAlignment.Center
    CaughtUpTitle.ZIndex = 50003
    CaughtUpTitle.Parent = TextBox

    local CaughtUpDesc = Instance.new("TextLabel")
    CaughtUpDesc.Name = "Description"
    CaughtUpDesc.BackgroundTransparency = 1
    CaughtUpDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    CaughtUpDesc.AnchorPoint = Vector2.new(0.5, 0)
    CaughtUpDesc.Position = UDim2.new(0.5, 0, 0, 24)
    CaughtUpDesc.Size = UDim2.new(1, 0, 0, 32)
    CaughtUpDesc.Text = "Milestones, recaps and alerts will show up here."
    CaughtUpDesc.TextColor3 = Color3.fromRGB(120, 120, 120)
    CaughtUpDesc.TextSize = 13
    CaughtUpDesc.TextWrapped = true
    CaughtUpDesc.TextXAlignment = Enum.TextXAlignment.Center
    CaughtUpDesc.TextYAlignment = Enum.TextYAlignment.Top
    CaughtUpDesc.ZIndex = 50003
    CaughtUpDesc.Parent = TextBox

    local NotificationsScroll = Instance.new("ScrollingFrame")
    NotificationsScroll.Name = "NotificationsScroll"
    NotificationsScroll.BackgroundTransparency = 1
    NotificationsScroll.BorderSizePixel = 0
    NotificationsScroll.Size = UDim2.new(1, 0, 1, 0)
    NotificationsScroll.ScrollBarThickness = 2
    NotificationsScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    NotificationsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NotificationsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NotificationsScroll.Visible = false
    NotificationsScroll.ZIndex = 50001
    NotificationsScroll.Parent = PopoverBody

    local NotifScrollLayout = Instance.new("UIListLayout")
    NotifScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifScrollLayout.Padding = UDim.new(0, 8)
    NotifScrollLayout.Parent = NotificationsScroll

    local NotifScrollPadding = Instance.new("UIPadding")
    NotifScrollPadding.PaddingTop = UDim.new(0, 10)
    NotifScrollPadding.PaddingBottom = UDim.new(0, 10)
    NotifScrollPadding.PaddingLeft = UDim.new(0, 12)
    NotifScrollPadding.PaddingRight = UDim.new(0, 12)
    NotifScrollPadding.Parent = NotificationsScroll


    local currentNotifications = {}
    local readNotificationIds = {}
    local clearedNotificationIds = {}

    local function LoadReadNotifications()
        pcall(function()
            if isfileFunc and readfileFunc and isfileFunc("VoltHub/ReadNotifications.json") then
                local content = readfileFunc("VoltHub/ReadNotifications.json")
                if content and #content > 0 then
                    local data = HttpService:JSONDecode(content)
                    if type(data) == "table" then
                        if data.read and type(data.read) == "table" then
                            for k, v in pairs(data.read) do
                                readNotificationIds[k] = v
                            end
                        end
                        if data.cleared and type(data.cleared) == "table" then
                            for k, v in pairs(data.cleared) do
                                clearedNotificationIds[k] = v
                            end
                        end
                        for k, v in pairs(data) do
                            if k ~= "read" and k ~= "cleared" then
                                readNotificationIds[k] = v
                            end
                        end
                    end
                end
            end
        end)
    end

    local function SaveReadNotifications()
        pcall(function()
            if writefileFunc then
                if makefolderFunc and isfolderFunc and not isfolderFunc("VoltHub") then
                    makefolderFunc("VoltHub")
                end
                local data = {
                    read = readNotificationIds,
                    cleared = clearedNotificationIds
                }
                writefileFunc("VoltHub/ReadNotifications.json", HttpService:JSONEncode(data))
            end
        end)
    end

    LoadReadNotifications()

    local function RenderNotifications(notifs)
        currentNotifications = notifs or {}
        
        for _, child in ipairs(NotificationsScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        local unreadCount = 0
        local visibleCount = 0
        for _, n in ipairs(currentNotifications) do
            local id = tostring(n._id or n.id or (tostring(n.title) .. "_" .. tostring(n.message)))
            if not clearedNotificationIds[id] then
                visibleCount = visibleCount + 1
                if not readNotificationIds[id] then
                    unreadCount = unreadCount + 1
                end

                local Card = Instance.new("Frame")
                Card.Name = "NotifCard"
                Card.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                Card.BorderSizePixel = 0
                Card.Size = UDim2.new(1, 0, 0, 0)
                Card.AutomaticSize = Enum.AutomaticSize.Y
                Card.ZIndex = 50002
                Card.Parent = NotificationsScroll

                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 8)
                CardCorner.Parent = Card

                local CardStroke = Instance.new("UIStroke")
                CardStroke.Color = Color3.fromRGB(44, 44, 44)
                CardStroke.Thickness = 1
                CardStroke.Parent = Card

                local CardPadding = Instance.new("UIPadding")
                CardPadding.PaddingTop = UDim.new(0, 10)
                CardPadding.PaddingBottom = UDim.new(0, 10)
                CardPadding.PaddingLeft = UDim.new(0, 12)
                CardPadding.PaddingRight = UDim.new(0, 12)
                CardPadding.Parent = Card

                local CardLayout = Instance.new("UIListLayout")
                CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
                CardLayout.Padding = UDim.new(0, 4)
                CardLayout.Parent = Card

                local HeaderRow = Instance.new("Frame")
                HeaderRow.BackgroundTransparency = 1
                HeaderRow.Size = UDim2.new(1, 0, 0, 18)
                HeaderRow.ZIndex = 50003
                HeaderRow.Parent = Card

                local HeaderLayout = Instance.new("UIListLayout")
                HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
                HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
                HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                HeaderLayout.Parent = HeaderRow

                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                TitleLabel.Text = tostring(n.title or "Notification")
                TitleLabel.TextColor3 = Color3.new(0.95, 0.95, 0.95)
                TitleLabel.TextSize = 14
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
                TitleLabel.ZIndex = 50003
                TitleLabel.Parent = HeaderRow

                local DateLabel = Instance.new("TextLabel")
                DateLabel.BackgroundTransparency = 1
                DateLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                DateLabel.Size = UDim2.new(0.3, 0, 1, 0)
                DateLabel.Text = n.createdAt and string.sub(tostring(n.createdAt), 1, 10) or "Recent"
                DateLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
                DateLabel.TextSize = 11
                DateLabel.TextXAlignment = Enum.TextXAlignment.Right
                DateLabel.ZIndex = 50003
                DateLabel.Parent = HeaderRow

                local MsgLabel = Instance.new("TextLabel")
                MsgLabel.BackgroundTransparency = 1
                MsgLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                MsgLabel.Size = UDim2.new(1, 0, 0, 0)
                MsgLabel.AutomaticSize = Enum.AutomaticSize.Y
                MsgLabel.Text = tostring(n.message or "")
                MsgLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                MsgLabel.TextSize = 12
                MsgLabel.TextWrapped = true
                MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
                MsgLabel.ZIndex = 50003
                MsgLabel.Parent = Card
            end
        end

        if visibleCount > 0 and unreadCount > 0 then
            NotifBadgeText.Text = unreadCount > 99 and "99+" or tostring(unreadCount)
            NotifBadge.Visible = true
            EmptyState.Visible = false
            NotificationsScroll.Visible = true
        elseif visibleCount > 0 then
            NotifBadge.Visible = false
            EmptyState.Visible = false
            NotificationsScroll.Visible = true
        else
            NotifBadge.Visible = false
            EmptyState.Visible = true
            NotificationsScroll.Visible = false
        end
    end

    local function FetchNotifications()
        task.spawn(function()
            local getFunc = (request and function(u) return request({Url = u, Method = "GET"}) end)
                         or (http_request and function(u) return http_request({Url = u, Method = "GET"}) end)
                         or (syn and syn.request and function(u) return syn.request({Url = u, Method = "GET"}) end)
                         or (game and game.HttpGet and function(u) return { Body = game:HttpGet(u) } end)
            if not getFunc then return end

            local url = "https://getvolt-hub.onrender.com/notifications"
            local queryParams = {}
            if Api and Api.UserData then
                if Api.UserData._id or Api.UserData.id then
                    table.insert(queryParams, "userId=" .. tostring(Api.UserData._id or Api.UserData.id))
                end
                if Api.UserData.discordId then
                    table.insert(queryParams, "discordId=" .. tostring(Api.UserData.discordId))
                end
            end
            if #queryParams > 0 then
                url = url .. "?" .. table.concat(queryParams, "&")
            end

            local ok, res = pcall(getFunc, url)
            if ok and res and res.Body then
                local decOk, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
                if decOk and data and data.notifications then
                    RenderNotifications(data.notifications)
                end
            end
        end)
    end

    local FetchUpdates = nil

    task.spawn(function()
        FetchNotifications()
        if FetchUpdates then FetchUpdates() end
        while Page and Page.Parent do
            task.wait(30)
            FetchNotifications()
            if FetchUpdates then FetchUpdates() end
        end
    end)

    local function UpdateFloatingPositions()
        if NotificationsBtn and MainFrame and NotificationsBtn.Parent then
            local btnPos = NotificationsBtn.AbsolutePosition
            local mainPos = MainFrame.AbsolutePosition
            local rightX = (btnPos.X - mainPos.X) + NotificationsBtn.AbsoluteSize.X
            local bottomY = (btnPos.Y - mainPos.Y) + NotificationsBtn.AbsoluteSize.Y + 6
            local centerX = (btnPos.X - mainPos.X) + (NotificationsBtn.AbsoluteSize.X / 2)
            
            NotificationsPopover.Position = UDim2.new(0, rightX, 0, bottomY)
            NotificationsPopover.AnchorPoint = Vector2.new(1, 0)
            
            Tooltip.Position = UDim2.new(0, centerX, 0, bottomY)
            Tooltip.AnchorPoint = Vector2.new(0.5, 0)
        end
    end

    local isNotifOpen = false
    local isHoveringNotif = false
    local TweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    SetNotifOpen = function(open)
        isNotifOpen = open
        Tooltip.Visible = false
        if isNotifOpen then
            if SetProfileOpen then SetProfileOpen(false) end
            UpdateFloatingPositions()
            NotificationsPopover.Visible = true
            NotificationsPopover.GroupTransparency = 1
            Tween(NotificationsBtn, TweenInfoFast, {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            Tween(NotifStroke, TweenInfoFast, {Color = Color3.new(1, 1, 1), Transparency = 0, Thickness = 1.4})
            Tween(NotificationsPopover, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})

            for _, n in ipairs(currentNotifications) do
                local id = tostring(n._id or n.id or (tostring(n.title) .. "_" .. tostring(n.message)))
                readNotificationIds[id] = true
            end
            SaveReadNotifications()
            NotifBadge.Visible = false
        else
            local targetColor = isHoveringNotif and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
            local targetTrans = isHoveringNotif and 0.5 or 1
            Tween(NotificationsBtn, TweenInfoFast, {BackgroundTransparency = isHoveringNotif and 0.85 or 1})
            Tween(NotifStroke, TweenInfoFast, {Color = targetColor, Transparency = targetTrans, Thickness = 1.2})
            Tween(NotificationsPopover, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
            task.delay(0.15, function()
                if not isNotifOpen then
                    NotificationsPopover.Visible = false
                end
            end)
        end
    end

    Maid:GiveTask(NotificationsBtn.MouseEnter:Connect(function()
        isHoveringNotif = true
        if not isNotifOpen then
            UpdateFloatingPositions()
            Tooltip.Visible = true
            Tween(NotificationsBtn, TweenInfoFast, {BackgroundTransparency = 0.85})
            Tween(NotifStroke, TweenInfoFast, {Color = Color3.fromRGB(70, 70, 70), Transparency = 0.5})
            Tween(Tooltip, TweenInfoFast, {BackgroundTransparency = 0})
            Tween(TooltipText, TweenInfoFast, {TextTransparency = 0})
            Tween(TooltipStroke, TweenInfoFast, {Transparency = 0})
        end
    end))

    Maid:GiveTask(NotificationsBtn.MouseLeave:Connect(function()
        isHoveringNotif = false
        Tween(Tooltip, TweenInfoFast, {BackgroundTransparency = 1})
        Tween(TooltipText, TweenInfoFast, {TextTransparency = 1})
        Tween(TooltipStroke, TweenInfoFast, {Transparency = 1})
        task.delay(0.2, function()
            if not isHoveringNotif then
                Tooltip.Visible = false
            end
        end)
        if not isNotifOpen then
            Tween(NotificationsBtn, TweenInfoFast, {BackgroundTransparency = 1})
            Tween(NotifStroke, TweenInfoFast, {Color = Color3.fromRGB(50, 50, 50), Transparency = 1})
        end
    end))

    Maid:GiveTask(NotificationsBtn.MouseButton1Click:Connect(function()
        SetNotifOpen(not isNotifOpen)
    end))

    Maid:GiveTask(ClearAllBtn.MouseButton1Click:Connect(function()
        for _, n in ipairs(currentNotifications) do
            local id = tostring(n._id or n.id or (tostring(n.title) .. "_" .. tostring(n.message)))
            clearedNotificationIds[id] = true
            readNotificationIds[id] = true
        end
        SaveReadNotifications()
        NotifBadge.Visible = false
        EmptyState.Visible = true
        NotificationsScroll.Visible = false
        SetNotifOpen(false)
    end))

    Maid:GiveTask(NotificationsBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if isNotifOpen or isHoveringNotif then
            UpdateFloatingPositions()
        end
    end))

    Maid:GiveTask(Page:GetPropertyChangedSignal("Visible"):Connect(function()
        if not Page.Visible then
            SetNotifOpen(false)
        end
    end))

    do
        local isProfileOpen = false
        local TweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        local AccountBtn = Instance.new("ImageButton")
        AccountBtn.Name = "Account"
        AccountBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        AccountBtn.BackgroundTransparency = 0
        AccountBtn.BorderColor3 = Color3.new(0, 0, 0)
        AccountBtn.BorderSizePixel = 0
        AccountBtn.LayoutOrder = 1
        AccountBtn.Size = UDim2.new(0, 64, 0, 34)
        AccountBtn.AutoButtonColor = false
        AccountBtn.Parent = Icons

        local AccountBtnCorner = Instance.new("UICorner")
        AccountBtnCorner.CornerRadius = UDim.new(0, 10)
        AccountBtnCorner.Parent = AccountBtn

        local AccountBtnStroke = Instance.new("UIStroke")
        AccountBtnStroke.Color = Color3.fromRGB(220, 220, 220)
        AccountBtnStroke.Thickness = 1.2
        AccountBtnStroke.Transparency = 1
        AccountBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        AccountBtnStroke.Parent = AccountBtn

        local AccountBtnLayout = Instance.new("UIListLayout")
        AccountBtnLayout.FillDirection = Enum.FillDirection.Horizontal
        AccountBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        AccountBtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
        AccountBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        AccountBtnLayout.Padding = UDim.new(0, 6)
        AccountBtnLayout.Parent = AccountBtn

        local AvatarImg = Instance.new("ImageLabel")
        AvatarImg.Name = "Avatar"
        AvatarImg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        AvatarImg.BorderSizePixel = 0
        AvatarImg.Size = UDim2.new(0, 24, 0, 24)
        AvatarImg.LayoutOrder = 1
        AvatarImg.Parent = AccountBtn

        local AvatarCorner = Instance.new("UICorner")
        AvatarCorner.CornerRadius = UDim.new(0, 6)
        AvatarCorner.Parent = AvatarImg

        local ChevronIcon = Instance.new("ImageLabel")
        ChevronIcon.Name = "Chevron"
        ChevronIcon.BackgroundTransparency = 1
        ChevronIcon.BorderSizePixel = 0
        ChevronIcon.Image = "rbxassetid://6031091004"
        ChevronIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        ChevronIcon.Size = UDim2.new(0, 14, 0, 14)
        ChevronIcon.LayoutOrder = 2
        ChevronIcon.Parent = AccountBtn

        local lp = Players.LocalPlayer
        if lp then
            task.spawn(function()
                local thumb = nil
                pcall(function()
                    thumb = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                end)
                if thumb then
                    AvatarImg.Image = thumb
                end
            end)
        end

        ProfilePopover = Instance.new("CanvasGroup")
        ProfilePopover.Name = "ProfilePopover"
        ProfilePopover.AnchorPoint = Vector2.new(1, 0)
        ProfilePopover.Size = UDim2.new(0, 200, 0, 0)
        ProfilePopover.AutomaticSize = Enum.AutomaticSize.Y
        ProfilePopover.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ProfilePopover.BorderSizePixel = 0
        ProfilePopover.ZIndex = 50000
        ProfilePopover.Visible = false
        ProfilePopover.GroupTransparency = 1
        ProfilePopover.ClipsDescendants = true
        ProfilePopover.Parent = MainFrame

        local PopoverCorner = Instance.new("UICorner")
        PopoverCorner.CornerRadius = UDim.new(0, 12)
        PopoverCorner.Parent = ProfilePopover

        local PopoverStroke = Instance.new("UIStroke")
        PopoverStroke.Color = Color3.fromRGB(45, 45, 45)
        PopoverStroke.Thickness = 1.2
        PopoverStroke.Parent = ProfilePopover

        local PopoverLayout = Instance.new("UIListLayout")
        PopoverLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PopoverLayout.Padding = UDim.new(0, 0)
        PopoverLayout.Parent = ProfilePopover

        local HeaderFrame = Instance.new("Frame")
        HeaderFrame.Name = "Header"
        HeaderFrame.BackgroundTransparency = 1
        HeaderFrame.Size = UDim2.new(1, 0, 0, 52)
        HeaderFrame.LayoutOrder = 1
        HeaderFrame.ZIndex = 50001
        HeaderFrame.Parent = ProfilePopover

        local HeaderPadding = Instance.new("UIPadding")
        HeaderPadding.PaddingLeft = UDim.new(0, 14)
        HeaderPadding.PaddingRight = UDim.new(0, 14)
        HeaderPadding.PaddingTop = UDim.new(0, 10)
        HeaderPadding.PaddingBottom = UDim.new(0, 10)
        HeaderPadding.Parent = HeaderFrame

        local HeaderLayout = Instance.new("UIListLayout")
        HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        HeaderLayout.Padding = UDim.new(0, 2)
        HeaderLayout.Parent = HeaderFrame

        local UsernameLabel = Instance.new("TextLabel")
        UsernameLabel.Name = "Username"
        UsernameLabel.BackgroundTransparency = 1
        UsernameLabel.Size = UDim2.new(1, 0, 0, 18)
        UsernameLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        UsernameLabel.Text = (lp and lp.Name) or (Api and Api.UserData and Api.UserData.username) or "User"
        UsernameLabel.TextColor3 = Color3.new(0.95, 0.95, 0.95)
        UsernameLabel.TextSize = 15
        UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
        UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        UsernameLabel.ZIndex = 50002
        UsernameLabel.LayoutOrder = 1
        UsernameLabel.Parent = HeaderFrame

        local IdLabel = Instance.new("TextLabel")
        IdLabel.Name = "Id"
        IdLabel.BackgroundTransparency = 1
        IdLabel.Size = UDim2.new(1, 0, 0, 14)
        IdLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        IdLabel.Text = "ID: " .. tostring((lp and lp.UserId) or (Api and Api.UserData and (Api.UserData.robloxId or Api.UserData.roblox_id or Api.UserData.userId)) or "0")
        IdLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
        IdLabel.TextSize = 12
        IdLabel.TextXAlignment = Enum.TextXAlignment.Left
        IdLabel.ZIndex = 50002
        IdLabel.LayoutOrder = 2
        IdLabel.Parent = HeaderFrame

        local function CreateDivider(order)
            local div = Instance.new("Frame")
            div.Name = "Divider"
            div.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            div.BorderSizePixel = 0
            div.Size = UDim2.new(1, 0, 0, 1)
            div.LayoutOrder = order
            div.ZIndex = 50001
            div.Parent = ProfilePopover
            return div
        end

        CreateDivider(2)

        local MenuContainer = Instance.new("Frame")
        MenuContainer.Name = "Menu"
        MenuContainer.BackgroundTransparency = 1
        MenuContainer.Size = UDim2.new(1, 0, 0, 0)
        MenuContainer.AutomaticSize = Enum.AutomaticSize.Y
        MenuContainer.LayoutOrder = 3
        MenuContainer.ZIndex = 50001
        MenuContainer.Parent = ProfilePopover

        local MenuPadding = Instance.new("UIPadding")
        MenuPadding.PaddingLeft = UDim.new(0, 6)
        MenuPadding.PaddingRight = UDim.new(0, 6)
        MenuPadding.PaddingTop = UDim.new(0, 4)
        MenuPadding.PaddingBottom = UDim.new(0, 4)
        MenuPadding.Parent = MenuContainer

        local MenuLayout = Instance.new("UIListLayout")
        MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
        MenuLayout.Padding = UDim.new(0, 2)
        MenuLayout.Parent = MenuContainer

        local function CreateMenuItem(parent, order, iconAsset, titleText, textColor, onClick)
            local btn = Instance.new("TextButton")
            btn.Name = titleText
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 1
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.LayoutOrder = order
            btn.ZIndex = 50002
            btn.Parent = parent

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn

            local btnLayout = Instance.new("UIListLayout")
            btnLayout.FillDirection = Enum.FillDirection.Horizontal
            btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
            btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            btnLayout.Padding = UDim.new(0, 10)
            btnLayout.Parent = btn

            local pad = Instance.new("UIPadding")
            pad.PaddingLeft = UDim.new(0, 10)
            pad.PaddingRight = UDim.new(0, 10)
            pad.Parent = btn

            local icon = Instance.new("ImageLabel")
            icon.BackgroundTransparency = 1
            icon.BorderSizePixel = 0
            icon.Size = UDim2.new(0, 18, 0, 18)
            icon.Image = iconAsset
            icon.ImageColor3 = textColor or Color3.fromRGB(180, 180, 180)
            icon.LayoutOrder = 1
            icon.ZIndex = 50003
            icon.Parent = btn

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Size = UDim2.new(1, -28, 1, 0)
            label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            label.Text = titleText
            label.TextColor3 = textColor or Color3.fromRGB(200, 200, 200)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.LayoutOrder = 2
            label.ZIndex = 50003
            label.Parent = btn

            Maid:GiveTask(btn.MouseEnter:Connect(function()
                Tween(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.93})
            end))
            Maid:GiveTask(btn.MouseLeave:Connect(function()
                Tween(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1})
            end))

            Maid:GiveTask(btn.MouseButton1Click:Connect(function()
                SetProfileOpen(false)
                if onClick then
                    onClick()
                end
            end))

            return btn
        end

        CreateMenuItem(MenuContainer, 1, "rbxassetid://134568818132029", "Account", Color3.fromRGB(200, 200, 200), function()
            if WindowObject and WindowObject.OpenAccount then
                WindowObject:OpenAccount()
            end
        end)

        CreateMenuItem(MenuContainer, 2, "rbxassetid://95898765113869", "Settings", Color3.fromRGB(200, 200, 200), function()
            if WindowObject and WindowObject.OpenSettings then
                WindowObject:OpenSettings()
            end
        end)

        CreateDivider(4)

        local LogoutContainer = Instance.new("Frame")
        LogoutContainer.Name = "LogoutContainer"
        LogoutContainer.BackgroundTransparency = 1
        LogoutContainer.Size = UDim2.new(1, 0, 0, 0)
        LogoutContainer.AutomaticSize = Enum.AutomaticSize.Y
        LogoutContainer.LayoutOrder = 5
        LogoutContainer.ZIndex = 50001
        LogoutContainer.Parent = ProfilePopover

        local LogoutPadding = Instance.new("UIPadding")
        LogoutPadding.PaddingLeft = UDim.new(0, 6)
        LogoutPadding.PaddingRight = UDim.new(0, 6)
        LogoutPadding.PaddingTop = UDim.new(0, 4)
        LogoutPadding.PaddingBottom = UDim.new(0, 6)
        LogoutPadding.Parent = LogoutContainer

        local LogoutLayout = Instance.new("UIListLayout")
        LogoutLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LogoutLayout.Parent = LogoutContainer

        CreateMenuItem(LogoutContainer, 1, "rbxassetid://83408923775191", "Logout", Color3.fromRGB(235, 75, 75), function()
            pcall(function()
                if Api and Api.ClearToken then
                    Api.ClearToken()
                elseif Api and Api.SaveToken then
                    Api.SaveToken("")
                end
                if Api then Api.UserData = nil end
            end)
            local pl = Players.LocalPlayer
            if pl then
                pl:Kick("You have been signed out. Please rejoin to sign in again.")
            end
        end)

        local function UpdateProfilePosition()
            if AccountBtn and MainFrame and AccountBtn.Parent then
                local btnPos = AccountBtn.AbsolutePosition
                local mainPos = MainFrame.AbsolutePosition
                local rightX = (btnPos.X - mainPos.X) + AccountBtn.AbsoluteSize.X
                local bottomY = (btnPos.Y - mainPos.Y) + AccountBtn.AbsoluteSize.Y + 6
                ProfilePopover.Position = UDim2.new(0, rightX, 0, bottomY)
            end
        end

        SetProfileOpen = function(open)
            isProfileOpen = open
            if isProfileOpen then
                if SetNotifOpen then
                    SetNotifOpen(false)
                end
                local currentUsername = (lp and lp.Name) or (Api and Api.UserData and Api.UserData.username) or "User"
                local currentRobloxId = tostring((lp and lp.UserId) or (Api and Api.UserData and (Api.UserData.robloxId or Api.UserData.roblox_id or Api.UserData.userId)) or "0")
                UsernameLabel.Text = currentUsername
                IdLabel.Text = "ID: " .. currentRobloxId
                UpdateProfilePosition()
                ProfilePopover.Visible = true
                ProfilePopover.GroupTransparency = 1
                Tween(AccountBtnStroke, TweenInfoFast, {Transparency = 0})
                Tween(ProfilePopover, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
                Tween(ChevronIcon, TweenInfo.new(0.2), {Rotation = 180})
            else
                Tween(ChevronIcon, TweenInfo.new(0.2), {Rotation = 0})
                Tween(AccountBtnStroke, TweenInfoFast, {Transparency = 1})
                Tween(ProfilePopover, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
                task.delay(0.15, function()
                    if not isProfileOpen then
                        ProfilePopover.Visible = false
                    end
                end)
            end
        end

        Maid:GiveTask(AccountBtn.MouseButton1Click:Connect(function()
            SetProfileOpen(not isProfileOpen)
        end))

        Maid:GiveTask(AccountBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if isProfileOpen then
                UpdateProfilePosition()
            end
        end))

        Maid:GiveTask(Page:GetPropertyChangedSignal("Visible"):Connect(function()
            if not Page.Visible then
                SetProfileOpen(false)
            end
        end))
    end

    local HomeBody = Instance.new("Frame")
    HomeBody.Name = "HomeBody"
    HomeBody.BackgroundTransparency = 1
    HomeBody.BorderSizePixel = 0
    HomeBody.Size = UDim2.new(1, 0, 1, -48)
    HomeBody.LayoutOrder = 1
    HomeBody.Parent = Page

    local OpenTicketModal = nil

    do
        local PotassiumContainer = Instance.new("Frame")
        PotassiumContainer.Name = "PotassiumContainer"
        PotassiumContainer.BackgroundTransparency = 1
        PotassiumContainer.Size = UDim2.new(1, 0, 1, 0)
        PotassiumContainer.Parent = HomeBody

        local PotassiumPadding = Instance.new("UIPadding")
        PotassiumPadding.PaddingLeft = UDim.new(0, 32)
        PotassiumPadding.PaddingRight = UDim.new(0, 32)
        PotassiumPadding.PaddingTop = UDim.new(0, 16)
        PotassiumPadding.PaddingBottom = UDim.new(0, 16)
        PotassiumPadding.Parent = PotassiumContainer

        local HeaderRow = Instance.new("Frame")
        HeaderRow.Name = "HeaderRow"
        HeaderRow.BackgroundTransparency = 1
        HeaderRow.Size = UDim2.new(1, 0, 0, 72)
        HeaderRow.Parent = PotassiumContainer

        local HeaderLeft = Instance.new("Frame")
        HeaderLeft.Name = "Left"
        HeaderLeft.BackgroundTransparency = 1
        HeaderLeft.Size = UDim2.new(0.55, 0, 1, 0)
        HeaderLeft.Parent = HeaderRow

        local HeaderLeftLayout = Instance.new("UIListLayout")
        HeaderLeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        HeaderLeftLayout.Padding = UDim.new(0, 4)
        HeaderLeftLayout.Parent = HeaderLeft

        local AppTitle = Instance.new("TextLabel")
        AppTitle.Name = "Title"
        AppTitle.BackgroundTransparency = 1
        AppTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        AppTitle.Size = UDim2.new(1, 0, 0, 34)
        AppTitle.Text = "Volt"
        AppTitle.TextColor3 = Color3.fromRGB(245, 245, 245)
        AppTitle.TextSize = 28
        AppTitle.TextXAlignment = Enum.TextXAlignment.Left
        AppTitle.LayoutOrder = 1
        AppTitle.Parent = HeaderLeft

        local SubtitleFrame = Instance.new("Frame")
        SubtitleFrame.Name = "Subtitle"
        SubtitleFrame.BackgroundTransparency = 1
        SubtitleFrame.Size = UDim2.new(1, 0, 0, 20)
        SubtitleFrame.LayoutOrder = 2
        SubtitleFrame.Parent = HeaderLeft

        local SubtitleLayout = Instance.new("UIListLayout")
        SubtitleLayout.FillDirection = Enum.FillDirection.Horizontal
        SubtitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SubtitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        SubtitleLayout.Padding = UDim.new(0, 4)
        SubtitleLayout.Parent = SubtitleFrame

        local lp = Players.LocalPlayer
        local username = (lp and lp.Name) or (Api and Api.UserData and Api.UserData.username) or "User"

        local SignedLabel = Instance.new("TextLabel")
        SignedLabel.Name = "Signed"
        SignedLabel.BackgroundTransparency = 1
        SignedLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        SignedLabel.Size = UDim2.new(0, 0, 1, 0)
        SignedLabel.AutomaticSize = Enum.AutomaticSize.X
        SignedLabel.Text = "Signed in as " .. username .. "."
        SignedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        SignedLabel.TextSize = 13
        SignedLabel.LayoutOrder = 1
        SignedLabel.Parent = SubtitleFrame

        local AttachedLabel = Instance.new("TextLabel")
        AttachedLabel.Name = "Attached"
        AttachedLabel.BackgroundTransparency = 1
        AttachedLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        AttachedLabel.Size = UDim2.new(0, 0, 1, 0)
        AttachedLabel.AutomaticSize = Enum.AutomaticSize.X
        AttachedLabel.Text = "1 client attached."
        AttachedLabel.TextColor3 = Color3.fromRGB(85, 215, 95)
        AttachedLabel.TextSize = 13
        AttachedLabel.LayoutOrder = 2
        AttachedLabel.Parent = SubtitleFrame

        local HeaderRight = Instance.new("Frame")
        HeaderRight.Name = "Right"
        HeaderRight.BackgroundTransparency = 1
        HeaderRight.Size = UDim2.new(0.45, 0, 1, 0)
        HeaderRight.AnchorPoint = Vector2.new(1, 0)
        HeaderRight.Position = UDim2.new(1, 0, 0, 0)
        HeaderRight.Parent = HeaderRow

        local HeaderRightLayout = Instance.new("UIListLayout")
        HeaderRightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        HeaderRightLayout.Padding = UDim.new(0, 6)
        HeaderRightLayout.Parent = HeaderRight

        local UpdatesHeaderLabel = Instance.new("TextLabel")
        UpdatesHeaderLabel.Name = "UpdatesHeader"
        UpdatesHeaderLabel.BackgroundTransparency = 1
        UpdatesHeaderLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        UpdatesHeaderLabel.Size = UDim2.new(1, 0, 0, 14)
        UpdatesHeaderLabel.Text = "UPDATES"
        UpdatesHeaderLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        UpdatesHeaderLabel.TextSize = 11
        UpdatesHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
        UpdatesHeaderLabel.LayoutOrder = 1
        UpdatesHeaderLabel.Parent = HeaderRight

        local UpdateCard = Instance.new("Frame")
        UpdateCard.Name = "UpdateCard"
        UpdateCard.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        UpdateCard.BorderSizePixel = 0
        UpdateCard.Size = UDim2.new(1, 0, 0, 48)
        UpdateCard.LayoutOrder = 2
        UpdateCard.Parent = HeaderRight

        local UpdateCorner = Instance.new("UICorner")
        UpdateCorner.CornerRadius = UDim.new(0, 6)
        UpdateCorner.Parent = UpdateCard

        local UpdateStroke = Instance.new("UIStroke")
        UpdateStroke.Color = Color3.fromRGB(36, 36, 36)
        UpdateStroke.Thickness = 1
        UpdateStroke.Parent = UpdateCard

        local UpdatePadding = Instance.new("UIPadding")
        UpdatePadding.PaddingLeft = UDim.new(0, 10)
        UpdatePadding.PaddingRight = UDim.new(0, 10)
        UpdatePadding.PaddingTop = UDim.new(0, 6)
        UpdatePadding.PaddingBottom = UDim.new(0, 6)
        UpdatePadding.Parent = UpdateCard

        local UpdateLayout = Instance.new("UIListLayout")
        UpdateLayout.FillDirection = Enum.FillDirection.Horizontal
        UpdateLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UpdateLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UpdateLayout.Padding = UDim.new(0, 8)
        UpdateLayout.Parent = UpdateCard

        local Badge = Instance.new("TextLabel")
        Badge.Name = "Badge"
        Badge.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        Badge.BorderSizePixel = 0
        Badge.Size = UDim2.new(0, 0, 0, 20)
        Badge.AutomaticSize = Enum.AutomaticSize.X
        Badge.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Badge.Text = "v1.1.15"
        Badge.TextColor3 = Color3.fromRGB(180, 180, 180)
        Badge.TextSize = 11
        Badge.Parent = UpdateCard

        local BadgeCorner = Instance.new("UICorner")
        BadgeCorner.CornerRadius = UDim.new(0, 4)
        BadgeCorner.Parent = Badge

        local BadgePad = Instance.new("UIPadding")
        BadgePad.PaddingLeft = UDim.new(0, 6)
        BadgePad.PaddingRight = UDim.new(0, 6)
        BadgePad.Parent = Badge

        local UpdateText = Instance.new("TextLabel")
        UpdateText.Name = "Text"
        UpdateText.BackgroundTransparency = 1
        UpdateText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        UpdateText.Size = UDim2.new(1, -75, 1, 0)
        UpdateText.Text = "Discord bug tickets & live support."
        UpdateText.TextColor3 = Color3.fromRGB(180, 180, 180)
        UpdateText.TextSize = 12
        UpdateText.TextXAlignment = Enum.TextXAlignment.Left
        UpdateText.TextTruncate = Enum.TextTruncate.AtEnd
        UpdateText.Parent = UpdateCard

        local ContentArea = Instance.new("Frame")
        ContentArea.Name = "ContentArea"
        ContentArea.BackgroundTransparency = 1
        ContentArea.Position = UDim2.new(0, 0, 0, 86)
        ContentArea.Size = UDim2.new(1, 0, 1, -86)
        ContentArea.Parent = PotassiumContainer

        local ActionsList = Instance.new("Frame")
        ActionsList.Name = "Actions"
        ActionsList.BackgroundTransparency = 1
        ActionsList.Size = UDim2.new(0, 240, 1, 0)
        ActionsList.Parent = ContentArea

        local ActionsLayout = Instance.new("UIListLayout")
        ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ActionsLayout.Padding = UDim.new(0, 14)
        ActionsLayout.Parent = ActionsList

        local StartHeader = Instance.new("TextLabel")
        StartHeader.Name = "StartHeader"
        StartHeader.BackgroundTransparency = 1
        StartHeader.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        StartHeader.Size = UDim2.new(1, 0, 0, 14)
        StartHeader.Text = "START"
        StartHeader.TextColor3 = Color3.fromRGB(120, 120, 120)
        StartHeader.TextSize = 11
        StartHeader.TextXAlignment = Enum.TextXAlignment.Left
        StartHeader.LayoutOrder = 1
        StartHeader.Parent = ActionsList

        local StartItems = Instance.new("Frame")
        StartItems.Name = "StartItems"
        StartItems.BackgroundTransparency = 1
        StartItems.Size = UDim2.new(1, 0, 0, 0)
        StartItems.AutomaticSize = Enum.AutomaticSize.Y
        StartItems.LayoutOrder = 2
        StartItems.Parent = ActionsList

        local StartItemsLayout = Instance.new("UIListLayout")
        StartItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        StartItemsLayout.Padding = UDim.new(0, 4)
        StartItemsLayout.Parent = StartItems

        local function CreateActionItem(parent, order, iconAsset, titleText, onClick)
            local btn = Instance.new("TextButton")
            btn.Name = titleText
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 1
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.LayoutOrder = order
            btn.Parent = parent

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn

            local btnLayout = Instance.new("UIListLayout")
            btnLayout.FillDirection = Enum.FillDirection.Horizontal
            btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
            btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            btnLayout.Padding = UDim.new(0, 10)
            btnLayout.Parent = btn

            local pad = Instance.new("UIPadding")
            pad.PaddingLeft = UDim.new(0, 6)
            pad.PaddingRight = UDim.new(0, 6)
            pad.Parent = btn

            local icon = Instance.new("ImageLabel")
            icon.BackgroundTransparency = 1
            icon.BorderSizePixel = 0
            icon.Size = UDim2.new(0, 16, 0, 16)
            icon.Image = iconAsset
            icon.ImageColor3 = Color3.fromRGB(170, 170, 170)
            icon.LayoutOrder = 1
            icon.Parent = btn

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Size = UDim2.new(1, -26, 1, 0)
            label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            label.Text = titleText
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.LayoutOrder = 2
            label.Parent = btn

            Maid:GiveTask(btn.MouseEnter:Connect(function()
                Tween(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.94})
                Tween(label, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(245, 245, 245)})
                Tween(icon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(245, 245, 245)})
            end))
            Maid:GiveTask(btn.MouseLeave:Connect(function()
                Tween(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1})
                Tween(label, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(200, 200, 200)})
                Tween(icon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(170, 170, 170)})
            end))

            if onClick then
                Maid:GiveTask(btn.MouseButton1Click:Connect(onClick))
            end

            return btn
        end

        CreateActionItem(StartItems, 1, "rbxassetid://70862937184937", "Bug Report", function()
            if OpenTicketModal then
                OpenTicketModal()
            end
        end)

        CreateActionItem(StartItems, 2, "rbxassetid://10747373176", "Explore scripts", function()
            SendNotification({
                Title = "Scripts",
                Content = "Explore community scripts and documentation.",
                Duration = 2
            })
        end)

        CreateActionItem(StartItems, 3, "rbxassetid://95898765113869", "Settings", function()
            if WindowObject and WindowObject.OpenSettings then
                WindowObject:OpenSettings()
            end
        end)

        CreateActionItem(StartItems, 4, "rbxassetid://134568818132029", "Account", function()
            if WindowObject and WindowObject.OpenAccount then
                WindowObject:OpenAccount()
            end
        end)

        local RecentHeader = Instance.new("TextLabel")
        RecentHeader.Name = "RecentHeader"
        RecentHeader.BackgroundTransparency = 1
        RecentHeader.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        RecentHeader.Size = UDim2.new(1, 0, 0, 14)
        RecentHeader.Text = "RECENT SCRIPTS"
        RecentHeader.TextColor3 = Color3.fromRGB(120, 120, 120)
        RecentHeader.TextSize = 11
        RecentHeader.TextXAlignment = Enum.TextXAlignment.Left
        RecentHeader.LayoutOrder = 3
        RecentHeader.Parent = ActionsList

        local RecentItems = Instance.new("Frame")
        RecentItems.Name = "RecentItems"
        RecentItems.BackgroundTransparency = 1
        RecentItems.Size = UDim2.new(1, 0, 0, 0)
        RecentItems.AutomaticSize = Enum.AutomaticSize.Y
        RecentItems.LayoutOrder = 4
        RecentItems.Parent = ActionsList

        local RecentItemsLayout = Instance.new("UIListLayout")
        RecentItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RecentItemsLayout.Padding = UDim.new(0, 4)
        RecentItemsLayout.Parent = RecentItems

        CreateActionItem(RecentItems, 1, "rbxassetid://10709789910", "Snowy_Hub.luau", function()
            SendNotification({ Title = "Script Selected", Content = "Snowy_Hub.luau ready to execute.", Duration = 2 })
        end)

        CreateActionItem(RecentItems, 2, "rbxassetid://10709789910", "Volt Test.luau", function()
            SendNotification({ Title = "Script Selected", Content = "Volt Test.luau ready to execute.", Duration = 2 })
        end)

        CreateActionItem(RecentItems, 3, "rbxassetid://10709789910", "BountyHunt.luau", function()
            SendNotification({ Title = "Script Selected", Content = "BountyHunt.luau ready to execute.", Duration = 2 })
        end)

        local AttachedStatus = Instance.new("Frame")
        AttachedStatus.Name = "Status"
        AttachedStatus.BackgroundTransparency = 1
        AttachedStatus.AnchorPoint = Vector2.new(1, 1)
        AttachedStatus.Position = UDim2.new(1, 0, 1, 0)
        AttachedStatus.Size = UDim2.new(0, 0, 0, 20)
        AttachedStatus.AutomaticSize = Enum.AutomaticSize.X
        AttachedStatus.Parent = ContentArea

        local AttachedStatusLayout = Instance.new("UIListLayout")
        AttachedStatusLayout.FillDirection = Enum.FillDirection.Horizontal
        AttachedStatusLayout.SortOrder = Enum.SortOrder.LayoutOrder
        AttachedStatusLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        AttachedStatusLayout.Padding = UDim.new(0, 6)
        AttachedStatusLayout.Parent = AttachedStatus

        local StatusDot = Instance.new("Frame")
        StatusDot.Name = "Dot"
        StatusDot.BackgroundColor3 = Color3.fromRGB(85, 215, 95)
        StatusDot.BorderSizePixel = 0
        StatusDot.Size = UDim2.new(0, 7, 0, 7)
        StatusDot.LayoutOrder = 1
        StatusDot.Parent = AttachedStatus

        local StatusDotCorner = Instance.new("UICorner")
        StatusDotCorner.CornerRadius = UDim.new(1, 0)
        StatusDotCorner.Parent = StatusDot

        local StatusText = Instance.new("TextLabel")
        StatusText.Name = "Text"
        StatusText.BackgroundTransparency = 1
        StatusText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        StatusText.Size = UDim2.new(0, 0, 1, 0)
        StatusText.AutomaticSize = Enum.AutomaticSize.X
        StatusText.Text = "Attached"
        StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        StatusText.TextSize = 12
        StatusText.LayoutOrder = 2
        StatusText.Parent = AttachedStatus
    end

    do
        local isModalOpen = false
        local activeTicketId = nil
        local ticketsList = {}
        local cooldownSeconds = 0

        local lp = Players.LocalPlayer
        local robloxId = tostring((lp and lp.UserId) or "0")
        local robloxUsername = (lp and lp.Name) or "Player"
        local hwid = (Api and Api.GetHWID and Api.GetHWID()) or "DUMMY_HWID"

        local TicketModal = Instance.new("CanvasGroup")
        TicketModal.Name = "TicketModal"
        TicketModal.Size = UDim2.new(1, 0, 1, 0)
        TicketModal.Position = UDim2.new(0, 0, 0, 0)
        TicketModal.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        TicketModal.BorderSizePixel = 0
        TicketModal.ZIndex = 10000
        TicketModal.Visible = false
        TicketModal.GroupTransparency = 1
        TicketModal.Parent = HomeBody

        local ModalHeader = Instance.new("Frame")
        ModalHeader.Name = "Header"
        ModalHeader.BackgroundTransparency = 1
        ModalHeader.Size = UDim2.new(1, 0, 0, 42)
        ModalHeader.Parent = TicketModal

        local ModalHeaderLayout = Instance.new("UIListLayout")
        ModalHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
        ModalHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ModalHeaderLayout.Padding = UDim.new(0, 10)
        ModalHeaderLayout.Parent = ModalHeader

        local ModalHeaderPad = Instance.new("UIPadding")
        ModalHeaderPad.PaddingLeft = UDim.new(0, 16)
        ModalHeaderPad.PaddingRight = UDim.new(0, 16)
        ModalHeaderPad.Parent = ModalHeader

        local BackBtn = Instance.new("TextButton")
        BackBtn.Name = "Back"
        BackBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        BackBtn.Size = UDim2.new(0, 80, 0, 26)
        BackBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        BackBtn.Text = "← Back"
        BackBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        BackBtn.TextSize = 12
        BackBtn.AutoButtonColor = false
        BackBtn.LayoutOrder = 1
        BackBtn.Parent = ModalHeader

        local BackCorner = Instance.new("UICorner")
        BackCorner.CornerRadius = UDim.new(0, 5)
        BackCorner.Parent = BackBtn

        local BackStroke = Instance.new("UIStroke")
        BackStroke.Color = Color3.fromRGB(45, 45, 45)
        BackStroke.Thickness = 1
        BackStroke.Parent = BackBtn

        local ModalTitle = Instance.new("TextLabel")
        ModalTitle.Name = "Title"
        ModalTitle.BackgroundTransparency = 1
        ModalTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        ModalTitle.Size = UDim2.new(1, -100, 1, 0)
        ModalTitle.Text = "Bug Reports & Discord Support"
        ModalTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        ModalTitle.TextSize = 14
        ModalTitle.TextXAlignment = Enum.TextXAlignment.Left
        ModalTitle.LayoutOrder = 2
        ModalTitle.Parent = ModalHeader

        local HeaderDivider = Instance.new("Frame")
        HeaderDivider.Name = "Divider"
        HeaderDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        HeaderDivider.BorderSizePixel = 0
        HeaderDivider.Position = UDim2.new(0, 0, 0, 42)
        HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
        HeaderDivider.Parent = TicketModal

        local TwoColumn = Instance.new("Frame")
        TwoColumn.Name = "TwoColumn"
        TwoColumn.BackgroundTransparency = 1
        TwoColumn.Position = UDim2.new(0, 0, 0, 43)
        TwoColumn.Size = UDim2.new(1, 0, 1, -43)
        TwoColumn.Parent = TicketModal

        local LeftPane = Instance.new("Frame")
        LeftPane.Name = "LeftPane"
        LeftPane.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        LeftPane.BorderSizePixel = 0
        LeftPane.Size = UDim2.new(0, 220, 1, 0)
        LeftPane.Parent = TwoColumn

        local LeftPanePad = Instance.new("UIPadding")
        LeftPanePad.PaddingLeft = UDim.new(0, 10)
        LeftPanePad.PaddingRight = UDim.new(0, 10)
        LeftPanePad.PaddingTop = UDim.new(0, 10)
        LeftPanePad.PaddingBottom = UDim.new(0, 10)
        LeftPanePad.Parent = LeftPane

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.Parent = LeftPane

        local CooldownBox = Instance.new("Frame")
        CooldownBox.Name = "CooldownBox"
        CooldownBox.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        CooldownBox.BorderSizePixel = 0
        CooldownBox.Size = UDim2.new(1, 0, 0, 32)
        CooldownBox.LayoutOrder = 1
        CooldownBox.Parent = LeftPane

        local CooldownCorner = Instance.new("UICorner")
        CooldownCorner.CornerRadius = UDim.new(0, 6)
        CooldownCorner.Parent = CooldownBox

        local CooldownStroke = Instance.new("UIStroke")
        CooldownStroke.Color = Color3.fromRGB(36, 36, 36)
        CooldownStroke.Thickness = 1
        CooldownStroke.Parent = CooldownBox

        local CooldownLayout = Instance.new("UIListLayout")
        CooldownLayout.FillDirection = Enum.FillDirection.Horizontal
        CooldownLayout.SortOrder = Enum.SortOrder.LayoutOrder
        CooldownLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        CooldownLayout.Padding = UDim.new(0, 8)
        CooldownLayout.Parent = CooldownBox

        local CooldownPad = Instance.new("UIPadding")
        CooldownPad.PaddingLeft = UDim.new(0, 10)
        CooldownPad.PaddingRight = UDim.new(0, 10)
        CooldownPad.Parent = CooldownBox

        local CooldownDot = Instance.new("Frame")
        CooldownDot.Name = "Dot"
        CooldownDot.BackgroundColor3 = Color3.fromRGB(85, 215, 95)
        CooldownDot.BorderSizePixel = 0
        CooldownDot.Size = UDim2.new(0, 8, 0, 8)
        CooldownDot.LayoutOrder = 1
        CooldownDot.Parent = CooldownBox

        local CooldownDotCorner = Instance.new("UICorner")
        CooldownDotCorner.CornerRadius = UDim.new(1, 0)
        CooldownDotCorner.Parent = CooldownDot

        local CooldownText = Instance.new("TextLabel")
        CooldownText.Name = "Text"
        CooldownText.BackgroundTransparency = 1
        CooldownText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        CooldownText.Size = UDim2.new(1, -20, 1, 0)
        CooldownText.Text = "Ready to submit"
        CooldownText.TextColor3 = Color3.fromRGB(200, 200, 200)
        CooldownText.TextSize = 12
        CooldownText.TextXAlignment = Enum.TextXAlignment.Left
        CooldownText.LayoutOrder = 2
        CooldownText.Parent = CooldownBox

        local NewReportBtn = Instance.new("TextButton")
        NewReportBtn.Name = "NewReportBtn"
        NewReportBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        NewReportBtn.BorderSizePixel = 0
        NewReportBtn.Size = UDim2.new(1, 0, 0, 32)
        NewReportBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        NewReportBtn.Text = "+ New Bug Report"
        NewReportBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        NewReportBtn.TextSize = 12
        NewReportBtn.AutoButtonColor = false
        NewReportBtn.LayoutOrder = 2
        NewReportBtn.Parent = LeftPane

        local NewReportCorner = Instance.new("UICorner")
        NewReportCorner.CornerRadius = UDim.new(0, 6)
        NewReportCorner.Parent = NewReportBtn

        local NewReportStroke = Instance.new("UIStroke")
        NewReportStroke.Color = Color3.fromRGB(48, 48, 48)
        NewReportStroke.Thickness = 1
        NewReportStroke.Parent = NewReportBtn

        local LeftDivider = Instance.new("Frame")
        LeftDivider.Name = "Divider"
        LeftDivider.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        LeftDivider.BorderSizePixel = 0
        LeftDivider.Size = UDim2.new(1, 0, 0, 1)
        LeftDivider.LayoutOrder = 3
        LeftDivider.Parent = LeftPane

        local ReportsHeader = Instance.new("TextLabel")
        ReportsHeader.Name = "ReportsHeader"
        ReportsHeader.BackgroundTransparency = 1
        ReportsHeader.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        ReportsHeader.Size = UDim2.new(1, 0, 0, 14)
        ReportsHeader.Text = "MY BUG REPORTS"
        ReportsHeader.TextColor3 = Color3.fromRGB(110, 110, 110)
        ReportsHeader.TextSize = 11
        ReportsHeader.TextXAlignment = Enum.TextXAlignment.Left
        ReportsHeader.LayoutOrder = 4
        ReportsHeader.Parent = LeftPane

        local ReportsScroll = Instance.new("ScrollingFrame")
        ReportsScroll.Name = "ReportsScroll"
        ReportsScroll.BackgroundTransparency = 1
        ReportsScroll.BorderSizePixel = 0
        ReportsScroll.Size = UDim2.new(1, 0, 1, -112)
        ReportsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ReportsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ReportsScroll.ScrollBarThickness = 3
        ReportsScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        ReportsScroll.LayoutOrder = 5
        ReportsScroll.Parent = LeftPane

        local ReportsScrollLayout = Instance.new("UIListLayout")
        ReportsScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ReportsScrollLayout.Padding = UDim.new(0, 4)
        ReportsScrollLayout.Parent = ReportsScroll

        local ColumnDivider = Instance.new("Frame")
        ColumnDivider.Name = "ColumnDivider"
        ColumnDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
        ColumnDivider.BorderSizePixel = 0
        ColumnDivider.Position = UDim2.new(0, 220, 0, 0)
        ColumnDivider.Size = UDim2.new(0, 1, 1, 0)
        ColumnDivider.Parent = TwoColumn

        local RightPane = Instance.new("Frame")
        RightPane.Name = "RightPane"
        RightPane.BackgroundTransparency = 1
        RightPane.Position = UDim2.new(0, 221, 0, 0)
        RightPane.Size = UDim2.new(1, -221, 1, 0)
        RightPane.Parent = TwoColumn

        local CreateView = Instance.new("Frame")
        CreateView.Name = "CreateView"
        CreateView.BackgroundTransparency = 1
        CreateView.Size = UDim2.new(1, 0, 1, 0)
        CreateView.Visible = true
        CreateView.Parent = RightPane

        local CreateViewPad = Instance.new("UIPadding")
        CreateViewPad.PaddingLeft = UDim.new(0, 20)
        CreateViewPad.PaddingRight = UDim.new(0, 20)
        CreateViewPad.PaddingTop = UDim.new(0, 16)
        CreateViewPad.PaddingBottom = UDim.new(0, 16)
        CreateViewPad.Parent = CreateView

        local CreateViewLayout = Instance.new("UIListLayout")
        CreateViewLayout.SortOrder = Enum.SortOrder.LayoutOrder
        CreateViewLayout.Padding = UDim.new(0, 12)
        CreateViewLayout.Parent = CreateView

        local CreateTitle = Instance.new("TextLabel")
        CreateTitle.Name = "Title"
        CreateTitle.BackgroundTransparency = 1
        CreateTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        CreateTitle.Size = UDim2.new(1, 0, 0, 22)
        CreateTitle.Text = "Submit a Bug Report"
        CreateTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        CreateTitle.TextSize = 16
        CreateTitle.TextXAlignment = Enum.TextXAlignment.Left
        CreateTitle.LayoutOrder = 1
        CreateTitle.Parent = CreateView

        local CreateSubtitle = Instance.new("TextLabel")
        CreateSubtitle.Name = "Subtitle"
        CreateSubtitle.BackgroundTransparency = 1
        CreateSubtitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        CreateSubtitle.Size = UDim2.new(1, 0, 0, 16)
        CreateSubtitle.Text = "Creates a private channel in our Discord server where you can speak with staff."
        CreateSubtitle.TextColor3 = Color3.fromRGB(140, 140, 140)
        CreateSubtitle.TextSize = 12
        CreateSubtitle.TextXAlignment = Enum.TextXAlignment.Left
        CreateSubtitle.LayoutOrder = 2
        CreateSubtitle.Parent = CreateView

        local TitleInputFrame = Instance.new("Frame")
        TitleInputFrame.Name = "TitleInput"
        TitleInputFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        TitleInputFrame.BorderSizePixel = 0
        TitleInputFrame.Size = UDim2.new(1, 0, 0, 36)
        TitleInputFrame.LayoutOrder = 3
        TitleInputFrame.Parent = CreateView

        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 6)
        TitleCorner.Parent = TitleInputFrame

        local TitleStroke = Instance.new("UIStroke")
        TitleStroke.Color = Color3.fromRGB(42, 42, 42)
        TitleStroke.Thickness = 1
        TitleStroke.Parent = TitleInputFrame

        local TitleInputPad = Instance.new("UIPadding")
        TitleInputPad.PaddingLeft = UDim.new(0, 10)
        TitleInputPad.PaddingRight = UDim.new(0, 10)
        TitleInputPad.Parent = TitleInputFrame

        local TitleTextBox = Instance.new("TextBox")
        TitleTextBox.Name = "Input"
        TitleTextBox.BackgroundTransparency = 1
        TitleTextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        TitleTextBox.Size = UDim2.new(1, 0, 1, 0)
        TitleTextBox.PlaceholderText = "Report title (e.g. Teleport bug)..."
        TitleTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        TitleTextBox.Text = ""
        TitleTextBox.TextColor3 = Color3.fromRGB(230, 230, 230)
        TitleTextBox.TextSize = 13
        TitleTextBox.TextXAlignment = Enum.TextXAlignment.Left
        TitleTextBox.ClearTextOnFocus = false
        TitleTextBox.Parent = TitleInputFrame

        local DescInputFrame = Instance.new("Frame")
        DescInputFrame.Name = "DescInput"
        DescInputFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        DescInputFrame.BorderSizePixel = 0
        DescInputFrame.Size = UDim2.new(1, 0, 0, 100)
        DescInputFrame.LayoutOrder = 4
        DescInputFrame.Parent = CreateView

        local DescCorner = Instance.new("UICorner")
        DescCorner.CornerRadius = UDim.new(0, 6)
        DescCorner.Parent = DescInputFrame

        local DescStroke = Instance.new("UIStroke")
        DescStroke.Color = Color3.fromRGB(42, 42, 42)
        DescStroke.Thickness = 1
        DescStroke.Parent = DescInputFrame

        local DescInputPad = Instance.new("UIPadding")
        DescInputPad.PaddingLeft = UDim.new(0, 10)
        DescInputPad.PaddingRight = UDim.new(0, 10)
        DescInputPad.PaddingTop = UDim.new(0, 8)
        DescInputPad.PaddingBottom = UDim.new(0, 8)
        DescInputPad.Parent = DescInputFrame

        local DescTextBox = Instance.new("TextBox")
        DescTextBox.Name = "Input"
        DescTextBox.BackgroundTransparency = 1
        DescTextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        DescTextBox.Size = UDim2.new(1, 0, 1, 0)
        DescTextBox.MultiLine = true
        DescTextBox.TextWrapped = true
        DescTextBox.PlaceholderText = "Describe the bug in detail, what happened, and steps to reproduce..."
        DescTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        DescTextBox.Text = ""
        DescTextBox.TextColor3 = Color3.fromRGB(230, 230, 230)
        DescTextBox.TextSize = 13
        DescTextBox.TextXAlignment = Enum.TextXAlignment.Left
        DescTextBox.TextYAlignment = Enum.TextYAlignment.Top
        DescTextBox.ClearTextOnFocus = false
        DescTextBox.Parent = DescInputFrame

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Name = "SubmitBtn"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        SubmitBtn.BorderSizePixel = 0
        SubmitBtn.Size = UDim2.new(0, 160, 0, 36)
        SubmitBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        SubmitBtn.Text = "Submit Bug Report"
        SubmitBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        SubmitBtn.TextSize = 13
        SubmitBtn.AutoButtonColor = false
        SubmitBtn.LayoutOrder = 5
        SubmitBtn.Parent = CreateView

        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 6)
        SubmitCorner.Parent = SubmitBtn

        local SubmitStroke = Instance.new("UIStroke")
        SubmitStroke.Color = Color3.fromRGB(55, 55, 55)
        SubmitStroke.Thickness = 1
        SubmitStroke.Parent = SubmitBtn

        local StatusMsg = Instance.new("TextLabel")
        StatusMsg.Name = "StatusMsg"
        StatusMsg.BackgroundTransparency = 1
        StatusMsg.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        StatusMsg.Size = UDim2.new(1, 0, 0, 20)
        StatusMsg.Text = ""
        StatusMsg.TextColor3 = Color3.fromRGB(230, 80, 80)
        StatusMsg.TextSize = 12
        StatusMsg.TextXAlignment = Enum.TextXAlignment.Left
        StatusMsg.LayoutOrder = 6
        StatusMsg.Parent = CreateView

        local ChatView = Instance.new("Frame")
        ChatView.Name = "ChatView"
        ChatView.BackgroundTransparency = 1
        ChatView.Size = UDim2.new(1, 0, 1, 0)
        ChatView.Visible = false
        ChatView.Parent = RightPane

        local ChatHeader = Instance.new("Frame")
        ChatHeader.Name = "ChatHeader"
        ChatHeader.BackgroundTransparency = 1
        ChatHeader.Size = UDim2.new(1, 0, 0, 42)
        ChatHeader.Parent = ChatView

        local ChatHeaderPad = Instance.new("UIPadding")
        ChatHeaderPad.PaddingLeft = UDim.new(0, 16)
        ChatHeaderPad.PaddingRight = UDim.new(0, 16)
        ChatHeaderPad.Parent = ChatHeader

        local ChatHeaderLayout = Instance.new("UIListLayout")
        ChatHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
        ChatHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ChatHeaderLayout.Padding = UDim.new(0, 8)
        ChatHeaderLayout.Parent = ChatHeader

        local ChatTitle = Instance.new("TextLabel")
        ChatTitle.Name = "Title"
        ChatTitle.BackgroundTransparency = 1
        ChatTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        ChatTitle.Size = UDim2.new(1, -90, 1, 0)
        ChatTitle.Text = "Bug Report"
        ChatTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        ChatTitle.TextSize = 14
        ChatTitle.TextXAlignment = Enum.TextXAlignment.Left
        ChatTitle.TextTruncate = Enum.TextTruncate.AtEnd
        ChatTitle.LayoutOrder = 1
        ChatTitle.Parent = ChatHeader

        local ChatStatusBadge = Instance.new("TextLabel")
        ChatStatusBadge.Name = "Status"
        ChatStatusBadge.BackgroundColor3 = Color3.fromRGB(30, 75, 40)
        ChatStatusBadge.BorderSizePixel = 0
        ChatStatusBadge.Size = UDim2.new(0, 0, 0, 20)
        ChatStatusBadge.AutomaticSize = Enum.AutomaticSize.X
        ChatStatusBadge.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        ChatStatusBadge.Text = "OPEN"
        ChatStatusBadge.TextColor3 = Color3.fromRGB(90, 220, 120)
        ChatStatusBadge.TextSize = 10
        ChatStatusBadge.LayoutOrder = 2
        ChatStatusBadge.Parent = ChatHeader

        local StatusCorner = Instance.new("UICorner")
        StatusCorner.CornerRadius = UDim.new(0, 4)
        StatusCorner.Parent = ChatStatusBadge

        local StatusPad = Instance.new("UIPadding")
        StatusPad.PaddingLeft = UDim.new(0, 6)
        StatusPad.PaddingRight = UDim.new(0, 6)
        StatusPad.Parent = ChatStatusBadge

        local ChatDivider = Instance.new("Frame")
        ChatDivider.Name = "Divider"
        ChatDivider.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        ChatDivider.BorderSizePixel = 0
        ChatDivider.Position = UDim2.new(0, 0, 0, 42)
        ChatDivider.Size = UDim2.new(1, 0, 0, 1)
        ChatDivider.Parent = ChatView

        local MessagesScroll = Instance.new("ScrollingFrame")
        MessagesScroll.Name = "MessagesScroll"
        MessagesScroll.BackgroundTransparency = 1
        MessagesScroll.BorderSizePixel = 0
        MessagesScroll.Position = UDim2.new(0, 0, 0, 43)
        MessagesScroll.Size = UDim2.new(1, 0, 1, -95)
        MessagesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        MessagesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        MessagesScroll.ScrollBarThickness = 3
        MessagesScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        MessagesScroll.Parent = ChatView

        local MessagesLayout = Instance.new("UIListLayout")
        MessagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        MessagesLayout.Padding = UDim.new(0, 8)
        MessagesLayout.Parent = MessagesScroll

        local MessagesPad = Instance.new("UIPadding")
        MessagesPad.PaddingLeft = UDim.new(0, 14)
        MessagesPad.PaddingRight = UDim.new(0, 14)
        MessagesPad.PaddingTop = UDim.new(0, 10)
        MessagesPad.PaddingBottom = UDim.new(0, 10)
        MessagesPad.Parent = MessagesScroll

        local ReplyBar = Instance.new("Frame")
        ReplyBar.Name = "ReplyBar"
        ReplyBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ReplyBar.BorderSizePixel = 0
        ReplyBar.Position = UDim2.new(0, 0, 1, -50)
        ReplyBar.Size = UDim2.new(1, 0, 0, 50)
        ReplyBar.Parent = ChatView

        local ReplyDivider = Instance.new("Frame")
        ReplyDivider.Name = "Divider"
        ReplyDivider.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        ReplyDivider.BorderSizePixel = 0
        ReplyDivider.Size = UDim2.new(1, 0, 0, 1)
        ReplyDivider.Parent = ReplyBar

        local ReplyPad = Instance.new("UIPadding")
        ReplyPad.PaddingLeft = UDim.new(0, 12)
        ReplyPad.PaddingRight = UDim.new(0, 12)
        ReplyPad.PaddingTop = UDim.new(0, 8)
        ReplyPad.PaddingBottom = UDim.new(0, 8)
        ReplyPad.Parent = ReplyBar

        local ReplyLayout = Instance.new("UIListLayout")
        ReplyLayout.FillDirection = Enum.FillDirection.Horizontal
        ReplyLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ReplyLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ReplyLayout.Padding = UDim.new(0, 8)
        ReplyLayout.Parent = ReplyBar

        local ReplyInputBox = Instance.new("TextBox")
        ReplyInputBox.Name = "ReplyInput"
        ReplyInputBox.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        ReplyInputBox.BorderSizePixel = 0
        ReplyInputBox.Size = UDim2.new(1, -70, 0, 34)
        ReplyInputBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        ReplyInputBox.PlaceholderText = "Reply to Discord staff..."
        ReplyInputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        ReplyInputBox.Text = ""
        ReplyInputBox.TextColor3 = Color3.fromRGB(235, 235, 235)
        ReplyInputBox.TextSize = 13
        ReplyInputBox.TextXAlignment = Enum.TextXAlignment.Left
        ReplyInputBox.ClearTextOnFocus = false
        ReplyInputBox.LayoutOrder = 1
        ReplyInputBox.Parent = ReplyBar

        local ReplyInputCorner = Instance.new("UICorner")
        ReplyInputCorner.CornerRadius = UDim.new(0, 6)
        ReplyInputCorner.Parent = ReplyInputBox

        local ReplyInputStroke = Instance.new("UIStroke")
        ReplyInputStroke.Color = Color3.fromRGB(42, 42, 42)
        ReplyInputStroke.Thickness = 1
        ReplyInputStroke.Parent = ReplyInputBox

        local ReplyInputPad = Instance.new("UIPadding")
        ReplyInputPad.PaddingLeft = UDim.new(0, 10)
        ReplyInputPad.PaddingRight = UDim.new(0, 10)
        ReplyInputPad.Parent = ReplyInputBox

        local SendReplyBtn = Instance.new("TextButton")
        SendReplyBtn.Name = "SendReplyBtn"
        SendReplyBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        SendReplyBtn.BorderSizePixel = 0
        SendReplyBtn.Size = UDim2.new(0, 62, 0, 34)
        SendReplyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        SendReplyBtn.Text = "Send"
        SendReplyBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        SendReplyBtn.TextSize = 12
        SendReplyBtn.AutoButtonColor = false
        SendReplyBtn.LayoutOrder = 2
        SendReplyBtn.Parent = ReplyBar

        local SendReplyCorner = Instance.new("UICorner")
        SendReplyCorner.CornerRadius = UDim.new(0, 6)
        SendReplyCorner.Parent = SendReplyBtn

        local SendReplyStroke = Instance.new("UIStroke")
        SendReplyStroke.Color = Color3.fromRGB(52, 52, 52)
        SendReplyStroke.Thickness = 1
        SendReplyStroke.Parent = SendReplyBtn

        local ClosedNotice = Instance.new("TextLabel")
        ClosedNotice.Name = "ClosedNotice"
        ClosedNotice.BackgroundTransparency = 1
        ClosedNotice.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        ClosedNotice.Size = UDim2.new(1, 0, 1, 0)
        ClosedNotice.Text = "🔒 Ticket closed - replies disabled."
        ClosedNotice.TextColor3 = Color3.fromRGB(140, 140, 140)
        ClosedNotice.TextSize = 13
        ClosedNotice.Visible = false
        ClosedNotice.Parent = ReplyBar

        local function FormatDate(dt)
            if not dt then return "" end
            local s = tostring(dt)
            if #s >= 10 then
                return string.sub(s, 1, 10)
            end
            return s
        end

        local function CheckCooldown()
            task.spawn(function()
                if Api and Api.Request then
                    local res = Api.Request("/tickets/cooldown?robloxId=" .. robloxId, "GET")
                    if res and res.canSubmit ~= nil then
                        if res.canSubmit then
                            cooldownSeconds = 0
                            CooldownDot.BackgroundColor3 = Color3.fromRGB(85, 215, 95)
                            CooldownText.Text = "Ready to submit"
                            CooldownText.TextColor3 = Color3.fromRGB(200, 200, 200)
                        else
                            cooldownSeconds = tonumber(res.cooldownSeconds) or 0
                            CooldownDot.BackgroundColor3 = Color3.fromRGB(230, 150, 40)
                            local mins = math.floor(cooldownSeconds / 60)
                            local secs = cooldownSeconds % 60
                            CooldownText.Text = string.format("Cooldown: %02d:%02d", mins, secs)
                            CooldownText.TextColor3 = Color3.fromRGB(230, 150, 40)
                        end
                    end
                end
            end)
        end

        local RenderChatMessages = nil
        local LoadTicket = nil

        local function RenderTicketsList()
            for _, c in ipairs(ReportsScroll:GetChildren()) do
                if c:IsA("GuiObject") and c.Name ~= "UIListLayout" then
                    c:Destroy()
                end
            end

            for i, t in ipairs(ticketsList) do
                local item = Instance.new("TextButton")
                item.Name = "Ticket_" .. tostring(t.ticketId)
                item.BackgroundColor3 = (t.ticketId == activeTicketId) and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(22, 22, 22)
                item.BorderSizePixel = 0
                item.Size = UDim2.new(1, 0, 0, 48)
                item.Text = ""
                item.AutoButtonColor = false
                item.LayoutOrder = i
                item.Parent = ReportsScroll

                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 6)
                itemCorner.Parent = item

                local itemStroke = Instance.new("UIStroke")
                itemStroke.Color = (t.ticketId == activeTicketId) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(34, 34, 34)
                itemStroke.Thickness = 1
                itemStroke.Parent = item

                local itemPad = Instance.new("UIPadding")
                itemPad.PaddingLeft = UDim.new(0, 8)
                itemPad.PaddingRight = UDim.new(0, 8)
                itemPad.PaddingTop = UDim.new(0, 6)
                itemPad.PaddingBottom = UDim.new(0, 6)
                itemPad.Parent = item

                local itemLayout = Instance.new("UIListLayout")
                itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                itemLayout.Padding = UDim.new(0, 2)
                itemLayout.Parent = item

                local rowTop = Instance.new("Frame")
                rowTop.Name = "RowTop"
                rowTop.BackgroundTransparency = 1
                rowTop.Size = UDim2.new(1, 0, 0, 18)
                rowTop.LayoutOrder = 1
                rowTop.Parent = item

                local rowTopLayout = Instance.new("UIListLayout")
                rowTopLayout.FillDirection = Enum.FillDirection.Horizontal
                rowTopLayout.SortOrder = Enum.SortOrder.LayoutOrder
                rowTopLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                rowTopLayout.Parent = rowTop

                local tTitle = Instance.new("TextLabel")
                tTitle.Name = "Title"
                tTitle.BackgroundTransparency = 1
                tTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                tTitle.Size = UDim2.new(1, -48, 1, 0)
                tTitle.Text = t.title or "Ticket"
                tTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
                tTitle.TextSize = 12
                tTitle.TextXAlignment = Enum.TextXAlignment.Left
                tTitle.TextTruncate = Enum.TextTruncate.AtEnd
                tTitle.LayoutOrder = 1
                tTitle.Parent = rowTop

                local badge = Instance.new("TextLabel")
                badge.Name = "Badge"
                badge.BackgroundColor3 = (t.status == "open") and Color3.fromRGB(25, 70, 35) or Color3.fromRGB(40, 40, 40)
                badge.BorderSizePixel = 0
                badge.Size = UDim2.new(0, 44, 0, 16)
                badge.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                badge.Text = (t.status == "open") and "OPEN" or "CLOSED"
                badge.TextColor3 = (t.status == "open") and Color3.fromRGB(85, 220, 110) or Color3.fromRGB(150, 150, 150)
                badge.TextSize = 9
                badge.LayoutOrder = 2
                badge.Parent = rowTop

                local badgeCorn = Instance.new("UICorner")
                badgeCorn.CornerRadius = UDim.new(0, 3)
                badgeCorn.Parent = badge

                local dateLabel = Instance.new("TextLabel")
                dateLabel.Name = "Date"
                dateLabel.BackgroundTransparency = 1
                dateLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                dateLabel.Size = UDim2.new(1, 0, 0, 14)
                dateLabel.Text = FormatDate(t.createdAt)
                dateLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
                dateLabel.TextSize = 10
                dateLabel.TextXAlignment = Enum.TextXAlignment.Left
                dateLabel.LayoutOrder = 2
                dateLabel.Parent = item

                Maid:GiveTask(item.MouseButton1Click:Connect(function()
                    LoadTicket(t.ticketId)
                end))
            end
        end

        local function FetchTickets()
            task.spawn(function()
                if Api and Api.Request then
                    local res = Api.Request("/tickets?robloxId=" .. robloxId, "GET")
                    if res and res.success and res.tickets then
                        ticketsList = res.tickets
                        RenderTicketsList()
                    end
                end
            end)
        end

        RenderChatMessages = function(messages, status)
            for _, c in ipairs(MessagesScroll:GetChildren()) do
                if c:IsA("GuiObject") and c.Name ~= "UIListLayout" and c.Name ~= "UIPadding" then
                    c:Destroy()
                end
            end

            for i, m in ipairs(messages or {}) do
                local isUser = (m.sender == "user")
                local isSystem = (m.sender == "system")

                local msgFrame = Instance.new("Frame")
                msgFrame.Name = "Msg_" .. tostring(i)
                msgFrame.BackgroundTransparency = 1
                msgFrame.Size = UDim2.new(1, 0, 0, 0)
                msgFrame.AutomaticSize = Enum.AutomaticSize.Y
                msgFrame.LayoutOrder = i
                msgFrame.Parent = MessagesScroll

                local msgLayout = Instance.new("UIListLayout")
                msgLayout.SortOrder = Enum.SortOrder.LayoutOrder
                msgLayout.HorizontalAlignment = isSystem and Enum.HorizontalAlignment.Center or (isUser and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left)
                msgLayout.Padding = UDim.new(0, 2)
                msgLayout.Parent = msgFrame

                if not isSystem then
                    local authorLabel = Instance.new("TextLabel")
                    authorLabel.Name = "Author"
                    authorLabel.BackgroundTransparency = 1
                    authorLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                    authorLabel.Size = UDim2.new(0, 0, 0, 14)
                    authorLabel.AutomaticSize = Enum.AutomaticSize.X
                    authorLabel.Text = isUser and "You" or (tostring(m.authorName or "Support") .. " [Staff]")
                    authorLabel.TextColor3 = isUser and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 160, 240)
                    authorLabel.TextSize = 11
                    authorLabel.Parent = msgFrame
                end

                local bubble = Instance.new("Frame")
                bubble.Name = "Bubble"
                bubble.BackgroundColor3 = isSystem and Color3.fromRGB(24, 24, 24) or (isUser and Color3.fromRGB(36, 48, 72) or Color3.fromRGB(28, 28, 30))
                bubble.BorderSizePixel = 0
                bubble.Size = UDim2.new(0, 0, 0, 0)
                bubble.AutomaticSize = Enum.AutomaticSize.XY
                bubble.Parent = msgFrame

                local bubbleCorner = Instance.new("UICorner")
                bubbleCorner.CornerRadius = UDim.new(0, 8)
                bubbleCorner.Parent = bubble

                local bubbleStroke = Instance.new("UIStroke")
                bubbleStroke.Color = isSystem and Color3.fromRGB(34, 34, 34) or (isUser and Color3.fromRGB(50, 68, 100) or Color3.fromRGB(44, 44, 48))
                bubbleStroke.Thickness = 1
                bubbleStroke.Parent = bubble

                local bubblePad = Instance.new("UIPadding")
                bubblePad.PaddingLeft = UDim.new(0, 10)
                bubblePad.PaddingRight = UDim.new(0, 10)
                bubblePad.PaddingTop = UDim.new(0, 7)
                bubblePad.PaddingBottom = UDim.new(0, 7)
                bubblePad.Parent = bubble

                local msgText = Instance.new("TextLabel")
                msgText.Name = "Text"
                msgText.BackgroundTransparency = 1
                msgText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                msgText.Size = UDim2.new(0, 0, 0, 0)
                msgText.AutomaticSize = Enum.AutomaticSize.XY
                msgText.Text = tostring(m.text or "")
                msgText.TextColor3 = isSystem and Color3.fromRGB(140, 140, 140) or Color3.fromRGB(240, 240, 240)
                msgText.TextSize = 13
                msgText.TextWrapped = true
                msgText.Parent = bubble

                local sizeConstraint = Instance.new("UISizeConstraint")
                sizeConstraint.MaxSize = Vector2.new(340, math.huge)
                sizeConstraint.Parent = msgText
            end

            task.delay(0.05, function()
                if MessagesScroll and MessagesScroll.Parent then
                    MessagesScroll.CanvasPosition = Vector2.new(0, 999999)
                end
            end)
        end

        LoadTicket = function(ticketId)
            activeTicketId = ticketId
            RenderTicketsList()
            CreateView.Visible = false
            ChatView.Visible = true

            task.spawn(function()
                if Api and Api.Request then
                    local res = Api.Request("/tickets/" .. tostring(ticketId) .. "/messages", "GET")
                    if res and res.success then
                        ChatTitle.Text = res.title or "Ticket"
                        local isClosed = (res.status == "closed")
                        ChatStatusBadge.Text = isClosed and "CLOSED" or "OPEN"
                        ChatStatusBadge.BackgroundColor3 = isClosed and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 70, 35)
                        ChatStatusBadge.TextColor3 = isClosed and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(85, 220, 110)

                        ReplyInputBox.Visible = not isClosed
                        SendReplyBtn.Visible = not isClosed
                        ClosedNotice.Visible = isClosed

                        RenderChatMessages(res.messages, res.status)
                    end
                end
            end)
        end

        local function RefreshTicketMessages()
            if not activeTicketId or not isModalOpen then return end
            task.spawn(function()
                if Api and Api.Request then
                    local res = Api.Request("/tickets/" .. tostring(activeTicketId) .. "/messages", "GET")
                    if res and res.success then
                        local isClosed = (res.status == "closed")
                        ChatStatusBadge.Text = isClosed and "CLOSED" or "OPEN"
                        ChatStatusBadge.BackgroundColor3 = isClosed and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 70, 35)
                        ChatStatusBadge.TextColor3 = isClosed and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(85, 220, 110)

                        ReplyInputBox.Visible = not isClosed
                        SendReplyBtn.Visible = not isClosed
                        ClosedNotice.Visible = isClosed

                        RenderChatMessages(res.messages, res.status)
                    end
                end
            end)
        end

        local function SendReply()
            local text = ReplyInputBox.Text
            if not text or string.gsub(text, "%s+", "") == "" then return end
            if not activeTicketId then return end

            ReplyInputBox.Text = ""
            task.spawn(function()
                if Api and Api.Request then
                    local res = Api.Request("/tickets/" .. tostring(activeTicketId) .. "/messages", "POST", {
                        text = text,
                        authorName = robloxUsername
                    })
                    if res and res.success then
                        RefreshTicketMessages()
                    else
                        SendNotification({ Title = "Error", Content = (res and res.error) or "Failed to send reply.", Type = "Error", Duration = 3 })
                    end
                end
            end)
        end

        Maid:GiveTask(SendReplyBtn.MouseButton1Click:Connect(SendReply))
        Maid:GiveTask(ReplyInputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                SendReply()
            end
        end))

        Maid:GiveTask(NewReportBtn.MouseButton1Click:Connect(function()
            activeTicketId = nil
            RenderTicketsList()
            ChatView.Visible = false
            CreateView.Visible = true
            TitleTextBox.Text = ""
            DescTextBox.Text = ""
            StatusMsg.Text = ""
            CheckCooldown()
        end))

        local function SubmitTicket()
            local title = TitleTextBox.Text
            local desc = DescTextBox.Text
            if not title or string.gsub(title, "%s+", "") == "" then
                StatusMsg.Text = "Please enter a report title."
                StatusMsg.TextColor3 = Color3.fromRGB(230, 80, 80)
                return
            end

            SubmitBtn.Text = "Submitting..."
            task.spawn(function()
                if Api and Api.Request then
                    local res = Api.Request("/tickets", "POST", {
                        title = title,
                        description = desc,
                        robloxId = robloxId,
                        robloxUsername = robloxUsername,
                        hwid = hwid,
                        username = (Api and Api.UserData and Api.UserData.username) or robloxUsername
                    })

                    SubmitBtn.Text = "Submit Bug Report"
                    if res and res.success and res.ticket then
                        TitleTextBox.Text = ""
                        DescTextBox.Text = ""
                        StatusMsg.Text = ""
                        SendNotification({ Title = "Report Created", Content = "Discord ticket channel opened! Staff notified.", Duration = 4 })
                        CheckCooldown()
                        FetchTickets()
                        LoadTicket(res.ticket.ticketId)
                    else
                        local err = (res and (res.message or res.error)) or "Failed to submit report."
                        StatusMsg.Text = err
                        StatusMsg.TextColor3 = Color3.fromRGB(230, 80, 80)
                    end
                end
            end)
        end

        Maid:GiveTask(SubmitBtn.MouseButton1Click:Connect(SubmitTicket))

        OpenTicketModal = function()
            isModalOpen = true
            TicketModal.Visible = true
            TicketModal.GroupTransparency = 1
            Tween(TicketModal, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
            CheckCooldown()
            FetchTickets()

            task.spawn(function()
                while isModalOpen and Page and Page.Parent do
                    task.wait(3)
                    if isModalOpen and activeTicketId then
                        RefreshTicketMessages()
                    end
                end
            end)
        end

        local function CloseTicketModal()
            isModalOpen = false
            activeTicketId = nil
            Tween(TicketModal, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 1})
            task.delay(0.18, function()
                if not isModalOpen then
                    TicketModal.Visible = false
                end
            end)
        end

        Maid:GiveTask(BackBtn.MouseButton1Click:Connect(CloseTicketModal))

        Maid:GiveTask(Page:GetPropertyChangedSignal("Visible"):Connect(function()
            if not Page.Visible and isModalOpen then
                CloseTicketModal()
            end
        end))
    end

    return {
        Instance = Page,
        Topbar = Topbar,
        Notifications = NotificationsPopover,
        Profile = ProfilePopover
    }
end

return HomePage
