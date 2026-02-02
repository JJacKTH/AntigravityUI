--[[
    Antigravity UI Library - Config Manager
    Auto Save/Load system per UserId
]]

local ConfigManager = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

ConfigManager.Folder = "AntigravityUI"
ConfigManager.Configs = {}

-- Check if file system functions exist (executor support)
local function hasFileSystem()
    return typeof(readfile) == "function" and 
           typeof(writefile) == "function" and
           typeof(isfolder) == "function" and
           typeof(makefolder) == "function"
end

-- Get UserId
local function getUserId()
    local player = Players.LocalPlayer
    return player and tostring(player.UserId) or "0"
end

-- Get config file path
function ConfigManager:GetPath(configName)
    local userId = getUserId()
    return string.format("%s/%s_%s.json", self.Folder, userId, configName)
end

-- Ensure folder exists
function ConfigManager:EnsureFolder()
    if hasFileSystem() and not isfolder(self.Folder) then
        makefolder(self.Folder)
    end
end

-- Save config to file
function ConfigManager:Save(configName, data)
    if not hasFileSystem() then
        warn("[AntigravityUI] File system not available - config will not persist")
        return false
    end
    
    self:EnsureFolder()
    
    local path = self:GetPath(configName)
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(data)
        writefile(path, json)
    end)
    
    if success then
        self.Configs[configName] = data
        return true
    else
        warn("[AntigravityUI] Failed to save config:", err)
        return false
    end
end

-- Load config from file
function ConfigManager:Load(configName)
    if not hasFileSystem() then
        warn("[AntigravityUI] File system not available")
        return nil
    end
    
    local path = self:GetPath(configName)
    
    if not isfile(path) then
        return nil
    end
    
    local success, result = pcall(function()
        local content = readfile(path)
        return HttpService:JSONDecode(content)
    end)
    
    if success then
        self.Configs[configName] = result
        return result
    else
        warn("[AntigravityUI] Failed to load config:", result)
        return nil
    end
end

-- Delete config file
function ConfigManager:Delete(configName)
    if not hasFileSystem() then
        return false
    end
    
    local path = self:GetPath(configName)
    
    if isfile(path) then
        local success = pcall(function()
            delfile(path)
        end)
        
        if success then
            self.Configs[configName] = nil
            return true
        end
    end
    
    return false
end

-- Check if config exists
function ConfigManager:Exists(configName)
    if not hasFileSystem() then
        return false
    end
    
    local path = self:GetPath(configName)
    return isfile(path)
end

-- List all configs for current user
function ConfigManager:ListConfigs()
    if not hasFileSystem() then
        return {}
    end
    
    self:EnsureFolder()
    
    local configs = {}
    local userId = getUserId()
    
    if typeof(listfiles) == "function" then
        local files = listfiles(self.Folder)
        for _, file in ipairs(files) do
            local fileName = file:match("([^/\\]+)$")
            if fileName and fileName:match("^" .. userId .. "_") then
                local configName = fileName:gsub("^" .. userId .. "_", ""):gsub("%.json$", "")
                table.insert(configs, configName)
            end
        end
    end
    
    return configs
end

-- Create a config handler for a window
function ConfigManager:CreateHandler(configName, autoSave, autoLoad)
    local handler = {
        ConfigName = configName,
        AutoSave = autoSave or false,
        AutoLoad = autoLoad or false,
        Data = {},
        Elements = {},
        SaveDebounce = false
    }
    
    -- Register an element
    function handler:Register(id, elementType, getValue, setValue)
        self.Elements[id] = {
            Type = elementType,
            GetValue = getValue,
            SetValue = setValue
        }
    end
    
    -- Unregister an element
    function handler:Unregister(id)
        self.Elements[id] = nil
    end
    
    -- Save all registered elements
    function handler:Save()
        local data = {}
        
        for id, element in pairs(self.Elements) do
            local success, value = pcall(element.GetValue)
            if success then
                data[id] = {
                    Type = element.Type,
                    Value = value
                }
            end
        end
        
        return ConfigManager:Save(self.ConfigName, data)
    end
    
    -- Load and apply to all elements
    function handler:Load()
        local data = ConfigManager:Load(self.ConfigName)
        
        if data then
            self.Data = data
            
            for id, savedData in pairs(data) do
                local element = self.Elements[id]
                if element and element.Type == savedData.Type then
                    local success, err = pcall(function()
                        element.SetValue(savedData.Value)
                    end)
                    
                    if not success then
                        warn("[AntigravityUI] Failed to load value for", id, ":", err)
                    end
                end
            end
            
            return true
        end
        
        return false
    end
    
    -- Trigger auto save with debounce
    function handler:TriggerAutoSave()
        if not self.AutoSave or self.SaveDebounce then
            return
        end
        
        self.SaveDebounce = true
        
        task.delay(1, function()
            self.SaveDebounce = false
            self:Save()
        end)
    end
    
    -- Delete config
    function handler:Delete()
        return ConfigManager:Delete(self.ConfigName)
    end
    
    -- Auto load on creation if enabled
    if autoLoad and ConfigManager:Exists(configName) then
        task.defer(function()
            handler:Load()
        end)
    end
    
    return handler
end

return ConfigManager
