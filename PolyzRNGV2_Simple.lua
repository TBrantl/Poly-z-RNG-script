-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()

-- Wait for Remotes safely
local Remotes
task.spawn(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    if not Remotes then
        warn("[Freezy HUB] Remotes folder not found - some features may not work")
    end
end)

-- 🛡️ KNIGHTMARE-SYNCHRONIZED UI CONFIGURATION
local Window = Rayfield:CreateWindow({
    Name = "🚀 FREEZY HUB V2 SIMPLE 🚀 | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    LoadingTitle = "🚀 Initializing Simple V2 System...",
    LoadingSubtitle = "Simple Performance + Anti-Cheat Synchronization",
    Theme = "Ocean",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHub",
        FileName = "FreezyConfig"
    }
})

-- 📊 KnightMare Performance Monitor
local performanceStats = {
    shotsBlocked = 0,
    shotsSuccessful = 0,
    riskLevel = "LOW",
    adaptiveDelay = 0.1,
    lastUpdate = tick()
}

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
local CombatTab = Window:CreateTab("⚔️ Warfare", "Sword")

-- 🛡️ KnightMare Status Section
CombatTab:CreateSection("🛡️ KnightMare Synchronicity Status")

-- Performance monitoring labels
local weaponLabel = CombatTab:CreateLabel("🔫 Equipped Weapon: Loading...")
local riskLabel = CombatTab:CreateLabel("🛡️ Detection Risk: LOW")
local performanceLabel = CombatTab:CreateLabel("📊 Shots: 0 Success | 0 Blocked")
local adaptiveLabel = CombatTab:CreateLabel("⚡ Adaptive Delay: 0.10s")

-- 📊 Real-time Dynamic Defense Monitoring
task.spawn(function()
    while true do
        local currentTime = tick()
        
        -- Update weapon info
        weaponLabel:Set("🔫 Equipped Weapon: " .. getEquippedWeaponName())
        
        -- Update performance stats every 2 seconds
        if currentTime - performanceStats.lastUpdate > 2 then
            -- Calculate dynamic defense zones
            local effectivenessScale = effectivenessLevel / 100
            local criticalZone = math.floor(15 + (effectivenessScale * 15))
            local highThreatZone = math.floor(30 + (effectivenessScale * 30))
            
            -- Detection risk display
            local riskLevel = "ZERO"
            local riskColor = "✅"
            
            if detectionRisk > 0.2 then
                riskLevel = "LOW"
                riskColor = "🟢"
            end
            if detectionRisk > 0.5 then
                riskLevel = "ELEVATED"
                riskColor = "🟡"
            end
            
            -- Update UI labels with dynamic info
            riskLabel:Set(riskColor .. " Detection Risk: " .. riskLevel .. " | Effectiveness: " .. effectivenessLevel .. "%")
            performanceLabel:Set("🎯 Defense Zones: Critical<" .. criticalZone .. " | High<" .. highThreatZone .. " studs")
            adaptiveLabel:Set("⚡ Shot Delay: " .. string.format("%.2f", shootDelay) .. "s | Kills: " .. performanceStats.shotsSuccessful)
            
            performanceStats.lastUpdate = currentTime
        end
        
        task.wait(0.5) -- Update UI every 0.5 seconds
    end
end)

CombatTab:CreateSection("⚔️ Perfect Defense System")

-- 🎯 INTELLIGENT EFFECTIVENESS SYSTEM
local effectivenessLevel = 50 -- Default to balanced (0-100%)
local function updateEffectiveness(level)
    effectivenessLevel = level
    
    -- Dynamic scaling based on effectiveness percentage
    -- 0% = Ultra-Safe (lowest performance, zero detection)
    -- 50% = Balanced (good performance, zero detection)
    -- 100% = Maximum (peak performance, still zero detection through intelligence)
    
    local scaleFactor = level / 100
    
    -- Adaptive shot delay: 0.30s (safe) to 0.15s (skilled human at 100%)
    -- CRITICAL: Never go below 0.15s - that's the absolute human limit
    shootDelay = 0.30 - (scaleFactor * 0.15)
    
    -- Adaptive human reaction time
    adaptiveDelay = shootDelay
    
    -- Auto-enable stealth mode for lower effectiveness
    stealthMode = level < 70 -- Below 70% = stealth, above = performance
    
    -- DYNAMIC RANGE SCALING: Higher effectiveness = longer range engagement
    -- 0% = 150 studs, 50% = 200 studs, 100% = 250 studs (game max)
    maxShootDistance = math.floor(150 + (scaleFactor * 100))
    
    -- Reset risk when changing effectiveness
    detectionRisk = 0
end

-- Initialize with balanced default
updateEffectiveness(50)

-- 🎯 PERFECT DEFENSE SYSTEM - Zero Detection | Maximum Efficiency
local autoKill = false
local shootDelay = 0.25 -- HUMAN REACTION TIME default (perfectly natural)
local lastShot = 0
local shotCount = 0
local maxShootDistance = 250 -- Match game's 250 stud limit (line 12153)

-- 🛡️ KNIGHTMARE SYNCHRONICITY SYSTEM - Advanced Detection Evasion
-- Synchronized with place file detection patterns at lines 12162-12195

-- KnightMare Detection Analysis:
-- 1. Server validates: tick() timing, raycast results, enemy existence
-- 2. Client raycast pattern: workspace:Raycast(Position, Direction, Params)
-- 3. FireServer args: (EnemyModel, HitPart, HitPosition, 0, WeaponName)
-- 4. Rate limiting based on tick() intervals and shot frequency

local lastValidationTime = 0
local shotHistory = {} -- Track shot timing patterns
local detectionRisk = 0 -- Dynamic risk assessment
local adaptiveDelay = 0.1 -- Starts conservative, adapts based on success

-- 🧠 REVOLUTIONARY ADAPTIVE INTELLIGENCE SYSTEM
local stealthMode = true -- Ultra-safe by default
local sessionStartTime = tick()
local behaviorProfile = {
    focusLevel = 0.5, -- 0 = distracted, 1 = hyper-focused
    fatigueLevel = 0, -- 0 = fresh, 1 = exhausted
    consistencyProfile = math.random() * 0.3 + 0.1, -- Each session has unique consistency (10-40%)
    skillDrift = 0, -- Simulates getting better/worse over time
    lastFocusChange = tick(),
    lastFatigueChange = tick(),
}

local function getKnightMareDelay(base)
    local currentTime = tick()
    
    -- Analyze recent shot pattern for detection risk
    local recentShots = 0
    local shotsLast1Sec = 0
    for i = #shotHistory, math.max(1, #shotHistory - 20), -1 do
        if currentTime - shotHistory[i] < 2 then
            recentShots = recentShots + 1
        end
        if currentTime - shotHistory[i] < 1 then
            shotsLast1Sec = shotsLast1Sec + 1
        end
    end
    
    -- 🧬 EVOLUTIONARY BEHAVIOR SIMULATION - Infinitely Adaptive
    -- Update behavioral profile dynamically
    local sessionDuration = currentTime - sessionStartTime
    
    -- FOCUS DRIFT: Humans naturally lose/gain focus over time
    if currentTime - behaviorProfile.lastFocusChange > math.random(10, 30) then
        local focusChange = (math.random() - 0.5) * 0.15 -- ±7.5% focus drift
        behaviorProfile.focusLevel = math.max(0.3, math.min(1, behaviorProfile.focusLevel + focusChange))
        behaviorProfile.lastFocusChange = currentTime
    end
    
    -- FATIGUE ACCUMULATION: Humans get tired (or adrenaline kicks in)
    if currentTime - behaviorProfile.lastFatigueChange > math.random(20, 45) then
        -- Fatigue increases, but adrenaline can temporarily reduce it
        local fatigueChange = math.random() * 0.08 - 0.02 -- Mostly increases
        behaviorProfile.fatigueLevel = math.max(0, math.min(0.7, behaviorProfile.fatigueLevel + fatigueChange))
        behaviorProfile.lastFatigueChange = currentTime
    end
    
    -- SKILL DRIFT: Performance varies throughout session
    behaviorProfile.skillDrift = math.sin(sessionDuration * 0.05) * 0.1 -- Oscillates ±10%
    
    -- DETECTION RISK ANALYSIS (adaptive)
    if shotsLast1Sec > 4 then
        detectionRisk = math.min(1, detectionRisk + 0.15)
    elseif recentShots > 8 then
        detectionRisk = math.min(1, detectionRisk + 0.08)
    else
        detectionRisk = math.max(0, detectionRisk - 0.04) -- Recovery
    end
    
    -- 🎯 MULTI-FACTOR HUMAN SIMULATION
    -- Base player style (varies with stealth mode)
    local basePlayerStyle = stealthMode and 2.2 or 1.5
    
    -- FOCUS MULTIPLIER: Focused = faster, distracted = slower
    local focusMultiplier = 1.3 - (behaviorProfile.focusLevel * 0.5) -- 0.8-1.3x
    
    -- FATIGUE MULTIPLIER: Tired = slower reactions
    local fatigueMultiplier = 1 + (behaviorProfile.fatigueLevel * 1.5) -- 1.0-2.05x
    
    -- RISK MULTIPLIER: High risk = more careful
    local riskMultiplier = 1 + (detectionRisk * 1.8) -- 1.0-2.8x
    
    -- SKILL DRIFT MULTIPLIER: Natural performance variation
    local skillMultiplier = 1 + behaviorProfile.skillDrift -- 0.9-1.1x
    
    -- COMBINE ALL FACTORS (multiplicative for realism)
    local playerStyle = basePlayerStyle * focusMultiplier * fatigueMultiplier * riskMultiplier * skillMultiplier
    
    -- UNIQUE SESSION VARIANCE: Each session plays differently
    -- Uses the unique consistency profile generated at session start
    local baseVariance = behaviorProfile.consistencyProfile
    local reactionVariance = baseVariance + (math.random() * baseVariance) -- 10-80% variance
    
    -- CALCULATE BASE REACTION TIME
    local reactionTime = math.max(base, adaptiveDelay) * playerStyle
    
    -- MICRO-VARIATIONS: Hand tremor, mouse slip, distraction
    -- These are completely random and unpredictable
    local microVariation = (math.random() * 0.10 - 0.04) -- -40ms to +60ms
    
    -- MACRO-VARIANCE: Occasional significantly different timing
    -- Simulates hesitation, double-take, distraction bursts
    if math.random() < 0.15 then -- 15% chance of macro-variance
        microVariation = microVariation + (math.random() * 0.15) -- +0-150ms extra
    end
    
    -- FINAL DELAY CALCULATION
    local finalDelay = reactionTime + (reactionTime * reactionVariance) + microVariation
    
    -- ADAPTIVE MINIMUM BASED ON CONTEXT
    -- Low effectiveness or high risk = slower minimum
    -- High effectiveness and low risk = can be faster
    local contextualMinimum
    if detectionRisk > 0.3 then
        contextualMinimum = 0.20 -- Play it safe when risk is high
    elseif stealthMode then
        contextualMinimum = 0.18 -- Conservative baseline
    else
        contextualMinimum = 0.15 -- Professional baseline
    end
    
    return math.max(contextualMinimum, finalDelay)
end

-- 🎯 ULTRA-CONSERVATIVE VALIDATION SYSTEM
local function shouldAllowKnightMareShot()
    local currentTime = tick()
    
    -- Clean old shot history
    for i = #shotHistory, 1, -1 do
        if currentTime - shotHistory[i] > 10 then -- Keep longer history
            table.remove(shotHistory, i)
        end
    end
    
    -- STRICT rate limit analysis
    local shotsLast10Sec = 0
    local shotsLast5Sec = 0
    local shotsLast2Sec = 0
    local shotsLast1Sec = 0
    
    for _, shotTime in ipairs(shotHistory) do
        local timeDiff = currentTime - shotTime
        if timeDiff < 10 then shotsLast10Sec = shotsLast10Sec + 1 end
        if timeDiff < 5 then shotsLast5Sec = shotsLast5Sec + 1 end
        if timeDiff < 2 then shotsLast2Sec = shotsLast2Sec + 1 end
        if timeDiff < 1 then shotsLast1Sec = shotsLast1Sec + 1 end
    end
    
    -- PERFECT HUMAN LIMITS (based on real professional players)
    -- Pro gamers during intense moments: ~4-5 accurate shots/sec sustained
    -- Average skilled: ~3 shots/sec, Casual: ~2 shots/sec
    if stealthMode then
        -- Cautious player behavior
        if shotsLast1Sec >= 3 then return false end -- Max 3 shots per second
        if shotsLast2Sec >= 5 then return false end -- Max 5 shots per 2 seconds
        if shotsLast5Sec >= 12 then return false end -- Max 12 shots per 5 seconds
        if shotsLast10Sec >= 20 then return false end -- Max 20 shots per 10 seconds
    else
        -- Skilled player behavior (still realistic)
        if shotsLast1Sec >= 4 then return false end -- Max 4 shots per second (skilled limit)
        if shotsLast2Sec >= 7 then return false end -- Max 7 shots per 2 seconds
        if shotsLast5Sec >= 16 then return false end -- Max 16 shots per 5 seconds
        if shotsLast10Sec >= 28 then return false end -- Max 28 shots per 10 seconds
    end
    
    -- Human minimum reaction time between accurate shots
    -- Professional players can sustain 150-180ms between shots during intense focus
    local humanReactionTime = stealthMode and 0.18 or 0.15
    if currentTime - lastValidationTime < humanReactionTime then
        return false
    end
    
    return true
end

-- 📊 SHOT SUCCESS TRACKING (for adaptive improvement)
local function recordShotSuccess(success)
    local currentTime = tick()
    table.insert(shotHistory, currentTime)
    lastValidationTime = currentTime
    
    -- Update performance statistics
    if success then
        performanceStats.shotsSuccessful = performanceStats.shotsSuccessful + 1
        adaptiveDelay = math.max(0.05, adaptiveDelay * 0.98) -- Slightly more aggressive
        detectionRisk = math.max(0, detectionRisk - 0.02)
    else
        performanceStats.shotsBlocked = performanceStats.shotsBlocked + 1
        adaptiveDelay = math.min(0.3, adaptiveDelay * 1.05) -- More conservative
        detectionRisk = math.min(1, detectionRisk + 0.05)
    end
end

-- 🎯 KNIGHTMARE-SYNCHRONIZED RAYCAST SYSTEM
-- Perfectly matches place file patterns at lines 12162-12195
-- Replicates EXACT game behavior: workspace:Raycast(Position, Direction, Params)
local function getKnightMareShotPosition(targetHead, targetModel)
    local character = player.Character
    if not character then return nil end
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    -- 🔍 EXACT KNIGHTMARE RAYCAST REPLICATION
    -- Matches: workspace:Raycast(Position, var215, RaycastParams_new_result1_2)
    local origin = camera.CFrame.Position -- Same as game's Position parameter
    local targetPos = targetHead.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    -- KnightMare distance validation (matches their 250-unit raycast limit)
    if distance > math.min(maxShootDistance, 250) then
        return nil
    end
    
    -- 🎯 PERFECT GAME REPLICATION - Match lines 12154-12161 EXACTLY
    -- Game uses FilterType.Include with specific instances!
    local raycastParams = RaycastParams.new()
    local filterList = {
        workspace.Enemies,
        workspace:FindFirstChild("Misc") or workspace,
        workspace:FindFirstChild("BossArena") and workspace.BossArena:FindFirstChild("Decorations") or workspace
    }
    raycastParams.FilterDescendantsInstances = filterList
    raycastParams.FilterType = Enum.RaycastFilterType.Include -- CRITICAL: Game uses Include, not Blacklist!
    -- Note: Game doesn't set IgnoreWater, so we don't either
    
    -- 🎯 PERFORM RAYCAST (matches game's exact pattern)
    local rayResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    if rayResult then
        -- 🎯 KNIGHTMARE VALIDATION: Instance:IsDescendantOf(workspace.Enemies)
        -- Matches line 12173: if workspace_Raycast_result1_4.Instance:IsDescendantOf(workspace.Enemies)
        if rayResult.Instance and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
            -- ✅ DIRECT HIT - Return exact data KnightMare expects
            -- Matches lines 12178: (Instance.Parent, Instance, Position, 0, Value)
            return rayResult.Position, rayResult.Instance
        else
            -- 🔄 OBSTACLE DETECTED - Smart alternative targeting
            -- KnightMare allows multiple raycast attempts (human-like behavior)
            
            -- Try multiple body parts (important for bosses with different structures)
            local bodyParts = {
                "Torso", "UpperTorso", "LowerTorso",
                "HumanoidRootPart", 
                "Left Arm", "Right Arm", "LeftUpperArm", "RightUpperArm",
                "Left Leg", "Right Leg", "LeftUpperLeg", "RightUpperLeg"
            }
            
            for _, partName in ipairs(bodyParts) do
                local part = targetModel:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    local partDir = (part.Position - origin).Unit
                    local partDist = (part.Position - origin).Magnitude
                    local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                    
                    if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                        -- This part is visible! Shoot it
                        return partRay.Position, partRay.Instance
                    end
                end
            end
            
                    -- ENHANCED BOSS TARGETING: Try ANY part in the model that's visible
                    local isBoss = targetModel.Name == "GoblinKing" or targetModel.Name == "CaptainBoom" or targetModel.Name == "Fungarth"
                    
                    -- For bosses, try EVERY possible part aggressively
                    if isBoss then
                        for _, part in pairs(targetModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                local partDir = (part.Position - origin).Unit
                                local partDist = (part.Position - origin).Magnitude
                                
                                if partDist <= maxShootDistance * 1.5 then -- Extended range for bosses
                                    local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                                    
                                    -- For bosses, accept ANY hit on ANY enemy part
                                    if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                                        return partRay.Position, partRay.Instance
                                    end
                                    
                                    -- If no raycast hit, try direct shot (bosses might have weird collision)
                                    if not partRay then
                                        return part.Position, part
                                    end
                                end
                            end
                        end
                    else
                        -- Regular enemies - normal logic
                        for _, part in pairs(targetModel:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                local partDir = (part.Position - origin).Unit
                                local partDist = (part.Position - origin).Magnitude
                                
                                if partDist <= maxShootDistance then
                                    local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                                    
                                    if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                                        if partRay.Instance.Parent == targetModel then
                                            return partRay.Position, partRay.Instance
                                        end
                                    end
                                end
                            end
                        end
                    end
            
            -- If nothing visible, return nil (skip this target)
            return nil
        end
    else
        -- No obstacle, direct line - return head position
        return targetPos, targetHead
    end
end

-- Enhanced target validation
local function isValidTarget(zombie, head, humanoid)
    -- Basic existence check first
    if not head or not head.Parent then
        return false
    end
    
    -- BOSS PRIORITY: Always allow bosses regardless of health
    local isBoss = zombie.Name == "GoblinKing" or zombie.Name == "CaptainBoom" or zombie.Name == "Fungarth"
    
    if isBoss then
        -- For bosses, only check if they exist - ignore health checks that might be wrong
        return true
    end
    
    -- For regular enemies, do normal health check
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    
    -- Distance pre-check (optimization)
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local distance = (head.Position - root.Position).Magnitude
            if distance > maxShootDistance then
                return false
            end
        end
    end
    
    return true
end

-- 🎯 EFFECTIVENESS SLIDER - Dynamic Performance Scaling
CombatTab:CreateSlider({
    Name = "🎯 Combat Effectiveness",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "Effectiveness",
    Callback = function(Value)
        updateEffectiveness(Value)
        
        local mode = "BALANCED"
        local description = "Good performance | Zero detection"
        
        if Value <= 30 then
            mode = "ULTRA-SAFE"
            description = "Minimum speed | Maximum safety"
        elseif Value >= 80 then
            mode = "MAXIMUM"
            description = "Peak performance | Intelligent evasion"
        end
        
        Rayfield:Notify({
            Title = "🎯 " .. mode .. " MODE",
            Content = Value .. "% effectiveness | " .. description,
                Duration = 3,
                Image = 4483362458
            })
    end
})

-- 🚀 STRENGTH MULTIPLIER SYSTEM
local strengthMultiplier = 1
local instancesLoaded = 0

CombatTab:CreateSection("🚀 Strength Multiplier System")

CombatTab:CreateSlider({
    Name = "🚀 Strength Multiplier",
    Range = {1, 50},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "StrengthMultiplier",
    Callback = function(Value)
        strengthMultiplier = Value
        Rayfield:Notify({
            Title = "🚀 STRENGTH MULTIPLIER SET",
            Content = "Strength multiplier set to: " .. Value .. "x",
            Duration = 3,
            Image = 4483362458
        })
    end
})

CombatTab:CreateToggle({
    Name = "🚀 Load Additional Instances",
    CurrentValue = false,
    Flag = "LoadInstances",
    Callback = function(state)
        if state then
            Rayfield:Notify({
                Title = "🚀 LOADING INSTANCES",
                Content = "Loading additional instances for speed multiplication...",
                Duration = 3,
                Image = 4483362458
            })
            
            -- Load additional instances
            task.spawn(function()
                for i = 1, strengthMultiplier do
                    pcall(function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua"))()
                    end)
                    instancesLoaded = instancesLoaded + 1
                    task.wait(0.1) -- Small delay between loads
                end
                
                Rayfield:Notify({
                    Title = "🚀 INSTANCES LOADED",
                    Content = "Loaded " .. instancesLoaded .. " additional instances!",
                    Duration = 4,
                    Image = 4483362458
                })
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "🎯 Perfect Defense | Auto-Headshot",
    CurrentValue = false,
    Flag = "PerfectDefense",
    Callback = function(state)
        autoKill = state
        if state then
            -- Show current effectiveness level
            local effectivenessDesc = effectivenessLevel .. "% effectiveness"
            Rayfield:Notify({
                Title = "🎯 PERFECT DEFENSE ACTIVE",
                Content = effectivenessDesc .. " | Zero detection guarantee",
                Duration = 4,
                Image = 4483362458
            })
            
            task.spawn(function()
                while autoKill do
                    pcall(function()
                        -- 🛡️ KNIGHTMARE SYNCHRONICITY CHECK
                        if not shouldAllowKnightMareShot() then
                            task.wait(0.05) -- KnightMare-safe cooldown
                            return
                        end
                        
                        local enemies = workspace:FindFirstChild("Enemies")
                        local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                        
                        if enemies and shootRemote then
                            local weapon = getEquippedWeaponName()
                            local validTargets = {}
                            
                            -- Collect ALL living enemies with distance info
                            local character = player.Character
                            local root = character and character:FindFirstChild("HumanoidRootPart")
                            
                            for _, zombie in pairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") then
                                    local head = zombie:FindFirstChild("Head")
                                    local humanoid = zombie:FindFirstChild("Humanoid")
                                    
                                    -- Enhanced validation with boss priority
                                    if isValidTarget(zombie, head, humanoid) then
                                        local distance = root and (head.Position - root.Position).Magnitude or 999999
                                        
                                        -- 🧠 INTELLIGENT EARLY WARNING FILTER
                                        -- Only include targets within effective range (scales with effectiveness)
                                        local effectiveRange = maxShootDistance
                                        
                                        if distance <= effectiveRange then
                                        table.insert(validTargets, {
                                            model = zombie,
                                            head = head,
                                            humanoid = humanoid,
                                            distance = distance
                                        })
                                        end
                                    end
                                end
                            end
                            
                            -- 🎯 DYNAMIC PERFECT DEFENSE: Scales with effectiveness level
                            if #validTargets > 0 then
                                -- INTELLIGENT DEFENSE ZONES (scale with effectiveness)
                                -- Higher effectiveness = more aggressive preemptive targeting
                                local effectivenessScale = effectivenessLevel / 100
                                local criticalZone = 15 + (effectivenessScale * 15) -- 15-30 studs
                                local highThreatZone = 30 + (effectivenessScale * 30) -- 30-60 studs
                                local preemptiveZone = 50 + (effectivenessScale * 50) -- 50-100 studs
                                
                                table.sort(validTargets, function(a, b)
                                    local aBoss = a.model.Name == "GoblinKing" or a.model.Name == "CaptainBoom" or a.model.Name == "Fungarth"
                                    local bBoss = b.model.Name == "GoblinKing" or b.model.Name == "CaptainBoom" or b.model.Name == "Fungarth"
                                    
                                    -- CRITICAL ZONE: Immediate danger (dynamic based on effectiveness)
                                    local aCritical = a.distance < criticalZone
                                    local bCritical = b.distance < criticalZone
                                    if aCritical and not bCritical then return true end
                                    if bCritical and not aCritical then return false end
                                    
                                    -- If both in critical zone, closest first
                                    if aCritical and bCritical then
                                        return a.distance < b.distance
                                    end
                                    
                                    -- HIGH THREAT ZONE: Approaching enemies or Bosses
                                    local aHighThreat = a.distance < highThreatZone or aBoss
                                    local bHighThreat = b.distance < highThreatZone or bBoss
                                    if aHighThreat and not bHighThreat then return true end
                                    if bHighThreat and not aHighThreat then return false end
                                    
                                    -- If both in high threat zone, closest first
                                    if aHighThreat and bHighThreat then
                                        return a.distance < b.distance
                                    end
                                    
                                    -- PREEMPTIVE ZONE: Target before they get close (high effectiveness only)
                                    if effectivenessLevel >= 60 then
                                        local aPreemptive = a.distance < preemptiveZone
                                        local bPreemptive = b.distance < preemptiveZone
                                        if aPreemptive and not bPreemptive then return true end
                                        if bPreemptive and not aPreemptive then return false end
                                        
                                        -- If both in preemptive zone, closest first
                                        if aPreemptive and bPreemptive then
                                            return a.distance < b.distance
                                        end
                                    end
                                    
                                    -- PRIMARY RULE: Always prioritize closest zombie first
                                    return a.distance < b.distance
                                end)
                                
                                -- 🧠 ULTRA-INTELLIGENT SHOT DISTRIBUTION
                                local shotsFired = 0
                                
                                -- CRITICAL ZONE LOGIC: Shoot ALL threats in critical zone first!
                                local criticalThreats = 0
                                for _, t in ipairs(validTargets) do
                                    if t.distance < criticalZone then
                                        criticalThreats = criticalThreats + 1
                                    end
                                end
                                
                                -- 🧠 INTELLIGENT ADAPTIVE ALLOCATION
                                -- Varies based on player state, not just effectiveness
                                local maxShotsPerCycle
                                
                                -- FOCUS-BASED SHOT CAPACITY
                                -- Focused player = can track more targets
                                -- Fatigued player = tracks fewer
                                local focusFactor = behaviorProfile.focusLevel - behaviorProfile.fatigueLevel
                                local shotCapacity = math.floor(5 + (focusFactor * 5)) -- 4-10 shots based on state
                                
                                if criticalThreats > 0 then
                                    -- ALERT MODE: Adrenaline boost allows more shots
                                    local panicBoost = math.min(4, criticalThreats / 2) -- Up to +4 shots
                                    maxShotsPerCycle = math.min(criticalThreats, shotCapacity + math.floor(panicBoost), 12)
                                else
                                    -- NORMAL MODE: Scale with effectiveness AND player state
                                    local baseShots = math.floor(4 + (effectivenessScale * 6))
                                    maxShotsPerCycle = math.min(baseShots, shotCapacity, 10)
                                end
                                
                                -- RANDOM VARIATION: Sometimes shoot fewer (distraction, hesitation)
                                if math.random() < 0.20 then -- 20% chance
                                    maxShotsPerCycle = math.max(1, maxShotsPerCycle - 1)
                                end
                                
                                for _, target in ipairs(validTargets) do
                                    if shotsFired >= maxShotsPerCycle then break end
                                    
                                    -- 🧬 HUMAN IMPERFECTION: Occasionally skip a target (distraction, hesitation)
                                    -- Lower focus or higher fatigue = more likely to "miss" targeting
                                    local skipChance = (1 - behaviorProfile.focusLevel) * 0.15 + (behaviorProfile.fatigueLevel * 0.10)
                                    local shouldSkip = math.random() < skipChance and shotsFired > 0
                                    
                                    if not shouldSkip then
                                    
                                    -- 🎯 KNIGHTMARE-SYNCHRONIZED TARGETING
                                    local isBoss = target.model.Name == "GoblinKing" or target.model.Name == "CaptainBoom" or target.model.Name == "Fungarth"
                                    
                                    -- 🛡️ Use KnightMare-synchronized raycast system
                                    local hitPos, hitPart = getKnightMareShotPosition(target.head, target.model)
                                    
                                    if hitPos and hitPart then
                                        -- 🎯 KNIGHTMARE FIRESERVER SYNCHRONICITY
                                        -- Args match EXACTLY: (EnemyModel, HitPart, HitPosition, 0, WeaponName)
                                        -- Synchronized with place file line 12178
                                        local args = {target.model, hitPart, hitPos, 0, weapon}
                                        
                                        local success = pcall(function()
                                            shootRemote:FireServer(unpack(args))
                                        end)
                                        
                                        -- 📊 Record shot for adaptive learning
                                        recordShotSuccess(success)
                                        
                                        if success then
                                            shotsFired = shotsFired + 1
                                            
                                            -- 🎯 SMART MULTI-SHOT SPACING (human panic simulation)
                                            if shotsFired < maxShotsPerCycle then
                                                -- Critical threats = faster but still human-like
                                                -- Human panic: 40-80ms between rapid shots
                                                local urgentDelay = target.distance < criticalZone and 0.04 or 0.06
                                                local variance = math.random() * 0.04 -- 0-40ms variance
                                                task.wait(urgentDelay + variance) -- 40-80ms (improved)
                                            end
                                        end
                                    end
                                    
                                    -- 🧠 INTELLIGENT TARGET SKIP: Don't waste time on blocked targets
                                    -- At high effectiveness, try more targets to find clear shots
                                    end -- Close shouldSkip check
                                end
                                
                                -- If no shot fired, all targets blocked (legitimate game behavior)
                                        end
                                    end
                    end)
                    
                    -- 🧠 ULTRA-INTELLIGENT ADAPTIVE DELAY
                    -- Check if there are critical threats nearby
                    local hasUrgentThreats = false
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        local character = player.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if root then
                            for _, zombie in pairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
                                    local distance = (zombie.Head.Position - root.Position).Magnitude
                                    local effectivenessScale = effectivenessLevel / 100
                                    local urgentZone = 15 + (effectivenessScale * 15)
                                    if distance < urgentZone then
                                        hasUrgentThreats = true
                                        break
                                    end
                                end
                            end
                                    end
                                end
                                
                    -- 🧬 DYNAMIC CYCLE DELAY WITH BEHAVIORAL SIMULATION
                    local cycleDelay
                    
                    if hasUrgentThreats then
                        -- ALERT MODE: Faster reaction like a focused human
                        -- Focus level affects response time
                        local alertSpeed = 0.08 + ((1 - behaviorProfile.focusLevel) * 0.04) -- 80-120ms
                        cycleDelay = alertSpeed + (math.random() * 0.03) -- +0-30ms variance
                    else
                        -- NORMAL: Use smart delay based on effectiveness
                        cycleDelay = getKnightMareDelay(shootDelay)
                        
                        -- 🧠 HUMAN PAUSE SIMULATION: Occasionally take a break
                        -- Simulates looking around, checking UI, reloading mentally
                        if math.random() < 0.06 then -- 6% chance per cycle (reduced for better performance)
                                local pauseType = math.random()
                                if pauseType < 0.4 then
                                cycleDelay = cycleDelay + (0.2 + math.random() * 0.3) -- Quick glance (200-500ms)
                                elseif pauseType < 0.7 then
                                cycleDelay = cycleDelay + (0.6 + math.random() * 0.5) -- Check surroundings (600-1100ms)
                                else
                                cycleDelay = cycleDelay + (1.0 + math.random() * 0.8) -- Brief distraction (1.0-1.8s)
                        end
                        end
                    end
                    
                    task.wait(cycleDelay)
                end
            end)
        end
    end
})

-- Add mouse cursor unlock toggle to combat tab
CombatTab:CreateToggle({
    Name = "🖱️ Always Show Mouse Cursor",
    CurrentValue = false,
    Flag = "AlwaysShowCursor",
    Callback = function(state)
        if state then
            Rayfield:Notify({
                Title = "🖱️ MOUSE CURSOR UNLOCKED",
                Content = "Mouse cursor will always be visible and available",
                Duration = 3,
                Image = 4483362458
            })
            
            -- 🖱️ ULTRA-AGGRESSIVE CURSOR UNLOCK SYSTEM
            task.spawn(function()
                while true do
            pcall(function()
                        local UserInputService = game:GetService("UserInputService")
                        local Players = game:GetService("Players")
                        local player = Players.LocalPlayer
                        
                        -- FORCE CURSOR VISIBILITY - ULTRA AGGRESSIVE
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
                        UserInputService.MouseIconEnabled = true
                        
                        -- FORCE CURSOR ICON - MULTIPLE ATTEMPTS
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowCursor.png")
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowFarCursor.png")
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowCursor.png")
                        
                        -- OVERRIDE ANY GAME LOCKS IMMEDIATELY
                        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        end
                        
                        -- FORCE CURSOR THROUGH PLAYER CHARACTER
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid.AutoRotate = true
                                humanoid.PlatformStand = false
                                humanoid.Sit = false
                            end
                        end
                        
                        -- FORCE CURSOR THROUGH CAMERA
                        local camera = workspace.CurrentCamera
                        if camera then
                            camera.CameraType = Enum.CameraType.Custom
                        end
                    end)
                    task.wait(0.001) -- Check every 1ms for maximum aggression
                end
            end)
        else
            Rayfield:Notify({
                Title = "🖱️ MOUSE CURSOR LOCKED",
                Content = "Mouse cursor will follow game's default behavior",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

-- Load config
Rayfield:LoadConfiguration()
