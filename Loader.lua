--[[
    Antigravity UI Library - Loader
    โหลด library จาก GitHub ผ่าน loadstring
    
    วิธีใช้:
    local AntigravityUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Loader.lua"))()
]]

local BASE_URL = "https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/"

-- Load all modules
local Theme = loadstring(game:HttpGet(BASE_URL .. "Core/Theme.lua"))()
local Animation = loadstring(game:HttpGet(BASE_URL .. "Core/Animation.lua"))()
local Utility = loadstring(game:HttpGet(BASE_URL .. "Core/Utility.lua"))()
local ConfigManager = loadstring(game:HttpGet(BASE_URL .. "Config/ConfigManager.lua"))()

-- Load components
local Components = {
    Button = loadstring(game:HttpGet(BASE_URL .. "Components/Button.lua"))(),
    Toggle = loadstring(game:HttpGet(BASE_URL .. "Components/Toggle.lua"))(),
    Textbox = loadstring(game:HttpGet(BASE_URL .. "Components/Textbox.lua"))(),
    Dropdown = loadstring(game:HttpGet(BASE_URL .. "Components/Dropdown.lua"))(),
    Slider = loadstring(game:HttpGet(BASE_URL .. "Components/Slider.lua"))(),
    ColorPicker = loadstring(game:HttpGet(BASE_URL .. "Components/ColorPicker.lua"))(),
    Keybind = loadstring(game:HttpGet(BASE_URL .. "Components/Keybind.lua"))(),
    Label = loadstring(game:HttpGet(BASE_URL .. "Components/Label.lua"))(),
    Section = loadstring(game:HttpGet(BASE_URL .. "Components/Section.lua"))()
}

-- ================================================================
-- MAIN LIBRARY
-- ================================================================

local AntigravityUI = {}
AntigravityUI.__index = AntigravityUI
AntigravityUI.Version = "1.0.0"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

AntigravityUI.Windows = {}

function AntigravityUI:GetParent()
    local success, gui = pcall(function()
        local existing = CoreGui:FindFirstChild("AntigravityUI")
        if existing then return existing end
        local newGui = Instance.new("ScreenGui")
        newGui.Name = "AntigravityUI"
        newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        newGui.ResetOnSpawn = false
        newGui.Parent = CoreGui
        return newGui
    end)
    
    if success and gui then
        return gui
    else
        local player = Players.LocalPlayer
        if player then
            local playerGui = player:WaitForChild("PlayerGui")
            local existing = playerGui:FindFirstChild("AntigravityUI")
            if existing then return existing end
            
            local newGui = Instance.new("ScreenGui")
            newGui.Name = "AntigravityUI"
            newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            newGui.ResetOnSpawn = false
            newGui.Parent = playerGui
            return newGui
        end
    end
    return nil
end

function AntigravityUI:CreateWindow(options)
    options = options or {}
    
    local Window = {}
    Window.Title = options.Title or "Antigravity UI"
    Window.Size = options.Size or UDim2.new(0, 500, 0, 400)
    Window.Theme = options.Theme or "Dark"
    Window.GameName = options.GameName or options.Title or "Default"  -- ชื่อ Game สำหรับ Config
    Window.ConfigName = options.ConfigName or "Config"  -- ชื่อไฟล์ config
    Window.AutoSave = options.AutoSave or false
    Window.AutoLoad = options.AutoLoad or false
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    Window.Visible = true
    
    if Theme.Presets and Theme.Presets[Window.Theme] then
        Theme.Current = Theme.Presets[Window.Theme]
    end
    
    -- CreateHandler(gameName, configName, autoSave, autoLoad)
    Window.ConfigHandler = ConfigManager:CreateHandler(Window.GameName, Window.ConfigName, Window.AutoSave, Window.AutoLoad)
    
    local parent = self:GetParent()
    if not parent then
        warn("[AntigravityUI] Failed to get parent")
        return nil
    end
    
    -- Main container
    Window.Container = Instance.new("Frame")
    Window.Container.Name = "Window_" .. Window.Title
    Window.Container.Size = Window.Size
    Window.Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Container.BackgroundColor3 = Theme.Current.Background
    Window.Container.BorderSizePixel = 0
    Window.Container.ClipsDescendants = true
    Window.Container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = Window.Container
    
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 1
    shadow.Transparency = 0.5
    shadow.Parent = Window.Container
    
    -- Title bar
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Name = "TitleBar"
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    Window.TitleBar.BackgroundColor3 = Theme.Current.Secondary
    Window.TitleBar.BorderSizePixel = 0
    Window.TitleBar.Parent = Window.Container
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = Window.TitleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 15)
    titleFix.Position = UDim2.new(0, 0, 1, -15)
    titleFix.BackgroundColor3 = Theme.Current.Secondary
    titleFix.BorderSizePixel = 0
    titleFix.Parent = Window.TitleBar
    
    Window.TitleLabel = Instance.new("TextLabel")
    Window.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    Window.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    Window.TitleLabel.BackgroundTransparency = 1
    Window.TitleLabel.Text = Window.Title
    Window.TitleLabel.TextColor3 = Theme.Current.Text
    Window.TitleLabel.TextSize = 16
    Window.TitleLabel.Font = Enum.Font.GothamBold
    Window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    Window.TitleLabel.Parent = Window.TitleBar
    
    -- Controls
    local controlsContainer = Instance.new("Frame")
    controlsContainer.Size = UDim2.new(0, 70, 1, 0)
    controlsContainer.Position = UDim2.new(1, -80, 0, 0)
    controlsContainer.BackgroundTransparency = 1
    controlsContainer.Parent = Window.TitleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlsLayout.Padding = UDim.new(0, 5)
    controlsLayout.Parent = controlsContainer
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.BackgroundColor3 = Theme.Current.Tertiary
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Theme.Current.Text
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = controlsContainer
    
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Current.Text
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = controlsContainer
    
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    Animation:CreateHoverEffect(minimizeBtn, Theme.Current.Accent, Theme.Current.Tertiary)
    Animation:CreateHoverEffect(closeBtn, Color3.fromRGB(220, 100, 100), Color3.fromRGB(200, 80, 80))
    
    -- Tab sidebar
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Size = UDim2.new(0, 140, 1, -50)
    Window.TabContainer.Position = UDim2.new(0, 5, 0, 45)
    Window.TabContainer.BackgroundColor3 = Theme.Current.Secondary
    Window.TabContainer.BackgroundTransparency = 0.5
    Window.TabContainer.BorderSizePixel = 0
    Window.TabContainer.Parent = Window.Container
    
    Instance.new("UICorner", Window.TabContainer).CornerRadius = UDim.new(0, 8)
    
    Window.TabScroll = Instance.new("ScrollingFrame")
    Window.TabScroll.Size = UDim2.new(1, -10, 1, -10)
    Window.TabScroll.Position = UDim2.new(0, 5, 0, 5)
    Window.TabScroll.BackgroundTransparency = 1
    Window.TabScroll.BorderSizePixel = 0
    Window.TabScroll.ScrollBarThickness = 2
    Window.TabScroll.ScrollBarImageColor3 = Theme.Current.Accent
    Window.TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.TabScroll.Parent = Window.TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = Window.TabScroll
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Window.TabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content area
    Window.ContentContainer = Instance.new("Frame")
    Window.ContentContainer.Size = UDim2.new(1, -160, 1, -55)
    Window.ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    Window.ContentContainer.BackgroundTransparency = 1
    Window.ContentContainer.ClipsDescendants = true
    Window.ContentContainer.Parent = Window.Container
    
    Utility:MakeDraggable(Window.Container, Window.TitleBar)
    
    -- Floating Icon
    if options.FloatingIcon and options.FloatingIcon.Enabled ~= false then
        local iconPosition = options.FloatingIcon.Position or UDim2.new(0, 20, 0.5, 0)
        
        Window.FloatingIcon = Instance.new("ImageButton")
        Window.FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
        Window.FloatingIcon.Position = iconPosition
        Window.FloatingIcon.AnchorPoint = Vector2.new(0, 0.5)
        Window.FloatingIcon.BackgroundColor3 = Theme.Current.Background
        Window.FloatingIcon.BorderSizePixel = 0
        Window.FloatingIcon.Image = options.FloatingIcon.Image or "rbxassetid://7733960981"
        Window.FloatingIcon.ImageColor3 = Theme.Current.Accent
        Window.FloatingIcon.Visible = false
        Window.FloatingIcon.Parent = parent
        
        Instance.new("UICorner", Window.FloatingIcon).CornerRadius = UDim.new(0, 10)
        local iconStroke = Instance.new("UIStroke", Window.FloatingIcon)
        iconStroke.Color = Theme.Current.Accent
        iconStroke.Thickness = 2
        
        Utility:MakeDraggable(Window.FloatingIcon)
        
        Window.FloatingIcon.MouseButton1Click:Connect(function()
            Window:Toggle()
        end)
    end
    
    -- Window methods
    function Window:Minimize()
        Window.Minimized = true
        Window.Container.Visible = false
        if Window.FloatingIcon then Window.FloatingIcon.Visible = true end
    end
    
    function Window:Maximize()
        Window.Minimized = false
        Window.Container.Visible = true
        if Window.FloatingIcon then Window.FloatingIcon.Visible = false end
    end
    
    function Window:Toggle()
        if Window.Minimized then Window:Maximize() else Window:Minimize() end
    end
    
    function Window:Hide()
        Window.Visible = false
        Window.Container.Visible = false
        if Window.FloatingIcon then Window.FloatingIcon.Visible = false end
    end
    
    function Window:Show()
        Window.Visible = true
        if Window.Minimized then
            if Window.FloatingIcon then Window.FloatingIcon.Visible = true end
        else
            Window.Container.Visible = true
        end
    end
    
    function Window:Destroy()
        Window.Container:Destroy()
        if Window.FloatingIcon then Window.FloatingIcon:Destroy() end
    end
    
    function Window:SetTheme(themeName)
        if Theme.Presets and Theme.Presets[themeName] then
            Theme.Current = Theme.Presets[themeName]
        end
    end
    
    function Window:SaveConfig() return Window.ConfigHandler:Save() end
    function Window:LoadConfig() return Window.ConfigHandler:Load() end
    function Window:DeleteConfig() return Window.ConfigHandler:Delete() end
    
    -- Create tab
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        
        local Tab = {}
        Tab.Name = tabOptions.Name or "Tab"
        Tab.Elements = {}
        Tab.LayoutOrder = #Window.Tabs + 1
        
        Tab.Button = Instance.new("TextButton")
        Tab.Button.Size = UDim2.new(1, 0, 0, 35)
        Tab.Button.BackgroundColor3 = Theme.Current.Tertiary
        Tab.Button.BackgroundTransparency = 1
        Tab.Button.BorderSizePixel = 0
        Tab.Button.Text = Tab.Name
        Tab.Button.TextColor3 = Theme.Current.SubText
        Tab.Button.TextSize = 13
        Tab.Button.Font = Enum.Font.GothamMedium
        Tab.Button.AutoButtonColor = false
        Tab.Button.LayoutOrder = Tab.LayoutOrder
        Tab.Button.Parent = Window.TabScroll
        
        Instance.new("UICorner", Tab.Button).CornerRadius = UDim.new(0, 6)
        
        Tab.Page = Instance.new("ScrollingFrame")
        Tab.Page.Name = "Page_" .. Tab.Name
        Tab.Page.Size = UDim2.new(1, 0, 1, 0)
        Tab.Page.BackgroundTransparency = 1
        Tab.Page.BorderSizePixel = 0
        Tab.Page.ScrollBarThickness = 3
        Tab.Page.ScrollBarImageColor3 = Theme.Current.Accent
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.Page.Visible = false
        Tab.Page.Parent = Window.ContentContainer
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.FillDirection = Enum.FillDirection.Vertical
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.Parent = Tab.Page
        
        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 5)
        pagePadding.PaddingBottom = UDim.new(0, 5)
        pagePadding.PaddingLeft = UDim.new(0, 5)
        pagePadding.PaddingRight = UDim.new(0, 5)
        pagePadding.Parent = Tab.Page
        
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.Page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        function Tab:Select()
            for _, tab in ipairs(Window.Tabs) do
                tab.Button.BackgroundTransparency = 1
                tab.Button.TextColor3 = Theme.Current.SubText
                tab.Page.Visible = false
            end
            Tab.Button.BackgroundTransparency = 0
            Tab.Button.BackgroundColor3 = Theme.Current.Accent
            Tab.Button.TextColor3 = Theme.Current.Text
            Tab.Page.Visible = true
            Window.ActiveTab = Tab
        end
        
        Tab.Button.MouseButton1Click:Connect(function() Tab:Select() end)
        
        Tab.Button.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Animation:Play(Tab.Button, {BackgroundTransparency = 0.5}, 0.15)
            end
        end)
        
        Tab.Button.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Animation:Play(Tab.Button, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then Tab:Select() end
        
        -- Add component methods
        function Tab:AddButton(opts) return Components.Button.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddToggle(opts) return Components.Toggle.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddTextbox(opts) return Components.Textbox.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddDropdown(opts) return Components.Dropdown.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddSlider(opts) return Components.Slider.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddColorPicker(opts) return Components.ColorPicker.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddKeybind(opts) return Components.Keybind.new(Tab, opts, Theme, Animation, Window.ConfigHandler) end
        function Tab:AddLabel(opts) return Components.Label.new(Tab, opts, Theme, Animation) end
        function Tab:AddSection(opts) return Components.Section.new(Tab, opts, Theme, Animation) end
        
        return Tab
    end
    
    minimizeBtn.MouseButton1Click:Connect(function() Window:Minimize() end)
    closeBtn.MouseButton1Click:Connect(function() Window:Destroy() end)
    
    table.insert(AntigravityUI.Windows, Window)
    
    Animation:ScaleIn(Window.Container, 0.4)
    Animation:Play(Window.Container, {BackgroundTransparency = 0}, 0.3)
    
    return Window
end

-- Notification system
function AntigravityUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 3
    local notifType = options.Type or "Info"
    
    local parent = self:GetParent()
    if not parent then return end
    
    local notifContainer = parent:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 300, 1, 0)
        notifContainer.Position = UDim2.new(1, -310, 0, 10)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = parent
        
        local notifLayout = Instance.new("UIListLayout")
        notifLayout.FillDirection = Enum.FillDirection.Vertical
        notifLayout.Padding = UDim.new(0, 10)
        notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        notifLayout.Parent = notifContainer
    end
    
    local typeColors = {
        Info = Theme.Current.Accent,
        Success = Color3.fromRGB(100, 200, 100),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 100)
    }
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.BackgroundColor3 = Theme.Current.Background
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = notifContainer
    
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.BackgroundColor3 = typeColors[notifType] or Theme.Current.Accent
    indicator.BorderSizePixel = 0
    indicator.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Current.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 30)
    messageLabel.Position = UDim2.new(0, 15, 0, 32)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Theme.Current.SubText
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notif
    
    notif.Position = UDim2.new(1, 50, 0, 0)
    Animation:Play(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    
    task.delay(duration, function()
        Animation:Play(notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
    
    return notif
end

function AntigravityUI:SetTheme(themeName)
    if Theme.Set then Theme:Set(themeName) end
end

function AntigravityUI:DestroyAll()
    for _, window in ipairs(self.Windows) do
        if window.Destroy then window:Destroy() end
    end
    self.Windows = {}
end

return AntigravityUI
