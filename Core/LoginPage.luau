local Utils = script.Parent.Parent.Utils
local Topbar = require(script.Parent.Topbar)
local Tween = require(Utils.Tween)
local Utility = require(Utils.Utility)
local Maid = require(Utils.Maid)
local Api = require(Utils.Api)
local Notifications = require(script.Parent.Notifications)

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
    
    Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 8)
    local PageStroke = Instance.new("UIStroke", Page)
    PageStroke.Color = Color3.new(0.15, 0.15, 0.15)
    
    local maid = Maid.new()
    
    local TopbarElements = Topbar.Create(Page, {Title = "Sign In"}, maid)
    
    maid:GiveTask(TopbarElements.CloseButton.MouseButton1Click:Connect(function()
        Page:Destroy()
        maid:Destroy()
    end))
    
    local ContentFrame = Instance.new("Frame", Page)
    ContentFrame.AnchorPoint = Vector2.new(0.5, 0)
    ContentFrame.Position = UDim2.new(0.5, 0, 0, 30)
    ContentFrame.Size = UDim2.new(0, 450, 1, -30)
    ContentFrame.BackgroundTransparency = 1
    
    local Layout = Instance.new("UIListLayout", ContentFrame)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 10)
    
    local LogoContainer = Instance.new("Frame", ContentFrame)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Size = UDim2.new(0, 100, 0, 50)
    LogoContainer.LayoutOrder = 1
    
    local LogoLayout = Instance.new("UIListLayout", LogoContainer)
    LogoLayout.FillDirection = Enum.FillDirection.Horizontal
    LogoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LogoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    LogoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogoLayout.Padding = UDim.new(0, 8)

    local LogoImg = Instance.new("ImageLabel", LogoContainer)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Size = UDim2.new(0, 32, 0, 32)
    LogoImg.Image = "rbxassetid://71942076965693"
    LogoImg.LayoutOrder = 1

    local LogoText = Instance.new("TextLabel", LogoContainer)
    LogoText.BackgroundTransparency = 1
    LogoText.Size = UDim2.new(0, 50, 0, 50)
    LogoText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LogoText.Text = "Volt"
    LogoText.TextColor3 = Color3.new(1, 1, 1)
    LogoText.TextSize = 28
    LogoText.LayoutOrder = 2
    LogoText.TextXAlignment = Enum.TextXAlignment.Left
    
    local Title = Instance.new("TextLabel", ContentFrame)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Title.Text = "Welcome to Volt"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 24
    Title.LayoutOrder = 2
    
    local Subtitle = Instance.new("TextLabel", ContentFrame)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    Subtitle.Text = "Sign in to access your Lua development environment"
    Subtitle.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    Subtitle.TextSize = 13
    Subtitle.LayoutOrder = 3
    
    local Spacer = Instance.new("Frame", ContentFrame)
    Spacer.BackgroundTransparency = 1
    Spacer.Size = UDim2.new(1, 0, 0, 10)
    Spacer.LayoutOrder = 4
    
    local Box = Instance.new("Frame", ContentFrame)
    Box.BackgroundColor3 = Color3.new(0.09, 0.09, 0.09)
    Box.Size = UDim2.new(0, 400, 0, 0)
    Box.AutomaticSize = Enum.AutomaticSize.Y
    Box.LayoutOrder = 5
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    local BoxStroke = Instance.new("UIStroke", Box)
    BoxStroke.Color = Color3.new(0.15, 0.15, 0.15)
    
    local BoxLayout = Instance.new("UIListLayout", Box)
    BoxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BoxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BoxLayout.Padding = UDim.new(0, 15)
    
    local BoxPadding = Instance.new("UIPadding", Box)
    BoxPadding.PaddingTop = UDim.new(0, 25)
    BoxPadding.PaddingBottom = UDim.new(0, 25)
    
    local function CreateInput(name, placeholder, isPassword, iconId)
        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, -50, 0, 65)
        
        local label = Instance.new("TextLabel", frame)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 20)
        label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        label.Text = name
        label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local boxBg = Instance.new("Frame", frame)
        boxBg.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
        boxBg.Size = UDim2.new(1, 0, 0, 40)
        boxBg.Position = UDim2.new(0, 0, 0, 25)
        Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6)
        local boxStroke = Instance.new("UIStroke", boxBg)
        boxStroke.Color = Color3.new(0.15, 0.15, 0.15)
        
        if iconId then
            local icon = Instance.new("ImageLabel", boxBg)
            icon.BackgroundTransparency = 1
            icon.Size = UDim2.new(0, 16, 0, 16)
            icon.Position = UDim2.new(0, 12, 0.5, -8)
            icon.Image = iconId
            icon.ImageColor3 = Color3.new(0.6, 0.6, 0.6)
        end
        
        local box = Instance.new("TextBox", boxBg)
        box.BackgroundTransparency = 1
        box.Size = UDim2.new(1, iconId and -45 or -25, 1, 0)
        box.Position = UDim2.new(0, iconId and 35 or 12, 0, 0)
        box.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        box.PlaceholderText = placeholder
        box.PlaceholderColor3 = Color3.new(0.4, 0.4, 0.4)
        box.Text = ""
        box.TextColor3 = Color3.new(1, 1, 1)
        box.TextSize = 13
        box.TextXAlignment = Enum.TextXAlignment.Left
        
        if isPassword then
            box.ClearTextOnFocus = false
        end
        
        return frame, box
    end
    
    local userFrame, userBox = CreateInput("Username", "Enter your username", false, "rbxassetid://134568818132029")
    local passFrame, passBox = CreateInput("Password", "Enter your password", true, "rbxassetid://113646711739432")
    local keyFrame, keyBox = CreateInput("License Key", "XXXX-XXXX-XXXX-XXXX", false, "rbxassetid://134568818132029")
    local codeFrame, codeBox = CreateInput("Reset Code", "Enter 6-digit code", false, "rbxassetid://134568818132029")
    local newPassFrame, newPassBox = CreateInput("New Password", "Enter new password", true, "rbxassetid://113646711739432")
    
    userFrame.Parent = Box
    passFrame.Parent = Box
    keyFrame.Parent = Box
    codeFrame.Parent = Box
    newPassFrame.Parent = Box
    
    userFrame.LayoutOrder = 1
    keyFrame.LayoutOrder = 2
    passFrame.LayoutOrder = 3
    codeFrame.LayoutOrder = 4
    newPassFrame.LayoutOrder = 5
    
    local ActionBtn = Instance.new("TextButton", Box)
    ActionBtn.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
    ActionBtn.Size = UDim2.new(1, -50, 0, 42)
    ActionBtn.LayoutOrder = 10
    ActionBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ActionBtn.Text = "Sign In"
    ActionBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ActionBtn.TextSize = 14
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)
    local ActionStroke = Instance.new("UIStroke", ActionBtn)
    ActionStroke.Color = Color3.new(0.25, 0.25, 0.25)
    
    local ForgotBtn = Instance.new("TextButton", Box)
    ForgotBtn.BackgroundTransparency = 1
    ForgotBtn.Size = UDim2.new(1, 0, 0, 20)
    ForgotBtn.LayoutOrder = 11
    ForgotBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ForgotBtn.Text = "Forgot your password?"
    ForgotBtn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    ForgotBtn.TextSize = 13
    
    local Divider = Instance.new("Frame", Box)
    Divider.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    Divider.Size = UDim2.new(1, -50, 0, 1)
    Divider.LayoutOrder = 12
    Divider.BorderSizePixel = 0
    
    local SwitchBtn = Instance.new("TextButton", Box)
    SwitchBtn.BackgroundTransparency = 1
    SwitchBtn.Size = UDim2.new(1, 0, 0, 20)
    SwitchBtn.LayoutOrder = 13
    SwitchBtn.RichText = true
    SwitchBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    SwitchBtn.Text = "Don't have an account? <b>Create one here</b>"
    SwitchBtn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    SwitchBtn.TextSize = 13
    
    local UIState = "Login"
    
    local function UpdateState(newState)
        UIState = newState
        userFrame.Visible = false
        passFrame.Visible = false
        keyFrame.Visible = false
        codeFrame.Visible = false
        newPassFrame.Visible = false
        
        ForgotBtn.Visible = false
        Divider.Visible = false
        SwitchBtn.Visible = false
        
        if UIState == "Login" then
            Title.Text = "Welcome to Volt"
            Subtitle.Text = "Sign in to access your Lua development environment"
            ActionBtn.Text = "Sign In"
            userFrame.Visible = true
            passFrame.Visible = true
            ForgotBtn.Visible = true
            Divider.Visible = true
            SwitchBtn.Visible = true
            SwitchBtn.Text = "Don't have an account? <b>Create one here</b>"
            TopbarElements.Instance.Version.Text.Text = "Sign In"
            
        elseif UIState == "Register" then
            Title.Text = "Join Volt"
            Subtitle.Text = "Create your account to start Lua development"
            ActionBtn.Text = "Create Account"
            userFrame.Visible = true
            keyFrame.Visible = true
            passFrame.Visible = true
            Divider.Visible = true
            SwitchBtn.Visible = true
            SwitchBtn.Text = "Already have an account? <b>Sign in here</b>"
            TopbarElements.Instance.Version.Text.Text = "Register"
            
        elseif UIState == "Forgot" then
            Title.Text = "Reset Password"
            Subtitle.Text = "Enter your username and we'll send a code to your Discord"
            ActionBtn.Text = "Send Reset Code"
            userFrame.Visible = true
            SwitchBtn.Visible = true
            SwitchBtn.Text = "← <b>Back to Login</b>"
            TopbarElements.Instance.Version.Text.Text = "Reset Password"
            
        elseif UIState == "Reset" then
            Title.Text = "Enter Code"
            Subtitle.Text = "Enter the 6-digit code sent to your Discord DM"
            ActionBtn.Text = "Reset Password"
            codeFrame.Visible = true
            newPassFrame.Visible = true
            SwitchBtn.Visible = true
            SwitchBtn.Text = "← <b>Back to Login</b>"
            TopbarElements.Instance.Version.Text.Text = "Enter Code"
        end
    end
    
    UpdateState("Login")
    
    ForgotBtn.MouseButton1Click:Connect(function()
        UpdateState("Forgot")
    end)
    
    SwitchBtn.MouseButton1Click:Connect(function()
        if UIState == "Login" then
            UpdateState("Register")
        elseif UIState == "Register" then
            UpdateState("Login")
        elseif UIState == "Forgot" or UIState == "Reset" then
            UpdateState("Login")
        end
    end)
    
    ActionBtn.MouseButton1Click:Connect(function()
        local prevText = ActionBtn.Text
        ActionBtn.Text = "Please wait..."
        
        task.spawn(function()
            if UIState == "Login" then
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
                
            elseif UIState == "Register" then
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
                
            elseif UIState == "Forgot" then
                local success, msg = Api.ForgotPassword(userBox.Text)
                if success then
                    Notifications.Notify({ Title = "Code Sent", Content = msg, Type = "Success" })
                    UpdateState("Reset")
                else
                    Notifications.Notify({ Title = "Failed", Content = msg, Type = "Error" })
                    ActionBtn.Text = prevText
                end
                
            elseif UIState == "Reset" then
                local success, msg = Api.ResetPassword(userBox.Text, codeBox.Text, newPassBox.Text)
                if success then
                    Notifications.Notify({ Title = "Password Reset", Content = msg, Type = "Success" })
                    UpdateState("Login")
                else
                    Notifications.Notify({ Title = "Reset Failed", Content = msg, Type = "Error" })
                    ActionBtn.Text = prevText
                end
            end
        end)
    end)
    
    return Page
end

return LoginPage
