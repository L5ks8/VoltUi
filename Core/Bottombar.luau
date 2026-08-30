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

return Bottombar
