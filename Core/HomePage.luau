local Players = game:GetService("Players")
local Tween = require(script.Parent.Parent.Utils.Tween)

local HomePage = {}

function HomePage.Create(Content, Maid, BackCallback, WindowObject)
    local Page = Instance.new("Frame")
    Page.Name = "HomePage"
    Page.AnchorPoint = Vector2.new(0, 0)
    Page.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
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
        Maid:GiveTask(ReturnButton.MouseButton1Click:Connect(BackCallback))
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
    PageTitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
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

    local NotificationsBtn = Instance.new("ImageButton")
    NotificationsBtn.Name = "Notifications"
    NotificationsBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    NotificationsBtn.BackgroundTransparency = 1
    NotificationsBtn.BorderColor3 = Color3.new(0, 0, 0)
    NotificationsBtn.BorderSizePixel = 0
    NotificationsBtn.Size = UDim2.new(0, 40, 0, 40)
    NotificationsBtn.Parent = Icons

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    NotifLayout.Parent = NotificationsBtn

    local NotifIcon = Instance.new("ImageLabel")
    NotifIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.BorderColor3 = Color3.new(0, 0, 0)
    NotifIcon.BorderSizePixel = 0
    NotifIcon.Image = "rbxassetid://113899772841352"
    NotifIcon.Size = UDim2.new(0, 25, 0, 25)
    NotifIcon.Parent = NotificationsBtn

    local AccountBtn = Instance.new("ImageButton")
    AccountBtn.Name = "Account"
    AccountBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    AccountBtn.BackgroundTransparency = 1
    AccountBtn.BorderColor3 = Color3.new(0, 0, 0)
    AccountBtn.BorderSizePixel = 0
    AccountBtn.LayoutOrder = 1
    AccountBtn.Size = UDim2.new(0, 60, 0, 40)
    AccountBtn.Parent = Icons

    local AccountBtnLayout = Instance.new("UIListLayout")
    AccountBtnLayout.FillDirection = Enum.FillDirection.Horizontal
    AccountBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    AccountBtnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    AccountBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    AccountBtnLayout.Parent = AccountBtn

    local AccountIconFrame = Instance.new("Frame")
    AccountIconFrame.Name = "Icon"
    AccountIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    AccountIconFrame.BackgroundTransparency = 1
    AccountIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    AccountIconFrame.BorderSizePixel = 0
    AccountIconFrame.LayoutOrder = 1
    AccountIconFrame.Position = UDim2.new(0.359, 0, 0, 0)
    AccountIconFrame.Size = UDim2.new(0, 20, 0, 40)
    AccountIconFrame.Parent = AccountBtn

    local AccountIconLayout = Instance.new("UIListLayout")
    AccountIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    AccountIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    AccountIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    AccountIconLayout.Parent = AccountIconFrame

    local AccountIconImg = Instance.new("ImageLabel")
    AccountIconImg.BackgroundColor3 = Color3.new(1, 1, 1)
    AccountIconImg.BackgroundTransparency = 1
    AccountIconImg.BorderColor3 = Color3.new(0, 0, 0)
    AccountIconImg.BorderSizePixel = 0
    AccountIconImg.Image = "rbxassetid://136385496998416"
    AccountIconImg.Size = UDim2.new(0, 20, 0, 20)
    AccountIconImg.Parent = AccountIconFrame

    local AccountIconPadding = Instance.new("UIPadding")
    AccountIconPadding.PaddingRight = UDim.new(0, 2)
    AccountIconPadding.Parent = AccountIconFrame

    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Name = "Profile"
    ProfileFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    ProfileFrame.BackgroundTransparency = 1
    ProfileFrame.BorderColor3 = Color3.new(0, 0, 0)
    ProfileFrame.BorderSizePixel = 0
    ProfileFrame.Size = UDim2.new(0, 40, 0, 40)
    ProfileFrame.Parent = AccountBtn

    local ProfileLayout = Instance.new("UIListLayout")
    ProfileLayout.FillDirection = Enum.FillDirection.Horizontal
    ProfileLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ProfileLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ProfileLayout.Parent = ProfileFrame

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Name = "Frame"
    AvatarImg.BackgroundColor3 = Color3.new(0.188, 0.188, 0.188)
    AvatarImg.BorderColor3 = Color3.new(0, 0, 0)
    AvatarImg.BorderSizePixel = 0
    AvatarImg.Size = UDim2.new(0, 30, 0, 30)
    AvatarImg.Parent = ProfileFrame

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 6)
    AvatarCorner.Parent = AvatarImg

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Color3.new(0.31, 0.31, 0.31)
    AvatarStroke.Parent = AvatarImg

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

    if WindowObject and WindowObject.OpenAccount then
        Maid:GiveTask(AccountBtn.MouseButton1Click:Connect(function()
            WindowObject:OpenAccount()
        end))
    end

    local MainSection = Instance.new("Frame")
    MainSection.Name = "Updats/Players"
    MainSection.BackgroundColor3 = Color3.new(1, 1, 1)
    MainSection.BackgroundTransparency = 1
    MainSection.BorderColor3 = Color3.new(0, 0, 0)
    MainSection.BorderSizePixel = 0
    MainSection.LayoutOrder = 1
    MainSection.Size = UDim2.new(1, 0, 0, 230)
    MainSection.Parent = Page

    local MainSectionLayout = Instance.new("UIListLayout")
    MainSectionLayout.FillDirection = Enum.FillDirection.Horizontal
    MainSectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainSectionLayout.Padding = UDim.new(0, 10)
    MainSectionLayout.Parent = MainSection

    local MainSectionPadding = Instance.new("UIPadding")
    MainSectionPadding.PaddingLeft = UDim.new(0, 8)
    MainSectionPadding.PaddingRight = UDim.new(0, 8)
    MainSectionPadding.Parent = MainSection

    local PlayersCard = Instance.new("Frame")
    PlayersCard.Name = "Players"
    PlayersCard.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersCard.BackgroundTransparency = 1
    PlayersCard.BorderColor3 = Color3.new(0, 0, 0)
    PlayersCard.BorderSizePixel = 0
    PlayersCard.Size = UDim2.new(0, 200, 1, 0)
    PlayersCard.Parent = MainSection

    local PlayersCardInner = Instance.new("Frame")
    PlayersCardInner.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    PlayersCardInner.BackgroundTransparency = 0.5
    PlayersCardInner.BorderColor3 = Color3.new(0, 0, 0)
    PlayersCardInner.BorderSizePixel = 0
    PlayersCardInner.Size = UDim2.new(1, 0, 1, 0)
    PlayersCardInner.Parent = PlayersCard

    local PlayersInnerCorner = Instance.new("UICorner")
    PlayersInnerCorner.CornerRadius = UDim.new(0, 8)
    PlayersInnerCorner.Parent = PlayersCardInner

    local PlayersInnerStroke = Instance.new("UIStroke")
    PlayersInnerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    PlayersInnerStroke.Color = Color3.new(0.149, 0.149, 0.149)
    PlayersInnerStroke.Parent = PlayersCardInner

    local PlayersInnerLayout = Instance.new("UIListLayout")
    PlayersInnerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayersInnerLayout.Parent = PlayersCardInner

    local PlayersHeader = Instance.new("Frame")
    PlayersHeader.Name = "Text"
    PlayersHeader.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersHeader.BackgroundTransparency = 1
    PlayersHeader.BorderColor3 = Color3.new(0, 0, 0)
    PlayersHeader.BorderSizePixel = 0
    PlayersHeader.Size = UDim2.new(1, 0, 0, 50)
    PlayersHeader.Parent = PlayersCardInner

    local PlayersHeaderLayout = Instance.new("UIListLayout")
    PlayersHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    PlayersHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayersHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    PlayersHeaderLayout.Parent = PlayersHeader

    local PlayersIconFrame = Instance.new("Frame")
    PlayersIconFrame.Name = "Icon"
    PlayersIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersIconFrame.BackgroundTransparency = 1
    PlayersIconFrame.BorderColor3 = Color3.new(0, 0, 0)
    PlayersIconFrame.BorderSizePixel = 0
    PlayersIconFrame.Size = UDim2.new(0, 45, 0, 50)
    PlayersIconFrame.Parent = PlayersHeader

    local PlayersIconLayout = Instance.new("UIListLayout")
    PlayersIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PlayersIconLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayersIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    PlayersIconLayout.Parent = PlayersIconFrame

    local PlayersIconImg = Instance.new("ImageLabel")
    PlayersIconImg.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersIconImg.BackgroundTransparency = 1
    PlayersIconImg.BorderColor3 = Color3.new(0, 0, 0)
    PlayersIconImg.BorderSizePixel = 0
    PlayersIconImg.Image = "rbxassetid://97001881921521"
    PlayersIconImg.Size = UDim2.new(0, 26, 0, 26)
    PlayersIconImg.Parent = PlayersIconFrame

    local PlayersInfoFrame = Instance.new("Frame")
    PlayersInfoFrame.Name = "Info"
    PlayersInfoFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersInfoFrame.BackgroundTransparency = 1
    PlayersInfoFrame.BorderColor3 = Color3.new(0, 0, 0)
    PlayersInfoFrame.BorderSizePixel = 0
    PlayersInfoFrame.LayoutOrder = 1
    PlayersInfoFrame.Size = UDim2.new(1, -45, 1, 0)
    PlayersInfoFrame.Parent = PlayersHeader

    local PlayersInfoLayout = Instance.new("UIListLayout")
    PlayersInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayersInfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    PlayersInfoLayout.Parent = PlayersInfoFrame

    local PlayersTitle = Instance.new("TextLabel")
    PlayersTitle.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersTitle.BackgroundTransparency = 1
    PlayersTitle.BorderColor3 = Color3.new(0, 0, 0)
    PlayersTitle.BorderSizePixel = 0
    PlayersTitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PlayersTitle.Size = UDim2.new(1, 0, 0, 20)
    PlayersTitle.Text = "Players"
    PlayersTitle.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    PlayersTitle.TextSize = 16
    PlayersTitle.TextXAlignment = Enum.TextXAlignment.Left
    PlayersTitle.TextYAlignment = Enum.TextYAlignment.Bottom
    PlayersTitle.Parent = PlayersInfoFrame

    local PlayersSubtitle = Instance.new("TextLabel")
    PlayersSubtitle.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersSubtitle.BackgroundTransparency = 1
    PlayersSubtitle.BorderColor3 = Color3.new(0, 0, 0)
    PlayersSubtitle.BorderSizePixel = 0
    PlayersSubtitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    PlayersSubtitle.Size = UDim2.new(1, 0, 0, 18)
    PlayersSubtitle.Text = "Players on the Server"
    PlayersSubtitle.TextColor3 = Color3.new(0.65, 0.65, 0.65)
    PlayersSubtitle.TextSize = 13
    PlayersSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    PlayersSubtitle.TextYAlignment = Enum.TextYAlignment.Top
    PlayersSubtitle.Parent = PlayersInfoFrame

    local PlayersScroll = Instance.new("ScrollingFrame")
    PlayersScroll.Name = "Players"
    PlayersScroll.BackgroundColor3 = Color3.new(1, 1, 1)
    PlayersScroll.BackgroundTransparency = 1
    PlayersScroll.BorderColor3 = Color3.new(0, 0, 0)
    PlayersScroll.BorderSizePixel = 0
    PlayersScroll.LayoutOrder = 1
    PlayersScroll.Size = UDim2.new(1, 0, 1, -50)
    PlayersScroll.ScrollBarThickness = 2
    PlayersScroll.ScrollBarImageColor3 = Color3.new(0.3, 0.3, 0.3)
    PlayersScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayersScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PlayersScroll.Parent = PlayersCardInner

    local PlayersScrollLayout = Instance.new("UIListLayout")
    PlayersScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PlayersScrollLayout.Padding = UDim.new(0, 5)
    PlayersScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayersScrollLayout.Parent = PlayersScroll

    local PlayersScrollPadding = Instance.new("UIPadding")
    PlayersScrollPadding.PaddingTop = UDim.new(0, 4)
    PlayersScrollPadding.PaddingBottom = UDim.new(0, 4)
    PlayersScrollPadding.Parent = PlayersScroll

    local function AddPlayerItem(player)
        local PlayerItem = Instance.new("Frame")
        PlayerItem.Name = player.Name
        PlayerItem.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
        PlayerItem.BackgroundTransparency = 0.5
        PlayerItem.BorderColor3 = Color3.new(0, 0, 0)
        PlayerItem.BorderSizePixel = 0
        PlayerItem.Size = UDim2.new(1, -10, 0, 40)
        PlayerItem.Parent = PlayersScroll

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 6)
        ItemCorner.Parent = PlayerItem

        local ItemStroke = Instance.new("UIStroke")
        ItemStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        ItemStroke.Color = Color3.new(0.149, 0.149, 0.149)
        ItemStroke.Parent = PlayerItem

        local ItemLayout = Instance.new("UIListLayout")
        ItemLayout.FillDirection = Enum.FillDirection.Horizontal
        ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ItemLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ItemLayout.Parent = PlayerItem

        local ItemIconFrame = Instance.new("Frame")
        ItemIconFrame.Name = "Icon"
        ItemIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        ItemIconFrame.BackgroundTransparency = 1
        ItemIconFrame.Size = UDim2.new(0, 36, 1, 0)
        ItemIconFrame.Parent = PlayerItem

        local ItemIconLayout = Instance.new("UIListLayout")
        ItemIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ItemIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ItemIconLayout.Parent = ItemIconFrame

        local AvatarThumb = Instance.new("ImageLabel")
        AvatarThumb.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
        AvatarThumb.BorderSizePixel = 0
        AvatarThumb.Size = UDim2.new(0, 26, 0, 26)
        AvatarThumb.Parent = ItemIconFrame

        local ThumbCorner = Instance.new("UICorner")
        ThumbCorner.CornerRadius = UDim.new(0, 13)
        ThumbCorner.Parent = AvatarThumb

        task.spawn(function()
            local iconImg = nil
            pcall(function()
                iconImg = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            if iconImg then
                AvatarThumb.Image = iconImg
            end
        end)

        local ItemTextFrame = Instance.new("Frame")
        ItemTextFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        ItemTextFrame.BackgroundTransparency = 1
        ItemTextFrame.Size = UDim2.new(1, -40, 1, 0)
        ItemTextFrame.Parent = PlayerItem

        local ItemTextLayout = Instance.new("UIListLayout")
        ItemTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ItemTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ItemTextLayout.Parent = ItemTextFrame

        local UsernameLabel = Instance.new("TextLabel")
        UsernameLabel.Name = "Username"
        UsernameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        UsernameLabel.BackgroundTransparency = 1
        UsernameLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        UsernameLabel.Size = UDim2.new(1, 0, 0, 18)
        UsernameLabel.Text = player.DisplayName or player.Name
        UsernameLabel.TextColor3 = Color3.new(1, 1, 1)
        UsernameLabel.TextSize = 14
        UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
        UsernameLabel.Parent = ItemTextFrame

        local IdLabel = Instance.new("TextLabel")
        IdLabel.Name = "Id"
        IdLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        IdLabel.BackgroundTransparency = 1
        IdLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        IdLabel.Size = UDim2.new(1, 0, 0, 16)
        IdLabel.Text = "@" .. player.Name
        IdLabel.TextColor3 = Color3.new(0.6, 0.6, 0.6)
        IdLabel.TextSize = 12
        IdLabel.TextTruncate = Enum.TextTruncate.AtEnd
        IdLabel.TextXAlignment = Enum.TextXAlignment.Left
        IdLabel.Parent = ItemTextFrame
    end

    for _, p in ipairs(Players:GetPlayers()) do
        AddPlayerItem(p)
    end
    Maid:GiveTask(Players.PlayerAdded:Connect(AddPlayerItem))
    Maid:GiveTask(Players.PlayerRemoving:Connect(function(p)
        local item = PlayersScroll:FindFirstChild(p.Name)
        if item then item:Destroy() end
    end))

    local UpdatesCard = Instance.new("Frame")
    UpdatesCard.Name = "Updates"
    UpdatesCard.BackgroundColor3 = Color3.new(1, 1, 1)
    UpdatesCard.BackgroundTransparency = 1
    UpdatesCard.BorderColor3 = Color3.new(0, 0, 0)
    UpdatesCard.BorderSizePixel = 0
    UpdatesCard.Size = UDim2.new(1, -210, 1, 0)
    UpdatesCard.Parent = MainSection

    local KeysFrame = Instance.new("Frame")
    KeysFrame.Name = "Keys"
    KeysFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    KeysFrame.BackgroundTransparency = 0.5
    KeysFrame.BorderColor3 = Color3.new(0, 0, 0)
    KeysFrame.BorderSizePixel = 0
    KeysFrame.Size = UDim2.new(1, 0, 1, 0)
    KeysFrame.Parent = UpdatesCard

    local KeysCorner = Instance.new("UICorner")
    KeysCorner.CornerRadius = UDim.new(0, 8)
    KeysCorner.Parent = KeysFrame

    local KeysStroke = Instance.new("UIStroke")
    KeysStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    KeysStroke.Color = Color3.new(0.149, 0.149, 0.149)
    KeysStroke.Parent = KeysFrame

    local KeysLayout = Instance.new("UIListLayout")
    KeysLayout.SortOrder = Enum.SortOrder.LayoutOrder
    KeysLayout.Parent = KeysFrame

    local UpdatesHeader = Instance.new("Frame")
    UpdatesHeader.Name = "Text"
    UpdatesHeader.BackgroundColor3 = Color3.new(1, 1, 1)
    UpdatesHeader.BackgroundTransparency = 1
    UpdatesHeader.BorderColor3 = Color3.new(0, 0, 0)
    UpdatesHeader.BorderSizePixel = 0
    UpdatesHeader.Size = UDim2.new(1, 0, 0, 32)
    UpdatesHeader.Parent = KeysFrame

    local UpdatesHeaderStroke = Instance.new("UIStroke")
    UpdatesHeaderStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    UpdatesHeaderStroke.Color = Color3.new(0.149, 0.149, 0.149)
    UpdatesHeaderStroke.Parent = UpdatesHeader

    local UpdatesHeaderCorner = Instance.new("UICorner")
    UpdatesHeaderCorner.CornerRadius = UDim.new(0, 8)
    UpdatesHeaderCorner.BottomLeftRadius = UDim.new(0, 0)
    UpdatesHeaderCorner.BottomRightRadius = UDim.new(0, 0)
    UpdatesHeaderCorner.Parent = UpdatesHeader

    local UpdatesHeaderLayout = Instance.new("UIListLayout")
    UpdatesHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    UpdatesHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UpdatesHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UpdatesHeaderLayout.Parent = UpdatesHeader

    local UpdatesIconFrame = Instance.new("Frame")
    UpdatesIconFrame.Name = "Icon"
    UpdatesIconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    UpdatesIconFrame.BackgroundTransparency = 1
    UpdatesIconFrame.Size = UDim2.new(0, 30, 0, 30)
    UpdatesIconFrame.Parent = UpdatesHeader

    local UpdatesIconLayout = Instance.new("UIListLayout")
    UpdatesIconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UpdatesIconLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UpdatesIconLayout.Parent = UpdatesIconFrame

    local UpdatesIconImg = Instance.new("ImageLabel")
    UpdatesIconImg.BackgroundColor3 = Color3.new(1, 1, 1)
    UpdatesIconImg.BackgroundTransparency = 1
    UpdatesIconImg.Image = "rbxassetid://74747504739295"
    UpdatesIconImg.Size = UDim2.new(0, 18, 0, 18)
    UpdatesIconImg.Parent = UpdatesIconFrame

    local UpdatesHeaderText = Instance.new("TextLabel")
    UpdatesHeaderText.Name = "Text"
    UpdatesHeaderText.BackgroundColor3 = Color3.new(1, 1, 1)
    UpdatesHeaderText.BackgroundTransparency = 1
    UpdatesHeaderText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    UpdatesHeaderText.Size = UDim2.new(0, 100, 0, 30)
    UpdatesHeaderText.Text = "Updates"
    UpdatesHeaderText.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    UpdatesHeaderText.TextSize = 15
    UpdatesHeaderText.TextXAlignment = Enum.TextXAlignment.Left
    UpdatesHeaderText.Parent = UpdatesHeader

    local UpdatesFiller = Instance.new("Frame")
    UpdatesFiller.Name = "Filler"
    UpdatesFiller.BackgroundColor3 = Color3.new(1, 1, 1)
    UpdatesFiller.BackgroundTransparency = 1
    UpdatesFiller.Size = UDim2.new(1, -135, 0, 30)
    UpdatesFiller.Parent = UpdatesHeader

    local ClaimedScroll = Instance.new("ScrollingFrame")
    ClaimedScroll.Name = "Claimed"
    ClaimedScroll.BackgroundColor3 = Color3.new(1, 1, 1)
    ClaimedScroll.BackgroundTransparency = 1
    ClaimedScroll.BorderColor3 = Color3.new(0, 0, 0)
    ClaimedScroll.BorderSizePixel = 0
    ClaimedScroll.Size = UDim2.new(1, 0, 1, -32)
    ClaimedScroll.ScrollBarThickness = 2
    ClaimedScroll.ScrollBarImageColor3 = Color3.new(0.3, 0.3, 0.3)
    ClaimedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ClaimedScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ClaimedScroll.Parent = KeysFrame

    local ClaimedLayout = Instance.new("UIListLayout")
    ClaimedLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ClaimedLayout.Padding = UDim.new(0, 6)
    ClaimedLayout.Parent = ClaimedScroll

    local ClaimedPadding = Instance.new("UIPadding")
    ClaimedPadding.PaddingTop = UDim.new(0, 8)
    ClaimedPadding.PaddingBottom = UDim.new(0, 8)
    ClaimedPadding.PaddingLeft = UDim.new(0, 10)
    ClaimedPadding.PaddingRight = UDim.new(0, 10)
    ClaimedPadding.Parent = ClaimedScroll

    local function AddUpdateCard(title, date, desc)
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
        Card.BackgroundTransparency = 0.4
        Card.Size = UDim2.new(1, 0, 0, 50)
        Card.Parent = ClaimedScroll

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 6)
        CardCorner.Parent = Card

        local CardStroke = Instance.new("UIStroke")
        CardStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
        CardStroke.Color = Color3.new(0.149, 0.149, 0.149)
        CardStroke.Parent = Card

        local CardLayout = Instance.new("UIListLayout")
        CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
        CardLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        CardLayout.Parent = Card

        local CardPadding = Instance.new("UIPadding")
        CardPadding.PaddingLeft = UDim.new(0, 10)
        CardPadding.PaddingRight = UDim.new(0, 10)
        CardPadding.Parent = Card

        local TitleRow = Instance.new("Frame")
        TitleRow.BackgroundTransparency = 1
        TitleRow.Size = UDim2.new(1, 0, 0, 20)
        TitleRow.Parent = Card

        local TitleRowLayout = Instance.new("UIListLayout")
        TitleRowLayout.FillDirection = Enum.FillDirection.Horizontal
        TitleRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TitleRowLayout.Parent = TitleRow

        local CardTitle = Instance.new("TextLabel")
        CardTitle.BackgroundTransparency = 1
        CardTitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        CardTitle.Size = UDim2.new(0.7, 0, 1, 0)
        CardTitle.Text = title
        CardTitle.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        CardTitle.TextSize = 14
        CardTitle.TextXAlignment = Enum.TextXAlignment.Left
        CardTitle.Parent = TitleRow

        local CardDate = Instance.new("TextLabel")
        CardDate.BackgroundTransparency = 1
        CardDate.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        CardDate.Size = UDim2.new(0.3, 0, 1, 0)
        CardDate.Text = date
        CardDate.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        CardDate.TextSize = 12
        CardDate.TextXAlignment = Enum.TextXAlignment.Right
        CardDate.Parent = TitleRow

        local CardDesc = Instance.new("TextLabel")
        CardDesc.BackgroundTransparency = 1
        CardDesc.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        CardDesc.Size = UDim2.new(1, 0, 0, 18)
        CardDesc.Text = desc
        CardDesc.TextColor3 = Color3.new(0.65, 0.65, 0.65)
        CardDesc.TextSize = 12
        CardDesc.TextXAlignment = Enum.TextXAlignment.Left
        CardDesc.Parent = Card
    end

    AddUpdateCard("Volt UI v1.1.4", "Today", "Added new Home Tab interface, live server player list and updates.")
    AddUpdateCard("Performance & Animations", "Yesterday", "Optimized tab transitions, instant switches and right-to-left slides.")

    local BugReportsSection = Instance.new("Frame")
    BugReportsSection.Name = "Bug Reports"
    BugReportsSection.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
    BugReportsSection.BackgroundTransparency = 0.5
    BugReportsSection.BorderColor3 = Color3.new(0, 0, 0)
    BugReportsSection.BorderSizePixel = 0
    BugReportsSection.LayoutOrder = 2
    BugReportsSection.Size = UDim2.new(1, -16, 0, 50)
    BugReportsSection.Position = UDim2.new(0, 8, 0, 0)
    BugReportsSection.Parent = Page

    local BugReportsCorner = Instance.new("UICorner")
    BugReportsCorner.CornerRadius = UDim.new(0, 8)
    BugReportsCorner.Parent = BugReportsSection

    local BugReportsStroke = Instance.new("UIStroke")
    BugReportsStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    BugReportsStroke.Color = Color3.new(0.149, 0.149, 0.149)
    BugReportsStroke.Parent = BugReportsSection

    local BugReportsLayout = Instance.new("UIListLayout")
    BugReportsLayout.FillDirection = Enum.FillDirection.Horizontal
    BugReportsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BugReportsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BugReportsLayout.Parent = BugReportsSection

    local BugInfo = Instance.new("Frame")
    BugInfo.Name = "Info"
    BugInfo.BackgroundColor3 = Color3.new(1, 1, 1)
    BugInfo.BackgroundTransparency = 1
    BugInfo.BorderColor3 = Color3.new(0, 0, 0)
    BugInfo.BorderSizePixel = 0
    BugInfo.Size = UDim2.new(0, 240, 0, 50)
    BugInfo.Parent = BugReportsSection

    local BugInfoLayout = Instance.new("UIListLayout")
    BugInfoLayout.FillDirection = Enum.FillDirection.Horizontal
    BugInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BugInfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BugInfoLayout.Parent = BugInfo

    local BugInfoPadding = Instance.new("UIPadding")
    BugInfoPadding.PaddingLeft = UDim.new(0, 9)
    BugInfoPadding.Parent = BugInfo

    local BugIcon = Instance.new("ImageLabel")
    BugIcon.Name = "Icon"
    BugIcon.BackgroundColor3 = Color3.new(1, 1, 1)
    BugIcon.BackgroundTransparency = 1
    BugIcon.BorderColor3 = Color3.new(0, 0, 0)
    BugIcon.BorderSizePixel = 0
    BugIcon.Image = "rbxassetid://70862937184937"
    BugIcon.Size = UDim2.new(0, 31, 0, 31)
    BugIcon.Parent = BugInfo

    local BugTextFrame = Instance.new("Frame")
    BugTextFrame.Name = "Text"
    BugTextFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    BugTextFrame.BackgroundTransparency = 1
    BugTextFrame.Size = UDim2.new(1, -40, 1, 0)
    BugTextFrame.Parent = BugInfo

    local BugTextPadding = Instance.new("UIPadding")
    BugTextPadding.PaddingLeft = UDim.new(0, 6)
    BugTextPadding.Parent = BugTextFrame

    local BugTextLayout = Instance.new("UIListLayout")
    BugTextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BugTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BugTextLayout.Parent = BugTextFrame

    local BugTitle = Instance.new("TextLabel")
    BugTitle.BackgroundColor3 = Color3.new(1, 1, 1)
    BugTitle.BackgroundTransparency = 1
    BugTitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    BugTitle.Size = UDim2.new(1, 0, 0, 20)
    BugTitle.Text = "Bug Report"
    BugTitle.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    BugTitle.TextSize = 15
    BugTitle.TextXAlignment = Enum.TextXAlignment.Left
    BugTitle.TextYAlignment = Enum.TextYAlignment.Bottom
    BugTitle.Parent = BugTextFrame

    local BugSubtitle = Instance.new("TextLabel")
    BugSubtitle.BackgroundColor3 = Color3.new(1, 1, 1)
    BugSubtitle.BackgroundTransparency = 1
    BugSubtitle.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    BugSubtitle.Size = UDim2.new(1, 0, 0, 18)
    BugSubtitle.Text = "Subscription and Claimed keys"
    BugSubtitle.TextColor3 = Color3.new(0.65, 0.65, 0.65)
    BugSubtitle.TextSize = 13
    BugSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    BugSubtitle.TextYAlignment = Enum.TextYAlignment.Top
    BugSubtitle.Parent = BugTextFrame

    local BugSendArea = Instance.new("Frame")
    BugSendArea.Name = "Send"
    BugSendArea.BackgroundColor3 = Color3.new(1, 1, 1)
    BugSendArea.BackgroundTransparency = 1
    BugSendArea.Size = UDim2.new(1, -240, 1, 0)
    BugSendArea.Parent = BugReportsSection

    local BugSendLayout = Instance.new("UIListLayout")
    BugSendLayout.FillDirection = Enum.FillDirection.Horizontal
    BugSendLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    BugSendLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BugSendLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BugSendLayout.Padding = UDim.new(0, 10)
    BugSendLayout.Parent = BugSendArea

    local BugSendPadding = Instance.new("UIPadding")
    BugSendPadding.PaddingRight = UDim.new(0, 10)
    BugSendPadding.Parent = BugSendArea

    local BugInputFrame = Instance.new("Frame")
    BugInputFrame.Name = "Input"
    BugInputFrame.BackgroundColor3 = Color3.new(0.086, 0.086, 0.086)
    BugInputFrame.BorderSizePixel = 0
    BugInputFrame.Size = UDim2.new(1, -110, 0, 35)
    BugInputFrame.Parent = BugSendArea

    local BugInputCorner = Instance.new("UICorner")
    BugInputCorner.CornerRadius = UDim.new(0, 6)
    BugInputCorner.Parent = BugInputFrame

    local BugInputStroke = Instance.new("UIStroke")
    BugInputStroke.Color = Color3.new(0.208, 0.208, 0.208)
    BugInputStroke.Parent = BugInputFrame

    local BugTextBox = Instance.new("TextBox")
    BugTextBox.BackgroundColor3 = Color3.new(1, 1, 1)
    BugTextBox.BackgroundTransparency = 1
    BugTextBox.BorderSizePixel = 0
    BugTextBox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    BugTextBox.Size = UDim2.new(1, 0, 1, 0)
    BugTextBox.Text = ""
    BugTextBox.PlaceholderText = "Describe the bug..."
    BugTextBox.PlaceholderColor3 = Color3.new(0.35, 0.35, 0.35)
    BugTextBox.TextColor3 = Color3.new(0.85, 0.85, 0.85)
    BugTextBox.TextSize = 14
    BugTextBox.TextXAlignment = Enum.TextXAlignment.Left
    BugTextBox.ClearTextOnFocus = false
    BugTextBox.Parent = BugInputFrame

    local BugTextBoxPadding = Instance.new("UIPadding")
    BugTextBoxPadding.PaddingLeft = UDim.new(0, 8)
    BugTextBoxPadding.PaddingRight = UDim.new(0, 8)
    BugTextBoxPadding.Parent = BugTextBox

    local SendBtnContainer = Instance.new("Frame")
    SendBtnContainer.Name = "Send"
    SendBtnContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    SendBtnContainer.BackgroundTransparency = 1
    SendBtnContainer.Size = UDim2.new(0, 80, 0, 35)
    SendBtnContainer.Parent = BugSendArea

    local SendBtn = Instance.new("TextButton")
    SendBtn.Name = "Button"
    SendBtn.BackgroundColor3 = Color3.new(0.149, 0.149, 0.149)
    SendBtn.BorderSizePixel = 0
    SendBtn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SendBtn.Size = UDim2.new(1, 0, 1, 0)
    SendBtn.Text = "Sent"
    SendBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    SendBtn.TextSize = 14
    SendBtn.Parent = SendBtnContainer

    local SendBtnCorner = Instance.new("UICorner")
    SendBtnCorner.CornerRadius = UDim.new(0, 6)
    SendBtnCorner.Parent = SendBtn

    local SendBtnStroke = Instance.new("UIStroke")
    SendBtnStroke.Color = Color3.new(0.247, 0.247, 0.247)
    SendBtnStroke.Parent = SendBtn

    Maid:GiveTask(SendBtn.MouseEnter:Connect(function()
        Tween(SendBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)})
    end))
    Maid:GiveTask(SendBtn.MouseLeave:Connect(function()
        Tween(SendBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.149, 0.149, 0.149)})
    end))
    Maid:GiveTask(SendBtn.MouseButton1Click:Connect(function()
        if BugTextBox.Text ~= "" then
            BugTextBox.Text = ""
            if WindowObject and WindowObject.Notify then
                WindowObject:Notify({
                    Title = "Bug Report",
                    Content = "Thank you! Your bug report has been submitted.",
                    Duration = 3
                })
            end
        end
    end))

    return {
        Instance = Page,
        Topbar = Topbar,
        PlayersScroll = PlayersScroll,
        ClaimedScroll = ClaimedScroll,
        BugTextBox = BugTextBox,
        SendBtn = SendBtn
    }
end

return HomePage
