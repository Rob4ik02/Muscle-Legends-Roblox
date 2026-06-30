-- // localization \\ --
local players = game:GetService("Players")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local rEvents = RS:WaitForChild("rEvents")

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

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



task.wait(3)

playInterfaceSound("LoadingSound")



print(" OXYGEN SYSTEM: Welcome to console! The Script is loading now..")
warn(" OXYGEN SYSTEM: The script can maybe not loaded if your exploit not strong possible!")

-- // Создание Окна \\ --

local Window = Rayfield:CreateWindow({
   Name = "Oxygen Hub | Muscle Legends",
   Icon = 102643647961511, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Oxygen Projects",
   LoadingSubtitle = "by Oxygen Development",
   ShowText = "Muscle Legends", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Oxygen Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
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
    LibraryUi = LibraryUi,
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
            warn("OXYGEN SYSTEM: Module " .. url .. " wasn't back the answer!")
        end
    else
        warn("OXYGEN SYSTEM: Module isn't loaded!" .. url .. "\n" .. tostring(result))
    end
end

wait(1)
print(" OXYGEN SYSTEM: Loading External Module 'VerifyPlayer.lua'")
loadExternalModule("https://raw.githubusercontent.com/Rob4ik02/Muscle-Legends-Roblox/refs/heads/main/Muscle%20Legends/Sirius%20Library/GymFarm.lua", Env)

playInterfaceSound("LoadedSound")


playInterfaceSound("NotificationSound")


Rayfield:Notify({
   Title = "Oxygen Hub",
   Content = "Script Loaded! Enjoy the script!",
   Duration = 5,
   Image = "check",
})
