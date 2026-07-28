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

    AutoTab:CreateSection("")

    AutoTab:CreateLabel("Rebirth Category", "repeat-1")
    
    print("Cloud Oxygen Hub: 0 / 4 Rebirth.Lua")
    AutoTab:CreateSection("Target Rebirth: Version 1")
    
    AutoTab:CreateParagraph({
        Title = "Information:",
        Content = [[
        There are two versions of the target rebirth feature:
            1) Input – enter the target number of rebirths you want, and the script will proceed until it reaches that goal.
            2) Dropdown – a pre-configured option for selecting rebirths specifically to exploit the pet glitch.
        ]],
    })

    -- Состояние
    local state = {
        Input1Enabled = false,
        Dropdown1Enabled = false,
        InfiniteEnabled = false,
        targetV1 = 0,
        targetV2 = 80,
    }

    -- Храним ссылки на тогглы, чтобы управлять ими из других колбэков
    local toggles = {}

    -- Общая функция ребирта с проверкой remote
    local function doRebirth()
        local rebirthRemote = rEvents:FindFirstChild("rebirthRemote") or rEvents:FindFirstChild("RebirthRemote") or rEvents:FindFirstChild("rebirth")
        if not rebirthRemote then
            playInterfaceSound("ErrorSound")
            Rayfield:Notify({
                Title = "Rebirth Error",
                Content = "Rebirth remote not found!",
                Duration = 5,
                Image = "x"
            })
            return false
        end
        local success, err = pcall(function()
            rebirthRemote:InvokeServer("rebirthRequest")
        end)
        if not success then
            playInterfaceSound("ErrorSound")
            Rayfield:Notify({
                Title = "Rebirth Failed",
                Content = "Error: " .. tostring(err),
                Duration = 4,
                Image = "x"
            })
        end
        return success
    end

    -- Ввод целевого количества (V1)
    AutoTab:CreateInput({
        Name = "Target Count V1",
        CurrentValue = "",
        PlaceholderText = "Input Value Of Rebirth Count",
        RemoveTextAfterFocusLost = false,
        Flag = "RebirthTarget1",
        Callback = function(Text)
            local num = tonumber(Text)
            if num and num > 0 then
                state.targetV1 = num
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Target Set",
                    Content = "Target rebirths set to " .. num,
                    Duration = 3,
                    Image = "check"
                })
            else
                playInterfaceSound("ErrorSound")
                Rayfield:Notify({
                    Title = "Invalid Input",
                    Content = "Please enter a valid number greater than 0",
                    Duration = 4,
                    Image = "x"
                })
            end
        end,
    })

    -- Тоггл V1
    local Toggle1 = AutoTab:CreateToggle({
        Name = "Auto Rebirth V1",
        CurrentValue = false,
        Flag = "ToggleRebirth1",
        Callback = function(Value)
            if Value then
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Auto Rebirth V1 Enabled! Target: " .. state.targetV1,
                    Duration = 6.5,
                    Image = "check",
                })
                -- Отключаем другие режимы
                state.Dropdown1Enabled = false
                state.InfiniteEnabled = false
                if toggles.Toggle2 then toggles.Toggle2:Set(false) end
                if toggles.Toggle3 then toggles.Toggle3:Set(false) end
                state.Input1Enabled = true
                -- Запускаем цикл
                task.spawn(function()
                    while state.Input1Enabled do
                        local leaderstats = player:FindFirstChild("leaderstats")
                        if leaderstats then
                            local rebirths = leaderstats:FindFirstChild("Rebirths")
                            if rebirths and rebirths.Value >= state.targetV1 then
                                state.Input1Enabled = false
                                if toggles.Toggle1 then toggles.Toggle1:Set(false) end
                                Rayfield:Notify({
                                    Title = "Target Reached",
                                    Content = "Rebirths: " .. rebirths.Value,
                                    Duration = 5,
                                    Image = "check"
                                })
                                break
                            end
                        end
                        doRebirth()
                        task.wait(0.1)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Auto Rebirth V1 Disabled! Target: " .. state.targetV1,
                    Duration = 6.5,
                    Image = "check",
                })
                state.Input1Enabled = false
            end
        end,
    })
    toggles.Toggle1 = Toggle1

    print("Cloud Oxygen Hub: 1 / 4 Rebirth.Lua")
    -- Секция 2: Target Rebirth V2 (Dropdown)
    AutoTab:CreateSection("Target Rebirth: Version 2")

    -- Dropdown для выбора цели
    AutoTab:CreateDropdown({
        Name = "Rebirth Count V2",
        Options = {"80", "280", "580", "980", "1480", "2080", "2780", "3580", "4480", "5480", "6580", "7780", "9080", "10480", "11980", "13580", "15280", "17080", "18980"},
        CurrentOption = {"80"},
        MultipleOptions = false,
        Flag = "RebirthTarget2",
        Callback = function(Options)
            local val = tonumber(Options[1])
            if val then
                state.targetV2 = val
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Target Set",
                    Content = "Target rebirths set to " .. val,
                    Duration = 3,
                    Image = "check"
                })
            end
        end,
    })

    -- Тоггл V2
    local Toggle2 = AutoTab:CreateToggle({
        Name = "Auto Rebirth V2",
        CurrentValue = false,
        Flag = "ToggleRebirth2",
        Callback = function(Value)
            if Value then
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Auto Rebirth V2 Enabled! Target: " .. state.targetV2,
                    Duration = 6.5,
                    Image = "check",
                })
                state.Input1Enabled = false
                state.InfiniteEnabled = false
                if toggles.Toggle1 then toggles.Toggle1:Set(false) end
                if toggles.Toggle3 then toggles.Toggle3:Set(false) end
                state.Dropdown1Enabled = true
                task.spawn(function()
                    while state.Dropdown1Enabled do
                        local leaderstats = player:FindFirstChild("leaderstats")
                        if leaderstats then
                            local rebirths = leaderstats:FindFirstChild("Rebirths")
                            if rebirths and rebirths.Value >= state.targetV2 then
                                state.Dropdown1Enabled = false
                                if toggles.Toggle2 then toggles.Toggle2:Set(false) end
                                Rayfield:Notify({
                                    Title = "Target Reached",
                                    Content = "Rebirths: " .. rebirths.Value,
                                    Duration = 5,
                                    Image = "check"
                                })
                                break
                            end
                        end
                        doRebirth()
                        task.wait(0.1)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Auto Rebirth V2 Disabled! Target: " .. state.targetV2,
                    Duration = 6.5,
                    Image = "check",
                })
                state.Dropdown1Enabled = false
            end
        end,
    })
    
    toggles.Toggle2 = Toggle2

    print("Cloud Oxygen Hub: 2 / 4 Rebirth.Lua")
    -- Метка для отображения выбранной цели (можно обновлять)
    AutoTab:CreateLabel("Selected Rebirth Target:", "square-mouse-pointer")

    -- Секция 3: Infinite Rebirths
    AutoTab:CreateSection("Infinity Rebirths")

    AutoTab:CreateParagraph({
        Title = "Information:",
        Content = [[
        Infinity rebirths – constantly performs rebirths without any specific goal or target.
        ]],
    })

    -- Тоггл Infinite
    local Toggle3 = AutoTab:CreateToggle({
        Name = "Auto Rebirth Infinity",
        CurrentValue = false,
        Flag = "ToggleRebirth3",
        Callback = function(Value)
            if Value then
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Auto Rebirth Infinite Enabled!",
                    Duration = 6.5,
                    Image = "check",
                })
                state.Input1Enabled = false
                state.Dropdown1Enabled = false
                if toggles.Toggle1 then toggles.Toggle1:Set(false) end
                if toggles.Toggle2 then toggles.Toggle2:Set(false) end
                state.InfiniteEnabled = true
                task.spawn(function()
                    while state.InfiniteEnabled do
                        doRebirth()
                        task.wait(0.1)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                Rayfield:Notify({
                    Title = "Success!",
                    Content = "Auto Rebirth Infinite Disabled!",
                    Duration = 6.5,
                    Image = "check",
                })
                state.InfiniteEnabled = false
            end
        end,
    })
    toggles.Toggle3 = Toggle3

    print("Cloud Oxygen Hub: 3 / 4 Rebirth.Lua")
    -- Секция статуса (можно дополнить позже)
    AutoTab:CreateSection("Rebirth Status")

    -- Получаем leaderstats (гарантируем наличие)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = player:WaitForChild("leaderstats")
    end

    -- Начальные значения
    local startTime = tick()
    local rebirthsStat = leaderstats:FindFirstChild("Rebirths")
    if not rebirthsStat then
        rebirthsStat = leaderstats:WaitForChild("Rebirths")
    end
    local initialRebirths = rebirthsStat.Value

    -- Создаём лейблы с уникальными именами и сохраняем ссылки
    local timeLabel = AutoTab:CreateLabel("Time: 0d 0h 0m 0s")
    timeLabel.TextSize = 16

    local currentLabel = AutoTab:CreateLabel("Current Rebirths: 0")
    currentLabel.TextSize = 16

    local gainedLabel = AutoTab:CreateLabel("Gained Rebirths: 0")
    gainedLabel.TextSize = 16

    -- Цикл обновления
    task.spawn(function()
        while true do
            -- Время
            local elapsed = tick() - startTime
            local days = math.floor(elapsed / 86400)
            local hours = math.floor((elapsed % 86400) / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = math.floor(elapsed % 60)
            local timeStr = string.format("Time: %dd %dh %dm %ds", days, hours, minutes, seconds)

            -- Текущие ребирты
            local current = rebirthsStat.Value
            local currentStr = "Current Rebirths: " .. tostring(current)

            -- Получено ребиртов
            local gained = current - initialRebirths
            local gainedStr = "Gained Rebirths: " .. tostring(gained)

            -- Обновление через :Set() (если метод существует)
            if timeLabel.Set then
                timeLabel:Set(timeStr)
                currentLabel:Set(currentStr)
                gainedLabel:Set(gainedStr)
            else
                -- fallback на прямое присвоение
                timeLabel.Text = timeStr
                currentLabel.Text = currentStr
                gainedLabel.Text = gainedStr
            end
            task.wait(1) -- обновление раз в секунду
        end
    end)

    print("Cloud Oxygen Hub: 4 / 4 Rebirth.Lua")

    print("Cloud Oxygen Hub: Loaded Rebirth.Lua Module Successfully!")
end
