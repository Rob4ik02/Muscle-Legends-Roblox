return function(Env)
    local AutoTab = Env.Tabs.Auto --3
    local HomeTab = Env.Tabs.Home -- 1
    local LiftingTab = Env.Tabs.Lifting -- 2
    local GymTab = Env.Tabs.Gym -- 1
    local ShopTab = Env.Tabs.Shop -- 4
    local StatusTab = Env.Tabs.Status -- 6
    local SettingsTab = Env.Tabs.Settings -- 8
    local KillTab = Env.Tabs.Kill -- 5
    local MiscellaneousTab = Env.Tabs.Misc -- 7
    local MainTab = Env.Tabs.Main -- 2
    local KeySystemTab = Env.Tabs.KeySystem -- 9
    local player = Env.player
    local playInterfaceSound = Env.playInterfaceSound
    local Notifier = Env.Notifier
    local RS = Env.RS
    local rEvents = Env.rEvents
    local Rayfield = Env.Rayfield 

    KeySystemTab:CreateSection("")

    KeySystemTab:CreateLabel("Key System Category", "key")

    KeySystemTab:CreateSection("Key System")

    KeySystemTab:CreateParagraph({
        Title = "Data of key:",
        Content = [[
        Key expires: never
        Current key: TEST_IN_DEVELOPMENT#000
        Unlocked: all tabs
        ]],
    })

    local Button1 = KeySystemTab:CreateButton({
        Name = "Reset Key and Session",
        Callback = function()
            Rayfield:SetVisibility(false)
            wait(2)
            Rayfield:Destroy()
        end,
    })

end
