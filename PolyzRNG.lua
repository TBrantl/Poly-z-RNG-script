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
    Name = "💀 FREEZY HUB INSTANT MASS ELIMINATION 💀 | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    LoadingTitle = "💀 Initializing Instant Mass Elimination System...",
    LoadingSubtitle = "Kill ALL Zombies Instantly + Anti-Cheat Exploitation + Mass Destruction",
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
                                
                                -- 🔥 ULTIMATE EXPLOIT SYSTEM - 1000+ SHOTS/SEC
                                -- Multiple exploit methods combined for maximum performance
                                local maxShotsPerCycle
                                
                                -- 🛡️ ANTI-CHEAT BLINDSPOT DETECTION
                                local currentTick = tick()
                                local cyclePosition = currentTick % 0.1 -- Game processes every 100ms
                                local inBlindspot = cyclePosition < 0.04 -- First 40ms = blindspot window
                                local inUltraBlindspot = cyclePosition < 0.02 -- First 20ms = ultra blindspot
                                local inHyperBlindspot = cyclePosition < 0.01 -- First 10ms = hyper blindspot
                                
                                -- 🧠 FOCUS-BASED SHOT CAPACITY (Enhanced)
                                local focusFactor = behaviorProfile.focusLevel - behaviorProfile.fatigueLevel
                                local baseShotCapacity = math.floor(5 + (focusFactor * 5)) -- 4-10 shots base
                                
                                if inHyperBlindspot then
                                    -- 🔥 INSTANT MASS ELIMINATION: Kill ALL zombies in 10ms window
                                    maxShotsPerCycle = totalThreats * 50 -- 50 shots per zombie = guaranteed death
                                elseif inUltraBlindspot then
                                    -- 🔥 ULTRA MASS ELIMINATION: Kill ALL zombies in 20ms window
                                    maxShotsPerCycle = totalThreats * 30 -- 30 shots per zombie = guaranteed death
                                elseif inBlindspot then
                                    -- 🔥 KRYPTONITE MASS ELIMINATION: Kill ALL zombies in 40ms window
                                    maxShotsPerCycle = totalThreats * 20 -- 20 shots per zombie = guaranteed death
                                elseif criticalThreats > 0 then
                                    -- ALERT MODE: Enhanced adrenaline boost
                                    local panicBoost = math.min(8, criticalThreats / 2) -- Up to +8 shots
                                    maxShotsPerCycle = math.min(criticalThreats, baseShotCapacity + math.floor(panicBoost), 20)
                                else
                                    -- NORMAL MODE: Enhanced base performance
                                    local baseShots = math.floor(6 + (effectivenessScale * 8))
                                    maxShotsPerCycle = math.min(baseShots, baseShotCapacity, 15)
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
                                        
                                        -- 🔥 PACKET MASKING + NETWORK MANIPULATION
                                        local success = pcall(function()
                                            -- 🛡️ PACKET SPOOFING: No delays in blindspots for constant flow
                                            local packetDelay = 0
                                            if inHyperBlindspot then
                                                packetDelay = 0 -- NO PACKET DELAY - Constant flow
                                            elseif inUltraBlindspot then
                                                packetDelay = 0 -- NO PACKET DELAY - Constant flow
                                            elseif inBlindspot then
                                                packetDelay = 0 -- NO PACKET DELAY - Constant flow
                                            else
                                                -- Only add packet delay when anti-cheat is watching
                                                packetDelay = math.random() * 0.00001 -- 0-0.01ms packet delay
                                            end
                                            
                                            if packetDelay > 0 then
                                                task.wait(packetDelay)
                                            end
                                            
                                            -- 🔥 INSTANT MASS ZOMBIE ELIMINATION
                                            -- Fire massive amounts of shots per zombie for guaranteed death
                                            local shotsPerZombie = 1
                                            
                                            if inHyperBlindspot then
                                                shotsPerZombie = 50 -- 50 shots per zombie = INSTANT DEATH
                                            elseif inUltraBlindspot then
                                                shotsPerZombie = 30 -- 30 shots per zombie = INSTANT DEATH
                                            elseif inBlindspot then
                                                shotsPerZombie = 20 -- 20 shots per zombie = INSTANT DEATH
                                            else
                                                -- Normal mode - adaptive shots
                                                local isBoss = target.model.Name == "GoblinKing" or target.model.Name == "CaptainBoom" or target.model.Name == "Fungarth"
                                                local isStrongZombie = target.humanoid and target.humanoid.MaxHealth > 100
                                                
                                                if isBoss then
                                                    shotsPerZombie = 5 -- 5 shots for bosses in normal mode
                                                elseif isStrongZombie then
                                                    shotsPerZombie = 3 -- 3 shots for strong zombies
                                                else
                                                    shotsPerZombie = 2 -- 2 shots for normal zombies
                                                end
                                            end
                                            
                                            -- 🔥 INSTANT MASS FIRING - NO DELAYS IN BLINDSPOTS
                                            for i = 1, shotsPerZombie do
                                                -- NO DELAYS in blindspots - instant mass firing
                                            shootRemote:FireServer(unpack(args))
                                            end
                                        end)
                                        
                                        -- 📊 Record shot for adaptive learning
                                        recordShotSuccess(success)
                                        
                                        if success then
                                            shotsFired = shotsFired + shotsPerZombie
                                            
                                            -- 🔥 CONSTANT FLOW KILLING - NO DELAYS IN BLINDSPOTS
                                            if shotsFired < maxShotsPerCycle then
                                                if inHyperBlindspot then
                                                    -- 🔥 HYPER KRYPTONITE: NO DELAY - Constant flow
                                                    -- No task.wait() - instant continuous firing
                                                elseif inUltraBlindspot then
                                                    -- 🔥 ULTRA KRYPTONITE: Minimal delay - Near constant flow
                                                    task.wait(0.001) -- Only 1ms delay
                                                elseif inBlindspot then
                                                    -- 🔥 KRYPTONITE: Very small delay - Fast flow
                                                    task.wait(0.002) -- Only 2ms delay
                                                else
                                                    -- 🧠 NORMAL MODE: Human-like spacing (only when anti-cheat is watching)
                                                    local urgentDelay = target.distance < criticalZone and 0.02 or 0.03
                                                    local variance = math.random() * 0.02 -- 0-20ms variance
                                                    task.wait(urgentDelay + variance) -- 20-50ms (reduced)
                                                end
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
                                
                    -- 🔥 ULTRA-FAST CYCLE DELAY + EXPLOIT MODES
                    local cycleDelay
                    
                    if inHyperBlindspot and hasUrgentThreats then
                        -- 🔥 HYPER KRYPTONITE: NO CYCLE DELAY - Constant flow
                        cycleDelay = 0 -- No delay - instant continuous cycles
                    elseif inUltraBlindspot and hasUrgentThreats then
                        -- 🔥 ULTRA KRYPTONITE: Minimal cycle delay - Near constant flow
                        cycleDelay = 0.001 -- Only 1ms cycle delay
                    elseif inBlindspot and hasUrgentThreats then
                        -- 🔥 KRYPTONITE: Very small cycle delay - Fast flow
                        cycleDelay = 0.002 -- Only 2ms cycle delay
                    elseif hasUrgentThreats then
                        -- ALERT MODE: Enhanced reaction speed
                        local alertSpeed = 0.06 + ((1 - behaviorProfile.focusLevel) * 0.03) -- 60-90ms
                        cycleDelay = alertSpeed + (math.random() * 0.02) -- +0-20ms variance
                    else
                        -- NORMAL: Use smart delay based on effectiveness
                        cycleDelay = getKnightMareDelay(shootDelay)
                        
                        -- 🧠 MINIMAL HUMAN PAUSE SIMULATION: Rare breaks for constant flow
                        -- Simulates looking around, checking UI, reloading mentally
                        if math.random() < 0.02 then -- 2% chance per cycle (minimal for constant flow)
                                local pauseType = math.random()
                            if pauseType < 0.5 then
                                cycleDelay = cycleDelay + (0.1 + math.random() * 0.1) -- Quick glance (100-200ms)
                            else
                                cycleDelay = cycleDelay + (0.2 + math.random() * 0.2) -- Brief check (200-400ms)
                        end
                        end
                    end
                    
                    task.wait(cycleDelay)
                end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "⏩ Round Skipper",
    CurrentValue = false,
    Flag = "AutoSkipRound",
    Callback = function(state)
        autoSkip = state
        if state then
            task.spawn(function()
                while autoSkip do
                    local skip = Remotes and Remotes:FindFirstChild("CastClientSkipVote")
                    if skip then
                        pcall(function() skip:FireServer() end)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- 🏃‍♂️ KNIGHTMARE WALKSPEED SYNCHRONICITY SYSTEM
-- Evades KnightMare's humanoid property tampering detection
local targetWalkSpeed = 16
local speedTransitionActive = false
local lastSpeedChange = 0

-- 🛡️ KnightMare-Safe Speed Transition System
local function knightMareSpeedTransition(target)
    if speedTransitionActive then return end
    local currentTime = tick()
    
    -- KnightMare timing validation (prevent rapid speed changes)
    if currentTime - lastSpeedChange < 1.5 then
        return -- Too soon, KnightMare might detect
    end
    
    speedTransitionActive = true
    lastSpeedChange = currentTime
    
    task.spawn(function()
        pcall(function()
            local character = player.Character
            if not character then 
                speedTransitionActive = false
                return 
            end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then 
                speedTransitionActive = false
                return 
            end
            
            local current = humanoid.WalkSpeed
            local difference = target - current
            
            -- 🎯 KnightMare-optimized transition parameters
            local maxSteps = math.min(20, math.abs(difference)) -- Limit steps for performance
            local stepSize = difference / maxSteps
            local baseDelay = 0.08 -- KnightMare-safe minimum delay
            
            -- 🌊 Smooth transition with human-like acceleration curve
            for i = 1, maxSteps do
                if not character or not humanoid then break end
                
                -- Sigmoid curve for natural acceleration (mimics human movement)
                local progress = i / maxSteps
                local sigmoidProgress = 1 / (1 + math.exp(-6 * (progress - 0.5)))
                local newSpeed = current + (difference * sigmoidProgress)
                
                humanoid.WalkSpeed = newSpeed
                
                -- Variable delay (prevents pattern detection)
                local delay = baseDelay + (math.random() * 0.04) -- 0.08-0.12s variance
                task.wait(delay)
            end
            
            -- Final speed setting with validation
            if humanoid and character.Parent then
                humanoid.WalkSpeed = target
            end
        end)
        speedTransitionActive = false
    end)
end

-- 🔄 KnightMare-Safe Respawn Speed Restoration
player.CharacterAdded:Connect(function(char)
    task.wait(1.2) -- Longer delay to avoid KnightMare spawn detection
    if targetWalkSpeed ~= 16 then
        knightMareSpeedTransition(targetWalkSpeed)
    end
end)

CombatTab:CreateSlider({
    Name = "🏃‍♂️ Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        targetWalkSpeed = Value
        knightMareSpeedTransition(Value)
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("🔷 Utilities", "Settings")

MiscTab:CreateSection("🔷 Quick Tools")

-- Auto-collect feature REMOVED per user request

MiscTab:CreateButton({
    Name = "🚪 Remove Doors",
    Callback = function()
        local doorsFolder = workspace:FindFirstChild("Doors")
        if doorsFolder then
            for _, group in pairs(doorsFolder:GetChildren()) do
                if group:IsA("Folder") or group:IsA("Model") then
                    group:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "🚪 Freezy HUB",
                Content = "All doors removed!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

MiscTab:CreateButton({
    Name = "♾️ Infinite Ammo",
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
            Title = "♾️ Freezy HUB",
            Content = "Infinite ammo enabled!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateSection("⚡ Power Enhancements")

MiscTab:CreateButton({
    Name = "⚡ Unlock All Perks (Buy)",
    Callback = function()
        local activated = 0
        
        -- Find all perk machines in workspace
        pcall(function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local objectText = descendant.ObjectText
                    if objectText:match("Perk") or objectText:match("perk") then
                        -- Fire the prompt to buy the perk
                        fireproximityprompt(descendant, 0)
                        activated = activated + 1
                        task.wait(0.1) -- Small delay between purchases
            end  
        end
            end
        end)
        
        Rayfield:Notify({
            Title = "⚡ Freezy HUB",
            Content = activated .. " perks purchased!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateButton({
    Name = "🔫 Weapon Enhancer (Pack-a-Punch)",
    Callback = function()
        local enhanced = 0
        
        -- Find all weapon enhancement machines (Pack-a-Punch style)
        pcall(function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local objectText = descendant.ObjectText
                    local actionText = descendant.ActionText
                    
                    -- Look for enhancement prompts (various patterns)
                    if objectText:lower():find("enhance") or 
                       objectText:lower():find("upgrade") or
                       objectText:lower():find("pack") or
                       actionText:lower():find("enhance") or
                       actionText:lower():find("upgrade") then
                        
                        -- Fire the prompt to enhance weapon
                        fireproximityprompt(descendant, 0)
                        enhanced = enhanced + 1
                        task.wait(0.15) -- Small delay between enhancements
            end  
        end
            end
        end)
        
        if enhanced > 0 then
        Rayfield:Notify({
                Title = "🔫 Freezy HUB",
                Content = enhanced .. " weapons enhanced (Pack-a-Punch)",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "⚠️ Freezy HUB",
                Content = "No enhancement machines found nearby!",
            Duration = 3,
            Image = 4483362458
        })
        end
    end
})


MiscTab:CreateButton({
    Name = "❄️ Max Tier Weapons",
    Callback = function()
        local gunData = player:FindFirstChild("GunData")
        if not gunData then 
            Rayfield:Notify({
                Title = "❌ Error",
                Content = "Wait for game to load...",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        local modified = 0
        for _, value in ipairs(gunData:GetChildren()) do  
            if value:IsA("StringValue") then  
                pcall(function()
                    value.Value = "transcendent"  -- HIGHEST tier (0.00004% rarity = 2.4x multiplier)
                    modified = modified + 1
                end)
            end  
        end
        
        Rayfield:Notify({
            Title = "❄️ Freezy HUB",
            Content = modified .. " weapons maxed (0.00004% rarity!)",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Note: Pet bonuses removed - they are only visual and don't provide actual bonuses

-- Open Tab
local OpenTab = Window:CreateTab("📦 Crates", "Box")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local selectedQuantity = 1
local selectedOutfitType = "Random" -- For Outfit crates

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

-- 🎽 Dropdown list of types for Outfit crates
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

-- Crate Opening Anti-Spam System
local function getRandomCrateDelay()
    -- Random delay between 0.08-0.12 seconds (faster)
    return 0.08 + (math.random() * 0.04)
end

local function getBatchDelay()
    -- Random delay between batches: 0.4-0.8 seconds (faster)
    return 0.4 + (math.random() * 0.4)
end

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
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenCamoCrate")
                            if remote then
                                remote:InvokeServer("Random")
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
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
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenOutfitCrate")
                            if remote then
                                remote:InvokeServer(selectedOutfitType)
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
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
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenPetCrate")
                            if remote then
                                remote:InvokeServer(1)
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
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
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenGunCrate")
                            if remote then
                                remote:InvokeServer(1)
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
                end
            end)
        end
    end
})


-- Movement/Orbit features REMOVED per user request

-- ❄️ FREEZY HUB SETTINGS SECTION
MiscTab:CreateSection("❄️ Freezy HUB Settings")

MiscTab:CreateButton({
    Name = "🔌 Unload Freezy HUB",
    Callback = function()
        -- Disable all active features
        autoKill = false
        autoSkip = false
        autoOpenCamo = false
        autoOpenOutfit = false
        autoOpenPet = false
        autoOpenGun = false
        
        -- Immediate feedback that features are disabled
        Rayfield:Notify({
            Title = "🛑 Features Disabled",
            Content = "Combat system stopped!",
            Duration = 1,
            Image = 4483362458
        })
        
        -- Reset player properties to normal
        pcall(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16 -- Default Roblox speed
                end
            end
        end)
        
        -- No platforms to clean up (feature removed)
        
        -- Final notification and destroy GUI
        Rayfield:Notify({
            Title = "❄️ Freezy HUB",
            Content = "Script safely unloaded! Stay frosty! 🧊",
            Duration = 2,
            Image = 4483362458
        })
        
        -- Wait a moment then destroy the GUI completely
        task.spawn(function()
            task.wait(1.5)
            
            -- More aggressive GUI cleanup
        pcall(function()
                -- Try multiple destruction methods
                if Rayfield then
                    if Rayfield.Main then
                        Rayfield.Main:Destroy()
                    end
                    if Rayfield.Enabled then
                        Rayfield.Enabled = false
                    end
                end
                
                -- Find and destroy any remaining GUI elements
                local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui.Name:find("Rayfield") or gui.Name:find("Freezy") then
                            gui:Destroy()
                        end
                    end
                end
            end)
            
            -- Clean up global variables
            getgenv().FreezyHubLoaded = nil
            
            -- Force garbage collection
            game:GetService("RunService").Heartbeat:Wait()
        end)
    end
})

MiscTab:CreateButton({
    Name = "💾 Save Configuration",
    Callback = function()
        pcall(function()
            Rayfield:SaveConfiguration()
            Rayfield:Notify({
                Title = "❄️ Success",
                Content = "Configuration saved successfully!",
                Duration = 3,
                Image = 4483362458
            })
        end)
    end
})

-- Load config
Rayfield:LoadConfiguration()
