--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           ANTIGRAVITY UI LIBRARY - EXAMPLE USAGE              ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    วิธีใช้งาน Antigravity UI Library
    รันสคริปต์นี้เพื่อดูตัวอย่างการทำงานของทุก Components
]]

-- ================================================================
-- LOAD LIBRARY
-- ================================================================
-- วิธีที่ 1: Load จาก GitHub (สำหรับ Executor)
local AntigravityUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Main.lua"))()

-- วิธีที่ 2: Require จาก ModuleScript (สำหรับ Roblox Studio)
-- local AntigravityUI = require(script.Parent.Main)

-- ================================================================
-- CREATE WINDOW
-- ================================================================
local Window = AntigravityUI:CreateWindow({
    Title = "🌌 Antigravity Hub",
    Size = UDim2.new(0, 550, 0, 450),
    Theme = "Dark", -- Dark, Light, PastelBlue, PastelGreen
    ConfigName = "ExampleConfig",
    AutoSave = true,
    AutoLoad = true,
    FloatingIcon = {
        Enabled = true,
        Position = UDim2.new(0, 20, 0.5, 0)
    }
})

-- ================================================================
-- TAB: MAIN
-- ================================================================
local MainTab = Window:CreateTab({
    Name = "🏠 Main",
    Icon = ""
})

-- Label
MainTab:AddLabel({
    Name = "Info",
    Text = "Welcome to Antigravity UI Library v1.0!"
})

-- Button
MainTab:AddButton({
    Name = "🎉 Click Me!",
    Callback = function()
        AntigravityUI:Notify({
            Title = "Button Clicked!",
            Message = "You pressed the button successfully.",
            Type = "Success",
            Duration = 3
        })
    end
})

-- Toggle
MainTab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Flag = "FeatureToggle", -- สำหรับ Auto Save
    Callback = function(value)
        print("Feature:", value and "Enabled" or "Disabled")
    end
})

-- Slider
MainTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Suffix = " studs/s",
    Flag = "WalkSpeed",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

-- ================================================================
-- TAB: PLAYER
-- ================================================================
local PlayerTab = Window:CreateTab({
    Name = "👤 Player",
    Icon = ""
})

-- Textbox
PlayerTab:AddTextbox({
    Name = "Player Name",
    Placeholder = "Enter player name...",
    Default = "",
    Flag = "TargetPlayer",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Searching for:", text)
        end
    end
})

-- Dropdown (Single Select)
local players = {}
for _, player in ipairs(game.Players:GetPlayers()) do
    table.insert(players, player.Name)
end

local PlayerDropdown = PlayerTab:AddDropdown({
    Name = "Select Player",
    Options = players,
    Searchable = true, -- พิมพ์ค้นหาได้!
    Multi = false,
    Flag = "SelectedPlayer",
    Callback = function(selected)
        print("Selected player:", selected)
    end
})

-- Update player list when players join/leave
game.Players.PlayerAdded:Connect(function(player)
    local newList = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        table.insert(newList, p.Name)
    end
    PlayerDropdown:Refresh(newList)
end)

game.Players.PlayerRemoving:Connect(function()
    local newList = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        table.insert(newList, p.Name)
    end
    PlayerDropdown:Refresh(newList)
end)

-- Dropdown (Multi Select)
PlayerTab:AddDropdown({
    Name = "Select Teams",
    Options = {"Red", "Blue", "Green", "Yellow", "Neutral"},
    Searchable = true,
    Multi = true, -- เลือกหลายตัวได้
    Default = {"Neutral"},
    Flag = "SelectedTeams",
    Callback = function(selected)
        print("Selected teams:", table.concat(selected, ", "))
    end
})

-- ================================================================
-- TAB: VISUALS
-- ================================================================
local VisualsTab = Window:CreateTab({
    Name = "👁️ Visuals",
    Icon = ""
})

-- Toggle with Keybind
VisualsTab:AddToggle({
    Name = "ESP Enabled",
    Default = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        print("ESP:", value and "ON" or "OFF")
    end
})

-- Color Picker
VisualsTab:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Callback = function(color)
        print("ESP Color:", color)
    end
})

-- Another Color Picker
VisualsTab:AddColorPicker({
    Name = "Chams Color",
    Default = Color3.fromRGB(0, 255, 0),
    Flag = "ChamsColor",
    Callback = function(color)
        print("Chams Color:", color)
    end
})

-- Slider for Transparency
VisualsTab:AddSlider({
    Name = "ESP Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Increment = 0.1,
    Flag = "ESPTransparency",
    Callback = function(value)
        print("ESP Transparency:", value)
    end
})

-- ================================================================
-- TAB: SETTINGS
-- ================================================================
local SettingsTab = Window:CreateTab({
    Name = "⚙️ Settings",
    Icon = ""
})

-- Keybind
SettingsTab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Flag = "ToggleUIKey",
    Callback = function()
        Window:Toggle()
    end,
    ChangedCallback = function(newKey)
        print("Toggle key changed to:", newKey.Name)
    end
})

-- Theme Dropdown
SettingsTab:AddDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "PastelBlue", "PastelGreen"},
    Default = "Dark",
    Callback = function(selected)
        Window:SetTheme(selected)
        AntigravityUI:Notify({
            Title = "Theme Changed",
            Message = "Theme set to: " .. selected,
            Type = "Info"
        })
    end
})

-- Save/Load buttons
SettingsTab:AddButton({
    Name = "💾 Save Config",
    Callback = function()
        if Window:SaveConfig() then
            AntigravityUI:Notify({
                Title = "Config Saved",
                Message = "Your settings have been saved!",
                Type = "Success"
            })
        else
            AntigravityUI:Notify({
                Title = "Save Failed",
                Message = "Could not save config",
                Type = "Error"
            })
        end
    end
})

SettingsTab:AddButton({
    Name = "📂 Load Config",
    Callback = function()
        if Window:LoadConfig() then
            AntigravityUI:Notify({
                Title = "Config Loaded",
                Message = "Your settings have been loaded!",
                Type = "Success"
            })
        else
            AntigravityUI:Notify({
                Title = "No Config",
                Message = "No saved config found",
                Type = "Warning"
            })
        end
    end
})

SettingsTab:AddButton({
    Name = "🗑️ Delete Config",
    Callback = function()
        Window:DeleteConfig()
        AntigravityUI:Notify({
            Title = "Config Deleted",
            Message = "Your saved settings have been deleted",
            Type = "Info"
        })
    end
})

-- Destroy button
SettingsTab:AddButton({
    Name = "❌ Close UI",
    Callback = function()
        Window:Destroy()
    end
})

-- ================================================================
-- INITIAL NOTIFICATION
-- ================================================================
AntigravityUI:Notify({
    Title = "🌌 Antigravity UI",
    Message = "Library loaded successfully! Press RightCtrl to toggle.",
    Type = "Info",
    Duration = 5
})

print("✅ Antigravity UI Library Example Loaded!")
print("📌 Press RightControl to toggle the UI")
print("📌 Use the floating icon when minimized")
