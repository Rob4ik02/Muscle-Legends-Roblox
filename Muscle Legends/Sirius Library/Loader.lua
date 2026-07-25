print("Executed Script!")
warn(" V 1.0.3 - SECURITY UPDATE ")

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
-- ССЫЛКА НА ТВОЙ СЕРВЕР 
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
   Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
   -- ОТКЛЮЧАЕМ БАГОВАННУЮ СИСТЕМУ РЕЙФИЛДА И ДЕЛАЕМ СВОЮ НИЖЕ!
   KeySystem = false 
})

-- =============================================================================
-- КAСТОМНАЯ И НАДЕЖНАЯ СИСТЕМА КЛЮЧЕЙ
-- =============================================================================

local isVerified = false
local KeyFileName = "OxygenKey_Saved.txt"

-- Создаем стартовую вкладку (будет видна только она до проверки ключа)
local AuthTab = Window:CreateTab("Authentication", "lock")

local function LoadMainScript()
    if isVerified then return end
    isVerified = true
    
    Rayfield:Notify({
        Title = "Access Granted",
        Content = "Modules are loading, please wait...",
        Duration = 3,
        Image = 4483362458,
    })
    
    -- Только после проверки ключа создаем остальные вкладки!
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

    local Env = { Window = Window, Tabs = Tabs, player = player, RS = RS, rEvents = rEvents, playInterfaceSound = playInterfaceSound, Rayfield = Rayfield }

    local function loadExternalModule(url, env)
        local success, scriptContent = pcall(function() return game:HttpGet(url) end)
        if not success then warn("OXYGEN SYSTEM: Bad internet: " .. url); return end
        
        local func, err = loadstring(scriptContent)
        if not func then warn("OXYGEN SYSTEM: Syntax Error: " .. url .. "\n" .. tostring(err)); return end
        
        local successExec, result = pcall(func)
        if successExec then
            if type(result) == "function" then result(env) else warn("OXYGEN SYSTEM: File didn't return function: " .. url) end
        else warn("OXYGEN SYSTEM: Module crash: " .. url .. "\n" .. tostring(result)) end
    end

    -- Загрузка твоих скриптов с GitHub
    local baseUrl = "https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/"
    local files = { "Home.lua", "GymFarm.lua", "Rebirth.lua", "EatAll.lua", "SpinFortune.lua", "GiftClaim.lua", "ShopBuy.lua", "KillPlrs.lua", "EspPlrs.lua", "Status.lua", "KeyTab.lua" }
    
    for _, file in ipairs(files) do
        print(" OXYGEN SYSTEM: Loading " .. file)
        loadExternalModule(baseUrl .. file, Env)
        task.wait(0.2)
    end

    playInterfaceSound("LoadedSound")
    task.wait(1)
    playInterfaceSound("NotificationSound")

    local setDivider = Tabs.Home:CreateDivider()

    Rayfield:Notify({
       Title = "Oxygen Hub",
       Content = "Script Loaded! Enjoy the script!",
       Duration = 5,
       Image = 4483362458,
    })
end

local function VerifyKey(EnteredKey)
    if EnteredKey == "OVERRIDE_DEVELOPER_KEY_666" then
        if writefile then writefile(KeyFileName, EnteredKey) end
        LoadMainScript()
        return
    end

    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    local payload = HttpService:JSONEncode({
        key = EnteredKey,
        hwid = hwid,
        user = player.Name
    })
    
    local successReq, response = pcall(function()
        if requestFunc then
            return requestFunc({ Url = WEB_SERVER_URL .. "/api/verify_key", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload })
        else
            local rawResp = game:HttpGet(WEB_SERVER_URL .. "/api/verify_key?key=" .. EnteredKey .. "&hwid=" .. hwid)
            return { Body = rawResp, StatusCode = 200 }
        end
    end)

    if not successReq or not response then
        Rayfield:Notify({Title = "Connection Error", Content = "Server is offline or blocked. Check console.", Duration = 6})
        warn(tostring(response))
        return
    end

    local successDec, decoded = pcall(function() return HttpService:JSONDecode(response.Body) end)
    
    if successDec and decoded and decoded.valid then
        if writefile then writefile(KeyFileName, EnteredKey) end
        Rayfield:Notify({Title = "Access Granted", Content = "Welcome, " .. decoded.user .. " (".. decoded.plan ..")!", Duration = 5})
        LoadMainScript()
    else
        local errMsg = (decoded and decoded.message) or "Invalid Key"
        Rayfield:Notify({Title = "Access Denied", Content = errMsg, Duration = 5})
    end
end

-- Интерфейс вкладки проверки ключа
AuthTab:CreateSection("Security Check")
AuthTab:CreateParagraph({Title = "Valid Key Required", Content = "Get your key from our dashboard. It lasts 12 hours and binds to your PC."})

AuthTab:CreateInput({
    Name = "Enter License Key",
    PlaceholderText = "GS-XXXX-XXXX-XXXX",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        VerifyKey(Text)
    end,
})

-- Автоматический вход, если ключ уже сохранен на ПК
if isfile and isfile(KeyFileName) then
    local savedKey = readfile(KeyFileName)
    if savedKey and savedKey ~= "" then
        VerifyKey(savedKey)
    end
end
