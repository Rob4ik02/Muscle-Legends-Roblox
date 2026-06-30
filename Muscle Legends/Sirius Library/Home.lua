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
    local player = Env.player
    local playInterfaceSound = Env.playInterfaceSound
    local Notifier = Env.Notifier
    local RS = Env.RS
    local rEvents = Env.rEvents
    local Rayfield = Env.Rayfield 

    -- // HOME TAB \\ --

    local Label1 = HomeTab:CreateLabel("Updates & News", "newspaper")

    local ParagraphUpdates1 = HomeTab:CreateParagraph({
        Title = "UPDATES",
        Content = [[
        Version 1.0.0:
          + New ui library added 
          + Better security
          + More functions
            ]]
    })

    local ParagraphNews1 = HomeTab:CreateParagraph({
        Title = "NEWS",
        Content = [[
        News 1:
          We upgraded the script!
            ]]
    })

    local Label2 = HomeTab:CreateLabel("FAQ & Information", "badge-info")

    local ParagraphFAQ1 = HomeTab:CreateParagraph({
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

    local Label3 = HomeTab:CreateLabel("I wanted to", "heart")

    local ParagraphSTT1 = HomeTab:CreateParagraph({
        Title = "special thanks to:",
        Content = [[
        Gemini - for helping in the development of the script and ui library
        Sirius - for creating the ui library
        ]]
    })

    local Label4 = HomeTab:CreateLabel("Key System", "key-round")

    local ParagraphKey1 = HomeTab:CreateParagraph({
        Title = "Key Time Status:",
        Content = [[
        The key is lifetime, cuz the script in
        the development stage, and the devs want to add more features in the future.
            ]]
    })
end
