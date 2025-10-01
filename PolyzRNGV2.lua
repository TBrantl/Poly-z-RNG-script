-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- UI Window
local Window = Rayfield:CreateWindow({
    Name = "Hops Hub",
    LoadingTitle = "Launching Hub...",
    LoadingSubtitle = "powered by Rayfield",
    Theme = "DarkBlue",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ZombieHub",
        FileName = "Config"
    }
})

-- Get equipped weapon name
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
local CombatTab = Window:CreateTab("Main", "skull")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
        task.wait(0.1)
    end
end)

-- Ultra-Optimized Auto Headshots (Anti-Detection & Maximum Range)
local autoKill = false
local lastShotTime = 0
local shotsFired = 0
local cachedRemotes = {}
local cachedWeapon = nil
local weaponCacheTime = 0
local rayParams = RaycastParams.new()

-- Configurable parameters for anti-detection
local MIN_ZOMBIE_DISTANCE = 50 -- Keep zombies at least 50 studs away
local SHOT_VARIATION = {min = 0.015, max = 0.035} -- Random delay range
local BURST_VARIATION = {min = 8, max = 15} -- Random burst size
local PAUSE_VARIATION = {min = 0.08, max = 0.2} -- Random pause duration
local HEADSHOT_CHANCE = 0.95 -- Slightly reduced for less predictable patterns

CombatTab:CreateToggle({
    Name = "Auto Headshot Zombies",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                -- Initialize caches with obfuscated names
                cachedRemotes[math.random(1000, 9999)] = workspace:FindFirstChild("Enemies")
                cachedRemotes[math.random(1000, 9999)] = Remotes:FindFirstChild("ShootEnemy")
                
                while autoKill do
                    local enemies = cachedRemotes[cachedRemotes[math.random(1000, 9999)]]
                    local shootRemote = cachedRemotes[cachedRemotes[math.random(1000, 9999)]]
                    local char = player.Character
                    
                    if enemies and shootRemote and char then
                        local primaryPart = char.PrimaryPart
                        if not primaryPart then
                            task.wait(SHOT_VARIATION.min)
                            continue
                        end
                        
                        local humanoid = char.Humanoid
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(SHOT_VARIATION.min)
                            continue
                        end
                        
                        -- Dynamic weapon caching with randomization
                        local currentTime = tick()
                        if not cachedWeapon or currentTime - weaponCacheTime > math.random(0.8, 1.2) then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local playerPos = primaryPart.Position
                        local closestZombie = nil
                        local closestHead = nil
                        local minDistSq = 1000000
                        
                        -- Dynamic raycast filtering
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        -- Optimized zombie scanning with distance check
                        for _, zombie in ipairs(enemies:GetChildren()) do
                            local head = zombie:FindFirstChild("Head")
                            if not head then continue end
                            
                            local delta = head.Position - playerPos
                            local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
                            
                            -- Enforce minimum distance
                            if distSq < MIN_ZOMBIE_DISTANCE * MIN_ZOMBIE_DISTANCE or distSq >= minDistSq then 
                                continue 
                            end
                            
                            -- Advanced raycast with randomized direction
                            local rayDirection = delta + Vector3.new(
                                math.random(-2, 2) * 0.1,
                                math.random(-2, 2) * 0.1,
                                math.random(-2, 2) * 0.1
                            )
                            local rayResult = workspace:Raycast(playerPos, rayDirection, rayParams)
                            
                            if rayResult and rayResult.Instance:IsDescendantOf(zombie) then
                                minDistSq = distSq
                                closestZombie = zombie
                                closestHead = head
                            end
                        end
                        
                        -- Fire with randomized patterns
                        if closestZombie and closestHead then
                            local torso = closestZombie:FindFirstChild("Torso") or closestZombie:FindFirstChild("UpperTorso")
                            
                            if torso then
                                -- Randomized headshot chance
                                local targetPart = math.random() < HEADSHOT_CHANCE and closestHead or torso
                                
                                -- Subtle offset for natural aim
                                local offset = Vector3.new(
                                    math.random(-15, 15) * 0.05,
                                    math.random(-15, 15) * 0.05,
                                    math.random(-15, 15) * 0.05
                                )
                                
                                -- Fire with obfuscated remote call
                                shootRemote:FireServer(
                                    closestZombie,
                                    targetPart,
                                    targetPart.Position + offset,
                                    math.random(1, 3), -- Random damage multiplier
                                    cachedWeapon
                                )
                                
                                shotsFired = shotsFired + 1
                                
                                -- Dynamic burst control
                                if shotsFired >= math.random(BURST_VARIATION.min, BURST_VARIATION.max) then
                                    task.wait(math.random(PAUSE_VARIATION.min * 100, PAUSE_VARIATION.max * 100) * 0.01)
                                    shotsFired = 0
                                end
                            end
                        end
                    else
                        -- Re-cache with randomization
                        local cacheKey1, cacheKey2 = math.random(1000, 9999), math.random(1000, 9999)
                        cachedRemotes[cacheKey1] = cachedRemotes[cacheKey1] or workspace:FindFirstChild("Enemies")
                        cachedRemotes[cacheKey2] = cachedRemotes[cacheKey2] or Remotes:FindFirstChild("ShootEnemy")
                    end
                    
                    -- Randomized delay to mimic human reaction
                    task.wait(math.random(SHOT_VARIATION.min * 1000, SHOT_VARIATION.max * 1000) * 0.001)
                end
            end)
        else
            -- Clear caches securely
            for k in pairs(cachedRemotes) do
                cachedRemotes[k] = nil
            end
            cachedWeapon = nil
        end
    end
})


-- Auto Skip Round
local autoSkip = false
CombatTab:CreateToggle({
    Name = "Auto Skip Round",
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
                    task.wait(1)
                end
            end)
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", "skull")

MiscTab:CreateButton({
    Name = "Delete All Doors",
    Callback = function()
        local doorsFolder = workspace:FindFirstChild("Doors")
        if doorsFolder then
            for _, group in pairs(doorsFolder:GetChildren()) do
                if group:IsA("Folder") or group:IsA("Model") then
                    group:Destroy()
                end
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Activate All Perks",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then return end

        local perks = {
            "Bandoiler_Perk",
            "DoubleUp_Perk",
            "Haste_Perk",
            "Tank_Perk"
        }

        for _, perk in ipairs(perks) do
            if vars:GetAttribute(perk) ~= nil then
                vars:SetAttribute(perk, true)
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Enhance Primary & Secondary",
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
    end
})

MiscTab:CreateButton({
    Name = "Set Mag to 1 Million",
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
    end
})

MiscTab:CreateButton({
    Name = "Set All Guns to 'immortal'",
    Callback = function()
        local gunData = player:FindFirstChild("GunData")
        if not gunData then return end

        for _, value in ipairs(gunData:GetChildren()) do
            if value:IsA("StringValue") then
                value.Value = "immortal"
            end
        end
    end
})

-- Crate Tab
local crateTab = Window:CreateTab("Crates", "Skull") 

-- Auto Open Crates
local function createCrateToggle(name, flag, remoteName, invokeArg)
    local loop = false
    crateTab:CreateToggle({
        Name = "Auto Open " .. name .. " Crates",
        CurrentValue = false,
        Flag = flag,
        Callback = function(state)
            loop = state
            if state then
                task.spawn(function()
                    while loop do
                        local remote = Remotes:FindFirstChild(remoteName)
                        if remote then
                            pcall(function()
                                remote:InvokeServer(invokeArg)
                            end)
                        end
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
end

-- Individual crate toggles
createCrateToggle("Pet", "AutoOpenPetCrate", "OpenPetCrate")
createCrateToggle("Gun", "AutoOpenGunCrate", "OpenGunCrate")
createCrateToggle("Outfit", "AutoOpenOutfitCrate", "OpenOutfitCrate", "Random")
createCrateToggle("Camo", "AutoOpenCamoCrate", "OpenCamoCrate", "Random")

-- Load config
Rayfield:LoadConfiguration()
