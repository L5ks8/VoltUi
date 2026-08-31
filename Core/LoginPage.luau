local Utils = script.Parent.Parent.Utils
local Tween = require(Utils.Tween)
local Api = require(Utils.Api)
local Notifications = require(script.Parent.Notifications)

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

return LoginPage
