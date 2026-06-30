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

playInterfaceSound("LoadingSound")


task.wait(3)

playInterfaceSound("LoadedSound")

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

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

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
    Main = Window:CreateTab("Main", "menu"),
    Auto = Window:CreateTab("Automation", "repeat"),
    Shop = Window:CreateTab("Shop", "shopping-cart"),
    Kill = Window:CreateTab("Kill", "skull"),
    Status = Window:CreateTab("Status", "info"),
    Misc = Window:CreateTab("Miscellaneous", "layout-dashboard"),
    Settings = Window:CreateTab("Settings", "cog")
}

-- =============================================================================
-- ENVIRONMENT (УПАКОВКА ДАННЫХ ДЛЯ ДРУГИХ ФАЙЛОВ)
-- =============================================================================
-- Мы передаём этот Env в другие файлы, чтобы они знали, куда рисовать UI

local Env = {
    LibraryUi = LibraryUi,
    Notifier = Notifier,
    Window = Window,
    Tabs = Tabs,
    player = player,
    RS = RS,
    rEvents = rEvents,
    playInterfaceSound = playInterfaceSound
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

playInterfaceSound("NotificationSound")

local Label1 = Tabs.Home:CreateLabel("Updates & News", "newspaper")

local ParagraphUpdates1 = Tabs.Home:CreateParagraph({
    Title = "UPDATES",
    Content = [[
    Version 1.0.0:
      + New ui library added 
      + Better security
      + More functions
        ]]
})

local ParagraphNews1 = Tabs.Home:CreateParagraph({
    Title = "NEWS",
    Content = [[
    News 1:
      We upgraded the script!
        ]]
})

local Label2 = Tabs.Home:CreateLabel("FAQ & Information", "badge-info")

local ParagraphFAQ1 = Tabs.Home:CreateParagraph({
    Title = "FAQ",
    Content = [[
    ( 1 ): Why the script is not working on other exploits?
      Answer:
        If it doesn't work, the exploit is not capable of supporting 
        a script that uses more complex details.
      Answer 2:
        Either the exploit is outdated and 
        does not work on current versions.
      Answer 3:
        The script works with the following exploits:
        Delta, JJsploit, Velocity, Arceus x neo

    ( 2 ): Why devs used this library Ui?
      Answer:
        The ui library is very easy to use and has a lot of features
        that can be used to create
        a great ui for the script.
        ]]
})

local Label3 = Tabs.Home:CreateLabel("I wanted to", "heart")

local ParagraphSTT1 = Tabs.Home:CreateParagraph({
    Title = "special thanks to:",
    Content = [[
    Gemini - for helping in the development of the script and ui library
    Sirius - for creating the ui library
    ]]
})

local Label4 = Tabs.Home:CreateLabel("Key System", "key-round")

local ParagraphKey1 = Tabs.Home:CreateParagraph({
    Title = "Key Time Status:",
    Content = [[
    The key is lifetime, cuz the script in
    the development stage, and the devs want to add more features in the future.
        ]]
})

Rayfield:Notify({
   Title = "Oxygen Hub",
   Content = "Script Loaded! Enjoy the script!",
   Duration = 5,
   Image = "check",
})
