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
        --[[
            ЗАМЕТКА: Выпадающие списки Rayfield, похоже, не поддерживают динамическое обновление через SetOptions.
            Эта функция отключена, чтобы предотвратить ошибки. Список игроков будет таким,
            каким он был на момент загрузки скрипта.
        ]]
        -- if playerDropdown then
        --     playerDropdown:SetOptions(getPlayerDisplayNames())
        -- end
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
        Strength = StatusTab:CreateParagraph({Content = "Strength: N/A"}),
        Gems = StatusTab:CreateParagraph({Content = "Gems: N/A"}),
        Rebirths = StatusTab:CreateParagraph({Content = "Rebirths: N/A"}),
        Durability = StatusTab:CreateParagraph({Content = "Durability: N/A"}),
        Agility = StatusTab:CreateParagraph({Content = "Agility: N/A"}),
        Kills = StatusTab:CreateParagraph({Content = "Kills: N/A"}),
        CurrentMap = StatusTab:CreateParagraph({Content = "Current Map: N/A"}),
        Size = StatusTab:CreateParagraph({Content = "Size: N/A"}),
        Speed = StatusTab:CreateParagraph({Content = "Speed: N/A"}),
        GoodKarma = StatusTab:CreateParagraph({Content = "Good Karma: N/A"}),
        EvilKarma = StatusTab:CreateParagraph({Content = "Evil Karma: N/A"}),
    }

    -- // Логика обновления \\ --
    local function updateStats()
        local targetPlayer = selectedPlayerName and Players:FindFirstChild(selectedPlayerName)

        -- Если игрок не выбран или вышел, сбрасываем все значения
        if not targetPlayer then
            statsLabels.Strength:Set({Content = "Strength: N/A"})
            statsLabels.Gems:Set({Content = "Gems: N/A"})
            statsLabels.Rebirths:Set({Content = "Rebirths: N/A"})
            statsLabels.Durability:Set({Content = "Durability: N/A"})
            statsLabels.Agility:Set({Content = "Agility: N/A"})
            statsLabels.Kills:Set({Content = "Kills: N/A"})
            statsLabels.CurrentMap:Set({Content = "Current Map: N/A"})
            statsLabels.Size:Set({Content = "Size: N/A"})
            statsLabels.Speed:Set({Content = "Speed: N/A"})
            statsLabels.GoodKarma:Set({Content = "Good Karma: N/A"})
            statsLabels.EvilKarma:Set({Content = "Evil Karma: N/A"})
            return
        end

        -- Безопасное получение и форматирование статов
        local function getStat(statName, isLeaderstat)
            local statHolder = isLeaderstat and targetPlayer:FindFirstChild("leaderstats") or targetPlayer
            local stat = statHolder and statHolder:FindFirstChild(statName, true)
            if stat and stat.Value ~= nil then
                return stat.Value
            end
            return "N/A"
        end

        local leaderstats = targetPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            statsLabels.Strength:Set({Content = "Strength: " .. FormatDisplay(getStat("Strength", true))})
            statsLabels.Rebirths:Set({Content = "Rebirths: " .. FormatDisplay(getStat("Rebirths", true))})
            statsLabels.Kills:Set({Content = "Kills: " .. FormatDisplay(getStat("Kills", true))})
        else
            statsLabels.Strength:Set({Content = "Strength: N/A"})
            statsLabels.Rebirths:Set({Content = "Rebirths: N/A"})
            statsLabels.Kills:Set({Content = "Kills: N/A"})
        end

        statsLabels.Gems:Set({Content = "Gems: " .. FormatDisplay(getStat("Gems"))})
        statsLabels.Durability:Set({Content = "Durability: " .. FormatDisplay(getStat("Durability"))})
        statsLabels.Agility:Set({Content = "Agility: " .. FormatDisplay(getStat("Agility"))})
        statsLabels.CurrentMap:Set({Content = "Current Map: " .. tostring(getStat("currentMap"))})
        statsLabels.Size:Set({Content = "Size: " .. FormatDisplay(getStat("customSize"))})
        statsLabels.Speed:Set({Content = "Speed: " .. FormatDisplay(getStat("customSpeed"))})
        statsLabels.GoodKarma:Set({Content = "Good Karma: " .. FormatDisplay(getStat("goodKarma"))})
        statsLabels.EvilKarma:Set({Content = "Evil Karma: " .. FormatDisplay(getStat("evilKarma"))})
    end

    task.spawn(function()
        while task.wait(0.5) do
            if StatusTab.Visible then -- Обновляем только если вкладка видима для экономии ресурсов
                updateStats()
            end
        end
    end)

    -- Players.PlayerAdded:Connect(updatePlayerDropdown)
    -- Players.PlayerRemoving:Connect(updatePlayerDropdown)

    print("Global Scripts: 1 / 1 Status.lua")
    print("Global Scripts: Loaded Status.lua")
end
