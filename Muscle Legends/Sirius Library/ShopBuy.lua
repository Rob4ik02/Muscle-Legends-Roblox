return function(Env)

    local AutoTab = Env.Tabs.Auto --3
  	local HomeTab = Env.Tabs.Home -- 1
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

    print("Global Scripts: Loading Shop.lua")
    print("Global Scripts: 0 / 1 Shop.Lua")

    -- =============================================================================
    -- ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ
    -- =============================================================================

    local function notify(title, content, duration, image)
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3,
            Image = image or "check"
        })
    end

    -- Получение гемов
    local function getPlayerGems()
        local gems = player:FindFirstChild("Gems")
        if not gems then
            gems = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Gems")
        end
        return gems and gems.Value or 0
    end

    -- Поиск remote и папки
    local function getPetShopRemote()
        local names = {"cPetShopRemote", "petShopRemote", "PetShopRemote", "shopRemote", "petRemote"}
        for _, name in ipairs(names) do
            local remote = RS:FindFirstChild(name)
            if remote then return remote end
        end
        return nil
    end

    local function getPetShopFolder()
        local names = {"cPetShopFolder", "petShopFolder", "PetShopFolder", "Pets", "shopFolder", "petFolder"}
        for _, name in ipairs(names) do
            local folder = RS:FindFirstChild(name)
            if folder then return folder end
        end
        return nil
    end

    -- =============================================================================
    -- РАЗДЕЛ: PETS
    -- =============================================================================

    ShopTab:CreateSection("  ")
    ShopTab:CreateLabel("Pets Category", "paw-print")
    ShopTab:CreateSection("Auto Buy Pets")

    local petNames = {
        "Orange Hedgehog", "Silver Dog", "Yellow Butterfly", "Red Dragon", "Gold Viking",
        "Blue Birdie", "Dark Golem", "Purple Dragom", "Purple Falcon", "Red Kitty",
        "Blue Bunny", "Green Butterfly", "Orange Pegasus", "Blue Firecaster",
        "Dark Vampy", "Crimson Falcon", "Blue Phoenix", "Golden Phoenix", "Neon Guardian"
    }

    -- ЕДИНСТВЕННЫЕ объявления переменных для PETS
    local selectedPet = petNames[1]
    local selectedPets = {"Orange Hedgehog"}   -- для множественного выбора
    local autoBuyPetActive = false
    local autoBuyPetsActive = false
    local totalBoughtPets = 0
    local totalBoughtPetsMulti = 0

    -- Функция обновления статуса PETS
    local function updatePetStatus()
        if not petStatusParagraph then return end
        local single = selectedPet or "None"
        local multi = table.concat(selectedPets or {"None"}, ", ")
        petStatusParagraph:Set({
            Title = "Status Pets",
            Content = string.format(
                "Buyed Pets: %d\nSelected Pet: %s\nSelected Pets (Multiple): %s",
                totalBoughtPets + totalBoughtPetsMulti,
                single,
                multi
            )
        })
    end

    -- Функция покупки питомца
    local function buyPet(petName)
        petName = petName or selectedPet
        local petShopRemote = getPetShopRemote()
        if not petShopRemote then
            playInterfaceSound("ErrorSound")
            notify("Error", "Pet Shop remote not found!", 5, "x")
            return false
        end
        local petShopFolder = getPetShopFolder()
        if not petShopFolder then
            playInterfaceSound("ErrorSound")
            notify("Error", "Pet Shop folder not found!", 5, "x")
            return false
        end
        local petObject = petShopFolder:FindFirstChild(petName)
        if not petObject then
            playInterfaceSound("ErrorSound")
            notify("Error", "Pet not found: " .. petName, 4, "x")
            return false
        end
        local success, err = pcall(function()
            return petShopRemote:InvokeServer(petObject)
        end)
        if success then
            totalBoughtPets = totalBoughtPets + 1
            playInterfaceSound("NotificationSound")
            notify("Success", "Bought " .. petName, 3, "check")
            updatePetStatus()
            return true
        else
            playInterfaceSound("ErrorSound")
            if err and string.find(string.lower(err), "gem") then
                notify("Not Enough Gems", "You don't have enough gems to buy " .. petName, 4, "x")
            else
                notify("Purchase Failed", "Error: " .. tostring(err), 4, "x")
            end
            return false
        end
    end

    -- Одиночный выбор питомца
    ShopTab:CreateDropdown({
        Name = "Select Pet",
        Options = petNames,
        CurrentOption = {selectedPet},
        MultipleOptions = false,
        Flag = "SelectablePet1Dropdown",
        Callback = function(Options)
            selectedPet = Options[1]
            playInterfaceSound("ButtonClick")
            updatePetStatus()
        end
    })

    -- Тоггл автопокупки (один питомец)
    ShopTab:CreateToggle({
        Name = "Auto Buy Pet",
        CurrentValue = false,
        Flag = "AutoBuyPet1",
        Callback = function(Value)
            autoBuyPetActive = Value
            if Value then
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Pet", "Enabled!", 3, "check")
                task.spawn(function()
                    while autoBuyPetActive do
                        buyPet()
                        task.wait(0.5)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Pet", "Disabled!", 3, "check")
            end
        end
    })

    -- Множественный выбор питомцев
    ShopTab:CreateSection("Variant 2")

    ShopTab:CreateDropdown({
        Name = "Select Pets",
        Options = petNames,
        CurrentOption = selectedPets,
        MultipleOptions = true,
        Flag = "SelectablePets1Dropdown",
        Callback = function(Options)
            selectedPets = Options
            playInterfaceSound("ButtonClick")
            updatePetStatus()
        end
    })

    ShopTab:CreateToggle({
        Name = "Auto Buy Pets",
        CurrentValue = false,
        Flag = "AutoBuyPets1",
        Callback = function(Value)
            autoBuyPetsActive = Value
            if Value then
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Pets", "Enabled!", 3, "check")
                task.spawn(function()
                    while autoBuyPetsActive do
                        for _, petName in ipairs(selectedPets) do
                            if not autoBuyPetsActive then break end
                            local success = buyPet(petName)
                            if success then
                                totalBoughtPetsMulti = totalBoughtPetsMulti + 1
                            end
                            task.wait(0.3)
                        end
                        task.wait(0.5)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Pets", "Disabled!", 3, "check")
            end
        end
    })

    local petStatusParagraph = ShopTab:CreateParagraph({
        Title = "Status Pets",
        Content = [[
        Buyed Pets: 0
        Selected Pet: Orange Hedgehog
        Selected Pets (Multiple): Orange Hedgehog
        ]]
    })
    updatePetStatus()

    -- =============================================================================
    -- РАЗДЕЛ: AURA
    -- =============================================================================

    ShopTab:CreateSection("  ")
    ShopTab:CreateLabel("Aura Category", "fan")
    ShopTab:CreateSection("Auto Buy Aura")

    local auraNames = {
        "Blue Aura", "Green Aura", "Purple Aura", "Red Aura", "Yellow Aura",
        "Ultra Inferno", "Azure Tundra", "Grand Supernova", "Muscle King",
        "Entropic Blast", "Eternal Megastrike"
    }

    -- ЕДИНСТВЕННЫЕ объявления переменных для AURA
    local selectedAura = auraNames[1]
    local selectedAuras = {"Blue Aura"}   -- для множественного выбора
    local autoBuyAuraActive = false
    local autoBuyAurasActive = false
    local totalBoughtAuras = 0
    local totalBoughtAurasMulti = 0

    -- Функция обновления статуса AURA
    local function updateAuraStatus()
        if not auraStatusParagraph then return end
        local single = selectedAura or "None"
        local multi = table.concat(selectedAuras or {"None"}, ", ")
        auraStatusParagraph:Set({
            Title = "Status Aura",
            Content = string.format(
                "Buyed Auras: %d\nSelected Aura: %s\nSelected Auras (Multiple): %s",
                totalBoughtAuras + totalBoughtAurasMulti,
                single,
                multi
            )
        })
    end

    -- Функция покупки ауры
    local function buyAura(auraName)
        auraName = auraName or selectedAura
        local petShopRemote = getPetShopRemote()
        if not petShopRemote then
            playInterfaceSound("ErrorSound")
            notify("Error", "Pet Shop remote not found!", 5, "x")
            return false
        end
        local petShopFolder = getPetShopFolder()
        if not petShopFolder then
            playInterfaceSound("ErrorSound")
            notify("Error", "Pet Shop folder not found!", 5, "x")
            return false
        end
        local auraObject = petShopFolder:FindFirstChild(auraName)
        if not auraObject then
            playInterfaceSound("ErrorSound")
            notify("Error", "Aura not found: " .. auraName, 4, "x")
            return false
        end
        local success, err = pcall(function()
            return petShopRemote:InvokeServer(auraObject)
        end)
        if success then
            totalBoughtAuras = totalBoughtAuras + 1
            playInterfaceSound("NotificationSound")
            notify("Success", "Bought " .. auraName, 3, "check")
            updateAuraStatus()
            return true
        else
            playInterfaceSound("ErrorSound")
            if err and string.find(string.lower(err), "gem") then
                notify("Not Enough Gems", "You don't have enough gems to buy " .. auraName, 4, "x")
            else
                notify("Purchase Failed", "Error: " .. tostring(err), 4, "x")
            end
            return false
        end
    end

    -- Одиночный выбор ауры
    ShopTab:CreateDropdown({
        Name = "Select Aura",
        Options = auraNames,
        CurrentOption = {selectedAura},
        MultipleOptions = false,
        Flag = "SelectableAura1Dropdown",
        Callback = function(Options)
            selectedAura = Options[1]
            playInterfaceSound("ButtonClick")
            updateAuraStatus()
        end
    })

    -- Тоггл автопокупки (одна аура)
    ShopTab:CreateToggle({
        Name = "Auto Buy Aura",
        CurrentValue = false,
        Flag = "AutoBuyAura",
        Callback = function(Value)
            autoBuyAuraActive = Value
            if Value then
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Aura", "Enabled!", 3, "check")
                task.spawn(function()
                    while autoBuyAuraActive do
                        buyAura()
                        task.wait(0.5)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Aura", "Disabled!", 3, "check")
            end
        end
    })

    -- Множественный выбор аур
    ShopTab:CreateSection("Variant 2")

    ShopTab:CreateDropdown({
        Name = "Select Auras",
        Options = auraNames,
        CurrentOption = selectedAuras,
        MultipleOptions = true,
        Flag = "SelectableAuras1Dropdown",
        Callback = function(Options)
            selectedAuras = Options
            playInterfaceSound("ButtonClick")
            updateAuraStatus()
        end
    })

    ShopTab:CreateToggle({
        Name = "Auto Buy Auras",
        CurrentValue = false,
        Flag = "AutoBuyAuras1",
        Callback = function(Value)
            autoBuyAurasActive = Value
            if Value then
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Auras", "Enabled!", 3, "check")
                task.spawn(function()
                    while autoBuyAurasActive do
                        for _, auraName in ipairs(selectedAuras) do
                            if not autoBuyAurasActive then break end
                            local success = buyAura(auraName)
                            if success then
                                totalBoughtAurasMulti = totalBoughtAurasMulti + 1
                            end
                            task.wait(0.3)
                        end
                        task.wait(0.5)
                    end
                end)
            else
                playInterfaceSound("NotificationSound")
                notify("Auto Buy Auras", "Disabled!", 3, "check")
            end
        end
    })

    local auraStatusParagraph = ShopTab:CreateParagraph({
        Title = "Status Aura",
        Content = [[
        Buyed Auras: 0
        Selected Aura: Blue Aura
        Selected Auras (Multiple): Blue Aura
        ]]
    })
    updateAuraStatus()


    print("Global Scripts: 1 / 1 Shop.Lua")
    task.wait(0.5)
    print("Global Scripts: Loaded Shop.lua")

end
