--[[
    Antigravity UI Library - Full Example
    ตัวอย่างการใช้งานครบทุก Component
    
    โครงสร้าง Config:
    AntigravityUI/
    └── {Username}/
        └── {GameName}/
            └── Config.json
]]

-- โหลด Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Loader.lua"))()

-- ================================================================
-- สร้าง Window
-- ================================================================
local Window = UI:CreateWindow({
    Title = "BloxFruit Hub",           -- ชื่อแสดงบน Title Bar
    GameName = "BloxFruit",            -- ชื่อ Folder สำหรับ Save Config
    ConfigName = "Config",             -- ชื่อไฟล์ Config (ไม่ต้องใส่ .json)
    Theme = "Dark",                    -- Theme: Dark, Light, PastelBlue, PastelGreen
    Size = UDim2.new(0, 550, 0, 450),  -- ขนาดหน้าต่าง
    AutoSave = true,                   -- Auto Save เมื่อค่าเปลี่ยน
    AutoLoad = true,                   -- Auto Load ตอนเปิด
    FloatingIcon = {                   -- ไอคอนลอย (เมื่อ Minimize)
        Enabled = true,
        Position = UDim2.new(0, 20, 0.5, 0)
    }
})

-- ================================================================
-- Tab: Main Functions
-- ================================================================
local MainTab = Window:CreateTab({ Name = "🎮 Main" })

-- Section: การเพาะเลี้ยง
local FarmSection = MainTab:AddSection({
    Name = "🌾 Auto Farm",
    Collapsed = false  -- เริ่มต้นเปิด
})

-- Toggle: เปิด/ปิด Auto Farm
MainTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Flag = "AutoFarm",  -- ← Flag สำหรับ Save Config
    Callback = function(value)
        print("Auto Farm:", value)
        -- ใส่โค้ดของคุณที่นี่
    end
})

-- Toggle: Auto Quest
MainTab:AddToggle({
    Name = "Auto Quest",
    Default = false,
    Flag = "AutoQuest",
    Callback = function(value)
        print("Auto Quest:", value)
    end
})

-- Dropdown: เลือก Zone
MainTab:AddDropdown({
    Name = "Select Zone",
    Options = {"Zone 1", "Zone 2", "Zone 3", "Boss Area", "Secret Zone"},
    Default = "Zone 1",
    Flag = "SelectedZone",
    Searchable = true,  -- มีช่องค้นหา
    Callback = function(selected)
        print("Selected Zone:", selected)
    end
})

-- Dropdown: Multi Select (เลือกหลายอัน)
MainTab:AddDropdown({
    Name = "Select Fruits",
    Options = {"Buddha", "Leopard", "Dragon", "Venom", "Dough"},
    Default = {"Buddha", "Dragon"},  -- เลือกหลายค่าตั้งต้น
    Multi = true,  -- เปิดใช้ Multi Select
    Flag = "SelectedFruits",
    Callback = function(selected)
        print("Selected Fruits:", table.concat(selected, ", "))
    end
})

-- Slider: ความเร็ว
MainTab:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 100,
    Default = 50,
    Increment = 5,  -- เพิ่มทีละ 5
    Suffix = " WPS",  -- หน่วย
    Flag = "FarmSpeed",
    Callback = function(value)
        print("Farm Speed:", value)
    end
})

-- Slider: ระยะห่าง
MainTab:AddSlider({
    Name = "Attack Range",
    Min = 10,
    Max = 500,
    Default = 100,
    Increment = 10,
    Suffix = " Studs",
    Flag = "AttackRange",
    Callback = function(value)
        print("Attack Range:", value)
    end
})

-- ================================================================
-- Tab: Player Settings
-- ================================================================
local PlayerTab = Window:CreateTab({ Name = "👤 Player" })

-- Label: แสดงข้อความ
PlayerTab:AddLabel({
    Name = "Player Settings",
    Text = "⚙️ ตั้งค่าผู้เล่น"
})

-- Toggle: Speed Hack
PlayerTab:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Flag = "SpeedHack",
    Callback = function(value)
        if value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

-- Toggle: Infinite Jump
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Flag = "InfJump",
    Callback = function(value)
        print("Infinite Jump:", value)
    end
})

-- Slider: WalkSpeed
PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Flag = "WalkSpeed",
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

-- Slider: Jump Power
PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 10,
    Flag = "JumpPower",
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

-- ================================================================
-- Tab: Teleport
-- ================================================================
local TeleportTab = Window:CreateTab({ Name = "🚀 Teleport" })

-- Button: Teleport ไปตำแหน่งต่างๆ
TeleportTab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        print("Teleporting to Spawn...")
        UI:Notify({
            Title = "Teleport",
            Message = "Teleported to Spawn!",
            Type = "Success",
            Duration = 3
        })
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Boss",
    Callback = function()
        print("Teleporting to Boss...")
        UI:Notify({
            Title = "Teleport",
            Message = "Teleported to Boss!",
            Type = "Info",
            Duration = 3
        })
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Shop",
    Callback = function()
        print("Teleporting to Shop...")
    end
})

-- Textbox: พิมพ์ชื่อผู้เล่นเพื่อ Teleport
TeleportTab:AddTextbox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter player name...",
    Flag = "TeleportPlayer",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Teleporting to player:", text)
        end
    end
})

-- ================================================================
-- Tab: Visuals
-- ================================================================
local VisualsTab = Window:CreateTab({ Name = "👁️ Visuals" })

-- Toggle: ESP
VisualsTab:AddToggle({
    Name = "Player ESP",
    Default = false,
    Flag = "PlayerESP",
    Callback = function(value)
        print("Player ESP:", value)
    end
})

-- ColorPicker: ESP Color
VisualsTab:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Callback = function(color)
        print("ESP Color:", color.R, color.G, color.B)
    end
})

-- Toggle: Fullbright
VisualsTab:AddToggle({
    Name = "Fullbright",
    Default = false,
    Flag = "Fullbright",
    Callback = function(value)
        local lighting = game:GetService("Lighting")
        if value then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
        else
            lighting.Brightness = 1
            lighting.ClockTime = 14
            lighting.FogEnd = 1000
        end
    end
})

-- Slider: Field of View
VisualsTab:AddSlider({
    Name = "Field of View",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Flag = "FOV",
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- ================================================================
-- Tab: Keybinds
-- ================================================================
local KeybindsTab = Window:CreateTab({ Name = "⌨️ Keybinds" })

-- Keybind: Toggle UI
KeybindsTab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Flag = "ToggleUIKey",
    Callback = function()
        Window:Toggle()
    end,
    ChangedCallback = function(newKey)
        print("Toggle UI key changed to:", newKey.Name)
    end
})

-- Keybind: Quick Farm
KeybindsTab:AddKeybind({
    Name = "Quick Farm",
    Default = Enum.KeyCode.F,
    Flag = "QuickFarmKey",
    Callback = function()
        print("Quick Farm activated!")
        UI:Notify({
            Title = "Keybind",
            Message = "Quick Farm activated!",
            Type = "Info",
            Duration = 2
        })
    end
})

-- Keybind: Emergency Stop
KeybindsTab:AddKeybind({
    Name = "Emergency Stop",
    Default = Enum.KeyCode.X,
    Flag = "EmergencyStopKey",
    Callback = function()
        print("Emergency Stop!")
        UI:Notify({
            Title = "⚠️ Emergency",
            Message = "All functions stopped!",
            Type = "Warning",
            Duration = 3
        })
    end
})

-- ================================================================
-- Tab: Settings
-- ================================================================
local SettingsTab = Window:CreateTab({ Name = "⚙️ Settings" })

-- Dropdown: Theme
SettingsTab:AddDropdown({
    Name = "UI Theme",
    Options = {"Dark", "Light", "PastelBlue", "PastelGreen"},
    Default = "Dark",
    Callback = function(selected)
        Window:SetTheme(selected)
        UI:Notify({
            Title = "Theme Changed",
            Message = "Theme set to " .. selected,
            Type = "Success"
        })
    end
})

-- Button: Save Config
SettingsTab:AddButton({
    Name = "💾 Save Config",
    Callback = function()
        Window:SaveConfig()
        UI:Notify({
            Title = "Config",
            Message = "Config saved successfully!",
            Type = "Success"
        })
    end
})

-- Button: Load Config
SettingsTab:AddButton({
    Name = "📂 Load Config",
    Callback = function()
        Window:LoadConfig()
        UI:Notify({
            Title = "Config",
            Message = "Config loaded successfully!",
            Type = "Success"
        })
    end
})

-- Button: Delete Config
SettingsTab:AddButton({
    Name = "🗑️ Delete Config",
    Callback = function()
        Window:DeleteConfig()
        UI:Notify({
            Title = "Config",
            Message = "Config deleted!",
            Type = "Warning"
        })
    end
})

-- ================================================================
-- Notifications Examples
-- ================================================================

-- แสดง Notification ตอนโหลดเสร็จ
UI:Notify({
    Title = "✅ Loaded!",
    Message = "BloxFruit Hub loaded successfully!",
    Type = "Success",
    Duration = 5
})

-- ================================================================
-- สรุป Config Path
-- ================================================================
print("============================================")
print("Antigravity UI - Full Example Loaded!")
print("Config Path: AntigravityUI/" .. game.Players.LocalPlayer.Name .. "/BloxFruit/Config.json")
print("============================================")
