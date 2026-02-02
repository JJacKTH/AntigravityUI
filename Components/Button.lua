--[[
    Antigravity UI Library - Button Component
]]

local Button = {}
Button.__index = Button

function Button.new(tab, options, Theme, Animation, ConfigHandler)
    options = options or {}
    
    local self = setmetatable({}, Button)
    self.Name = options.Name or "Button"
    self.Callback = options.Callback or function() end
    self.Tab = tab
    
    -- Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Button_" .. self.Name
    self.Container.Size = UDim2.new(1, -10, 0, 35)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.Parent = tab.Page
    
    -- Button element
    self.Element = Instance.new("TextButton")
    self.Element.Name = "ButtonElement"
    self.Element.Size = UDim2.new(1, 0, 1, 0)
    self.Element.BackgroundColor3 = Theme.Current.Tertiary
    self.Element.BackgroundTransparency = 0
    self.Element.BorderSizePixel = 0
    self.Element.Text = self.Name
    self.Element.TextColor3 = Theme.Current.Text
    self.Element.TextSize = 14
    self.Element.Font = Enum.Font.GothamMedium
    self.Element.AutoButtonColor = false
    self.Element.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.Element
    
    -- Hover effect
    if Animation then
        Animation:CreateHoverEffect(self.Element, Theme.Current.Accent, Theme.Current.Tertiary)
        Animation:CreateRipple(self.Element)
    else
        self.Element.MouseEnter:Connect(function()
            self.Element.BackgroundColor3 = Theme.Current.Accent
        end)
        self.Element.MouseLeave:Connect(function()
            self.Element.BackgroundColor3 = Theme.Current.Tertiary
        end)
    end
    
    -- Click event
    self.Element.MouseButton1Click:Connect(function()
        self.Callback()
    end)
    
    -- Methods
    function self:SetText(text)
        self.Element.Text = text
    end
    
    function self:SetCallback(callback)
        self.Callback = callback
    end
    
    function self:Destroy()
        self.Container:Destroy()
    end
    
    return self
end

return Button
