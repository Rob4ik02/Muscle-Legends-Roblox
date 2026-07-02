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

    -- // REBIRTH CATEGORY \\ --

    local Label1 = AutoTab:CreateLabel("Rebirth Category", "repeat-1")

    local Paragraph1 = AutoTab:CreateParagraph({
        Title = "Information:",
        Content = [[
        There are two versions of the rebirth feature available here:
            1) Input – enter the target number of rebirths you want, and the script will proceed until it reaches that goal.
            2) Dropdown – a pre-configured option for selecting rebirths specifically to exploit the pet glitch.
        ]],
    })

    local Section1 = AutoTab:CreateSection("Target Rebirth")

    local Input1Enabled = false
    local Dropdown1Enabled = false
    local InfiniteRebirthEnabled = false


    local Input1 = AutoTab:CreateInput({
        Name = "Target Count V1",
        CurrentValue = "",
        PlaceholderText = "Input Value Of Rebirth Count",
        RemoveTextAfterFocusLost = false,
        Flag = "RebirthTarget1",
        Callback = function(Text)

        end,
    })

    local Toggle1 = AutoTab:CreateToggle({
        Name = "Auto Rebirth V1",
        CurrentValue = false,
        Flag = "ToggleRebirth1", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            if Value then
                if Dropdown1Enabled == true then
                    Dropdown1Enabled = false
                elseif InfiniteRebirthEnabled == true then
                    InfiniteRebirthEnabled = false
                end
            else
                
            end
        end,
    })

    local Section2 = AutoTab:CreateSection("or")

    local Dropdown1 = AutoTab:CreateDropdown({
        Name = "Rebirth Count V2",
        Options = {"80", "280", "580", "980", "1480", "2080", "2780", "3580", "4480", "5480", "6580", "7780", "9080", "10480", "11980", "13580", "15280", "17080", "18980"},
        CurrentOption = {"80"},
        MultipleOptions = false,
        Flag = "RebirthTarget2", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Options)
        -- The function that takes place when the selected option is changed
        -- The variable (Options) is a table of strings for the current selected options
        end,
    })

    local Toggle2 = AutoTab:CreateToggle({
        Name = "Auto Rebirth V2",
        CurrentValue = false,
        Flag = "ToggleRebirth2", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            if Value then
                if Input1Enabled == true then
                    Input1Enabled = false
                elseif InfiniteRebirthEnabled == true then
                    InfiniteRebirthEnabled = false
                end
            else
                
            end
        end,
    })

    local SectionOfCount1 = AutoTab:CreateSection("Select Rebirth Count: V1 or V2") -- показываем какой вариант выбран, чтобы пользователь понимал что он выбрал

    -- SectionOfCount1:Set("Section Example") Обновление текста в секции

    local Section3 = AutoTab:CreateSection("Infinity Rebirths")

    local Paragraph1 = AutoTab:CreateParagraph({
        Title = "Information:",
        Content = [[
        Infinity rebirths – constantly performs rebirths without any specific goal or target.
        ]],
    })

    local Toggle3 = AutoTab:CreateToggle({
        Name = "Auto Rebirth Infinity",
        CurrentValue = false,
        Flag = "ToggleRebirth3", -- A flag is the identifier for the configuration file; make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            if Value then
                if Input1Enabled == true then
                    Input1Enabled = false
                elseif Dropdown1Enabled == true then
                    Dropdown1Enabled = false
                end
            else
                
            end
        end,
    })

    local Label2 = AutoTab:CreateLabel("Rebirth Status", "chart-column")

    local Paragraph1 = AutoTab:CreateParagraph({
        Title = "Status:",
        Content = [[
            Now: 
            Starts Farm:
            Target:
            Income per second/minute/hour:
        ]],
    })
end
