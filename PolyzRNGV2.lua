-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()

-- UI Window Configuration
local Window = Rayfield:CreateWindow({
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

-- Utility Functions
local function getEquippedWeaponName()
    local model = workspace:FindFirstChild("Players"):FindFirstChild(player.Name)
    if model then
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("Model") then
                return child.Name
            end
        end
    end
    return "M1911"
end

-- Combat Tab
local CombatTab = Window:CreateTab("⚔️ Combat", "Skull")

-- Stealth Information
CombatTab:CreateLabel("🛡️ OPTIMIZED STEALTH MODE:")
CombatTab:CreateLabel("✅ 360° Camera Coverage | ✅ Smooth Movement | ✅ Toggleable System")
CombatTab:CreateLabel("✅ Anti-Cheat Bypass | ✅ Weapon Fire Rates | ✅ Human Behavior")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
        task.wait(0.1)
    end
end)

-- Auto Headshots (STEALTH)
local autoKill = false
local shootDelay = 0.15
local lastShotTime = 0
local shotsFired = 0
local weaponFireRates = {
    ["M1911"] = 0.133,
    ["AK47"] = 0.120,
    ["M4A1"] = 0.100,
    ["G36C"] = 0.086,
    ["MAC10"] = 0.075,
    ["UMP45"] = 0.080,
    ["MP5"] = 0.086,
    ["AUG"] = 0.086,
    ["FAMAS"] = 0.069,
    ["P90"] = 0.075,
    ["SCAR"] = 0.109,
    ["G3"] = 0.133,
    ["M249"] = 0.133,
    ["AWP"] = 1.714,
    ["M16"] = 0.109
}

-- Get weapon fire rate with jitter
local function getWeaponFireDelay(weaponName)
    local baseDelay = weaponFireRates[weaponName] or 0.12
    local jitter = math.random(90, 110) * 0.01 -- ±10% jitter
    return baseDelay * jitter
end

-- Check if we can shoot (cooldown validation)
local function canShoot()
    local currentTime = tick()
    local weaponName = getEquippedWeaponName()
    local requiredDelay = getWeaponFireDelay(weaponName)
    return (currentTime - lastShotTime) >= requiredDelay
end

-- Optimized camera hijacking system for legitimate raycasts
local AimAssist = {Enabled = false, Target = nil}
local lastCameraUpdate = 0
local cameraSmoothing = 0.15
local humanReactionTime = math.random(8, 15) * 0.01

-- Optimized camera system with 360-degree coverage
game:GetService("RunService").RenderStepped:Connect(function()
    if AimAssist.Enabled and AimAssist.Target and AimAssist.Target.PrimaryPart then
        local currentTime = tick()
        
        -- Variable reaction time for human-like behavior
        if currentTime - lastCameraUpdate > humanReactionTime then
            local targetPos = AimAssist.Target.PrimaryPart.Position
            local currentPos = workspace.CurrentCamera.CFrame.Position
            local distance = (targetPos - currentPos).Magnitude
            
            -- Calculate direction with 360-degree coverage
            local direction = (targetPos - currentPos).Unit
            local currentLookDirection = workspace.CurrentCamera.CFrame.LookVector
            
            -- Smooth interpolation for natural movement
            local interpolatedDirection = currentLookDirection:Lerp(direction, cameraSmoothing)
            
            -- Add slight randomization for realism (reduced for smoother movement)
            local randomOffset = Vector3.new(
                math.random(-1, 1) * 0.05,
                math.random(-1, 1) * 0.05,
                math.random(-1, 1) * 0.05
            )
            
            -- Create smooth camera movement
            local targetCFrame = CFrame.new(currentPos, currentPos + interpolatedDirection + randomOffset)
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCFrame, 0.2)
            
            lastCameraUpdate = currentTime
            -- Reset reaction time for next update
            humanReactionTime = math.random(8, 15) * 0.01
        end
    end
end)

-- Text input for shot delay (STEALTH)
CombatTab:CreateInput({
    Name = "⏱️ Shot delay (0.15-2 sec)",
    PlaceholderText = "0.15",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.15 and num <= 2 then
            shootDelay = num
            Rayfield:Notify({
                Title = "Success",
                Content = "Shot delay set to "..num.." seconds",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a number between 0.15 and 2",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

-- Camera hijacking toggle
local useCameraHijacking = true

CombatTab:CreateToggle({
    Name = "📹 Camera Hijacking",
    CurrentValue = true,
    Flag = "CameraHijacking",
    Callback = function(state)
        useCameraHijacking = state
        Rayfield:Notify({
            Title = "Camera System",
            Content = "Camera hijacking " .. (state and "enabled" or "disabled"),
            Duration = 2,
            Image = 4483362458
        })
    end
})

CombatTab:CreateToggle({
    Name = "🔪 Auto Headshots (STEALTH)",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                while autoKill do
                    -- Check if we can shoot (cooldown validation)
                    if not canShoot() then
                        task.wait(0.05)
                        continue
                    end
                    
                    local enemies = workspace:FindFirstChild("Enemies")
                    local shootRemote = Remotes:FindFirstChild("ShootEnemy")
                    
                    if enemies and shootRemote then
                        local weapon = getEquippedWeaponName()
                        local closestZombie = nil
                        local closestHead = nil
                        local minDist = math.huge
                        local playerPos = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position
                        
                        if not playerPos then
                            task.wait(0.1)
                            continue
                        end
                        
                        -- Find closest zombie (more human-like)
                        for _, zombie in pairs(enemies:GetChildren()) do
                            if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
                                local head = zombie.Head
                                local humanoid = zombie:FindFirstChildOfClass("Humanoid")
                                
                                -- Check if zombie is alive
                                if humanoid and humanoid.Health > 0 then
                                    local distance = (head.Position - playerPos).Magnitude
                                    
                                    -- Only target zombies within reasonable range
                                    if distance < 200 and distance < minDist then
                                        minDist = distance
                                        closestZombie = zombie
                                        closestHead = head
                                    end
                                end
                            end
                        end
                        
                        -- Shoot closest zombie with OPTIMIZED CAMERA SYSTEM
                        if closestZombie and closestHead then
                            -- Add human-like miss chance (5-15% based on distance)
                            local missChance = math.random(1, 100)
                            local distanceMissChance = math.min(minDist / 10, 15) -- +1% per 10 studs, max 15%
                            local totalMissChance = 5 + distanceMissChance
                            
                            if missChance > totalMissChance then
                                local success = false
                                
                                if useCameraHijacking then
                                    -- OPTIMIZED CAMERA HIJACKING (shorter duration)
                                    AimAssist.Enabled = true
                                    AimAssist.Target = closestZombie
                                    
                                    -- Shorter aim time for better performance
                                    task.wait(math.random(8, 15) * 0.01)
                                    
                                    -- PERFORM EXACT GAME RAYCAST (CRITICAL FOR ANTI-CHEAT BYPASS)
                                    local camera = workspace.CurrentCamera
                                    local cameraPos = camera.CFrame.Position
                                    local lookDirection = camera.CFrame.LookVector
                                    
                                    -- EXACT GAME RAYCAST PARAMETERS
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterType = Enum.RaycastFilterType.Include
                                    raycastParams.FilterDescendantsInstances = {workspace.Enemies, workspace.Misc, workspace.BossArena.Decorations}
                                    
                                    -- Perform raycast from camera (EXACT GAME METHOD)
                                    local raycastResult = workspace:Raycast(cameraPos, lookDirection * 250, raycastParams)
                                    
                                    -- Only fire if raycast hits the target (EXACT GAME VALIDATION)
                                    if raycastResult and raycastResult.Instance:IsDescendantOf(workspace.Enemies) then
                                        -- Use EXACT GAME PARAMETERS
                                        local args = {
                                            raycastResult.Instance.Parent,  -- zombie model
                                            raycastResult.Instance,        -- hit part
                                            raycastResult.Position,        -- hit position
                                            0,                            -- damage multiplier (EXACT GAME VALUE)
                                            weapon                        -- weapon name
                                        }
                                        
                                        success = pcall(function() 
                                            shootRemote:FireServer(unpack(args)) 
                                        end)
                                    end
                                    
                                    -- Immediately disable camera hijacking for better performance
                                    AimAssist.Enabled = false
                                    AimAssist.Target = nil
                                    
                                    -- Add small delay to prevent rapid camera switching
                                    task.wait(math.random(5, 10) * 0.01)
                                else
                                    -- SIMPLE DIRECT SHOOTING (no camera hijacking)
                                    local args = {closestZombie, closestHead, closestHead.Position, 0, weapon}
                                    success = pcall(function() 
                                        shootRemote:FireServer(unpack(args)) 
                                    end)
                                end
                                
                                if success then
                                    lastShotTime = tick()
                                    shotsFired = shotsFired + 1
                                    
                                    -- Take breaks occasionally (human-like behavior)
                                    if shotsFired >= math.random(8, 15) then
                                        task.wait(math.random(20, 50) * 0.01) -- 0.2-0.5s break
                                        shotsFired = 0
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Variable delay for stealth
                    local delay = shootDelay + math.random(-5, 5) * 0.01 -- ±0.05s jitter
                    task.wait(math.max(0.05, delay))
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
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Value
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
        if not vars then return end

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
        if not vars then return end

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
        if not vars then return end

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
        if not gunData then return end

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
