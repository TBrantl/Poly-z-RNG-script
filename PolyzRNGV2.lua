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

-- Ultra-Optimized Auto Headshots with Predictive AI (Enhanced Anti-Detection, Zombies & Bosses)
local autoKill = false
local shotsFired = 0
local cachedRemotes = {}
local cachedWeapon = nil
local weaponCacheTime = 0
local rayParams = RaycastParams.new()

-- Configurable parameters for anti-detection and speed
local MAX_TARGETS_PER_LOOP = 5 -- Increased for faster clearing
local SHOT_VARIATION = {min = 0.008, max = 0.02} -- Tighter delay for speed
local BURST_VARIATION = {min = 5, max = 10} -- Shorter bursts
local PAUSE_VARIATION = {min = 0.03, max = 0.1} -- Minimal pauses
local HEADSHOT_CHANCE = 0.97 -- Slightly less predictable
local BULLET_SPEED = 500 -- Assumed bullet speed
local MAX_DISTANCE = 200 -- Max distance to scan (studs) for performance

CombatTab:CreateToggle({
    Name = "Auto Headshot Enemies",
    CurrentValue = false,
    Flag = "AutoKillEnemies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                -- Initialize caches with obfuscated keys
                local enemyKey = math.random(10000, 99999)
                local remoteKey = math.random(10000, 99999)
                cachedRemotes[enemyKey] = workspace:FindFirstChild("Enemies")
                cachedRemotes[remoteKey] = Remotes:FindFirstChild("ShootEnemy")
                
                while autoKill do
                    local enemiesFolder = cachedRemotes[enemyKey]
                    local shootRemote = cachedRemotes[remoteKey]
                    local char = player.Character
                    
                    if shootRemote and char then
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
                        
                        -- Dynamic weapon caching
                        local currentTime = tick()
                        if not cachedWeapon or currentTime - weaponCacheTime > math.random(0.6, 1.0) then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local playerPos = primaryPart.Position
                        local visibleEnemies = {}
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        -- Check Enemies folder (zombies)
                        if enemiesFolder then
                            for _, enemy in pairs(enemiesFolder:GetChildren()) do
                                local head = enemy:FindFirstChild("Head")
                                if not head then continue end
                                
                                local delta = head.Position - playerPos
                                local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
                                if distSq > MAX_DISTANCE * MAX_DISTANCE then continue end
                                
                                local enemyRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
                                local velocity = enemyRoot and enemyRoot.Velocity or Vector3.new(0, 0, 0)
                                local distance = math.sqrt(distSq)
                                local bulletTime = distance / BULLET_SPEED
                                local predictedDelta = delta + velocity * bulletTime
                                
                                local rayDirection = predictedDelta + Vector3.new(
                                    math.random(-3, 3) * 0.08,
                                    math.random(-3, 3) * 0.08,
                                    math.random(-3, 3) * 0.08
                                )
                                local rayResult = workspace:Raycast(playerPos, rayDirection, rayParams)
                                
                                if rayResult and rayResult.Instance:IsDescendantOf(enemy) then
                                    table.insert(visibleEnemies, {
                                        enemy = enemy,
                                        head = head,
                                        torso = enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso"),
                                        distSq = distSq,
                                        predictedPos = head.Position + velocity * bulletTime
                                    })
                                end
                            end
                        end
                        
                        -- Check for bosses in workspace
                        for _, potentialEnemy in pairs(workspace:GetChildren()) do
                            if potentialEnemy ~= enemiesFolder and potentialEnemy:IsA("Model") then
                                local head = potentialEnemy:FindFirstChild("Head")
                                local humanoid = potentialEnemy:FindFirstChildOfClass("Humanoid")
                                if not (head or humanoid) then continue end
                                
                                local delta = head.Position - playerPos
                                local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
                                if distSq > MAX_DISTANCE * MAX_DISTANCE then continue end
                                
                                local enemyRoot = potentialEnemy:FindFirstChild("HumanoidRootPart") or potentialEnemy:FindFirstChild("Torso")
                                local velocity = enemyRoot and enemyRoot.Velocity or Vector3.new(0, 0, 0)
                                local distance = math.sqrt(distSq)
                                local bulletTime = distance / BULLET_SPEED
                                local predictedDelta = delta + velocity * bulletTime
                                
                                local rayDirection = predictedDelta + Vector3.new(
                                    math.random(-3, 3) * 0.08,
                                    math.random(-3, 3) * 0.08,
                                    math.random(-3, 3) * 0.08
                                )
                                local rayResult = workspace:Raycast(playerPos, rayDirection, rayParams)
                                
                                if rayResult and rayResult.Instance:IsDescendantOf(potentialEnemy) then
                                    -- 👇 FIX: Fire like the first script for bosses
                                    local targetPart = head
                                    local args = {
                                        potentialEnemy,     -- enemy model
                                        targetPart,         -- always head for bosses
                                        targetPart.Position,-- real position
                                        0.5,                -- fixed damage
                                        cachedWeapon        -- weapon
                                    }
                                    pcall(function()
                                        shootRemote:FireServer(unpack(args))
                                    end)
                                end
                            end
                        end
                        
                        -- Sort by distance and prioritize closer enemies
                        table.sort(visibleEnemies, function(a, b) return a.distSq < b.distSq end)
                        
                        -- Shoot closest enemies (up to MAX_TARGETS_PER_LOOP)
                        local targetsShot = 0
                        for i, target in ipairs(visibleEnemies) do
                            if targetsShot >= MAX_TARGETS_PER_LOOP then break end
                            if not target.torso then continue end
                            
                            -- Randomize target selection slightly to avoid patterns
                            if math.random() < 0.1 and #visibleEnemies > 1 then
                                target = visibleEnemies[math.random(1, math.min(3, #visibleEnemies))]
                            end
                            
                            local targetPart = math.random() < HEADSHOT_CHANCE and target.head or target.torso
                            
                            local offset = Vector3.new(
                                math.random(-20, 20) * 0.04,
                                math.random(-20, 20) * 0.04,
                                math.random(-20, 20) * 0.04
                            )
                            
                            -- Keep full obfuscation/randomization for normal enemies
                            shootRemote:FireServer(
                                target.enemy,
                                targetPart,
                                target.predictedPos + offset,
                                math.random(1, 3) * (math.random() < 0.9 and 1 or 0.5),
                                cachedWeapon,
                                math.random()
                            )
                            
                            shotsFired = shotsFired + 1
                            targetsShot = targetsShot + 1
                            
                            task.wait(math.random(1, 4) * 0.004) -- Faster intra-burst delay
                        end
                        
                        -- Dynamic burst control
                        if shotsFired >= math.random(BURST_VARIATION.min, BURST_VARIATION.max) then
                            task.wait(math.random(PAUSE_VARIATION.min * 100, PAUSE_VARIATION.max * 100) * 0.01)
                            shotsFired = 0
                        end
                    else
                        -- Re-cache with new keys
                        enemyKey = math.random(10000, 99999)
                        remoteKey = math.random(10000, 99999)
                        cachedRemotes[enemyKey] = workspace:FindFirstChild("Enemies")
                        cachedRemotes[remoteKey] = Remotes:FindFirstChild("ShootEnemy")
                    end
                    
                    -- Randomized cycle delay
                    task.wait(math.random(SHOT_VARIATION.min * 1000, SHOT_VARIATION.max * 1000) * 0.001)
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
