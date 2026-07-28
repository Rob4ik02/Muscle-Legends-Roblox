return function(Env)
    local StatusTab = Env.Tabs.Status
    local player = Env.player
    local Players = game:GetService("Players")

    
    print("Global Scripts: Loading Status.lua")
    print("Global Scripts: 0 / 1 Status.lua")

    StatusTab:CreateSection("")
    StatusTab:CreateLabel("Status Plr Category", "user-search")
    StatusTab:CreateSection("Status Player")

    -- // Функции форматирования чисел (взяты из чужого скрипта) \\ --
    local function FormatNumberWithCommas(number)
        if type(number) ~= "number" then return tostring(number) end
        local s = tostring(math.floor(number))
        return s:reverse():gsub("(...)", "%1,"):reverse():gsub("^,", "")
    end

    local function FormatAbbreviated(number)
        if type(number) ~= "number" then return tostring(number) end
        local abbreviations = {"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"}
        local i = 1
        while number >= 1000 and i < #abbreviations do
            number = number / 1000
            i = i + 1
        end
        return string.format("%.2f", number) .. abbreviations[i]
    end

    local function FormatDisplay(value)
        if type(value) ~= "number" then return tostring(value) end
        local normal = FormatNumberWithCommas(value)
        local abbreviated = FormatAbbreviated(value)
        return normal .. " (" .. abbreviated .. ")"
    end

    -- // UI Элементы \\ --
    local selectedPlayerName = nil
    local playerDropdown -- Предварительно объявляем переменную

    -- Функция обновления списка игроков в дропдауне
    local function updatePlayerDropdown()
        if playerDropdown then -- Проверяем, что дропдаун уже создан
            playerDropdown:SetOptions(getPlayerDisplayNames())
        end
    end
    
    local function getPlayerDisplayNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            table.insert(names, p.DisplayName .. " (@" .. p.Name .. ")")
        end
        return names
    end

    playerDropdown = StatusTab:CreateDropdown({
        Name = "Select Player",
        Options = getPlayerDisplayNames(),
        CurrentOption = {},
        MultipleOptions = false,
        Flag = "StatusPlayerDropdown",
        Callback = function(options)
            local selection = options[1]
            if selection then
                -- Извлекаем реальный ник из "DisplayName (@Username)"
                selectedPlayerName = selection:match("@(.-)%)")
            else
                selectedPlayerName = nil
            end
        end,
    })

    StatusTab:CreateDivider()

    -- Создаем лейблы для каждого стата
    local statsLabels = {
        Strength = StatusTab:CreateLabel("Strength: N/A"),
        Gems = StatusTab:CreateLabel("Gems: N/A"),
        Rebirths = StatusTab:CreateLabel("Rebirths: N/A"),
        Durability = StatusTab:CreateLabel("Durability: N/A"),
        Agility = StatusTab:CreateLabel("Agility: N/A"),
        Kills = StatusTab:CreateLabel("Kills: N/A"),
        CurrentMap = StatusTab:CreateLabel("Current Map: N/A"),
        Size = StatusTab:CreateLabel("Size: N/A"),
        Speed = StatusTab:CreateLabel("Speed: N/A"),
        GoodKarma = StatusTab:CreateLabel("Good Karma: N/A"),
        EvilKarma = StatusTab:CreateLabel("Evil Karma: N/A"),
    }

    -- // Логика обновления \\ --
    local function updateStats()
        local targetPlayer = selectedPlayerName and Players:FindFirstChild(selectedPlayerName)

        if not targetPlayer then
            for _, label in pairs(statsLabels) do
                label:Set(label.Name:gsub(": .*", ": N/A"))
            end
            return
        end

        local leaderstats = targetPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            statsLabels.Strength:Set("Strength: " .. FormatDisplay(leaderstats:FindFirstChild("Strength", true).Value))
            statsLabels.Rebirths:Set("Rebirths: " .. FormatDisplay(leaderstats:FindFirstChild("Rebirths", true).Value))
            statsLabels.Kills:Set("Kills: " .. FormatDisplay(leaderstats:FindFirstChild("Kills", true).Value))
        end

        statsLabels.Gems:Set("Gems: " .. FormatDisplay(targetPlayer:FindFirstChild("Gems", true).Value))
        statsLabels.Durability:Set("Durability: " .. FormatDisplay(targetPlayer:FindFirstChild("Durability", true).Value))
        statsLabels.Agility:Set("Agility: " .. FormatDisplay(targetPlayer:FindFirstChild("Agility", true).Value))
        statsLabels.CurrentMap:Set("Current Map: " .. tostring(targetPlayer:FindFirstChild("currentMap", true).Value))
        statsLabels.Size:Set("Size: " .. FormatDisplay(targetPlayer:FindFirstChild("customSize", true).Value))
        statsLabels.Speed:Set("Speed: " .. FormatDisplay(targetPlayer:FindFirstChild("customSpeed", true).Value))
        statsLabels.GoodKarma:Set("Good Karma: " .. FormatDisplay(targetPlayer:FindFirstChild("goodKarma", true).Value))
        statsLabels.EvilKarma:Set("Evil Karma: " .. FormatDisplay(targetPlayer:FindFirstChild("evilKarma", true).Value))
    end

    task.spawn(function()
        while task.wait(0.5) do
            if StatusTab.Visible then -- Обновляем только если вкладка видима для экономии ресурсов
                updateStats()
            end
        end
    end)

    Players.PlayerAdded:Connect(updatePlayerDropdown)
    Players.PlayerRemoving:Connect(updatePlayerDropdown)

    print("Global Scripts: 1 / 1 Status.lua")
    print("Global Scripts: Loaded Status.lua")
end
