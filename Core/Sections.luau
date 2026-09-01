local Utils = script.Parent.Parent.Utils
local Components = script.Parent.Parent.Components
local ButtonComponent = require(Components.Button)
local ToggleComponent = require(Components.Toggle)
local DropdownComponent = require(Components.Dropdown)

local Sections = {}

function Sections.CreateSection(TabContent, Maid, Title, Description)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = Title or "Section"
    SectionFrame.BackgroundColor3 = Color3.new(0.11, 0.11, 0.11)
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
    SectionStroke.Color = Color3.new(0.216, 0.216, 0.216)
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
            Separator.BackgroundColor3 = Color3.new(0.216, 0.216, 0.216)
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
        TitleLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
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
            DescLabel.TextColor3 = Color3.new(0.6, 0.6, 0.6)
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
    
    function SectionMethods:CreateToggle(Config)
        AddSeparator()
        local Element = ToggleComponent.Create(SectionFrame, Maid, Config)
        ElementCount = ElementCount + 1
        return Element
    end
    
    function SectionMethods:CreateDropdown(Config)
        AddSeparator()
        local Element = DropdownComponent.Create(SectionFrame, Maid, Config)
        ElementCount = ElementCount + 1
        return Element
    end
    
    return SectionMethods
end

return Sections
