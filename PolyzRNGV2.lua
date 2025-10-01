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

-- CRITICAL DETECTION RESISTANCE SYSTEM
local lastShotTime = 0
local shotCount = 0
local sessionStartTime = tick()
local humanBehaviorPattern = {
    reactionTime = {0.1, 0.3},
    aimVariation = {0.02, 0.05},
    timingJitter = {0.01, 0.03},
    breakFrequency = {8, 15},
    missChance = {0.05, 0.15}
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
                    if weaponData then
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
            if child:IsA("Model") then
                return child.Name
            end
        end
    end
        end
        
        return "M1911" -- Default fallback
    end)
    
    return success and result or "M1911"
end

-- Human-like timing validation
local function validateShotTiming()
    local currentTime = tick()
    local timeSinceLastShot = currentTime - lastShotTime
    
    -- Get weapon-specific minimum delay
    local weapon = getEquippedWeaponName()
    local minDelay = weaponFireRates[weapon] or 0.12
    
    -- Add human reaction time variation
    local humanDelay = math.random(humanBehaviorPattern.reactionTime[1] * 100, humanBehaviorPattern.reactionTime[2] * 100) / 100
    
    return timeSinceLastShot >= (minDelay + humanDelay)
end

-- Behavioral pattern analysis
local function shouldTakeBreak()
    shotCount = shotCount + 1
    local breakChance = math.random(1, 100)
    local breakThreshold = math.random(humanBehaviorPattern.breakFrequency[1], humanBehaviorPattern.breakFrequency[2])
    
    return shotCount >= breakThreshold or breakChance <= 5
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

-- CRITICAL: Detection monitoring system
local detectionRisk = 0
local function updateDetectionRisk()
    local sessionTime = tick() - sessionStartTime
    local shotsPerMinute = (shotCount / (sessionTime / 60))
    
    -- Calculate risk based on multiple factors
    local timeRisk = math.min(sessionTime / 600, 1) -- 10 minute risk
    local shotRisk = math.min(shotsPerMinute / 60, 1) -- 60 shots/minute risk
    local patternRisk = shotCount % 20 == 0 and 0.1 or 0 -- Pattern detection
    
    detectionRisk = (timeRisk + shotRisk + patternRisk) / 3
    
    -- Adaptive behavior based on risk
    if detectionRisk > 0.7 then
        humanBehaviorPattern.missChance = {0.15, 0.25}
        humanBehaviorPattern.breakFrequency = {5, 10}
    elseif detectionRisk > 0.4 then
        humanBehaviorPattern.missChance = {0.10, 0.20}
        humanBehaviorPattern.breakFrequency = {6, 12}
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
CombatTab:CreateLabel("🛡️ CRITICAL DETECTION RESISTANCE:")
CombatTab:CreateLabel("✅ Human Behavior Simulation | ✅ Server Validation Bypass | ✅ Timing Synchronization")
CombatTab:CreateLabel("✅ Session Adaptation | ✅ Behavioral Patterns | ✅ Perfect Game Sync")
CombatTab:CreateLabel("✅ Boss Targeting | ✅ Zombie + Boss Auto Kill | ✅ Priority System")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Round Counter Label
local roundLabel = CombatTab:CreateLabel("🎯 Round: 0 | Risk: 0% | Shots: 0")

-- Detection Risk Label
local riskLabel = CombatTab:CreateLabel("🛡️ Detection Risk: 0% | Session: 0m")

-- Update labels
task.spawn(function()
    while true do
        local sessionTime = math.floor((tick() - sessionStartTime) / 60)
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
        roundLabel:Set("🎯 Round: " .. roundsSurvived .. " | Risk: " .. math.floor(detectionRisk * 100) .. "% | Shots: " .. shotCount)
        riskLabel:Set("🛡️ Detection Risk: " .. math.floor(detectionRisk * 100) .. "% | Session: " .. sessionTime .. "m")
        task.wait(0.1)
    end
end)

-- Auto Headshots (ULTRA STEALTH)
local autoKill = false
local autoKillBosses = false
local shootDelay = 0.25
local lastShotTime = 0
local shotsFired = 0
local roundsSurvived = 0
local detectionRisk = 0
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

-- Boss Auto Kill Toggle
CombatTab:CreateToggle({
    Name = "👹 Auto Kill Bosses",
    CurrentValue = false,
    Flag = "AutoKillBosses",
    Callback = function(state)
        autoKillBosses = state
        Rayfield:Notify({
            Title = "Boss Auto Kill",
            Content = "Automatically target and kill bosses " .. (state and "enabled" or "disabled"),
            Duration = 3,
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
                        local closestTarget = nil
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
                                        closestTarget = zombie
                                        closestHead = head
                                    end
                                end
                            end
                        end
                        
                        -- BOSS TARGETING: Check for bosses if enabled
                        if autoKillBosses then
                            local bossArena = workspace:FindFirstChild("BossArena")
                            if bossArena then
                                -- Look for boss models in BossArena
                                for _, boss in pairs(bossArena:GetChildren()) do
                                    if boss:IsA("Model") and boss:FindFirstChild("Head") then
                                        local head = boss.Head
                                        local humanoid = boss:FindFirstChildOfClass("Humanoid")
                                        
                                        -- Check if boss is alive
                                        if humanoid and humanoid.Health > 0 then
                                            local distance = (head.Position - playerPos).Magnitude
                                            
                                            -- Bosses have higher priority (closer range check)
                                            if distance < 300 and distance < minDist then
                                                minDist = distance
                                                closestTarget = boss
                                                closestHead = head
                                            end
                                        end
                                    end
                                end
                                
                                -- Also check BossArena.Decorations for boss parts
                                local decorations = bossArena:FindFirstChild("Decorations")
                                if decorations then
                                    for _, decoration in pairs(decorations:GetChildren()) do
                                        if decoration:IsA("Model") and decoration:FindFirstChild("Head") then
                                            local head = decoration.Head
                                            local humanoid = decoration:FindFirstChildOfClass("Humanoid")
                                            
                                            if humanoid and humanoid.Health > 0 then
                                                local distance = (head.Position - playerPos).Magnitude
                                                
                                                if distance < 300 and distance < minDist then
                                                    minDist = distance
                                                    closestTarget = decoration
                                                    closestHead = head
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- Update round info for adaptive stealth
                        updateRoundInfo()
                        
                        -- Shoot closest target (zombie or boss) with ADAPTIVE STEALTH SYSTEM
                        if closestTarget and closestHead then
                            -- Adaptive miss chance (increases with rounds and risk)
                            local missChance = math.random(1, 100)
                            local totalMissChance = getAdaptiveMissChance(minDist)
                            
                            if missChance > totalMissChance then
                                -- CRITICAL: Update detection risk before shooting
                                updateDetectionRisk()
                                
                                -- ANTI-PATTERN: Vary behavior if needed
                                if shouldVaryBehavior() then
                                    local variationDelay = math.random(100, 300) / 1000
                                    task.wait(variationDelay)
                                end
                                
                                local success = false
                                
                                if useSilentAim then
                                    -- CRITICAL DETECTION RESISTANCE: Validate timing first
                                    if not validateShotTiming() then
                                        return -- Skip shot if timing is invalid
                                    end
                                    
                                    -- HUMAN BEHAVIOR: Check if should take break
                                    if shouldTakeBreak() then
                                        local breakDuration = math.random(200, 500) / 1000
                                        task.wait(breakDuration)
                                        shotCount = 0 -- Reset counter
                                        return
                                    end
                                    
                                    -- SILENT AIM WITH CAMERA HIJACKING (detection avoidance)
                                    AimAssist.Enabled = true
                                    AimAssist.Target = closestTarget
                                    
                                    -- Session-adapted camera aim time
                                    local sessionAdaptation = getSessionAdaptation()
                                    local baseAimTime = math.random(8, 15) + (roundsSurvived * 2)
                                    local adaptedAimTime = baseAimTime + (sessionAdaptation.timingJitter * 100)
                                    task.wait(adaptedAimTime * 0.01)
                                    
                                    -- ENHANCED RAYCASTING WITH DETECTION AVOIDANCE
                                    local camera = workspace.CurrentCamera
                                    local cameraPos = camera.CFrame.Position
                                    
                                    -- PERFECT GAME SYNCHRONIZATION: Match exact game raycast parameters
                                    local sessionAdaptation = getSessionAdaptation()
                                    
                                    -- Human-like camera position variation (detection avoidance)
                                    local randomOffset = Vector3.new(
                                        math.random(-2, 2) * sessionAdaptation.aimVariation,
                                        math.random(-2, 2) * sessionAdaptation.aimVariation,
                                        math.random(-2, 2) * sessionAdaptation.aimVariation
                                    )
                                    local adjustedCameraPos = cameraPos + randomOffset
                                    
                                    -- Calculate direction with human-like aim variation
                                    local targetPos = closestHead.Position
                                    local baseDirection = (targetPos - adjustedCameraPos).Unit
                                    
                                    -- Session-adapted aim variation for realism
                                    local aimVariation = Vector3.new(
                                        math.random(-3, 3) * sessionAdaptation.aimVariation,
                                        math.random(-3, 3) * sessionAdaptation.aimVariation,
                                        math.random(-3, 3) * sessionAdaptation.aimVariation
                                    )
                                    local targetDirection = (baseDirection + aimVariation).Unit
                                    
                                    -- ADAPTIVE RAYCAST PARAMETERS (round-based detection avoidance)
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterType = Enum.RaycastFilterType.Include
                                    
                                    -- Adaptive filter instances based on rounds (more conservative in higher rounds)
                                    local filterInstances = {workspace.Enemies, workspace.Misc}
                                    if roundsSurvived >= 5 then
                                        table.insert(filterInstances, workspace.BossArena.Decorations)
                                    end
                                    raycastParams.FilterDescendantsInstances = filterInstances
                                    
                                    -- Variable raycast distance (more realistic)
                                    local raycastDistance = math.random(200, 300)
                                    
                                    -- MULTIPLE RAYCAST ATTEMPTS (detection avoidance)
                                    local raycastResult = nil
                                    local maxAttempts = 3
                                    
                                    for attempt = 1, maxAttempts do
                                        -- Slightly different raycast each attempt
                                        local attemptOffset = Vector3.new(
                                            math.random(-1, 1) * 0.05,
                                            math.random(-1, 1) * 0.05,
                                            math.random(-1, 1) * 0.05
                                        )
                                        local attemptPos = adjustedCameraPos + attemptOffset
                                        
                                        local attemptDirection = (targetPos - attemptPos).Unit
                                        local attemptDistance = math.random(200, 300)
                                        
                                        raycastResult = workspace:Raycast(attemptPos, attemptDirection * attemptDistance, raycastParams)
                                        
                                        -- If we hit an enemy, use this result
                                        if raycastResult and raycastResult.Instance:IsDescendantOf(workspace.Enemies) then
                                            break
                                        end
                                        
                                        -- Small delay between attempts
                                        if attempt < maxAttempts then
                                            task.wait(math.random(1, 3) * 0.01)
                                        end
                                    end
                                    
                                    -- SERVER-SIDE VALIDATION BYPASS: Only fire if raycast hits the target
                                    if raycastResult and raycastResult.Instance:IsDescendantOf(workspace.Enemies) then
                                        -- CRITICAL: Update shot timing for validation
                                        lastShotTime = tick()
                                        
                                        -- Use EXACT GAME PARAMETERS with timing validation
                                    local args = {
                                            raycastResult.Instance.Parent,  -- zombie model
                                            raycastResult.Instance,        -- hit part
                                            raycastResult.Position,        -- hit position
                                            0,                            -- damage multiplier (EXACT GAME VALUE)
                                            weapon                        -- weapon name
                                        }
                                        
                                        -- Add human-like delay before firing
                                        local fireDelay = math.random(10, 30) / 1000
                                        task.wait(fireDelay)
                                        
                                        success = pcall(function() 
                                            shootRemote:FireServer(unpack(args)) 
                                        end)
                                        
                                        -- CRITICAL: Update shot count for behavioral tracking
                                        shotCount = shotCount + 1
                                    else
                                        -- FALLBACK: Direct shooting if raycast fails (stealth mode)
                                        if roundsSurvived < 3 then -- Only in early rounds
                                            local fallbackArgs = {closestTarget, closestHead, closestHead.Position, 0, weapon}
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
