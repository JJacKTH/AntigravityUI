# 🌌 Antigravity UI Library

A modern, feature-rich UI library for Roblox Luau scripting.

## ✨ Features

- **Draggable Window** - ลากย้ายได้อิสระ
- **Floating Icon** - ไอคอนลอยเมื่อ minimize
- **Auto Save/Load** - บันทึก config อัตโนมัติต่อ UserId
- **4 Themes** - Dark, Light, PastelBlue, PastelGreen
- **Searchable Dropdown** - พิมพ์ค้นหาได้

## 📦 Components

| Component | Description |
|-----------|-------------|
| Button | ปุ่มกด พร้อม hover/ripple effects |
| Toggle | สวิตช์เปิด/ปิด |
| Textbox | ช่องกรอกข้อความ |
| Dropdown | Single/Multi select + Searchable |
| Slider | ปรับค่าตัวเลข |
| ColorPicker | เลือกสี RGB/Hex |
| Keybind | ตั้งปุ่มลัด |
| Label | แสดงข้อความ |
| Section | จัดกลุ่ม (Collapsible) |
| Notification | Toast notifications |

## 🚀 Quick Start

```lua
-- Load library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Main.lua"))()

-- Create window
local Window = UI:CreateWindow({
    Title = "My Hub",
    Theme = "Dark",
    AutoSave = true,
    FloatingIcon = { Enabled = true }
})

-- Create tab
local Tab = Window:CreateTab({ Name = "Main" })

-- Add components
Tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Clicked!")
    end
})

Tab:AddToggle({
    Name = "Enable",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

Tab:AddDropdown({
    Name = "Select",
    Options = {"A", "B", "C"},
    Searchable = true,
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

## 📁 File Structure

```
AntigravityUI/
├── Main.lua           -- Entry point
├── Example.lua        -- Usage example
├── Core/
│   ├── Theme.lua
│   ├── Animation.lua
│   └── Utility.lua
├── Components/
│   └── (all components)
└── Config/
    └── ConfigManager.lua
```

## 📝 License

MIT License - Free to use and modify
