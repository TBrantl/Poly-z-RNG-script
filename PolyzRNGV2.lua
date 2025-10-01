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

-- Ultra-Stealth Auto Headshots for Knightmare AC (Max Anti-Detection, Zombies & Bosses)
local autoKill = false
local shotsFired = 0
local cachedRemotes = {}
local cachedWeapon = nil
local weaponCacheTime = 0
local rayParams = RaycastParams.new()
local waveCounter = 0
local lastWaveCheck = 0
local lastShotTime = 0

-- Configurable parameters - Tuned for Knightmare server-side detection avoidance
local MAX_TARGETS_PER_LOOP = 2 -- Very low to mimic human firing rate
local SHOT_VARIATION = {min = 0.05, max = 0.12} -- Human-like delays (50-120ms between shots)
local BURST_VARIATION = {min = 2, max = 4} -- Tiny bursts
local PAUSE_VARIATION = {min = 0.2, max = 0.5} -- Longer pauses to avoid rate limits
local HEADSHOT_CHANCE = 0.75 -- Significantly lowered to avoid perfect accuracy flags
local MISS_CHANCE = 0.35 -- Higher miss rate for natural play
local COOLDOWN_CHANCE = 0.5 -- 50% chance for cooldowns
local BULLET_SPEED = 500 -- Assumed bullet speed
local MAX_DISTANCE = 100 -- Shorter scan to reduce computation
local HUMAN_VARIANCE = 0.15 -- Overall variance factor

CombatTab:CreateToggle({
    Name = "🔪 Auto Headshots",
    CurrentValue = false,
    Flag = "AutoKillEnemies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                -- Initialize caches with obfuscated keys
                local enemyKey = math.random(100000, 999999)
                local remoteKey = math.random(100000, 999999)
                cachedRemotes[enemyKey] = workspace:FindFirstChild("Enemies")
                cachedRemotes[remoteKey] = Remotes:FindFirstChild("ShootEnemy")
                
                while autoKill do
                    local currentTime = tick()
                    local enemies = cachedRemotes[enemyKey]
                    local shootRemote = cachedRemotes[remoteKey]
                    local char = player.Character
                    
                    -- Wave estimation
                    if currentTime - lastWaveCheck > 45 then -- More frequent wave checks
                        waveCounter = waveCounter + 1
                        lastWaveCheck = currentTime
                    end
                    
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
                        
                        -- Dynamic weapon caching with variance
                        if not cachedWeapon or currentTime - weaponCacheTime > math.random(1.0, 1.5) then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local playerPos = primaryPart.Position
                        local visibleEnemies = {}
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        -- Scan all models in Enemies folder (zombies and bosses)
                        for _, enemy in pairs(enemies:GetChildren()) do
                            if enemy:IsA("Model") then
                                local head = enemy:FindFirstChild("Head")
                                if not head then continue end
                                
                                local delta = head.Position - playerPos
                                local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
                                if distSq > MAX_DISTANCE * MAX_DISTANCE then continue end
                                
                                -- Simplified prediction to reduce patterns
                                local enemyRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
                                local velocity = enemyRoot and enemyRoot.Velocity or Vector3.new(0, 0, 0)
                                local distance = math.sqrt(distSq)
                                local bulletTime = distance / BULLET_SPEED
                                local predictedPos = head.Position + velocity * bulletTime * (1 + math.random(-HUMAN_VARIANCE, HUMAN_VARIANCE))
                                
                                -- Less accurate raycast for natural variance
                                local rayDirection = (predictedPos - playerPos).Unit * distance + Vector3.new(
                                    math.random(-8, 8) * 0.15,
                                    math.random(-8, 8) * 0.15,
                                    math.random(-8, 8) * 0.15
                                )
                                local rayResult = workspace:Raycast(playerPos, rayDirection, rayParams)
                                
                                if rayResult and rayResult.Instance:IsDescendantOf(enemy) then
                                    table.insert(visibleEnemies, {
                                        enemy = enemy,
                                        head = head,
                                        torso = enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso"),
                                        distSq = distSq,
                                        predictedPos = predictedPos
                                    })
                                end
                            end
                        end
                        
                        -- Sort by distance (closest first)
                        table.sort(visibleEnemies, function(a, b) return a.distSq < b.distSq end)
                        
                        -- Shoot closest enemies (very limited)
                        local targetsShot = 0
                        for i, target in ipairs(visibleEnemies) do
                            if targetsShot >= MAX_TARGETS_PER_LOOP then break end
                            if not target.torso then continue end
                            
                            -- High randomization in target selection
                            if math.random() < 0.4 and #visibleEnemies > 1 then
                                local randIndex = math.random(1, math.min(6, #visibleEnemies))
                                target = visibleEnemies[randIndex]
                            end
                            
                            -- Simulate more human error
                            local miss = math.random() < MISS_CHANCE
                            local targetPart = math.random() < HEADSHOT_CHANCE and target.head or target.torso
                            
                            local offsetScale = miss and 0.4 or math.random(0.08, 0.15)
                            local offset = Vector3.new(
                                math.random(-40, 40) * offsetScale,
                                math.random(-40, 40) * offsetScale,
                                math.random(-40, 40) * offsetScale
                            )
                            
                            -- Ensure minimum time between shots
                            local timeSinceLast = currentTime - lastShotTime
                            if timeSinceLast < SHOT_VARIATION.min then
                                task.wait(SHOT_VARIATION.min - timeSinceLast)
                            end
                            lastShotTime = tick()
                            
                            -- Fire with highly variable parameters
                            local damageVar = math.random(1, 4) * (math.random() < 0.7 and 1 or math.random(0.2, 0.6))
                            local args = {
                                target.enemy,
                                targetPart,
                                target.predictedPos + offset,
                                damageVar,
                                cachedWeapon,
                                math.random(0, 2000), -- Fake param
                                tick() * math.random(0.8, 1.2) -- Timestamp noise
                            }
                            pcall(function() shootRemote:FireServer(unpack(args)) end)
                            
                            -- Occasional fake shot (15% chance)
                            if math.random() < 0.15 then
                                task.wait(math.random(0.05, 0.1))
                                local fakeArgs = {
                                    target.enemy,
                                    target.torso,
                                    target.torso.Position + Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20)),
                                    0, -- Zero damage
                                    cachedWeapon,
                                    math.random(0, 2000)
                                }
                                pcall(function() shootRemote:FireServer(unpack(fakeArgs)) end)
                            end
                            
                            shotsFired = shotsFired + 1
                            targetsShot = targetsShot + 1
                            
                            -- Extended intra-burst delay with wave scaling
                            local baseDelay = waveCounter >= 2 and math.random(4, 8) * 0.008 or math.random(3, 6) * 0.007
                            task.wait(baseDelay + math.random() * 0.01) -- Add jitter
                            
                            -- Frequent cooldowns
                            if math.random() < COOLDOWN_CHANCE then
                                task.wait(math.random(0.15, 0.4) + (waveCounter * 0.05))
                            end
                        end
                        
                        -- Extended burst control
                        if shotsFired >= math.random(BURST_VARIATION.min, BURST_VARIATION.max) then
                            local pause = math.random(PAUSE_VARIATION.min * 100, PAUSE_VARIATION.max * 100) * 0.01
                            if waveCounter >= 2 then
                                pause = pause * (1 + waveCounter * 0.1) -- Progressive slowdown
                            end
                            task.wait(pause)
                            shotsFired = 0
                        end
                    else
                        -- Re-cache less frequently to avoid patterns
                        if math.random() < 0.2 then
                            enemyKey = math.random(100000, 999999)
                            remoteKey = math.random(100000, 999999)
                            cachedRemotes[enemyKey] = workspace:FindFirstChild("Enemies")
                            cachedRemotes[remoteKey] = Remotes:FindFirstChild("ShootEnemy")
                        end
                    end
                    
                    -- Longer cycle delay with scaling
                    local cycleDelay = math.random(SHOT_VARIATION.min * 1000, SHOT_VARIATION.max * 1000) * 0.001
                    if waveCounter >= 2 then
                        cycleDelay = cycleDelay * (1 + waveCounter * 0.08)
                    end
                    task.wait(cycleDelay + math.random() * 0.02) -- Jitter
                end
            end)
        else
            -- Clear caches
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
