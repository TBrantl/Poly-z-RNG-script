-- Poly-z RNG Script V2 - Fixed Version
print("[Poly-z RNG V2] Script starting...")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Wait for Remotes with error handling
local Remotes
local success, error = pcall(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10) -- 10 second timeout
end)

if not success or not Remotes then
    warn("Failed to find Remotes folder, script may not work properly")
    -- Create a dummy remotes table to prevent errors
    Remotes = {
        FindFirstChild = function() return nil end,
        ShootEnemy = { FireServer = function() end }
    }
end

-- Load Rayfield UI Library with error handling
local Rayfield, Window
local success, error = pcall(function()
    -- Try multiple Rayfield sources for better compatibility
    local rayfieldSources = {
        'https://limerbro.github.io/Roblox-Limer/rayfield.lua',
        'https://sirius.menu/rayfield',
        'https://raw.githubusercontent.com/shlexware/Rayfield/main/source'
    }
    
    for i, source in ipairs(rayfieldSources) do
        local success, result = pcall(function()
            return loadstring(game:HttpGet(source))()
        end)
        
        if success and result then
            Rayfield = result
            break
        end
    end
    
    if not Rayfield then
        error("Failed to load Rayfield from any source")
    end
    
    -- UI Window Configuration
    Window = Rayfield:CreateWindow({
        Name = "✨ LimerHub ✨ | POLY-Z",
        Icon = 71338090068856,
        LoadingTitle = "Loading...",
        LoadingSubtitle = "Author: LimerBoy",
        Theme = "BlackWhite",
        ToggleUIKeybind = Enum.KeyCode.K,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "ZombieHub",
            FileName = "Config"
        }
    })
end)

if not success then
    warn("Failed to load Rayfield UI:", error)
    -- Create a fallback notification system
    game.StarterGui:SetCore("SendNotification", {
        Title = "Script Error",
        Text = "Failed to load Rayfield UI. Please check your internet connection and try again.",
        Duration = 5
    })
    return
end

-- Success notification
pcall(function()
    Rayfield:Notify({
        Title = "Script Loaded",
        Content = "Poly-z RNG Script loaded successfully! Press K to toggle GUI.",
        Duration = 5,
        Image = 4483362458
    })
end)

-- Utility Functions
local function getEquippedWeaponName()
    local success, result = pcall(function()
        local playersFolder = workspace:FindFirstChild("Players")
        if not playersFolder then return "M1911" end
        
        local model = playersFolder:FindFirstChild(player.Name)
        if not model then return "M1911" end
        
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("Model") then
                return child.Name
            end
        end
        return "M1911"
    end)
    
    return success and result or "M1911"
end

-- Combat Tab
local CombatTab = Window:CreateTab("⚔️ Combat", "Skull")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        local weapon = getEquippedWeaponName()
        if weapon and weapon ~= "" then
            weaponLabel:Set("🔫 Current Weapon: " .. tostring(weapon))
        else
            weaponLabel:Set("🔫 Current Weapon: Unknown")
        end
        task.wait(0.1)
    end
end)

-- Auto Headshots
local autoKill = false
local autoSkip = false
local shootDelay = 0.1

-- Text input for shot delay
CombatTab:CreateInput({
    Name = "⏱️ Shot delay (0-2 sec)",
    PlaceholderText = "0.1",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0 and num <= 2 then
            shootDelay = num
            Rayfield:Notify({
                Title = "Success",
                Content = "Shot delay set to " .. tostring(num) .. " seconds",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a number between 0 and 2",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateToggle({
    Name = "🔪 Auto Headshots",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                while autoKill do
                    local enemies = workspace:FindFirstChild("Enemies")
                    local shootRemote = Remotes:FindFirstChild("ShootEnemy")
                    if enemies and shootRemote then
                        local weapon = getEquippedWeaponName()
                        if weapon then
                            for _, zombie in pairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") then
                                    local head = zombie:FindFirstChild("Head")
                                    if head then
                                        local args = {zombie, head, head.Position, 0.5, weapon}
                                        pcall(function() shootRemote:FireServer(unpack(args)) end)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(shootDelay)
                end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "⏩ Auto Skip Round",
    CurrentValue = false,
    Flag = "AutoSkipRound",
    Callback = function(state)
        autoSkip = state
        if state then
            task.spawn(function()
                while autoSkip do
                    local skip = Remotes:FindFirstChild("CastClientSkipVote")
                    if skip then
                        pcall(function() skip:FireServer() end)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

CombatTab:CreateSlider({
    Name = "🏃‍♂️ Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("✨ Utilities", "Sparkles")

MiscTab:CreateSection("🔧 Tools")

MiscTab:CreateButton({
    Name = "🚪 Delete All Doors",
    Callback = function()
        local doorsFolder = workspace:FindFirstChild("Doors")
        if doorsFolder then
            for _, group in pairs(doorsFolder:GetChildren()) do
                if group:IsA("Folder") or group:IsA("Model") then
                    group:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "Success",
                Content = "All doors deleted!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

MiscTab:CreateButton({
    Name = "🎯 Infinite Magazines",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then 
            Rayfield:Notify({
                Title = "Error",
                Content = "Variables not found!",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        local ammoAttributes = {  
            "Primary_Mag",  
            "Secondary_Mag"  
        }  

        for _, attr in ipairs(ammoAttributes) do  
            if vars:GetAttribute(attr) ~= nil then  
                vars:SetAttribute(attr, 100000000)  
            end  
        end
        Rayfield:Notify({
            Title = "Magazines",
            Content = "Infinite magazines set!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateSection("💎 Enhancements Visual")

MiscTab:CreateButton({
    Name = "🌟 Activate All Perks",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then 
            Rayfield:Notify({
                Title = "Error",
                Content = "Variables not found!",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        local perks = {  
            "Bandoiler_Perk",  
            "DoubleUp_Perk",  
            "Haste_Perk",  
            "Tank_Perk",  
            "GasMask_Perk",  
            "DeadShot_Perk",  
            "DoubleMag_Perk",  
            "WickedGrenade_Perk"  
        }  

        for _, perk in ipairs(perks) do  
            if vars:GetAttribute(perk) ~= nil then  
                vars:SetAttribute(perk, true)  
            end  
        end
        Rayfield:Notify({
            Title = "Perks",
            Content = "All perks activated!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateButton({
    Name = "🔫 Enhance Weapons",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then 
            Rayfield:Notify({
                Title = "Error",
                Content = "Variables not found!",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        local enchants = {  
            "Primary_Enhanced",  
            "Secondary_Enhanced"  
        }  

        for _, attr in ipairs(enchants) do  
            if vars:GetAttribute(attr) ~= nil then  
                vars:SetAttribute(attr, true)  
            end  
        end
        Rayfield:Notify({
            Title = "Enhancement",
            Content = "Weapons enhanced!",
            Duration = 3,
            Image = 4483362458
        })
    end
})


MiscTab:CreateButton({
    Name = "💫 Celestial Weapons",
    Callback = function()
        local gunData = player:FindFirstChild("GunData")
        if not gunData then 
            Rayfield:Notify({
                Title = "Error",
                Content = "GunData not found!",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        for _, value in ipairs(gunData:GetChildren()) do  
            if value:IsA("StringValue") then  
                value.Value = "celestial"  
            end  
        end
        Rayfield:Notify({
            Title = "Weapons",
            Content = "Set to Celestial tier!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Open Tab
local OpenTab = Window:CreateTab("🎁 Crates", "Gift")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local selectedQuantity = 1
local selectedOutfitType = "Random" -- для Outfit кейсів

OpenTab:CreateDropdown({
    Name = "🔢 Open Quantity",
    Options = {"1", "25", "50", "200"},
    CurrentOption = "1",
    Flag = "OpenQuantity",
    Callback = function(Option)
        selectedQuantity = tonumber(Option)
    end,
})

OpenTab:CreateSection("📦 Auto Open Crates")

-- 🎽 Випадаючий список типів для Outfit кейсів
OpenTab:CreateDropdown({
    Name = "👕 Outfit Type",
    Options = {
        "Random", "Hat", "torseaccessory", "legaccessory", "faceaccessory", 
        "armaccessory", "backaccessory", "gloves", "shoes", "hair",
        "shirt", "pants", "haircolor", "skincolor", "face"
    },
    CurrentOption = "Random",
    Callback = function(option)
        selectedOutfitType = option
    end,
})

-- 🕶️ Camo Crates
local autoOpenCamo = false
OpenTab:CreateToggle({
    Name = "🕶️ Camo Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenCamo = state
        if state then
            task.spawn(function()
                while autoOpenCamo do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            ReplicatedStorage.Remotes.OpenCamoCrate:InvokeServer("Random")
                            task.wait(0.1)
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- 👕 Outfit Crates
local autoOpenOutfit = false
OpenTab:CreateToggle({
    Name = "👕 Outfit Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenOutfit = state
        if state then
            task.spawn(function()
                while autoOpenOutfit do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            ReplicatedStorage.Remotes.OpenOutfitCrate:InvokeServer(selectedOutfitType)
                            task.wait(0.1)
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- 🐾 Pet Crates
local autoOpenPet = false
OpenTab:CreateToggle({
    Name = "🐾 Pet Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenPet = state
        if state then
            task.spawn(function()
                while autoOpenPet do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            ReplicatedStorage.Remotes.OpenPetCrate:InvokeServer(1)
                            task.wait(0.1)
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- 🔫 Weapon Crates
local autoOpenGun = false
OpenTab:CreateToggle({
    Name = "🔫 Weapon Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenGun = state
        if state then
            task.spawn(function()
                while autoOpenGun do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            ReplicatedStorage.Remotes.OpenGunCrate:InvokeServer(1)
                            task.wait(0.1)
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})


-- Mod Tab
local ModTab = Window:CreateTab("🌀 Mods", "Skull")

-- ⬇ Змінні оголошуються глобально (всередині скрипта, але поза функціями)
local spinning = false
local angle = 0
local speed = 5      -- ✅ глобально
local radius = 15    -- ✅ глобально

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local HRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    HRP = char:WaitForChild("HumanoidRootPart")
end)

-- 🔁 Головне коло
RunService.RenderStepped:Connect(function(dt)
    if spinning and HRP then
        local function findNearestBoss()
            local bosses = {
                workspace.Enemies:FindFirstChild("GoblinKing"),
                workspace.Enemies:FindFirstChild("CaptainBoom"),
                workspace.Enemies:FindFirstChild("Fungarth")
            }

            local nearestBoss = nil
            local shortestDistance = math.huge

            for _, boss in pairs(bosses) do
                if boss and boss:FindFirstChild("Head") then
                    local distance = (boss.Head.Position - HRP.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestBoss = boss
                    end
                end
            end
            return nearestBoss
        end

        local boss = findNearestBoss()
        if boss and boss:FindFirstChild("Head") then
            angle += dt * speed  -- ✅ використовує глобальну змінну
            local bossPos = boss.Head.Position
            local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius -- ✅ радіус
            local orbitPos = bossPos + offset
            HRP.CFrame = CFrame.new(Vector3.new(orbitPos.X, bossPos.Y, orbitPos.Z), bossPos)
        end
    end
end)

-- 🔘 Кнопка в меню
ModTab:CreateToggle({
    Name = "🌪️ Orbit Around Boss",
    CurrentValue = false,
    Callback = function(value)
        spinning = value
    end
})

-- ⚙️ Слайдер швидкості
ModTab:CreateSlider({
    Name = "⚡ Rotation Speed",
    Range = {1, 20},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 5,
    Callback = function(val)
        speed = val   -- ✅ оновлює глобальну змінну
    end
})

-- 📏 Слайдер радіуса
ModTab:CreateSlider({
    Name = "📏 Orbit Radius",
    Range = {5, 100},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 15,
    Callback = function(val)
        radius = val  -- ✅ оновлює глобальну змінну
    end
})


ModTab:CreateButton({
    Name = "🛸 TP & Smart Platform",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local HRP = player.Character and player.Character:WaitForChild("HumanoidRootPart")

        if not HRP then
            warn("❌ HumanoidRootPart не знайдено")
            return
        end

        local currentPos = HRP.Position
        local targetPos = currentPos + Vector3.new(0, 60, 0)

        -- 🧱 Створюємо платформу
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(20, 1, 20)
        platform.Anchored = true
        platform.Position = targetPos - Vector3.new(0, 2, 0)
        platform.Color = Color3.fromRGB(120, 120, 120)
        platform.Material = Enum.Material.Metal
        platform.Name = "SmartPlatform"
        platform.Parent = workspace

        -- ⏫ Телепорт гравця трохи вище платформи
        HRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))

        -- ⏱️ Таймер самознищення, коли гравець сходить
        local isStanding = true
        local lastTouch = tick()

        -- Перевірка кожен кадр
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not platform or not platform.Parent then
                conn:Disconnect()
                return
            end

            local char = player.Character
            local humanoidRoot = char and char:FindFirstChild("HumanoidRootPart")
            if not humanoidRoot then return end

            local rayOrigin = humanoidRoot.Position
            local rayDirection = Vector3.new(0, -5, 0)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            if raycastResult and raycastResult.Instance == platform then
                -- Гравець стоїть на платформі
                lastTouch = tick()
            end

            -- Якщо пройшло більше 10 секунд після того, як гравець стояв — видалити
            if tick() - lastTouch > 10 then
                platform:Destroy()
                conn:Disconnect()
            end
        end)
    end
})




-- Load config
Rayfield:LoadConfiguration()