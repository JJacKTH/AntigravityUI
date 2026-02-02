local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Load Antigravity UI Library (Assuming it's hosted or local)
-- For local development, we load from the file path we know
local Antigravity = loadstring(game:HttpGet("https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Loader.lua"))()

-- Configuration
local Config = {
    Key = "KEY-1234", -- Example fixed key
    KeyLink = "https://example.com/getkey",
    DiscordLink = "https://discord.gg/example",
    MainScript = "https://raw.githubusercontent.com/JJacKTH/AntigravityUI/main/Example.lua"
}

-- Create Window (Smaller size for Login)
local Window = Antigravity:Load({
    Title = "Authentication",
    Size = UDim2.fromOffset(400, 280),
    Resizing = false, -- Fixed size for login
    MinSize = UDim2.fromOffset(400, 280),
    MaxSize = UDim2.fromOffset(400, 280)
})

-- Create a single tab
local KeyTab = Window:CreateTab({
    Name = "Login",
    Icon = "rbxassetid://10723407389" -- Key icon
})

-- Add UI Elements
local Section = KeyTab:AddSection({ Name = "Enter License Key" })

local KeyInput = nil

KeyInput = KeyTab:AddInput({
    Name = "License Key",
    Placeholder = "Paste your key here...",
    Callback = function(text)
        -- Optional: Auto-check on text change or just store value
    end
})

KeyTab:AddButton({
    Name = "Check Key",
    Callback = function()
        if KeyInput.Value == Config.Key then
            Antigravity:Notify({
                Title = "Success",
                Message = "Key Valid! Loading script...",
                Duration = 3
            })
            
            -- Close Key UI
            Window:Destroy()
            
            -- Load Main Script
            task.delay(1, function()
                loadstring(game:HttpGet(Config.MainScript))()
            end)
        else
            Antigravity:Notify({
                Title = "Error",
                Message = "Invalid Key! Please try again.",
                Duration = 3
            })
        end
    end
})

KeyTab:AddDivider()

KeyTab:AddButton({
    Name = "Get Key Link",
    Callback = function()
        setclipboard(Config.KeyLink)
        Antigravity:Notify({
            Title = "Link Copied",
            Message = "Key link copied to clipboard!",
            Duration = 2
        })
    end
})

KeyTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard(Config.DiscordLink)
        local request = (syn and syn.request) or (http and http.request) or http_request
        if request then
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "example" -- Replace with actual invite code
                    },
                    nonce = HttpService:GenerateGUID(false)
                })
            })
        end
        Antigravity:Notify({
            Title = "Discord",
            Message = "Discord link copied / invite opened!",
            Duration = 2
        })
    end
})

-- Force Select Tab
KeyTab:Select()

-- Auto-Paste Support (Optional)
if setclipboard and getclipboard then
   -- KeyInput:SetValue(getclipboard())
end
