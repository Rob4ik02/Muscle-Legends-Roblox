print("Executed Script!")
warn(" V 1.0.2 ") -- Версия обновлена

-- // localization \\ --
local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local rEvents = RS:WaitForChild("rEvents")
local HttpService = game:GetService("HttpService")

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

-- =======================================================
-- ВНИМАНИЕ: ССЫЛКА БЕЗ СЛЕША НА КОНЦЕ! (ИСПРАВЛЕНО)
-- =======================================================
local WEB_SERVER_URL = "https://global-scripts-development.onrender.com"

-- // Загрузка звуков \\ --
local sounds = {
    ["ButtonClick"] = "rbxassetid://140387697208266",
    ["WarnSound"] = "rbxassetid://136001454409424",
    ["NotificationSound"] = "rbxassetid://134195160579609",
    ["LoadedSound"] = "rbxassetid://117683281438895",
    ["ErrorSound"] = "rbxassetid://131039887376992",
    ["LoadingSound"] = "rbxassetid://3320590485"
}

for soundName, assetId in pairs(sounds) do
    local existingSound = playerGui:FindFirstChild(soundName)
    if not existingSound then
        local newSound = Instance.new("Sound")
        newSound.Name = soundName
        newSound.SoundId = assetId
        newSound.Volume = 0.6
        newSound.PlayOnRemove = false
        newSound.Parent = playerGui
    else
        existingSound.SoundId = assetId
    end
end

local function playInterfaceSound(soundName)
    local sound = playerGui:FindFirstChild(soundName)
    if sound and sound:IsA("Sound") then
        sound:Play()
    end
end

-- // Oxygen Hub Library \\ --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

task.wait(1)

playInterfaceSound("LoadingSound")

print(" OXYGEN SYSTEM: Welcome to console! The Script is loading now..")
task.wait(0.5)
warn(" OXYGEN SYSTEM: The script can maybe not loaded if your exploit not strong possible!")

-- // Создание Окна \\ --
local Window = Rayfield:CreateWindow({
   Name = "Oxygen Hub | Muscle Legends",
   Icon = 102643647961511, 
   LoadingTitle = "Oxygen Projects",
   LoadingSubtitle = "by Oxygen Development",
   ShowText = "Muscle Legends", 
   Theme = "DarkBlue",

   ToggleUIKeybind = "K", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GlobalScriptsHub", 
      FileName = "OxygenHub"
   },

   Discord = {
      Enabled = false, 
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = true, 
   KeySettings = {
        Title = "Oxygen Hub | Security",
        Subtitle = "Valid Key Required",
        Note = "Get your key from our dashboard (Valid for 12 hours)", 
        FileName = "OxygenKey_Saved", 
        SaveKey = true, 
        GrabKeyFromSite = false, 
        Key = {"OVERRIDE_DEVELOPER_KEY_666"}, 
        
        -- Исправленная проверка ключа с продвинутым дебагом
        KeyCheck = function(EnteredKey)
            local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
            local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
            
            local payload = HttpService:JSONEncode({
                key = EnteredKey,
                hwid = hwid,
                user = player.Name
            })
            
            local successReq, response = pcall(function()
                if requestFunc then
                    return requestFunc({
                        Url = WEB_SERVER_URL .. "/api/verify_key",
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = payload
                    })
                else
                    local rawResp = game:HttpGet(WEB_SERVER_URL .. "/api/verify_key?key=" .. EnteredKey .. "&hwid=" .. hwid)
                    return { Body = rawResp, StatusCode = 200 }
                end
            end)

            if not successReq or not response then
                warn("OXYGEN SYSTEM ERROR: Request failed. Ensure the server is online. Details: " .. tostring(response))
                Rayfield:Notify({
                    Title = "Connection Error",
                    Content = "Не удалось связаться с сервером ключей. Сайт выключен или запрос заблокирован.",
                    Duration = 6,
                    Image = 4483362458,
                })
                return false
            end

            local successDec, decoded = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            
            if not successDec then
                warn("OXYGEN SYSTEM ERROR: Failed to parse JSON. Server returned: " .. tostring(response.Body))
                Rayfield:Notify({
                    Title = "Server Error",
                    Content = "Сервер вернул неверный ответ. Проверь консоль (F9).",
                    Duration = 6,
                    Image = 4483362458,
                })
                return false
            end
            
            if decoded.valid then
                Rayfield:Notify({
                    Title = "Access Granted!",
                    Content = "Welcome back, " .. decoded.user .. "!",
                    Duration = 5,
                    Image = 4483362458,
                })
                return true
            else
                local errMsg = (decoded and decoded.message) or "Invalid Key or Server Offline"
                Rayfield:Notify({
                    Title = "Access Denied",
                    Content = errMsg,
                    Duration = 5,
                    Image = 4483362458,
                })
                return false
            end
        end
    }
})

-- // СОЗДАНИЕ ВКЛАДОК \\ --

local Tabs = {
    Home = Window:CreateTab("Home", "layout-panel-left"),
    Gym = Window:CreateTab("Gym", "dumbbell"),
    Lifting = Window:CreateTab("Lifting", "brain"),
    Auto = Window:CreateTab("Automation", "repeat"),
    Shop = Window:CreateTab("Shop", "shopping-cart"),
    Kill = Window:CreateTab("Kill", "skull"),
    Status = Window:CreateTab("Status", "info"),
    Misc = Window:CreateTab("Miscellaneous", "layout-dashboard"),
    KeySystem = Window:CreateTab("Key System", "key"),
    Settings = Window:CreateTab("Settings", "cog")
}

-- =============================================================================
-- ENVIRONMENT (УПАКОВКА ДАННЫХ ДЛЯ ДРУГИХ ФАЙЛОВ)
-- =============================================================================

local Env = {
    LibraryUi = nil, 
    Window = Window,
    Tabs = Tabs,
    player = player,
    RS = RS,
    rEvents = rEvents,
    playInterfaceSound = playInterfaceSound,
    Rayfield = Rayfield
}

-- =============================================================================
-- БЕЗОПАСНАЯ ЗАГРУЗКА МОДУЛЕЙ
-- =============================================================================

local function loadExternalModule(url, env)
    local success, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("OXYGEN SYSTEM: Bad internet. (Can't download the module): " .. url)
        return
    end

    local func, err = loadstring(scriptContent)
    if not func then
        warn("OXYGEN SYSTEM: No func after then. (Syntax in file?): " .. url .. "\n" .. tostring(err))
        return
    end

    local successExec, result = pcall(func)
    if successExec then
        if type(result) == "function" then
            result(env) -- Передаем Env
        else
            warn("OXYGEN SYSTEM: Module " .. url .. " wasn't back the answer! (Make sure the GitHub file ends with 'return function(Env) ... end')")
        end
    else
        warn("OXYGEN SYSTEM: Module isn't loaded!" .. url .. "\n" .. tostring(result))
    end
end

task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Home/Home.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/Home.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Gym&Lifting/GymFarm.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/GymFarm.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Automation/Rebirth.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/Rebirth.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Automation/EatAll.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/EatAll.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Automation/SpinFortune.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/SpinFortune.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Automation/GiftClaim.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/GiftClaim.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Shop/ShopBuy.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/ShopBuy.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Kill/KillPlrs.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/KillPlrs.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Misc/EspPlrs.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/EspPlrs.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'Status/Status.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/Status.lua", Env)
task.wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'KeySystem/KeyTab.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/KeyTab.lua", Env)
task.wait(1)

playInterfaceSound("LoadedSound")

task.wait(5)

playInterfaceSound("NotificationSound")

local Divider = Tabs.Home:CreateDivider()

Rayfield:Notify({
   Title = "Oxygen Hub",
   Content = "Script Loaded! Enjoy the script!",
   Duration = 5,
   Image = "check",
})
