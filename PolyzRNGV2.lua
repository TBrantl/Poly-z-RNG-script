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

-- Ultra-Optimized Auto Headshots with Predictive AI (Anti-Detection, Max Speed, Zombie Prevention)
local autoKill = false
local lastShotTime = 0
local shotsFired = 0
local cachedRemotes = {}
local cachedWeapon = nil
local weaponCacheTime = 0
local rayParams = RaycastParams.new()

-- Configurable parameters for anti-detection and AI
local MAX_TARGETS_PER_LOOP = 3 -- Shoot up to 3 closest zombies per cycle for faster clearing
local SHOT_VARIATION = {min = 0.01, max = 0.025} -- Faster randomized delay
local BURST_VARIATION = {min = 6, max = 12} -- Smaller bursts for quicker response
local PAUSE_VARIATION = {min = 0.05, max = 0.15} -- Shorter pauses
local HEADSHOT_CHANCE = 0.99 -- Near-perfect headshots
local BULLET_SPEED = 500 -- Assumed bullet speed for prediction (adjust if known)

CombatTab:CreateToggle({
    Name = "Auto Headshot Zombies",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                -- Initialize caches with obfuscated keys
                local enemyKey = math.random(1000, 9999)
                local remoteKey = math.random(1000, 9999)
                cachedRemotes[enemyKey] = workspace:FindFirstChild("Enemies")
                cachedRemotes[remoteKey] = Remotes:FindFirstChild("ShootEnemy")
                
                while autoKill do
                    local enemies = cachedRemotes[enemyKey]
                    local shootRemote = cachedRemotes[remoteKey]
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
                        
                        -- Dynamic weapon caching
                        local currentTime = tick()
                        if not cachedWeapon or currentTime - weaponCacheTime > math.random(0.8, 1.2) then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local playerPos = primaryPart.Position
                        
                        -- Collect visible zombies
                        local visibleZombies = {}
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        for _, zombie in pairs(enemies:GetChildren()) do
                            local head = zombie:FindFirstChild("Head")
                            if not head then continue end
                            
                            local delta = head.Position - playerPos
                            local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
                            
                            -- AI Prediction: Get velocity for predictive aiming
                            local zombieRoot = zombie:FindFirstChild("HumanoidRootPart") or zombie:FindFirstChild("Torso")
                            local velocity = zombieRoot and zombieRoot.Velocity or Vector3.new(0, 0, 0)
                            local distance = math.sqrt(distSq)
                            local bulletTime = distance / BULLET_SPEED
                            local predictedDelta = delta + velocity * bulletTime
                            
                            -- Raycast to predicted position
                            local rayDirection = predictedDelta + Vector3.new(
                                math.random(-2, 2) * 0.1,
                                math.random(-2, 2) * 0.1,
                                math.random(-2, 2) * 0.1
                            )
                            local rayResult = workspace:Raycast(playerPos, rayDirection, rayParams)
                            
                            if rayResult and rayResult.Instance:IsDescendantOf(zombie) then
                                table.insert(visibleZombies, {
                                    zombie = zombie,
                                    head = head,
                                    torso = zombie:FindFirstChild("Torso") or zombie:FindFirstChild("UpperTorso"),
                                    distSq = distSq,
                                    predictedPos = head.Position + velocity * bulletTime
                                })
                            end
                        end
                        
                        -- Sort by distance (closest first)
                        table.sort(visibleZombies, function(a, b) return a.distSq < b.distSq end)
                        
                        -- Shoot the closest ones (up to MAX_TARGETS_PER_LOOP)
                        local targetsShot = 0
                        for _, target in ipairs(visibleZombies) do
                            if targetsShot >= MAX_TARGETS_PER_LOOP then break end
                            if not target.torso then continue end
                            
                            -- Randomized headshot
                            local targetPart = math.random() < HEADSHOT_CHANCE and target.head or target.torso
                            
                            -- Subtle offset
                            local offset = Vector3.new(
                                math.random(-15, 15) * 0.05,
                                math.random(-15, 15) * 0.05,
                                math.random(-15, 15) * 0.05
                            )
                            
                            -- Fire with predicted position
                            shootRemote:FireServer(
                                target.zombie,
                                targetPart,
                                target.predictedPos + offset,
                                math.random(1, 3),
                                cachedWeapon
                            )
                            
                            shotsFired = shotsFired + 1
                            targetsShot = targetsShot + 1
                            
                            -- Tiny delay between shots in burst
                            task.wait(math.random(1, 5) * 0.005)
                        end
                        
                        -- Burst control
                        if shotsFired >= math.random(BURST_VARIATION.min, BURST_VARIATION.max) then
                            task.wait(math.random(PAUSE_VARIATION.min * 100, PAUSE_VARIATION.max * 100) * 0.01)
                            shotsFired = 0
                        end
                    else
                        -- Re-cache if needed
                        enemyKey = math.random(1000, 9999)
                        remoteKey = math.random(1000, 9999)
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
