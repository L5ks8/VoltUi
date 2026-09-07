local Components = script.Parent.Parent.Components
local ButtonComponent = require(Components.Button)
local ToggleComponent = require(Components.Toggle)
local CheckboxComponent = require(Components.Checkbox)
local DropdownComponent = require(Components.Dropdown)
local SliderComponent = require(Components.Slider)
local InputComponent = require(Components.Input)
local LabelComponent = require(Components.Label)
local ParagraphComponent = require(Components.Paragraph)
local DividerComponent = require(Components.Divider)
local ColorPickerComponent = require(Components.ColorPicker)
local KeybindComponent = require(Components.Keybind)

local Sections = {}

function Sections.CreateSection(TabContent, Maid, Title, Description)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = Title or "Section"
    SectionFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    SectionFrame.BorderColor3 = Color3.new(0, 0, 0)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Size = UDim2.new(1, 0, 0, 0)
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    SectionFrame.ClipsDescendants = true
    SectionFrame.Parent = TabContent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = SectionFrame
    
    local SectionStroke = Instance.new("UIStroke")
    SectionStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
    SectionStroke.Color = Color3.fromRGB(48, 48, 48)
    SectionStroke.Parent = SectionFrame
    
    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 0)
    SectionLayout.Parent = SectionFrame
    
    local ElementCount = 0
    
    local function AddSeparator()
        if ElementCount > 0 then
            local Separator = Instance.new("Frame")
            Separator.Name = "Separator"
            Separator.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Separator.BorderSizePixel = 0
            Separator.Size = UDim2.new(1, 0, 0, 1)
            Separator.Parent = SectionFrame
        end
    end
    
    if Title and Title ~= "" then
        local TitleFrame = Instance.new("Frame")
        TitleFrame.Name = "TitleFrame"
        TitleFrame.BackgroundTransparency = 1
        TitleFrame.Size = UDim2.new(1, 0, 0, (Description and Description ~= "") and 45 or 30)
        TitleFrame.Parent = SectionFrame
        
        local TitleLayout = Instance.new("UIListLayout")
        TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TitleLayout.Padding = UDim.new(0, 2)
        TitleLayout.Parent = TitleFrame
        
        local TitlePadding = Instance.new("UIPadding")
        TitlePadding.PaddingTop = UDim.new(0, 8)
        TitlePadding.PaddingLeft = UDim.new(0, 10)
        TitlePadding.Parent = TitleFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, -20, 0, 16)
        TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        TitleLabel.Text = Title
        TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
        TitleLabel.Parent = TitleFrame
        
        if Description and Description ~= "" then
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Name = "Description"
            DescLabel.BackgroundTransparency = 1
            DescLabel.Size = UDim2.new(1, -20, 0, 14)
            DescLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            DescLabel.Text = Description
            DescLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
            DescLabel.TextSize = 12
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.TextYAlignment = Enum.TextYAlignment.Center
            DescLabel.Parent = TitleFrame
        end
        
        ElementCount = ElementCount + 1
    end
    
    local SectionMethods = {}
    
    function SectionMethods:CreateButton(Config)
        AddSeparator()
        local Element = ButtonComponent.Create(SectionFrame, Maid, Config)
        ElementCount = ElementCount + 1
        return Element
    end
    
    function SectionMethods:CreateToggle(Config, Flag)
        AddSeparator()
        local Element = ToggleComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateCheckbox(Config, Flag)
        AddSeparator()
        local Element = CheckboxComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateSlider(Config, Flag)
        AddSeparator()
        local Element = SliderComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateInput(Config, Flag)
        AddSeparator()
        local Element = InputComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end
    SectionMethods.CreateTextBox = SectionMethods.CreateInput
    
    function SectionMethods:CreateDropdown(Config, Flag)
        AddSeparator()
        local Element = DropdownComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateColorPicker(Config, Flag)
        AddSeparator()
        local Element = ColorPickerComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateKeybind(Config, Flag)
        AddSeparator()
        local Element = KeybindComponent.Create(SectionFrame, Maid, Config, Flag)
        ElementCount = ElementCount + 1
        return Element
    end
    SectionMethods.CreateBind = SectionMethods.CreateKeybind

    function SectionMethods:CreateLabel(Config)
        AddSeparator()
        local Element = LabelComponent.Create(SectionFrame, Maid, Config)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateParagraph(Config)
        AddSeparator()
        local Element = ParagraphComponent.Create(SectionFrame, Maid, Config)
        ElementCount = ElementCount + 1
        return Element
    end

    function SectionMethods:CreateDivider(Config)
        AddSeparator()
        local Element = DividerComponent.Create(SectionFrame, Maid, Config)
        ElementCount = ElementCount + 1
        return Element
    end
    
    SectionMethods.AddButton = SectionMethods.CreateButton
    SectionMethods.AddToggle = SectionMethods.CreateToggle
    SectionMethods.AddCheckbox = SectionMethods.CreateCheckbox
    SectionMethods.AddSlider = SectionMethods.CreateSlider
    SectionMethods.AddInput = SectionMethods.CreateInput
    SectionMethods.AddTextBox = SectionMethods.CreateInput
    SectionMethods.AddDropdown = SectionMethods.CreateDropdown
    SectionMethods.AddColorPicker = SectionMethods.CreateColorPicker
    SectionMethods.AddKeybind = SectionMethods.CreateKeybind
    SectionMethods.AddBind = SectionMethods.CreateKeybind
    SectionMethods.AddLabel = SectionMethods.CreateLabel
    SectionMethods.AddParagraph = SectionMethods.CreateParagraph
    SectionMethods.AddDivider = SectionMethods.CreateDivider
    
    return SectionMethods
end

return Sections
