local Notifications = require(script.Parent.Notifications)
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
    
    local Tween = require(script.Parent.Parent.Utils.Tween)
    Maid:GiveTask(ReturnButton.MouseEnter:Connect(function()
        Tween(ReturnButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9})
    end))
    Maid:GiveTask(ReturnButton.MouseLeave:Connect(function()
        Tween(ReturnButton, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    end))

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
            -- Username
            if data and data.username then
                Username.Text = data.username
            else
                local success, name = pcall(function() return game:GetService("Players").LocalPlayer.Name end)
                Username.Text = success and name or "Username"
            end
            
            -- Hidden ID
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
            
            -- Member since
            if data and data.createdAt then
                local dateStr = string.match(tostring(data.createdAt), "^(%d+%-%d+%-%d+)") or tostring(data.createdAt)
                MemberSince.Text = "Member since " .. dateStr
            else
                MemberSince.Text = "Member since Jul 24, 2026"
            end
            
            -- Subscription
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
            
            -- Claimed Keys Count
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
            
            local Tween = require(script.Parent.Parent.Utils.Tween)
            
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
            
            -- Profile image
            local success, userId = pcall(function() return game:GetService("Players").LocalPlayer.UserId end)
            if success and userId then
                ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"
            end
        end
    return PageData
end

return AccountPage
