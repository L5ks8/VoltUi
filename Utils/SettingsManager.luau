local HttpService = game:GetService("HttpService")

local SettingsManager = {}
SettingsManager.ConfigPath = "VoltHub/Settings.json"

local currentSettings = nil

function SettingsManager.LoadSettings()
    if currentSettings then
        return currentSettings
    end

    local defaultSettings = {
        ActiveTheme = "My Volt Dark",
        Mode = "Dark"
    }

    if isfile and isfile(SettingsManager.ConfigPath) then
        local success, content = pcall(function()
            return readfile(SettingsManager.ConfigPath)
        end)
        
        if success and content and content ~= "" then
            local decodeSuccess, decoded = pcall(function()
                return HttpService:JSONDecode(content)
            end)
            
            if decodeSuccess and type(decoded) == "table" then
                -- Merge defaults with loaded settings
                for k, v in pairs(defaultSettings) do
                    if decoded[k] == nil then
                        decoded[k] = v
                    end
                end
                currentSettings = decoded
                return currentSettings
            end
        end
    end

    currentSettings = defaultSettings
    SettingsManager.SaveSettings(currentSettings)
    return currentSettings
end

function SettingsManager.SaveSettings(settingsTable)
    if not writefile then return false end
    
    -- Update current settings
    if settingsTable then
        if not currentSettings then currentSettings = {} end
        for k, v in pairs(settingsTable) do
            currentSettings[k] = v
        end
    end
    
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(currentSettings)
    end)
    
    if success and encoded then
        pcall(function()
            -- Make sure VoltHub and Configs folders exist
            if isfolder and not isfolder("VoltHub") then
                makefolder("VoltHub")
            end
            if isfolder and not isfolder("VoltHub/Configs") then
                makefolder("VoltHub/Configs")
            end
            writefile(SettingsManager.ConfigPath, encoded)
        end)
        return true
    end
    
    return false
end

function SettingsManager.GetSetting(key)
    if not currentSettings then
        SettingsManager.LoadSettings()
    end
    return currentSettings and currentSettings[key]
end

return SettingsManager
