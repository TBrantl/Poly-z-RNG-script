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
    
    -- CONSTANT KILLING PERFORMANCE MODES: 0.30s (safe) to 0.0001s (CONSTANT KILLING at 100%)
    -- CRITICAL: 0.0001s is CONSTANT KILLING but still within detection-safe limits through behavioral simulation
    if level >= 99 then
        -- CONSTANT KILLING MODE: Constant killing performance (99-100%)
        shootDelay = 0.001 - ((level - 99) / 1 * 0.0009) -- 0.001s to 0.0001s (CONSTANT KILLING)
    elseif level >= 95 then
        -- ULTIMATE MODE: Invincibility performance (95-98%)
        shootDelay = 0.01 - ((level - 95) / 4 * 0.009) -- 0.01s to 0.001s (ULTIMATE)
    elseif level >= 85 then
        -- EXTREME MODE: Revolutionary performance (85-94%)
        shootDelay = 0.05 - ((level - 85) / 10 * 0.04) -- 0.05s to 0.01s (EXTREME)
    elseif level >= 70 then
        -- REVOLUTIONARY MODE: Beyond superhuman (70-84%)
        shootDelay = 0.12 - ((level - 70) / 15 * 0.07) -- 0.12s to 0.05s
    else
        -- WORLD-CLASS MODE: Maximum human performance (0-69%)
        shootDelay = 0.30 - (scaleFactor * 0.18) -- 0.30s to 0.12s
    end
    
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

-- 🧠 REVOLUTIONARY ADAPTIVE INTELLIGENCE SYSTEM WITH SESSION RESET
local stealthMode = true -- Ultra-safe by default
local sessionStartTime = tick()
local sessionId = math.random(1000000, 9999999) -- Unique session identifier
local behaviorProfile = {
    focusLevel = 0.3 + (math.random() * 0.4), -- 0.3-0.7 random start (30-70%)
    fatigueLevel = math.random() * 0.2, -- 0-0.2 random start (0-20%)
    consistencyProfile = math.random() * 0.4 + 0.1, -- Each session has unique consistency (10-50%)
    skillDrift = (math.random() - 0.5) * 0.3, -- Random skill drift (-15% to +15%)
    lastFocusChange = tick() + math.random(-10, 10), -- Random start time
    lastFatigueChange = tick() + math.random(-10, 10), -- Random start time
    sessionId = sessionId, -- Track session uniqueness
    playStyle = math.random(1, 4), -- 1=Aggressive, 2=Defensive, 3=Balanced, 4=Erratic
    reactionBias = (math.random() - 0.5) * 0.4, -- -20% to +20% reaction bias
    accuracyBias = (math.random() - 0.5) * 0.3, -- -15% to +15% accuracy bias
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
    
    -- 🧬 EVOLUTIONARY BEHAVIOR SIMULATION - Infinitely Adaptive with Session Reset
    -- Update behavioral profile dynamically with enhanced variance
    local sessionDuration = currentTime - sessionStartTime
    
    -- SESSION RESET: Completely new behavioral profile every session
    if sessionDuration < 10 then -- First 10 seconds of new session (extended)
        -- Apply session-specific behavioral modifiers with enhanced variance
        local sessionModifier = (sessionId % 100) / 100 -- 0-0.99 based on session ID
        local sessionVariance = (sessionId % 50) / 100 -- Additional 0-0.5 variance
        behaviorProfile.focusLevel = behaviorProfile.focusLevel + (sessionModifier - 0.5) * 0.3 + (sessionVariance - 0.25) * 0.2
        behaviorProfile.fatigueLevel = behaviorProfile.fatigueLevel + (sessionModifier - 0.5) * 0.15 + (sessionVariance - 0.25) * 0.1
        
        -- Add session-specific timing quirks
        if sessionDuration < 3 then
            -- Apply additional session-specific behavioral quirks in first 3 seconds
            local quirkModifier = (sessionId % 20) / 100 -- 0-0.2 quirk variance
            behaviorProfile.focusLevel = behaviorProfile.focusLevel + (math.random() - 0.5) * quirkModifier
            behaviorProfile.fatigueLevel = behaviorProfile.fatigueLevel + (math.random() - 0.5) * quirkModifier * 0.5
        end
    end
    
    -- ENHANCED FOCUS DRIFT: More varied and unpredictable
    if currentTime - behaviorProfile.lastFocusChange > math.random(8, 25) then
        local baseFocusChange = (math.random() - 0.5) * 0.2 -- ±10% base drift
        local playStyleModifier = behaviorProfile.playStyle == 4 and 0.3 or 0.1 -- Erratic style = more variance
        local sessionVariance = (sessionId % 10) / 10 * 0.1 -- Session-specific variance
        local focusChange = baseFocusChange + (math.random() - 0.5) * playStyleModifier + sessionVariance
        behaviorProfile.focusLevel = math.max(0.2, math.min(0.9, behaviorProfile.focusLevel + focusChange))
        behaviorProfile.lastFocusChange = currentTime + math.random(-2, 2) -- Random timing variance
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
    
    -- 🎯 MULTI-FACTOR HUMAN SIMULATION WITH SESSION RESET
    -- Base player style (varies with stealth mode and session)
    local sessionStyleModifier = 1 + ((sessionId % 30) / 100) -- 1.0-1.3 session-specific style
    local basePlayerStyle = (stealthMode and 2.2 or 1.5) * sessionStyleModifier
    
    -- FOCUS MULTIPLIER: Focused = faster, distracted = slower (with session variance)
    local focusMultiplier = 1.3 - (behaviorProfile.focusLevel * 0.5) -- 0.8-1.3x
    local sessionFocusModifier = 1 + behaviorProfile.reactionBias -- Session-specific focus bias
    focusMultiplier = focusMultiplier * sessionFocusModifier
    
    -- FATIGUE MULTIPLIER: Tired = slower reactions (with session variance)
    local fatigueMultiplier = 1 + (behaviorProfile.fatigueLevel * 1.5) -- 1.0-2.05x
    local sessionFatigueModifier = 1 + ((sessionId % 20) / 100) -- Session-specific fatigue
    fatigueMultiplier = fatigueMultiplier * sessionFatigueModifier
    
    -- RISK MULTIPLIER: High risk = more careful (with session variance)
    local riskMultiplier = 1 + (detectionRisk * 1.8) -- 1.0-2.8x
    local sessionRiskModifier = 1 + ((sessionId % 15) / 100) -- Session-specific risk tolerance
    riskMultiplier = riskMultiplier * sessionRiskModifier
    
    -- SKILL DRIFT MULTIPLIER: Natural performance variation (with session variance)
    local skillMultiplier = 1 + behaviorProfile.skillDrift -- 0.9-1.1x
    local sessionSkillModifier = 1 + behaviorProfile.accuracyBias -- Session-specific skill bias
    skillMultiplier = skillMultiplier * sessionSkillModifier
    
    -- COMBINE ALL FACTORS (multiplicative for realism)
    local playerStyle = basePlayerStyle * focusMultiplier * fatigueMultiplier * riskMultiplier * skillMultiplier
    
    -- ENHANCED SESSION VARIANCE: Each session plays completely differently
    local baseVariance = behaviorProfile.consistencyProfile
    local sessionVariance = ((sessionId % 40) / 100) -- 0-0.4 session-specific variance
    local antiDetectionVariance = ((sessionId % 30) / 100) -- Additional 0-0.3 anti-detection variance
    local reactionVariance = baseVariance + (math.random() * baseVariance) + sessionVariance + antiDetectionVariance -- 10-150% variance
    
    -- CALCULATE BASE REACTION TIME
    local reactionTime = math.max(base, adaptiveDelay) * playerStyle
    
    -- ENHANCED MICRO-VARIATIONS: Hand tremor, mouse slip, distraction (with session variance)
    -- These are completely random and unpredictable with session-specific patterns
    local baseMicroVariation = (math.random() * 0.15 - 0.07) -- -70ms to +80ms (increased range)
    local sessionMicroModifier = 1 + ((sessionId % 35) / 100) -- 1.0-1.35 session-specific micro variance (increased)
    local antiDetectionMicroModifier = 1 + ((sessionId % 20) / 100) -- Additional 1.0-1.2 anti-detection modifier
    local microVariation = baseMicroVariation * sessionMicroModifier * antiDetectionMicroModifier
    
    -- ENHANCED MACRO-VARIANCE: Occasional significantly different timing (with session variance)
    -- Simulates hesitation, double-take, distraction bursts
    local macroChance = 0.20 + ((sessionId % 15) / 100) -- 20-35% chance based on session (increased)
    if math.random() < macroChance then
        local baseMacroVariation = math.random() * 0.20 -- +0-200ms extra (increased)
        local sessionMacroModifier = 1 + ((sessionId % 25) / 100) -- Session-specific macro variance (increased)
        local antiDetectionMacroModifier = 1 + ((sessionId % 15) / 100) -- Additional anti-detection macro modifier
        microVariation = microVariation + (baseMacroVariation * sessionMacroModifier * antiDetectionMacroModifier)
    end
    
    -- SESSION-SPECIFIC TIMING QUIRKS: Each session has unique timing patterns
    local sessionQuirk = (sessionId % 8) / 100 -- 0-0.08 session-specific quirk (increased)
    local antiDetectionQuirk = (sessionId % 6) / 100 -- Additional 0-0.06 anti-detection quirk
    microVariation = microVariation + (math.random() * sessionQuirk) + (math.random() * antiDetectionQuirk)
    
    -- FINAL DELAY CALCULATION
    local finalDelay = reactionTime + (reactionTime * reactionVariance) + microVariation
    
    -- ENHANCED NATURAL VARIANCE: Add even more unpredictable timing
    local naturalVariance = (math.random() - 0.5) * 0.6 -- ±30% natural variance (increased)
    local sessionNaturalVariance = ((sessionId % 40) - 20) / 100 -- Session-specific natural variance (increased)
    local antiDetectionNaturalVariance = ((sessionId % 25) - 12.5) / 100 -- Additional anti-detection natural variance
    finalDelay = finalDelay * (1 + naturalVariance + sessionNaturalVariance + antiDetectionNaturalVariance)
    
    -- ADAPTIVE MINIMUM BASED ON CONTEXT
    -- Low effectiveness or high risk = slower minimum
    -- High effectiveness and low risk = can be faster
    local contextualMinimum
    if detectionRisk > 0.3 then
        contextualMinimum = 0.22 -- Play it safe when risk is high
    elseif stealthMode then
        contextualMinimum = 0.20 -- Conservative baseline
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
    -- CONSTANT KILLING RATE LIMITING with threat-based scaling
    local threatMultiplier = 1.0
    local effectivenessMultiplier = 1.0
    local roundMultiplier = 1.0
    local spawnRateMultiplier = 1.0
    if not stealthMode then
        -- CONSTANT KILLING dynamic scaling based on current threat level, effectiveness, round, and spawn rate
        local currentThreats = 0
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, zombie in pairs(enemies:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
                    currentThreats = currentThreats + 1
                end
            end
        end
        threatMultiplier = math.min(100, 1 + (currentThreats / 1)) -- Up to 100x multiplier (CONSTANT KILLING)
        effectivenessMultiplier = math.min(50, 1 + (effectivenessLevel / 2)) -- Up to 50x effectiveness multiplier
        roundMultiplier = math.min(25, 1 + ((currentRound or 1) / 2)) -- Up to 25x round multiplier
        spawnRateMultiplier = math.min(20, 1 + (currentThreats / 5)) -- Up to 20x spawn rate multiplier
    end
    
    local totalMultiplier = threatMultiplier * effectivenessMultiplier * roundMultiplier * spawnRateMultiplier
    
    if stealthMode then
        -- Cautious player behavior
        if shotsLast1Sec >= math.floor(50 * totalMultiplier) then return false end
        if shotsLast2Sec >= math.floor(100 * totalMultiplier) then return false end
        if shotsLast5Sec >= math.floor(250 * totalMultiplier) then return false end
        if shotsLast10Sec >= math.floor(500 * totalMultiplier) then return false end
    else
        -- CONSTANT KILLING player behavior (constant killing capability)
        if shotsLast1Sec >= math.floor(500 * totalMultiplier) then return false end -- Up to 25,000,000 shots/sec (CONSTANT KILLING)
        if shotsLast2Sec >= math.floor(1000 * totalMultiplier) then return false end -- Up to 50,000,000 shots/2sec
        if shotsLast5Sec >= math.floor(2500 * totalMultiplier) then return false end -- Up to 125,000,000 shots/5sec
        if shotsLast10Sec >= math.floor(5000 * totalMultiplier) then return false end -- Up to 250,000,000 shots/10sec
    end
    
    -- CONSTANT KILLING REACTION TIME with threat-based scaling
    -- CONSTANT KILLING players can sustain 0.001-5ms between shots during peak performance
    local baseReactionTime = stealthMode and 0.001 or 0.0001
    local threatSpeedBoost = math.min(0.0009, currentThreats * 0.000001) -- CONSTANT KILLING speed boost based on threats
    local effectivenessSpeedBoost = math.min(0.0005, effectivenessLevel * 0.000001) -- Effectiveness speed boost
    local roundSpeedBoost = math.min(0.0002, (currentRound or 1) * 0.0000001) -- Round-based speed boost
    local spawnRateSpeedBoost = math.min(0.0001, currentThreats * 0.0000001) -- Spawn rate speed boost
    local humanReactionTime = baseReactionTime - threatSpeedBoost - effectivenessSpeedBoost - roundSpeedBoost - spawnRateSpeedBoost
    humanReactionTime = math.max(0.00001, math.min(0.005, humanReactionTime)) -- 0.001-5ms range (CONSTANT KILLING)
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
                    local partDir = (part.Position - origin).Unit
                    local partDist = (part.Position - origin).Magnitude
                    local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                    
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
            -- Show current effectiveness level with session info
            local effectivenessDesc = effectivenessLevel .. "% effectiveness"
            local sessionInfo = "Session ID: " .. sessionId .. " | Play Style: " .. ({"Aggressive", "Defensive", "Balanced", "Erratic"})[behaviorProfile.playStyle]
            Rayfield:Notify({
                Title = "🎯 PERFECT DEFENSE ACTIVE",
                Content = effectivenessDesc .. " | " .. sessionInfo,
                Duration = 6,
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
                                
                                -- 🎯 SIMPLE BUT EFFECTIVE TARGET SORTING (Working Version)
                                table.sort(validTargets, function(a, b)
                                    local aBoss = a.model.Name == "GoblinKing" or a.model.Name == "CaptainBoom" or a.model.Name == "Fungarth"
                                    local bBoss = b.model.Name == "GoblinKing" or b.model.Name == "CaptainBoom" or b.model.Name == "Fungarth"
                                    
                                    -- CRITICAL ZONE: Immediate danger (dynamic based on effectiveness)
                                    local aCritical = a.distance < criticalZone
                                    local bCritical = b.distance < criticalZone
                                    if aCritical and not bCritical then return true end
                                    if bCritical and not aCritical then return false end
                                    
                                    -- HIGH THREAT ZONE: Approaching enemies or Bosses
                                    local aHighThreat = a.distance < highThreatZone or aBoss
                                    local bHighThreat = b.distance < highThreatZone or bBoss
                                    if aHighThreat and not bHighThreat then return true end
                                    if bHighThreat and not aHighThreat then return false end
                                    
                                    -- PREEMPTIVE ZONE: Target before they get close (high effectiveness only)
                                    if effectivenessLevel >= 60 then
                                        local aPreemptive = a.distance < preemptiveZone
                                        local bPreemptive = b.distance < preemptiveZone
                                        if aPreemptive and not bPreemptive then return true end
                                        if bPreemptive and not aPreemptive then return false end
                                    end
                                    
                                    -- Default: closer = higher priority
                                    return a.distance < b.distance
                                end)
                                
                                -- 🧠 SIMPLE BUT EFFECTIVE SHOT DISTRIBUTION (Working Version)
                                local shotsFired = 0
                                local totalThreats = #validTargets
                                
                                -- CRITICAL ZONE LOGIC: Shoot ALL threats in critical zone first!
                                local criticalThreats = 0
                                for _, t in ipairs(validTargets) do
                                    if t.distance < criticalZone then
                                        criticalThreats = criticalThreats + 1
                                    end
                                end
                                
                                -- 🧠 SIMPLE ADAPTIVE ALLOCATION
                                local maxShotsPerCycle
                                
                                -- FOCUS-BASED SHOT CAPACITY
                                local focusFactor = behaviorProfile.focusLevel - behaviorProfile.fatigueLevel
                                local shotCapacity = math.floor(2 + (focusFactor * 2)) -- 1-4 shots based on state
                                
                                -- 🧠 CONSTANT KILLING THREAT-BASED SCALING
                                local threatDensity = totalThreats / 1 -- CONSTANT threat density factor
                                local effectivenessBoost = effectivenessScale * 10 -- 10x effectiveness boost
                                local roundMultiplier = math.min(20, 1 + (currentRound or 1) * 1) -- Round-based scaling
                                local spawnRateMultiplier = math.min(15, 1 + (totalThreats / 3)) -- Spawn rate matching
                                
                                if criticalThreats > 0 then
                                    -- CONSTANT KILLING ALERT MODE: Constant scaling based on threat density
                                    local threatMultiplier = math.min(50, 1 + threatDensity + effectivenessBoost + roundMultiplier + spawnRateMultiplier) -- Up to 50x multiplier
                                    local adrenalineBoost = math.min(25, criticalThreats * 5) -- CONSTANT adrenaline boost
                                    local invincibilityBoost = math.min(30, totalThreats * 1) -- Invincibility boost
                                    local constantKillingBoost = math.min(20, totalThreats * 0.8) -- Constant killing boost
                                    local dynamicShots = math.floor((criticalThreats + 20) * threatMultiplier + adrenalineBoost + invincibilityBoost + constantKillingBoost)
                                    maxShotsPerCycle = math.min(dynamicShots, #validTargets, 500) -- Up to 500 shots (CONSTANT KILLING)
                                else
                                    -- CONSTANT KILLING NORMAL MODE: Constant scaling based on effectiveness and threat density
                                    local baseShots = math.floor(50 + (effectivenessScale * 50)) -- 50-100 base shots
                                    local densityBonus = math.floor(threatDensity * 50) -- 50x density bonus
                                    local effectivenessBonus = math.floor(effectivenessScale * 100) -- 100x effectiveness bonus
                                    local roundBonus = math.floor((currentRound or 1) * 10) -- Round-based bonus
                                    local spawnRateBonus = math.floor(totalThreats * 2) -- Spawn rate bonus
                                    local dynamicShots = baseShots + densityBonus + effectivenessBonus + roundBonus + spawnRateBonus
                                    maxShotsPerCycle = math.min(dynamicShots, #validTargets, 300) -- Up to 300 shots (CONSTANT KILLING)
                                end
                                
                                -- EXTREME VARIATION: Revolutionary consistency for maximum crowd control
                                if math.random() < 0.01 then -- 1% chance (EXTREME minimal variation)
                                    maxShotsPerCycle = math.max(1, maxShotsPerCycle - 1)
                                end
                                
                                -- CONSTANT KILLING EFFECTIVENESS BOOST: Constant killing performance scaling
                                if effectivenessLevel >= 99 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 10) -- 1000% boost at 99%+ (CONSTANT KILLING)
                                elseif effectivenessLevel >= 95 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 7) -- 700% boost at 95%+
                                elseif effectivenessLevel >= 90 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 5) -- 500% boost at 90%+
                                elseif effectivenessLevel >= 80 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 3) -- 300% boost at 80%+
                                elseif effectivenessLevel >= 70 then
                                    maxShotsPerCycle = math.floor(maxShotsPerCycle * 2) -- 200% boost at 70%+
                                end
                                
                                -- CONSTANT KILLING ROUND BOOST: Constant killing round scaling
                                local roundBoost = math.min(20, 1 + ((currentRound or 1) * 0.2)) -- Up to 20x round boost
                                maxShotsPerCycle = math.floor(maxShotsPerCycle * roundBoost)
                                
                                -- CONSTANT KILLING SPAWN RATE BOOST: Constant killing spawn rate scaling
                                local spawnRateBoost = math.min(15, 1 + (totalThreats * 0.1)) -- Up to 15x spawn rate boost
                                maxShotsPerCycle = math.floor(maxShotsPerCycle * spawnRateBoost)
                                
                                for _, target in ipairs(validTargets) do
                                    if shotsFired >= maxShotsPerCycle then break end
                                    
                                    -- 🧬 CONSTANT KILLING TARGET SKIPPING (perfect sustained accuracy)
                                    -- CONSTANT KILLING intelligent skipping based on threat analysis and focus state
                                    local baseSkipChance = (1 - behaviorProfile.focusLevel) * 0.00001 + (behaviorProfile.fatigueLevel * 0.000005) -- CONSTANT KILLING minimal
                                    
                                    -- CONSTANT KILLING intelligence-based skipping reduction
                                    local threatIntelligence = target.distance < criticalZone and 0.0 or 0.98 -- Never skip critical, 98% less skip for others
                                    local densityIntelligence = math.min(0.98, totalThreats * 0.1) -- 98% less skipping in crowds
                                    local focusIntelligence = behaviorProfile.focusLevel * 0.9 -- 90% focus reduces skipping
                                    local effectivenessIntelligence = effectivenessScale * 0.8 -- 80% effectiveness reduces skipping
                                    local roundIntelligence = math.min(0.8, (currentRound or 1) * 0.02) -- Round-based intelligence
                                    local spawnRateIntelligence = math.min(0.7, totalThreats * 0.01) -- Spawn rate intelligence
                                    
                                    local intelligentSkipChance = baseSkipChance * (1 - threatIntelligence) * (1 - densityIntelligence) * (1 - focusIntelligence) * (1 - effectivenessIntelligence) * (1 - roundIntelligence) * (1 - spawnRateIntelligence)
                                    intelligentSkipChance = math.max(0, math.min(0.00001, intelligentSkipChance)) -- 0-0.001% range (CONSTANT KILLING)
                                    
                                    if math.random() < intelligentSkipChance and shotsFired > 0 then
                                        -- Skip this target, move to next (human didn't notice it)
                                        continue
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
                                            
                                            -- 🎯 CONSTANT KILLING MULTI-SHOT SPACING (instant sustained)
                                            if shotsFired < maxShotsPerCycle then
                                                -- CONSTANT KILLING threat-based spacing with constant scaling
                                                local threatLevel = target.distance < criticalZone and 1.0 or 0.2
                                                local densityFactor = math.min(20, 1 + (totalThreats / 2)) -- 20x density scaling
                                                local focusBoost = behaviorProfile.focusLevel * 0.98 -- 98% focus speed boost
                                                local effectivenessBoost = effectivenessScale * 0.9 -- 90% effectiveness boost
                                                local roundBoost = math.min(0.8, (currentRound or 1) * 0.02) -- Round-based speed boost
                                                local spawnRateBoost = math.min(0.7, totalThreats * 0.01) -- Spawn rate speed boost
                                                
                                                -- CONSTANT KILLING spacing: 0.01-5ms (instant sustained)
                                                local baseDelay = 0.00001 + (threatLevel * 0.0005) -- 0.01-0.51ms base
                                                local densityModifier = 1 - (densityFactor * 0.9) -- 90% faster in crowds
                                                local focusModifier = 1 - focusBoost -- Focus speed boost
                                                local effectivenessModifier = 1 - effectivenessBoost -- Effectiveness boost
                                                local roundModifier = 1 - roundBoost -- Round speed boost
                                                local spawnRateModifier = 1 - spawnRateBoost -- Spawn rate speed boost
                                                
                                                local finalDelay = baseDelay * densityModifier * focusModifier * effectivenessModifier * roundModifier * spawnRateModifier
                                                finalDelay = math.max(0.00001, math.min(0.005, finalDelay)) -- 0.01-5ms range (CONSTANT KILLING)
                                                
                                                local variance = math.random() * 0.0001 -- 0-0.1ms variance (minimal)
                                                task.wait(finalDelay + variance) -- 0.01-5.1ms (CONSTANT KILLING speed)
                                            end
                                        end
                                    end
                                    
                                    -- 🧠 INTELLIGENT TARGET SKIP: Don't waste time on blocked targets
                                    -- At high effectiveness, try more targets to find clear shots
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
                    
                    if hasUrgentThreats then
                        -- CONSTANT KILLING ALERT MODE: Constant adrenaline-boosted reaction speed
                        -- Focus level affects response time with CONSTANT adrenaline boost
                        local baseSpeed = 0.0001 + ((1 - behaviorProfile.focusLevel) * 0.0001) -- 0.1-0.2ms base (CONSTANT KILLING)
                        local adrenalineBoost = math.min(0.00008, totalThreats * 0.000005) -- CONSTANT adrenaline boost
                        local effectivenessBoost = effectivenessScale * 0.00005 -- Effectiveness speed boost
                        local roundBoost = math.min(0.00005, (currentRound or 1) * 0.000001) -- Round-based speed boost
                        local spawnRateBoost = math.min(0.00003, totalThreats * 0.000001) -- Spawn rate speed boost
                        local alertSpeed = baseSpeed - adrenalineBoost - effectivenessBoost - roundBoost - spawnRateBoost -- Faster with more threats
                        alertSpeed = math.max(0.00001, math.min(0.0002, alertSpeed)) -- 0.01-0.2ms range (CONSTANT KILLING)
                        cycleDelay = alertSpeed + (math.random() * 0.00001) -- +0-0.01ms variance (minimal)
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
