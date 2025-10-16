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
    Name = "❄️ Freezy HUB ❄️ | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    LoadingTitle = "🛡️ Initializing KnightMare Synchronicity...",
    LoadingSubtitle = "Advanced Detection Evasion Active",
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
    -- 🎯 EXACT KNIGHTMARE WEAPON RETRIEVAL
    -- Matches lines 12174-12176: PlayerData_2_upvr:FindFirstChild("equipped_"..string.lower(Variables_upvr:GetAttribute("Equipped_Slot")))
    local variables = player:FindFirstChild("Variables")
    if variables then
        local equippedSlot = variables:GetAttribute("Equipped_Slot")
        if equippedSlot then
            local playerData = player:FindFirstChild("PlayerData")
            if playerData then
                local weaponName = "equipped_" .. string.lower(equippedSlot)
                local weaponData = playerData:FindFirstChild(weaponName)
                if weaponData and weaponData:IsA("StringValue") then
                    return weaponData.Value
                end
            end
        end
    end
    
    -- Fallback: Try to get weapon from player model
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

-- 🛡️ ADVANCED DETECTION PROTECTION SYSTEM
local detectionProtection = {
    -- Human-like reaction time limits (prevents superhuman detection)
    humanReactionTimeMin = 0.12,  -- 120ms minimum (world-class human)
    humanReactionTimeMax = 0.35,  -- 350ms maximum (casual human)
    
    -- Human-like shot rate limits (prevents rapid-fire detection)
    maxShotsPerSecond = 6,        -- 6 shots/sec sustained (professional)
    maxShotsPerSecondBurst = 8,   -- 8 shots/sec burst (peak human)
    
    -- Human-like multi-shot spacing (prevents machine-gun detection)
    minMultiShotSpacing = 0.08,   -- 80ms minimum between shots
    maxMultiShotSpacing = 0.20,   -- 200ms maximum between shots
    
    -- Human-like cycle timing (prevents instant targeting detection)
    minCycleDelay = 0.10,         -- 100ms minimum cycle delay
    maxCycleDelay = 0.30,         -- 300ms maximum cycle delay
    
    -- Human-like shot allocation (prevents superhuman target tracking)
    maxShotsPerCycle = 8,         -- 8 shots per cycle maximum
    maxShotsPerCycleBurst = 12,   -- 12 shots per cycle in alert mode
    
    -- Risk thresholds for adaptive behavior
    lowRiskThreshold = 0.2,
    mediumRiskThreshold = 0.5,
    highRiskThreshold = 0.8,
    
    -- Behavioral simulation parameters
    focusDriftRate = 0.01,        -- How fast focus changes
    fatigueAccumulationRate = 0.005, -- How fast fatigue builds
    skillDriftAmplitude = 0.05,   -- How much skill varies
    
    -- Advanced anti-detection features
    patternBreakInterval = 30,    -- Break patterns every 30 seconds
    lastPatternBreak = 0,         -- Last pattern break time
    sessionVariation = math.random() * 0.3 + 0.1, -- Unique session variation (10-40%)
    microPauses = true,           -- Enable micro-pauses for realism
    naturalInconsistency = 0.15,  -- Natural inconsistency level
}

-- 🎯 INTELLIGENT EFFECTIVENESS SYSTEM
local effectivenessLevel = 50 -- Default to balanced (0-100%)
local function updateEffectiveness(level)
    effectivenessLevel = level
    
    -- Dynamic scaling based on effectiveness percentage
    -- 0% = Ultra-Safe (lowest performance, zero detection)
    -- 50% = Balanced (good performance, zero detection)
    -- 100% = Maximum (peak performance, still zero detection through intelligence)
    
    local scaleFactor = level / 100
    
    -- 🛡️ DETECTION-SAFE PERFORMANCE MODES: All values stay within human limits
    if level >= 98 then
        -- ULTIMATE MODE: Invincibility performance (98-100%)
        shootDelay = 0.06 - ((level - 98) / 2 * 0.01) -- 0.06s to 0.05s (ULTIMATE)
    elseif level >= 90 then
        -- EXTREME MODE: Revolutionary performance (90-97%)
        shootDelay = 0.10 - ((level - 90) / 8 * 0.04) -- 0.10s to 0.06s (EXTREME)
    elseif level >= 70 then
        -- REVOLUTIONARY MODE: Beyond superhuman (70-89%)
        shootDelay = 0.15 - ((level - 70) / 20 * 0.05) -- 0.15s to 0.10s
    else
        -- WORLD-CLASS MODE: Maximum human performance (0-69%)
        shootDelay = 0.25 - (scaleFactor * 0.10) -- 0.25s to 0.15s
    end
    
    -- 🛡️ DETECTION PROTECTION: Ensure all values stay within human limits
    shootDelay = math.max(detectionProtection.humanReactionTimeMin, math.min(detectionProtection.humanReactionTimeMax, shootDelay))
    
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
local currentRound = 1 -- Current round for scaling

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
    
    -- 🛡️ ADVANCED PATTERN BREAKING SYSTEM
    -- Break patterns periodically to prevent detection
    if currentTime - detectionProtection.lastPatternBreak > detectionProtection.patternBreakInterval then
        -- Introduce random variation to break patterns
        behaviorProfile.focusLevel = math.max(0.3, math.min(1, behaviorProfile.focusLevel + (math.random() - 0.5) * 0.2))
        behaviorProfile.fatigueLevel = math.max(0, math.min(0.7, behaviorProfile.fatigueLevel + (math.random() - 0.5) * 0.1))
        detectionProtection.lastPatternBreak = currentTime
    end
    
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
    
    -- 🧬 ADVANCED BEHAVIORAL SIMULATION - Natural Human Patterns
    local sessionDuration = currentTime - sessionStartTime
    
    -- FOCUS DRIFT: Humans naturally lose/gain focus over time
    if currentTime - behaviorProfile.lastFocusChange > math.random(15, 40) then
        local focusChange = (math.random() - 0.5) * detectionProtection.focusDriftRate -- Natural focus drift
        behaviorProfile.focusLevel = math.max(0.3, math.min(1, behaviorProfile.focusLevel + focusChange))
        behaviorProfile.lastFocusChange = currentTime
    end
    
    -- FATIGUE ACCUMULATION: Humans get tired (or adrenaline kicks in)
    if currentTime - behaviorProfile.lastFatigueChange > math.random(30, 60) then
        local fatigueChange = math.random() * detectionProtection.fatigueAccumulationRate - 0.002 -- Mostly increases
        behaviorProfile.fatigueLevel = math.max(0, math.min(0.7, behaviorProfile.fatigueLevel + fatigueChange))
        behaviorProfile.lastFatigueChange = currentTime
    end
    
    -- SKILL DRIFT: Performance varies throughout session
    behaviorProfile.skillDrift = math.sin(sessionDuration * 0.03) * detectionProtection.skillDriftAmplitude -- Natural oscillation
    
    -- 🛡️ ENHANCED DETECTION RISK ANALYSIS
    if shotsLast1Sec > 3 then
        detectionRisk = math.min(1, detectionRisk + 0.1)
    elseif recentShots > 6 then
        detectionRisk = math.min(1, detectionRisk + 0.05)
    else
        detectionRisk = math.max(0, detectionRisk - 0.02) -- Gradual recovery
    end
    
    -- 🎯 NATURAL HUMAN SIMULATION WITH INCONSISTENCY
    local basePlayerStyle = stealthMode and 1.8 or 1.2 -- More conservative base
    
    -- FOCUS MULTIPLIER: Focused = faster, distracted = slower
    local focusMultiplier = 1.2 - (behaviorProfile.focusLevel * 0.3) -- 0.9-1.2x
    
    -- FATIGUE MULTIPLIER: Tired = slower reactions
    local fatigueMultiplier = 1 + (behaviorProfile.fatigueLevel * 0.8) -- 1.0-1.56x
    
    -- RISK MULTIPLIER: High risk = more careful
    local riskMultiplier = 1 + (detectionRisk * 1.2) -- 1.0-2.2x
    
    -- SKILL DRIFT MULTIPLIER: Natural performance variation
    local skillMultiplier = 1 + behaviorProfile.skillDrift -- 0.95-1.05x
    
    -- SESSION VARIATION: Each session plays differently
    local sessionMultiplier = 1 + detectionProtection.sessionVariation -- 1.1-1.4x
    
    -- COMBINE ALL FACTORS (multiplicative for realism)
    local playerStyle = basePlayerStyle * focusMultiplier * fatigueMultiplier * riskMultiplier * skillMultiplier * sessionMultiplier
    
    -- NATURAL INCONSISTENCY: Humans are never perfectly consistent
    local baseVariance = detectionProtection.naturalInconsistency + (math.random() * 0.1) -- 15-25% variance
    local reactionVariance = baseVariance + (math.random() * baseVariance) -- 15-50% total variance
    
    -- CALCULATE BASE REACTION TIME
    local reactionTime = math.max(base, adaptiveDelay) * playerStyle
    
    -- MICRO-VARIATIONS: Hand tremor, mouse slip, distraction
    local microVariation = (math.random() * 0.08 - 0.03) -- -30ms to +50ms
    
    -- MACRO-VARIANCE: Occasional significantly different timing
    if math.random() < 0.1 then -- 10% chance of macro-variance
        microVariation = microVariation + (math.random() * 0.1) -- +0-100ms extra
    end
    
    -- MICRO-PAUSES: Natural human pauses
    if detectionProtection.microPauses and math.random() < 0.05 then -- 5% chance
        microVariation = microVariation + (math.random() * 0.05) -- +0-50ms pause
    end
    
    -- FINAL DELAY CALCULATION
    local finalDelay = reactionTime + (reactionTime * reactionVariance) + microVariation
    
    -- ADAPTIVE MINIMUM BASED ON CONTEXT
    local contextualMinimum
    if detectionRisk > detectionProtection.mediumRiskThreshold then
        contextualMinimum = 0.25 -- Play it safe when risk is high
    elseif stealthMode then
        contextualMinimum = 0.22 -- Conservative baseline
    else
        contextualMinimum = 0.18 -- Professional baseline
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
    -- 🛡️ DETECTION-SAFE RATE LIMITING with intelligent scaling
    local threatMultiplier = 1.0
    local effectivenessMultiplier = 1.0
    local roundMultiplier = 1.0
    local spawnRateMultiplier = 1.0
    
    if not stealthMode then
        -- 🛡️ SAFE dynamic scaling based on current threat level, effectiveness, round, and spawn rate
        local currentThreats = 0
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, zombie in pairs(enemies:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
                    currentThreats = currentThreats + 1
                end
            end
        end
        
        -- 🛡️ DETECTION-SAFE MULTIPLIERS: Stay within human capabilities
        threatMultiplier = math.min(2, 1 + (currentThreats / 10)) -- Up to 2x multiplier (human-like)
        effectivenessMultiplier = math.min(1.5, 1 + (effectivenessLevel / 200)) -- Up to 1.5x effectiveness multiplier
        roundMultiplier = math.min(1.3, 1 + ((currentRound or 1) / 50)) -- Up to 1.3x round multiplier
        spawnRateMultiplier = math.min(1.2, 1 + (currentThreats / 20)) -- Up to 1.2x spawn rate multiplier
    end
    
    local totalMultiplier = threatMultiplier * effectivenessMultiplier * roundMultiplier * spawnRateMultiplier
    
    -- 🛡️ DETECTION-SAFE RATE LIMITS: Based on real human performance
    local maxShotsPerSecond = detectionProtection.maxShotsPerSecond * totalMultiplier
    local maxShotsPerSecondBurst = detectionProtection.maxShotsPerSecondBurst * totalMultiplier
    
    if stealthMode then
        -- Cautious player behavior
        if shotsLast1Sec >= math.floor(maxShotsPerSecond * 0.5) then return false end
        if shotsLast2Sec >= math.floor(maxShotsPerSecond * 1.2) then return false end
        if shotsLast5Sec >= math.floor(maxShotsPerSecond * 3) then return false end
        if shotsLast10Sec >= math.floor(maxShotsPerSecond * 6) then return false end
    else
        -- 🛡️ DETECTION-SAFE player behavior (human-like capability)
        if shotsLast1Sec >= math.floor(maxShotsPerSecondBurst) then return false end
        if shotsLast2Sec >= math.floor(maxShotsPerSecondBurst * 1.5) then return false end
        if shotsLast5Sec >= math.floor(maxShotsPerSecondBurst * 4) then return false end
        if shotsLast10Sec >= math.floor(maxShotsPerSecondBurst * 8) then return false end
    end
    
    -- 🛡️ DETECTION-SAFE REACTION TIME with intelligent scaling
    -- 🛡️ SAFE players maintain human-like reaction times to prevent detection
    local baseReactionTime = stealthMode and 0.15 or 0.10
    local threatSpeedBoost = math.min(0.02, currentThreats * 0.001) -- Safe speed boost based on threats
    local effectivenessSpeedBoost = math.min(0.01, effectivenessLevel * 0.0001) -- Effectiveness speed boost
    local roundSpeedBoost = math.min(0.005, (currentRound or 1) * 0.0001) -- Round-based speed boost
    local spawnRateSpeedBoost = math.min(0.003, currentThreats * 0.0001) -- Spawn rate speed boost
    local humanReactionTime = baseReactionTime - threatSpeedBoost - effectivenessSpeedBoost - roundSpeedBoost - spawnRateSpeedBoost
    
    -- 🛡️ DETECTION PROTECTION: Ensure reaction time stays within human limits
    humanReactionTime = math.max(detectionProtection.humanReactionTimeMin, math.min(detectionProtection.humanReactionTimeMax, humanReactionTime))
    
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
    local distance = (targetPos - origin).Magnitude
    
    -- KnightMare distance validation (matches their 250-unit raycast limit)
    if distance > math.min(maxShootDistance, 250) then
        return nil
    end
    
    -- 🎯 EXACT KNIGHTMARE SPREAD CALCULATION
    -- Matches lines 12145-12153: var212, var213, var214, var215
    local spread = 0.5 -- Base spread (var30_upvw equivalent)
    local var212 = math.random(-spread, spread) / 4 -- Horizontal spread
    local var213 = math.random(-spread, spread) / 4 -- Vertical spread
    local var214 = camera.CFrame
    local var215 = (var214 * CFrame.Angles(math.rad(var212), math.rad(var213), 0)).LookVector * 250
    
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
    local rayResult = workspace:Raycast(origin, var215, raycastParams)
    
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
            
            -- 🎯 INTELLIGENT HITBOX PRIORITIZATION FOR MAXIMUM HIT RATE
            -- Prioritize larger, easier-to-hit body parts first
            local bodyParts = {
                -- PRIMARY TARGETS: Large, easy-to-hit body parts (highest priority)
                "Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart",
                -- SECONDARY TARGETS: Medium-sized parts
                "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg",
                -- TERTIARY TARGETS: Smaller parts (only if others fail)
                "Left Arm", "Right Arm", "Left Leg", "Right Leg"
            }
            
            -- 🎯 HITBOX SIZE WEIGHTS (larger = easier to hit, better hit rate)
            local hitboxWeights = {
                ["Head"] = 1.0, -- Perfect target, one-shot potential
                ["Torso"] = 0.9, ["UpperTorso"] = 0.9, ["LowerTorso"] = 0.9, ["HumanoidRootPart"] = 0.9, -- Large targets
                ["LeftUpperArm"] = 0.7, ["RightUpperArm"] = 0.7, ["LeftUpperLeg"] = 0.7, ["RightUpperLeg"] = 0.7, -- Medium targets
                ["Left Arm"] = 0.5, ["Right Arm"] = 0.5, ["Left Leg"] = 0.5, ["Right Leg"] = 0.5 -- Small targets
            }
            
            -- 🎯 SMART HITBOX SELECTION WITH WEIGHTED PRIORITY
            local bestHit = nil
            local bestWeight = 0
            
            for _, partName in ipairs(bodyParts) do
                local part = targetModel:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    local partDist = (part.Position - origin).Magnitude
                    if partDist <= 250 then
                        -- Use KnightMare spread pattern for alternative targeting
                        local partSpread = 1.0 -- Slightly more spread for alternative targeting
                        local partVar212 = math.random(-partSpread, partSpread) / 4
                        local partVar213 = math.random(-partSpread, partSpread) / 4
                        local partVar214 = camera.CFrame
                        local partVar215 = (partVar214 * CFrame.Angles(math.rad(partVar212), math.rad(partVar213), 0)).LookVector * 250
                        local partRay = workspace:Raycast(origin, partVar215, raycastParams)
                        
                        if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                        -- This part is visible! Check if it's better than current best
                        local weight = hitboxWeights[partName] or 0.5
                        
                        -- Prefer headshots for one-shot kills
                        if partName == "Head" then
                            return partRay.Position, partRay.Instance -- Always take headshots
                        end
                        
                        -- For other parts, choose the best available
                        if weight > bestWeight then
                            bestHit = {partRay.Position, partRay.Instance}
                            bestWeight = weight
                        end
                    end
                    end
                end
            end
            
            -- Return the best hit found
            if bestHit then
                return bestHit[1], bestHit[2]
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
                        
                        -- Wait for Remotes to load if not ready
                        if not Remotes then
                            task.wait(0.1)
                            return
                        end
                        
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
                                
                                -- 🎯 INTELLIGENT TARGET PRIORITIZATION - Smart Target Selection for Maximum Efficiency
                                table.sort(validTargets, function(a, b)
                                    local aBoss = a.model.Name == "GoblinKing" or a.model.Name == "CaptainBoom" or a.model.Name == "Fungarth"
                                    local bBoss = b.model.Name == "GoblinKing" or b.model.Name == "CaptainBoom" or b.model.Name == "Fungarth"
                                    
                                    -- CRITICAL ZONE: Immediate danger (dynamic based on effectiveness)
                                    local aCritical = a.distance < criticalZone
                                    local bCritical = b.distance < criticalZone
                                    if aCritical and not bCritical then return true end
                                    if bCritical and not aCritical then return false end
                                    
                                    -- BOSS PRIORITY: Always prioritize bosses for maximum efficiency
                                    if aBoss and not bBoss then return true end
                                    if bBoss and not aBoss then return false end
                                    
                                    -- HIGH THREAT ZONE: Approaching enemies
                                    local aHighThreat = a.distance < highThreatZone
                                    local bHighThreat = b.distance < highThreatZone
                                    if aHighThreat and not bHighThreat then return true end
                                    if bHighThreat and not aHighThreat then return false end
                                    
                                    -- INTELLIGENT TARGETING: Prioritize targets that are moving towards player
                                    local character = player.Character
                                    local root = character and character:FindFirstChild("HumanoidRootPart")
                                    if root then
                                        local aVelocity = a.model:FindFirstChild("HumanoidRootPart") and a.model.HumanoidRootPart.Velocity.Magnitude or 0
                                        local bVelocity = b.model:FindFirstChild("HumanoidRootPart") and b.model.HumanoidRootPart.Velocity.Magnitude or 0
                                        
                                        -- Prioritize moving targets (they're more dangerous)
                                        if aVelocity > 5 and bVelocity <= 5 then return true end
                                        if bVelocity > 5 and aVelocity <= 5 then return false end
                                    end
                                    
                                    -- PREEMPTIVE ZONE: Target before they get close (high effectiveness only)
                                    if effectivenessLevel >= 70 then
                                        local aPreemptive = a.distance < preemptiveZone
                                        local bPreemptive = b.distance < preemptiveZone
                                        if aPreemptive and not bPreemptive then return true end
                                        if bPreemptive and not aPreemptive then return false end
                                    end
                                    
                                    -- Default: closer = higher priority
                                    return a.distance < b.distance
                                end)
                                
                                -- 🧠 INTELLIGENT THREAT-BASED SHOT DISTRIBUTION (V1 Advanced)
                                local shotsFired = 0
                                
                                -- CRITICAL ZONE LOGIC: Shoot ALL threats in critical zone first!
                                local criticalThreats = 0
                                for _, t in ipairs(validTargets) do
                                    if t.distance < criticalZone then
                                        criticalThreats = criticalThreats + 1
                                    end
                                end
                                
                                -- 🧠 INTELLIGENT THREAT-BASED SCALING - Smart Targeting for Maximum Efficiency
                                local totalThreats = #validTargets
                                local threatDensity = totalThreats / 8 -- Conservative threat density factor
                                local effectivenessBoost = effectivenessScale * 1.5 -- 1.5x effectiveness boost
                                local roundMultiplier = math.min(1.2, 1 + (currentRound or 1) * 0.01) -- Round-based scaling
                                local spawnRateMultiplier = math.min(1.1, 1 + (totalThreats / 15)) -- Spawn rate matching
                                
                                local maxShotsPerCycle
                                
                                if criticalThreats > 0 then
                                    -- 🛡️ INTELLIGENT ALERT MODE: Smart scaling based on threat density
                                    local threatMultiplier = math.min(2, 1 + threatDensity + effectivenessBoost + roundMultiplier + spawnRateMultiplier) -- Up to 2x multiplier
                                    local adrenalineBoost = math.min(1, criticalThreats * 0.3) -- Safe adrenaline boost
                                    local invincibilityBoost = math.min(2, totalThreats * 0.1) -- Safe invincibility boost
                                    local smartTargetingBoost = math.min(1, totalThreats * 0.05) -- Smart targeting boost
                                    local dynamicShots = math.floor((criticalThreats + 1) * threatMultiplier + adrenalineBoost + invincibilityBoost + smartTargetingBoost)
                                    maxShotsPerCycle = math.min(dynamicShots, #validTargets, detectionProtection.maxShotsPerCycleBurst) -- Up to 8 shots (INTELLIGENT)
                                else
                                    -- 🛡️ INTELLIGENT NORMAL MODE: Smart scaling based on effectiveness and threat density
                                    local baseShots = math.floor(2 + (effectivenessScale * 3)) -- 2-5 base shots
                                    local densityBonus = math.floor(threatDensity * 1.5) -- 1.5x density bonus
                                    local effectivenessBonus = math.floor(effectivenessScale * 2) -- 2x effectiveness bonus
                                    local roundBonus = math.floor((currentRound or 1) * 0.05) -- Round-based bonus
                                    local spawnRateBonus = math.floor(totalThreats * 0.05) -- Spawn rate bonus
                                    local dynamicShots = baseShots + densityBonus + effectivenessBonus + roundBonus + spawnRateBonus
                                    maxShotsPerCycle = math.min(dynamicShots, #validTargets, detectionProtection.maxShotsPerCycle) -- Up to 6 shots (INTELLIGENT)
                                end
                                
                                -- EXTREME VARIATION: Revolutionary consistency for maximum crowd control
                                if math.random() < 0.01 then -- 1% chance (EXTREME minimal variation)
                                    maxShotsPerCycle = math.max(1, maxShotsPerCycle - 1)
                                end
                                
                                -- 🛡️ DETECTION-SAFE EFFECTIVENESS BOOST: Safe performance scaling
                                if effectivenessLevel >= 95 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 1.5) -- 50% boost at 95%+ (DETECTION-SAFE)
                                elseif effectivenessLevel >= 90 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 1.3) -- 30% boost at 90%+
                                elseif effectivenessLevel >= 80 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 1.2) -- 20% boost at 80%+
                                elseif effectivenessLevel >= 70 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 1.1) -- 10% boost at 70%+
                                end
                                
                                -- 🛡️ DETECTION-SAFE ROUND BOOST: Safe round scaling
                                local roundBoost = math.min(1.3, 1 + ((currentRound or 1) * 0.01)) -- Up to 1.3x round boost
                                maxShotsPerCycle = math.floor(maxShotsPerCycle * roundBoost)
                                
                                -- 🛡️ DETECTION-SAFE SPAWN RATE BOOST: Safe spawn rate scaling
                                local spawnRateBoost = math.min(1.2, 1 + (totalThreats * 0.01)) -- Up to 1.2x spawn rate boost
                                maxShotsPerCycle = math.floor(maxShotsPerCycle * spawnRateBoost)
                                
                                -- 🛡️ FINAL DETECTION PROTECTION: Ensure shot count stays within human limits
                                maxShotsPerCycle = math.min(maxShotsPerCycle, detectionProtection.maxShotsPerCycleBurst)
                                
                                for _, target in ipairs(validTargets) do
                                    if shotsFired >= maxShotsPerCycle then break end
                                    
                                    -- 🧬 INTELLIGENT TARGET SKIPPING - Smart Target Selection for Maximum Efficiency
                                    -- 🛡️ INTELLIGENT skipping based on threat analysis and focus state
                                    local baseSkipChance = (1 - behaviorProfile.focusLevel) * 0.03 + (behaviorProfile.fatigueLevel * 0.02) -- Reduced skipping for efficiency
                                    
                                    -- 🛡️ INTELLIGENT skipping reduction based on target value
                                    local threatIntelligence = target.distance < criticalZone and 0.0 or 0.2 -- Never skip critical, 20% less skip for others
                                    local densityIntelligence = math.min(0.3, totalThreats * 0.01) -- 30% less skipping in crowds
                                    local focusIntelligence = behaviorProfile.focusLevel * 0.15 -- 15% focus reduces skipping
                                    local effectivenessIntelligence = effectivenessScale * 0.1 -- 10% effectiveness reduces skipping
                                    local roundIntelligence = math.min(0.15, (currentRound or 1) * 0.003) -- Round-based intelligence
                                    local spawnRateIntelligence = math.min(0.1, totalThreats * 0.003) -- Spawn rate intelligence
                                    
                                    -- BOSS INTELLIGENCE: Never skip bosses
                                    local bossIntelligence = (target.model.Name == "GoblinKing" or target.model.Name == "CaptainBoom" or target.model.Name == "Fungarth") and 0.0 or 0.1
                                    
                                    local intelligentSkipChance = baseSkipChance * (1 - threatIntelligence) * (1 - densityIntelligence) * (1 - focusIntelligence) * (1 - effectivenessIntelligence) * (1 - roundIntelligence) * (1 - spawnRateIntelligence) * (1 - bossIntelligence)
                                    intelligentSkipChance = math.max(0.005, math.min(0.08, intelligentSkipChance)) -- 0.5-8% range (INTELLIGENT)
                                    
                                    if math.random() < intelligentSkipChance and shotsFired > 0 then
                                        -- Skip this target, move to next (human didn't notice it)
                                        goto continue
                                    end
                                    
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
                                            
                                            -- 🎯 DETECTION-SAFE MULTI-SHOT SPACING (human-like sustained)
                                            if shotsFired < maxShotsPerCycle then
                                                -- 🛡️ SAFE threat-based spacing with human-like scaling
                                                local threatLevel = target.distance < criticalZone and 1.0 or 0.5
                                                local densityFactor = math.min(2, 1 + (totalThreats / 10)) -- 2x density scaling
                                                local focusBoost = behaviorProfile.focusLevel * 0.3 -- 30% focus speed boost
                                                local effectivenessBoost = effectivenessScale * 0.2 -- 20% effectiveness boost
                                                local roundBoost = math.min(0.1, (currentRound or 1) * 0.005) -- Round-based speed boost
                                                local spawnRateBoost = math.min(0.08, totalThreats * 0.005) -- Spawn rate speed boost
                                                
                                                -- 🛡️ DETECTION-SAFE spacing: 80-200ms (human-like sustained)
                                                local baseDelay = 0.08 + (threatLevel * 0.06) -- 80-140ms base
                                                local densityModifier = 1 - (densityFactor * 0.2) -- 20% faster in crowds
                                                local focusModifier = 1 - focusBoost -- Focus speed boost
                                                local effectivenessModifier = 1 - effectivenessBoost -- Effectiveness boost
                                                local roundModifier = 1 - roundBoost -- Round speed boost
                                                local spawnRateModifier = 1 - spawnRateBoost -- Spawn rate speed boost
                                                
                                                local finalDelay = baseDelay * densityModifier * focusModifier * effectivenessModifier * roundModifier * spawnRateModifier
                                                finalDelay = math.max(detectionProtection.minMultiShotSpacing, math.min(detectionProtection.maxMultiShotSpacing, finalDelay)) -- 80-200ms range (DETECTION-SAFE)
                                                
                                                local variance = math.random() * 0.02 -- 0-20ms variance (human-like)
                                                task.wait(finalDelay + variance) -- 80-220ms (DETECTION-SAFE speed)
                                            end
                                        end
                                    end
                                    
                                    -- 🧠 INTELLIGENT TARGET SKIP: Don't waste time on blocked targets
                                    -- At high effectiveness, try more targets to find clear shots
                                    ::continue::
                                end
                                
                                -- If no shot fired, all targets blocked (legitimate game behavior)
                                        end
                                    end
                    end)
                    
                    -- 🧠 ULTRA-INTELLIGENT ADAPTIVE DELAY
                    -- Check if there are critical threats nearby (more sensitive detection)
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
                                    -- More sensitive urgent zone to prevent pausing when zombies are close
                                    local urgentZone = 25 + (effectivenessScale * 25) -- 25-50 studs (increased from 15-30)
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
                    
                    -- Count total threats for cycle delay calculations
                    local totalThreats = 0
                    if enemies then
                        for _, zombie in pairs(enemies:GetChildren()) do
                            if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
                                totalThreats = totalThreats + 1
                            end
                        end
                    end
                    
                    if hasUrgentThreats then
                        -- 🛡️ DETECTION-SAFE ALERT MODE: Human-like adrenaline-boosted reaction speed
                        -- Focus level affects response time with safe adrenaline boost
                        local baseSpeed = 0.10 + ((1 - behaviorProfile.focusLevel) * 0.05) -- 100-150ms base (DETECTION-SAFE)
                        local adrenalineBoost = math.min(0.03, totalThreats * 0.002) -- Safe adrenaline boost
                        local effectivenessBoost = effectivenessScale * 0.02 -- Effectiveness speed boost
                        local roundBoost = math.min(0.01, (currentRound or 1) * 0.001) -- Round-based speed boost
                        local spawnRateBoost = math.min(0.008, totalThreats * 0.001) -- Spawn rate speed boost
                        local alertSpeed = baseSpeed - adrenalineBoost - effectivenessBoost - roundBoost - spawnRateBoost -- Faster with more threats
                        alertSpeed = math.max(detectionProtection.minCycleDelay, math.min(detectionProtection.maxCycleDelay, alertSpeed)) -- 100-300ms range (DETECTION-SAFE)
                        cycleDelay = alertSpeed + (math.random() * 0.01) -- +0-10ms variance (human-like)
                    else
                        -- NORMAL: Use smart delay based on effectiveness
                        cycleDelay = getKnightMareDelay(shootDelay)
                        
                        -- 🧠 INTELLIGENT HUMAN PAUSE SIMULATION
                        -- NEVER pause when urgent threats are present (survival instinct)
                        if not hasUrgentThreats then
                            -- Reduced pause chance when no urgent threats
                            if math.random() < 0.02 then -- 2% chance per cycle (very reduced)
                                local pauseType = math.random()
                                if pauseType < 0.4 then
                                    cycleDelay = cycleDelay + (0.1 + math.random() * 0.2) -- Quick glance (100-300ms)
                                elseif pauseType < 0.7 then
                                    cycleDelay = cycleDelay + (0.3 + math.random() * 0.3) -- Check surroundings (300-600ms)
                                else
                                    cycleDelay = cycleDelay + (0.5 + math.random() * 0.5) -- Brief distraction (500-1000ms)
                            end
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
        -- 🛑 IMMEDIATE FEATURE DISABLE
        autoKill = false
        autoSkip = false
        autoOpenCamo = false
        autoOpenOutfit = false
        autoOpenPet = false
        autoOpenGun = false
        
        -- 🛑 IMMEDIATE NOTIFICATION
        Rayfield:Notify({
            Title = "🛑 SHUTTING DOWN",
            Content = "All features disabled! Cleaning up...",
            Duration = 1,
            Image = 4483362458
        })
        
        -- 🛑 AGGRESSIVE CLEANUP - IMMEDIATE
        task.spawn(function()
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
        
            -- 🗑️ DESTROY ALL GUI ELEMENTS IMMEDIATELY
        pcall(function()
                -- Destroy Rayfield library completely
                if Rayfield then
                    -- Disable first
                    if Rayfield.Enabled ~= nil then
                        Rayfield.Enabled = false
                    end
                    
                    -- Destroy main window
                    if Rayfield.Main then
                        Rayfield.Main:Destroy()
                    end
                    
                    -- Call destroy method if exists
                    if Rayfield.Destroy then
                        Rayfield:Destroy()
                    end
                    
                    -- Clear Rayfield reference
                    Rayfield = nil
                end
                
                -- 🗑️ DESTROY ALL GUI IN PLAYERGUI
                local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetChildren()) do
                        -- Destroy anything related to Rayfield, Freezy, or UI
                        if gui.Name:lower():find("rayfield") or 
                           gui.Name:lower():find("freezy") or
                           gui.Name:find("UI") or
                           gui.ClassName == "ScreenGui" and gui:FindFirstChild("Main") then
                            pcall(function()
                            gui:Destroy()
                            end)
                        end
                    end
                end
                
                -- 🗑️ DESTROY ALL GUI IN COREGUI
                local coreGui = game:GetService("CoreGui")
                for _, gui in pairs(coreGui:GetChildren()) do
                    if gui.Name:lower():find("rayfield") or 
                       gui.Name:lower():find("freezy") or
                       gui.Name:find("UI") then
                        pcall(function()
                            gui:Destroy()
                        end)
                    end
                end
            end)
            
            -- 🗑️ CLEAN UP ALL GLOBAL VARIABLES
            pcall(function()
            getgenv().FreezyHubLoaded = nil
                getgenv().Rayfield = nil
                _G.FreezyHub = nil
                _G.Rayfield = nil
                _G.autoKill = nil
                _G.autoSkip = nil
                _G.autoOpenCamo = nil
                _G.autoOpenOutfit = nil
                _G.autoOpenPet = nil
                _G.autoOpenGun = nil
            end)
            
            -- 🗑️ FORCE MULTIPLE GARBAGE COLLECTIONS
            for i = 1, 5 do
                task.wait(0.1)
            game:GetService("RunService").Heartbeat:Wait()
                collectgarbage("collect")
            end
            
            -- 🗑️ FINAL DESTRUCTION - DESTROY SCRIPT ITSELF
            pcall(function()
                -- Try to destroy the script
                if script and script.Parent then
                    script:Destroy()
                end
            end)
            
            -- 🗑️ CLEAR ALL REFERENCES
            pcall(function()
                -- Clear all local variables
                autoKill = nil
                autoSkip = nil
                autoOpenCamo = nil
                autoOpenOutfit = nil
                autoOpenPet = nil
                autoOpenGun = nil
                player = nil
                Remotes = nil
                Window = nil
                CombatTab = nil
                MiscTab = nil
                OpenTab = nil
            end)
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
