--[[
    Antigravity UI Library - Label Component
]]

local Label = {}
Label.__index = Label

function Label.new(tab, options, Theme, Animation)
    options = options or {}
    
    local self = setmetatable({}, Label)
    self.Name = options.Name or "Label"
    self.Text = options.Text or self.Name
    self.Tab = tab
    
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Label_" .. self.Name
    self.Container.Size = UDim2.new(1, -10, 0, 25)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.Parent = tab.Page
    
    -- Label text
    self.Element = Instance.new("TextLabel")
    self.Element.Name = "Text"
    self.Element.Size = UDim2.new(1, -10, 1, 0)
    self.Element.Position = UDim2.new(0, 5, 0, 0)
    self.Element.BackgroundTransparency = 1
    self.Element.Text = self.Text
    self.Element.TextColor3 = Theme.Current.SubText
    self.Element.TextSize = 13
    self.Element.Font = Enum.Font.Gotham
    self.Element.TextXAlignment = Enum.TextXAlignment.Left
    self.Element.TextWrapped = true
    self.Element.Parent = self.Container
    
    -- Methods
    function self:Set(text)
        self.Text = text
        self.Element.Text = text
    end
    
    function self:Get()
        return self.Text
    end
    
    function self:Destroy()
        self.Container:Destroy()
    end
    
    return self
end

return Label
