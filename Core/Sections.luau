local Utils = script.Parent.Parent.Utils
local Components = script.Parent.Parent.Components
local ButtonComponent = require(Components.Button)
local ToggleComponent = require(Components.Toggle)

local Sections = {}

function Sections.CreateSection(TabContent, Maid, Title)
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
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        TitleLabel.Text = Title
        TitleLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
        
        local TitleFrame = Instance.new("Frame")
        TitleFrame.Name = "TitleFrame"
        TitleFrame.BackgroundTransparency = 1
        TitleFrame.Size = UDim2.new(1, 0, 0, 30)
        TitleFrame.Parent = SectionFrame
        
        TitleLabel.Parent = TitleFrame
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
    
    return SectionMethods
end

return Sections
