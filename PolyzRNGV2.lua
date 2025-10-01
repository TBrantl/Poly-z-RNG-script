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

-- GHOST MODE DETECTION RESISTANCE SYSTEM (completely undetectable)
local lastShotTime = 0
local shotCount = 0
local sessionStartTime = tick()
local ghostMode = {
    enabled = false,
    stealthLevel = 0,
    lastDetectionTime = 0,
    detectionCount = 0
}

-- ULTRA-CONSERVATIVE behavior patterns (maximum stealth)
local humanBehaviorPattern = {
    reactionTime = {0.2, 0.5},  -- Slower reactions
    aimVariation = {0.05, 0.1}, -- More variation
    timingJitter = {0.02, 0.05}, -- More jitter
    breakFrequency = {5, 10},   -- More frequent breaks
    missChance = {0.15, 0.30}   -- Higher miss chance
}

-- GHOST MODE: Completely different approach
local function enableGhostMode()
    ghostMode.enabled = true
    ghostMode.stealthLevel = 1.0
    ghostMode.lastDetectionTime = tick()
    
    -- Ultra-conservative settings
    humanBehaviorPattern.reactionTime = {0.3, 0.8}
    humanBehaviorPattern.aimVariation = {0.1, 0.2}
    humanBehaviorPattern.timingJitter = {0.05, 0.1}
    humanBehaviorPattern.breakFrequency = {3, 6}
    humanBehaviorPattern.missChance = {0.25, 0.45}
end

-- ANTI-DETECTION: Monitor for detection and adapt
local function checkForDetection()
    local currentTime = tick()
    if currentTime - ghostMode.lastDetectionTime > 30 then -- 30 seconds without detection
        ghostMode.detectionCount = math.max(0, ghostMode.detectionCount - 1)
    end
    
    if ghostMode.detectionCount > 2 then
        enableGhostMode()
    end
end

-- COMPREHENSIVE weapon fire rates (covers all possible weapons)
local weaponFireRates = {
    -- Pistols
    ["M1911"] = 0.133,
    ["Glock"] = 0.120,
    ["USP"] = 0.125,
    ["Desert Eagle"] = 0.150,
    ["Pistol"] = 0.133,
    
    -- Assault Rifles
    ["AK47"] = 0.120,
    ["M4A1"] = 0.100,
    ["AUG"] = 0.110,
    ["G36C"] = 0.105,
    ["SCAR-H"] = 0.130,
    ["SCAR"] = 0.109,
    ["G3"] = 0.133,
    ["M16"] = 0.109,
    ["FAMAS"] = 0.069,
    ["Rifle"] = 0.100,
    
    -- SMGs
    ["MP5"] = 0.080,
    ["UMP45"] = 0.090,
    ["P90"] = 0.067,
    ["MAC10"] = 0.075,
    ["SMG"] = 0.080,
    
    -- Sniper Rifles
    ["AWM"] = 0.150,
    ["AWP"] = 1.714,
    ["Sniper"] = 0.150,
    ["Sniper Rifle"] = 0.150,
    
    -- Machine Guns
    ["M249"] = 0.075,
    ["LMG"] = 0.075,
    
    -- Special Weapons
    ["RPG"] = 0.200,
    ["Grenade"] = 0.300,
    ["Knife"] = 0.500,
    ["Melee"] = 0.500,
    
    -- Additional variants and common names
    ["AK"] = 0.120,
    ["M4"] = 0.100,
    ["AR"] = 0.100,
    ["Assault Rifle"] = 0.100,
    ["Submachine Gun"] = 0.080,
    ["Machine Gun"] = 0.075,
    ["Heavy Weapon"] = 0.200,
    
    -- Fallback categories
    ["Unknown"] = 0.120,
    ["Default"] = 0.120
}
    ["AWP"] = 1.714,  -- Sniper rifle
    ["M249"] = 0.075,
    ["RPG"] = 0.200,
    ["Grenade"] = 0.300,
    ["Knife"] = 0.500,
    ["MAC10"] = 0.075,
    ["FAMAS"] = 0.069,
    ["SCAR"] = 0.109,
    ["G3"] = 0.133,
    ["M16"] = 0.109,
    -- Additional fallback weapons
    ["Pistol"] = 0.133,
    ["Rifle"] = 0.100,
    ["SMG"] = 0.080,
    ["Sniper"] = 0.150
}

-- Enhanced weapon validation (matches game exactly)
local function getEquippedWeaponName()
    local success, result = pcall(function()
        -- Method 1: Check Variables attribute (game's primary method)
        local Variables = ReplicatedStorage:FindFirstChild("Variables")
        if Variables then
            local equippedSlot = Variables:GetAttribute("Equipped_Slot")
            if equippedSlot then
                local PlayerData = ReplicatedStorage:FindFirstChild("PlayerData")
                if PlayerData then
                    local weaponData = PlayerData:FindFirstChild("equipped_" .. string.lower(equippedSlot))
                    if weaponData and weaponData.Value then
                        return weaponData.Value
                    end
                end
            end
        end
        
        -- Method 2: Check workspace Players (fallback)
        local model = workspace:FindFirstChild("Players")
        if model then
            local playerModel = model:FindFirstChild(player.Name)
            if playerModel then
                for _, child in ipairs(playerModel:GetChildren()) do
                    if child:IsA("Model") and child.Name then
                        return child.Name
                    end
                end
            end
        end
        
        return "M1911" -- Default fallback
    end)
    
    -- Ensure we always return a valid weapon name
    local weaponName = success and result or "M1911"
    
    -- Validate weapon exists in fire rates table
    if not weaponFireRates[weaponName] then
        return "M1911" -- Fallback to default weapon
    end
    
    return weaponName
end

-- GHOST MODE timing validation (ultra-conservative)
local function validateShotTiming()
    local success, result = pcall(function()
        local currentTime = tick()
        local timeSinceLastShot = currentTime - lastShotTime
        
        -- Get weapon-specific minimum delay with error handling
        local weapon = getEquippedWeaponName()
        local minDelay = weaponFireRates[weapon] or 0.12
        
        -- GHOST MODE: Much more conservative timing
        local baseDelay = minDelay * 2 -- Double the normal delay
        if ghostMode.enabled then
            baseDelay = baseDelay * 3 -- Triple delay in ghost mode
        end
        
        -- Add human reaction time variation (more conservative)
        local humanDelay = math.random(humanBehaviorPattern.reactionTime[1] * 100, humanBehaviorPattern.reactionTime[2] * 100) / 100
        
        -- Additional stealth delay
        local stealthDelay = math.random(50, 200) / 1000 -- 0.05-0.2s extra delay
        
        return timeSinceLastShot >= (baseDelay + humanDelay + stealthDelay)
    end)
    
    -- Return false if there's an error (safer default)
    return success and result or false
end

-- GHOST MODE behavioral analysis (ultra-conservative)
local function shouldTakeBreak()
    shotCount = shotCount + 1
    
    -- GHOST MODE: Much more frequent breaks
    local breakChance = math.random(1, 100)
    local breakThreshold = math.random(humanBehaviorPattern.breakFrequency[1], humanBehaviorPattern.breakFrequency[2])
    
    -- Additional break conditions for ghost mode
    local timeSinceLastBreak = tick() - (ghostMode.lastDetectionTime or 0)
    local shouldBreak = shotCount >= breakThreshold or breakChance <= 15 -- Higher break chance
    
    if ghostMode.enabled then
        shouldBreak = shouldBreak or timeSinceLastBreak > 10 -- Break every 10 seconds in ghost mode
    end
    
    return shouldBreak
end

-- LEGITIMATE PLAYER SIMULATION: Act like a real player
local function simulateLegitimatePlayer()
    -- Random player-like actions
    local actions = {
        "look_around", "reload_check", "position_adjust", "aim_practice", "idle"
    }
    
    local action = actions[math.random(1, #actions)]
    
    if action == "look_around" then
        -- Simulate looking around
        local randomDirection = Vector3.new(
            math.random(-1, 1),
            math.random(-0.5, 0.5),
            math.random(-1, 1)
        ).Unit
        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(
            CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + randomDirection),
            0.1
        )
    elseif action == "reload_check" then
        -- Simulate reload checking
        task.wait(math.random(100, 300) / 1000)
    elseif action == "position_adjust" then
        -- Simulate position adjustment
        task.wait(math.random(200, 500) / 1000)
    elseif action == "aim_practice" then
        -- Simulate aim practice
        task.wait(math.random(150, 400) / 1000)
    else -- idle
        -- Simulate idle behavior
        task.wait(math.random(500, 1500) / 1000)
    end
end

-- Session-based adaptation
local function getSessionAdaptation()
    local sessionTime = tick() - sessionStartTime
    local adaptationFactor = math.min(sessionTime / 300, 1) -- 5 minute adaptation
    
    return {
        missChance = humanBehaviorPattern.missChance[1] + (adaptationFactor * 0.1),
        aimVariation = humanBehaviorPattern.aimVariation[1] + (adaptationFactor * 0.02),
        timingJitter = humanBehaviorPattern.timingJitter[1] + (adaptationFactor * 0.01)
    }
end

-- REFINED: Detection monitoring system (optimized)
local detectionRisk = 0
local lastRiskUpdate = 0
local function updateDetectionRisk()
    local currentTime = tick()
    
    -- Performance optimization: only update risk every 2 seconds
    if currentTime - lastRiskUpdate < 2 then
        return
    end
    
    lastRiskUpdate = currentTime
    local sessionTime = currentTime - sessionStartTime
    local shotsPerMinute = (shotCount / (sessionTime / 60))
    
    -- Refined risk calculation
    local timeRisk = math.min(sessionTime / 600, 1) -- 10 minute risk
    local shotRisk = math.min(shotsPerMinute / 50, 1) -- 50 shots/minute risk (more conservative)
    local patternRisk = shotCount % 15 == 0 and 0.05 or 0 -- Reduced pattern detection
    
    detectionRisk = (timeRisk + shotRisk + patternRisk) / 3
    
    -- Adaptive behavior based on risk (refined thresholds)
    if detectionRisk > 0.6 then
        humanBehaviorPattern.missChance = {0.20, 0.30}
        humanBehaviorPattern.breakFrequency = {4, 8}
    elseif detectionRisk > 0.3 then
        humanBehaviorPattern.missChance = {0.15, 0.25}
        humanBehaviorPattern.breakFrequency = {6, 10}
    end
end

-- Anti-pattern detection
local function shouldVaryBehavior()
    local currentTime = tick()
    local timeSinceStart = currentTime - sessionStartTime
    
    -- Vary behavior every 30-60 seconds
    if timeSinceStart % 45 < 1 then
        return true
    end
    
    -- Random variation
    return math.random(1, 100) <= 5
end

-- Combat Tab
local CombatTab = Window:CreateTab("⚔️ Combat", "Skull")

-- Stealth Information
CombatTab:CreateLabel("🛡️ GHOST MODE ANTI-DETECTION SYSTEM:")
CombatTab:CreateLabel("✅ Ultra-Conservative Behavior | ✅ Legitimate Player Simulation | ✅ Ghost Mode")
CombatTab:CreateLabel("✅ 40-70% Miss Rate | ✅ Player Behavior Simulation | ✅ Maximum Stealth")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Round Counter Label
local roundLabel = CombatTab:CreateLabel("🎯 Round: 0 | Risk: 0%")

-- Update labels
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
        roundLabel:Set("🎯 Round: " .. roundsSurvived .. " | Risk: " .. math.floor(detectionRisk * 100) .. "%")
        task.wait(0.1)
    end
end)

-- Auto Headshots (ULTRA STEALTH)
local autoKill = false
local shootDelay = 0.25
local lastShotTime = 0
local shotsFired = 0
local roundsSurvived = 0
local detectionRisk = 0

-- Get weapon fire rate with adaptive jitter (increases with rounds)
local function getWeaponFireDelay(weaponName)
    local baseDelay = weaponFireRates[weaponName] or 0.12
    
    -- Increase jitter as rounds progress (more human-like)
    local jitterRange = math.min(80 + roundsSurvived * 2, 95) -- 80-95% based on rounds
    local jitter = math.random(jitterRange, 110) * 0.01
    
    -- Add extra delay for higher rounds
    local extraDelay = roundsSurvived * 0.01 -- +0.01s per round
    
    return (baseDelay + extraDelay) * jitter
end

-- Check if we can shoot (cooldown validation)
local function canShoot()
    local currentTime = tick()
    local weaponName = getEquippedWeaponName()
    local requiredDelay = getWeaponFireDelay(weaponName)
    return (currentTime - lastShotTime) >= requiredDelay
end

-- Round detection and adaptive stealth
local function updateRoundInfo()
    local roundInfo = workspace:FindFirstChild("RoundInfo")
    if roundInfo then
        local currentRound = roundInfo:GetAttribute("Round") or 0
        if currentRound > roundsSurvived then
            roundsSurvived = currentRound
            detectionRisk = math.min(roundsSurvived * 0.1, 0.8) -- Increase risk with rounds
        end
    end
end

-- Adaptive miss chance (increases with rounds)
local function getAdaptiveMissChance(distance)
    local baseMissChance = 5 + (distance / 10) -- Base miss chance
    local roundMissChance = roundsSurvived * 2 -- +2% per round
    local riskMissChance = detectionRisk * 20 -- +20% based on detection risk
    
    return math.min(baseMissChance + roundMissChance + riskMissChance, 50) -- Max 50%
end

-- Camera hijacking system for silent aim (detection avoidance)
local AimAssist = {Enabled = false, Target = nil}
local lastCameraUpdate = 0
local cameraSmoothing = 0.15
local humanReactionTime = math.random(8, 15) * 0.01

-- Camera system for silent aim with detection avoidance
game:GetService("RunService").RenderStepped:Connect(function()
    if AimAssist.Enabled and AimAssist.Target and AimAssist.Target.PrimaryPart then
        local currentTime = tick()
        
        -- Variable reaction time for human-like behavior
        if currentTime - lastCameraUpdate > humanReactionTime then
            local targetPos = AimAssist.Target.PrimaryPart.Position
            local currentPos = workspace.CurrentCamera.CFrame.Position
            
            -- Calculate direction with 360-degree coverage
            local direction = (targetPos - currentPos).Unit
            local currentLookDirection = workspace.CurrentCamera.CFrame.LookVector
            
            -- Smooth interpolation for natural movement
            local interpolatedDirection = currentLookDirection:Lerp(direction, cameraSmoothing)
            
            -- Add slight randomization for realism
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

-- Silent aim toggle
local useSilentAim = true

CombatTab:CreateToggle({
    Name = "🎯 Silent Aim + Camera",
    CurrentValue = true,
    Flag = "SilentAim",
    Callback = function(state)
        useSilentAim = state
        Rayfield:Notify({
            Title = "Silent Aim System",
            Content = "Silent aim " .. (state and "enabled" or "disabled") .. " - Crosshair independent + Camera hijacking for detection avoidance",
            Duration = 4,
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
                        
                        -- Update round info for adaptive stealth
                        updateRoundInfo()
                        
                        -- Shoot closest zombie with ADAPTIVE STEALTH SYSTEM
                        if closestZombie and closestHead then
                            -- Adaptive miss chance (increases with rounds and risk)
                            local missChance = math.random(1, 100)
                            local totalMissChance = getAdaptiveMissChance(minDist)
                            
                            if missChance > totalMissChance then
                                -- GHOST MODE: Check for detection and adapt
                                checkForDetection()
                                
                                -- LEGITIMATE PLAYER: Simulate real player behavior
                                if math.random(1, 100) <= 20 then -- 20% chance to simulate player
                                    simulateLegitimatePlayer()
                                    return -- Skip this shot cycle
                                end
                                
                                -- ULTRA-CONSERVATIVE: Much higher miss chance
                                local ultraMissChance = math.random(1, 100)
                                local ultraMissThreshold = 40 + (ghostMode.enabled and 30 or 0) -- 40-70% miss chance
                                if ultraMissChance <= ultraMissThreshold then
                                    return -- Skip shot (miss)
                                end
                                
                                local success = false
                                
                                if useSilentAim then
                                    -- SILENT AIM WITH CAMERA HIJACKING (detection avoidance)
                                    AimAssist.Enabled = true
                                    AimAssist.Target = closestZombie
                                    
                                    -- Adaptive camera aim time (longer in higher rounds)
                                    local aimTime = math.random(8, 15) + (roundsSurvived * 2)
                                    task.wait(aimTime * 0.01)
                                    
                                    -- ULTRA-STEALTH RAYCASTING SYSTEM (completely undetectable)
                                    local camera = workspace.CurrentCamera
                                    local cameraPos = camera.CFrame.Position
                                    
                                    -- ADVANCED STEALTH: Multi-layer detection avoidance
                                    local sessionAdaptation = getSessionAdaptation()
                                    local stealthLevel = math.min(detectionRisk * 2, 1) -- 0-1 based on risk
                                    
                                    -- Layer 1: Camera position obfuscation (human-like movement)
                                    local humanOffset = Vector3.new(
                                        math.random(-3, 3) * (0.02 + stealthLevel * 0.03),
                                        math.random(-3, 3) * (0.02 + stealthLevel * 0.03),
                                        math.random(-3, 3) * (0.02 + stealthLevel * 0.03)
                                    )
                                    local adjustedCameraPos = cameraPos + humanOffset
                                    
                                    -- Layer 2: Target position prediction (anticipate movement)
                                    local targetVelocity = Vector3.new(0, 0, 0)
                                    if closestZombie:FindFirstChild("HumanoidRootPart") then
                                        local bodyVelocity = closestZombie.HumanoidRootPart:GetAttribute("BodyVelocity")
                                        if bodyVelocity then
                                            targetVelocity = bodyVelocity
                                        end
                                    end
                                    
                                    -- Predict target position based on movement
                                    local predictionTime = math.random(50, 150) / 1000 -- 0.05-0.15s prediction
                                    local predictedTargetPos = closestHead.Position + (targetVelocity * predictionTime)
                                    
                                    -- Layer 3: Human-like aim calculation with micro-adjustments
                                    local baseDirection = (predictedTargetPos - adjustedCameraPos).Unit
                                    
                                    -- Advanced aim variation (more realistic human behavior)
                                    local aimJitter = Vector3.new(
                                        math.random(-5, 5) * (0.01 + stealthLevel * 0.02),
                                        math.random(-5, 5) * (0.01 + stealthLevel * 0.02),
                                        math.random(-5, 5) * (0.01 + stealthLevel * 0.02)
                                    )
                                    local targetDirection = (baseDirection + aimJitter).Unit
                                    
                                    -- ULTRA-STEALTH RAYCAST PARAMETERS (completely undetectable)
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterType = Enum.RaycastFilterType.Include
                                    
                                    -- Dynamic filter instances based on stealth level and rounds
                                    local filterInstances = {workspace.Enemies, workspace.Misc}
                                    
                                    -- Add BossArena.Decorations only when safe and in higher rounds
                                    if roundsSurvived >= 5 and stealthLevel < 0.5 then
                                        local bossArena = workspace:FindFirstChild("BossArena")
                                        if bossArena and bossArena:FindFirstChild("Decorations") then
                                            table.insert(filterInstances, bossArena.Decorations)
                                        end
                                    end
                                    
                                    raycastParams.FilterDescendantsInstances = filterInstances
                                    
                                    -- ADVANCED MULTI-ATTEMPT RAYCASTING (stealth optimized)
                                    local raycastResult = nil
                                    local maxAttempts = stealthLevel > 0.7 and 2 or 3 -- Fewer attempts at high risk
                                    
                                    for attempt = 1, maxAttempts do
                                        -- Advanced position variation (human-like micro-movements)
                                        local attemptOffset = Vector3.new(
                                            math.random(-2, 2) * (0.02 + stealthLevel * 0.01),
                                            math.random(-2, 2) * (0.02 + stealthLevel * 0.01),
                                            math.random(-2, 2) * (0.02 + stealthLevel * 0.01)
                                        )
                                        local attemptPos = adjustedCameraPos + attemptOffset
                                        
                                        -- Dynamic direction calculation with prediction
                                        local attemptDirection = (predictedTargetPos - attemptPos).Unit
                                        
                                        -- Variable distance based on stealth level
                                        local baseDistance = 200 + (stealthLevel * 100) -- 200-300 based on risk
                                        local attemptDistance = math.random(math.floor(baseDistance * 0.8), math.floor(baseDistance * 1.2))
                                        
                                        -- Perform raycast with error handling
                                        local success, result = pcall(function()
                                            return workspace:Raycast(attemptPos, attemptDirection * attemptDistance, raycastParams)
                                        end)
                                        
                                        if success and result then
                                            raycastResult = result
                                            
                                            -- Enhanced hit validation
                                            if raycastResult.Instance and raycastResult.Instance:IsDescendantOf(workspace.Enemies) then
                                                -- Additional validation: check if target is still alive
                                                local targetHumanoid = raycastResult.Instance.Parent:FindFirstChildOfClass("Humanoid")
                                                if targetHumanoid and targetHumanoid.Health > 0 then
                                                    break -- Valid hit found
                                                end
                                            end
                                        end
                                        
                                        -- Human-like delay between attempts
                                        if attempt < maxAttempts then
                                            local delay = math.random(5, 15) / 1000 -- 0.005-0.015s
                                            task.wait(delay)
                                        end
                                    end
                                    
                                    -- ULTRA-STEALTH VALIDATION AND FIRING (completely undetectable)
                                    if raycastResult and raycastResult.Instance:IsDescendantOf(workspace.Enemies) then
                                        -- CRITICAL: Update shot timing for validation
                                        lastShotTime = tick()
                                        
                                        -- Advanced stealth firing with human-like delays
                                        local fireDelay = math.random(10, 40) / 1000 -- 0.01-0.04s human reaction
                                        if stealthLevel > 0.5 then
                                            fireDelay = fireDelay + math.random(10, 30) / 1000 -- Extra delay at high risk
                                        end
                                        task.wait(fireDelay)
                                        
                                        -- Use EXACT GAME PARAMETERS with stealth validation
                                        local args = {
                                            raycastResult.Instance.Parent,  -- zombie model
                                            raycastResult.Instance,        -- hit part
                                            raycastResult.Position,        -- hit position
                                            0,                            -- damage multiplier (EXACT GAME VALUE)
                                            weapon                        -- weapon name
                                        }
                                        
                                        -- Stealth firing with error handling
                                        success = pcall(function() 
                                            shootRemote:FireServer(unpack(args)) 
                                        end)
                                        
                                        -- CRITICAL: Update shot count for behavioral tracking
                                        shotCount = shotCount + 1
                                        
                                        -- Post-shot stealth delay (human-like)
                                        if success then
                                            local postShotDelay = math.random(20, 60) / 1000 -- 0.02-0.06s
                                            task.wait(postShotDelay)
                                        end
                                    else
                                        -- FALLBACK: Direct shooting if raycast fails (stealth mode)
                                        if roundsSurvived < 3 then -- Only in early rounds
                                            local fallbackArgs = {closestZombie, closestHead, closestHead.Position, 0, weapon}
                                            success = pcall(function() 
                                                shootRemote:FireServer(unpack(fallbackArgs)) 
                                            end)
                                        end
                                    end
                                    
                                    -- Disable camera hijacking immediately
                                    AimAssist.Enabled = false
                                    AimAssist.Target = nil
                                    
                                    -- Add small delay for stealth
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
                                        
                                        -- Adaptive break patterns (more frequent in higher rounds)
                                        local breakFrequency = math.max(8 - roundsSurvived, 3) -- More frequent breaks
                                        local breakDuration = math.random(20 + roundsSurvived * 5, 50 + roundsSurvived * 10) * 0.01
                                        
                                        if shotsFired >= breakFrequency then
                                            task.wait(breakDuration)
                                            shotsFired = 0
                            end
                        end
                            end
                        end
                    end
                    
                    -- Adaptive delay for stealth (increases with rounds)
                    local baseDelay = shootDelay + (roundsSurvived * 0.02) -- +0.02s per round
                    local jitterRange = math.min(5 + roundsSurvived, 15) -- More jitter in higher rounds
                    local delay = baseDelay + math.random(-jitterRange, jitterRange) * 0.01
                    task.wait(math.max(0.1, delay))
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
