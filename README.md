# 🌌 Antigravity UI Library

[English](#english) | [ภาษาไทย](#ภาษาไทย)

---

## English

A modern, feature-rich UI library for Roblox Luau scripting.

### ✨ Features

| Feature | Description |
|---------|-------------|
| **Draggable Window** | Freely movable window |
| **Floating Icon** | Floating icon when minimized, draggable |
| **Auto Save/Load** | Auto-save config per UserId |
| **4 Themes** | Dark, Light, PastelBlue, PastelGreen |
| **Searchable Dropdown** | Type to search in dropdown |

### 📦 Components

| Component | Description |
|-----------|-------------|
| Button | Clickable button with hover/ripple effects |
| Toggle | On/Off switch with animation |
| Textbox | Text input field |
| Dropdown | Single/Multi select + Searchable |
| Slider | Numeric value adjuster |
| ColorPicker | RGB/Hex color selector |
| Keybind | Hotkey setter |
| Label | Text display |
| Section | Collapsible group |
| Notification | Toast notifications |

### 🚀 Quick Start

```lua
-- Load library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Loader.lua"))()

-- Create window
local Window = UI:CreateWindow({
    Title = "My Hub",
    Theme = "Dark", -- Dark, Light, PastelBlue, PastelGreen
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
    Name = "Enable Feature",
    Default = false,
    Flag = "MyToggle", -- For auto-save
    Callback = function(value)
        print("Toggle:", value)
    end
})

Tab:AddDropdown({
    Name = "Select Option",
    Options = {"Option A", "Option B", "Option C"},
    Searchable = true, -- Enable search
    Multi = false, -- Set true for multi-select
    Callback = function(selected)
        print("Selected:", selected)
    end
})

Tab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Value:", value)
    end
})

Tab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Window:Toggle()
    end
})
```

### 📁 File Structure

```
AntigravityUI/
├── Main.lua           -- Entry point
├── Example.lua        -- Usage example
├── Core/
│   ├── Theme.lua      -- Theme system
│   ├── Animation.lua  -- Tween effects
│   └── Utility.lua    -- Helper functions
├── Components/        -- All UI components
└── Config/
    └── ConfigManager.lua -- Save/Load system
```

### 📝 License

MIT License - Free to use and modify

---

## ภาษาไทย

UI Library ที่ทันสมัยและมีฟีเจอร์ครบครันสำหรับ Roblox Luau scripting

### ✨ ฟีเจอร์หลัก

| ฟีเจอร์ | รายละเอียด |
|--------|------------|
| **Draggable Window** | หน้าต่างลากย้ายได้อิสระ |
| **Floating Icon** | ไอคอนลอยเมื่อ minimize ลากได้ |
| **Auto Save/Load** | บันทึก config อัตโนมัติต่อ UserId |
| **4 Themes** | Dark, Light, PastelBlue, PastelGreen |
| **Searchable Dropdown** | พิมพ์ค้นหาใน dropdown ได้ |

### 📦 Components ทั้งหมด

| Component | รายละเอียด |
|-----------|------------|
| Button | ปุ่มกด พร้อม hover/ripple effects |
| Toggle | สวิตช์เปิด/ปิด พร้อม animation |
| Textbox | ช่องกรอกข้อความ |
| Dropdown | เลือก Single/Multi + ค้นหาได้ |
| Slider | ปรับค่าตัวเลขด้วยการลาก |
| ColorPicker | เลือกสี RGB/Hex |
| Keybind | ตั้งปุ่มลัด |
| Label | แสดงข้อความ |
| Section | จัดกลุ่มแบบยุบได้ |
| Notification | แจ้งเตือนแบบ Toast |

### 🚀 เริ่มต้นใช้งาน

```lua
-- โหลด library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Loader.lua"))()

-- สร้างหน้าต่าง
local Window = UI:CreateWindow({
    Title = "My Hub",
    Theme = "Dark", -- Dark, Light, PastelBlue, PastelGreen
    AutoSave = true,
    FloatingIcon = { Enabled = true }
})

-- สร้างแท็บ
local Tab = Window:CreateTab({ Name = "หลัก" })

-- เพิ่ม components
Tab:AddButton({
    Name = "กดเลย!",
    Callback = function()
        print("คลิกแล้ว!")
    end
})

Tab:AddToggle({
    Name = "เปิดใช้งาน",
    Default = false,
    Flag = "MyToggle", -- สำหรับ auto-save
    Callback = function(value)
        print("Toggle:", value)
    end
})

Tab:AddDropdown({
    Name = "เลือกตัวเลือก",
    Options = {"ตัวเลือก A", "ตัวเลือก B", "ตัวเลือก C"},
    Searchable = true, -- เปิดการค้นหา
    Multi = false, -- ใส่ true เพื่อเลือกหลายตัว
    Callback = function(selected)
        print("เลือก:", selected)
    end
})

Tab:AddSlider({
    Name = "ความเร็ว",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("ค่า:", value)
    end
})

Tab:AddKeybind({
    Name = "เปิด/ปิด UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Window:Toggle()
    end
})
```

### 💡 หมายเหตุสำคัญ

- ใช้ `Flag` parameter เพื่อให้ค่าถูกบันทึกอัตโนมัติ
- Floating Icon จะแสดงเมื่อกด minimize หน้าต่าง
- Config จะถูกบันทึกเป็น `[UserId]_[ConfigName].json`
- กด `RightControl` (ค่าเริ่มต้น) เพื่อเปิด/ปิด UI

### 📁 โครงสร้างไฟล์

```
AntigravityUI/
├── Main.lua           -- จุดเริ่มต้น
├── Example.lua        -- ตัวอย่างการใช้งาน
├── Core/
│   ├── Theme.lua      -- ระบบธีม
│   ├── Animation.lua  -- Tween effects
│   └── Utility.lua    -- ฟังก์ชันช่วยเหลือ
├── Components/        -- Components ทั้งหมด
└── Config/
    └── ConfigManager.lua -- ระบบ Save/Load
```

### 📝 License

MIT License - ใช้งานและแก้ไขได้อิสระ
