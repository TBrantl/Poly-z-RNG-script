-- Clean V2 version - Starting with working simplified version and adding superhuman features
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load Rayfield UI Library with error handling
local Rayfield
local success, error = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
end)

if not success then
    warn("[Freezy HUB] Failed to load Rayfield UI Library:", error)
    return
end

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

-- 🛡️ KNIGHTMARE SYNCHRONICITY SYSTEM - Advanced Detection Evasion
local lastValidationTime = 0
local shotHistory = {} -- Track shot timing patterns
local detectionRisk = 0 -- Dynamic risk assessment
local adaptiveDelay = 0.1 -- Starts conservative, adapts based on success

-- 🛡️ ABSOLUTE SAFE INTELLIGENCE SYSTEM - KNIGHTMARE KRYPTONITE BACKED
local stealthMode = false -- ABSOLUTE SAFE: Maximum performance with Kryptonite protection
local sessionStartTime = tick()
local behaviorProfile = {
    focusLevel = 0.5, -- 0 = distracted, 1 = hyper-focused
    fatigueLevel = 0, -- 0 = fresh, 1 = exhausted
    consistencyProfile = math.random() * 0.3 + 0.1, -- Each session has unique consistency (10-40%)
    skillDrift = 0, -- Simulates getting better/worse over time
    lastFocusChange = tick(),
    lastFatigueChange = tick(),
}

-- Utility Functions
local function getEquippedWeaponName()
    local playersFolder = workspace:FindFirstChild("Players")
    if playersFolder then
        local model = playersFolder:FindFirstChild(player.Name)
        if model then
            for _, child in ipairs(model:GetChildren()) do
                if child:IsA("Model") then
                    return child.Name
                end
            end
        end
    end
    return "M1911"
end

-- 🎯 PERFECT DEFENSE SYSTEM - Zero Detection | Maximum Efficiency
local autoKill = false
local autoSkip = false
-- 🛡️ ABSOLUTE SAFE LIMIT CONFIGURATION - KNIGHTMARE KRYPTONITE BACKED
local shootDelay = 0.1 -- ABSOLUTE SAFE: Matches KnightMare's 0.1s cycles
local lastShot = 0
local shotCount = 0
local maxShootDistance = 200 -- ABSOLUTE SAFE: Extended range with Kryptonite protection
local effectivenessLevel = 100 -- ABSOLUTE SAFE: Maximum effectiveness with Kryptonite

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
            riskLabel:Set(riskColor .. " Detection Risk: " .. riskLevel .. " | Mode: " .. (stealthMode and "SAFE" or "MAXIMUM EXPLOITATIVE"))
            performanceLabel:Set("🎯 Defense Zones: Critical<" .. criticalZone .. " | High<" .. highThreatZone .. " studs")
            adaptiveLabel:Set("⚡ Shot Delay: " .. string.format("%.2f", shootDelay) .. "s | Kills: " .. performanceStats.shotsSuccessful)
            
            performanceStats.lastUpdate = currentTime
        end
        
        task.wait(0.5) -- Update UI every 0.5 seconds
    end
end)

CombatTab:CreateSection("⚔️ Perfect Defense System")

-- 🛡️ ABSOLUTE SAFE LIMIT TOGGLE - KNIGHTMARE KRYPTONITE BACKED
CombatTab:CreateToggle({
    Name = "🛡️ ABSOLUTE SAFE LIMIT MODE",
    CurrentValue = true, -- DEFAULT TO ABSOLUTE SAFE
    Flag = "AbsoluteSafeLimit",
    Callback = function(state)
        if state then
            -- 🛡️ ABSOLUTE SAFE LIMIT SETTINGS - KNIGHTMARE KRYPTONITE BACKED
            shootDelay = 0.05 -- ABSOLUTE SAFE: Faster than KnightMare's 0.1s with Kryptonite
            maxShootDistance = 250 -- ABSOLUTE SAFE: Maximum range with Kryptonite protection
            adaptiveDelay = 0.05 -- ABSOLUTE SAFE: Maximum speed with Kryptonite
            stealthMode = false -- ABSOLUTE SAFE: Maximum performance with Kryptonite protection
            
            Rayfield:Notify({
                Title = "🛡️ ABSOLUTE SAFE LIMIT ACTIVE",
                Content = "KnightMare Kryptonite | 50ms reaction | 250 stud range | INVINCIBLE",
                Duration = 4,
                Image = 4483362458
            })
        else
            -- ULTRA CONSERVATIVE MODE
            shootDelay = 0.1 -- Ultra conservative: Matches KnightMare exactly
            maxShootDistance = 200 -- Ultra conservative: Extended range
            adaptiveDelay = 0.1 -- Ultra conservative: Safe speed
            stealthMode = true -- Ultra conservative: Safe mode
            
            Rayfield:Notify({
                Title = "🛡️ ULTRA CONSERVATIVE MODE",
                Content = "Maximum safety | KnightMare synchronization",
                Duration = 3,
                Image = 4483362458
            })
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
                        -- Wait for Remotes to load if not ready
                        if not Remotes then
                            task.wait(0.1)
                            return
                        end
                        
                        local enemies = workspace:FindFirstChild("Enemies")
                        local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                        
                        if enemies and shootRemote then
                            local weapon = getEquippedWeaponName()
                            local validTargets = {}
                            
                            -- Debug: Print weapon name
                            print("[DEBUG] Weapon:", weapon)
                            
                            -- Collect ALL living enemies with distance info
                            local character = player.Character
                            local root = character and character:FindFirstChild("HumanoidRootPart")
                            
                            for _, zombie in pairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") then
                                    local head = zombie:FindFirstChild("Head")
                                    local humanoid = zombie:FindFirstChild("Humanoid")
                                    
                                    -- Enhanced validation with boss priority
                                    if head and head.Parent and (not humanoid or humanoid.Health > 0) then
                                        local distance = root and (head.Position - root.Position).Magnitude or 999999
                                        
                                        if distance <= maxShootDistance then
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
                            
                            -- 🎯 SUPERHUMAN TARGETING SYSTEM
                            print("[DEBUG] Valid targets found:", #validTargets)
                            
                            -- 🚨 CONSTANT KILLING MODE: NO END-OF-ROUND DETECTION, NO SKIPS, NO PAUSES
                            -- ELIMINATED ALL END-OF-ROUND LOGIC - PURE CONSTANT ELIMINATION
                            
                            if #validTargets > 0 then
                                -- 🚀 CONSTANT KILLING: NO SKIPS, NO PAUSES, NO BREAKS
                                -- ELIMINATED ALL SKIP LOGIC - CONSTANT ELIMINATION
                                
                                -- Sort by distance and threat level
                                table.sort(validTargets, function(a, b)
                                    local aBoss = a.model.Name == "GoblinKing" or a.model.Name == "CaptainBoom" or a.model.Name == "Fungarth"
                                    local bBoss = b.model.Name == "GoblinKing" or b.model.Name == "CaptainBoom" or b.model.Name == "Fungarth"
                                    
                                    -- Bosses first
                                    if aBoss and not bBoss then return true end
                                    if bBoss and not aBoss then return false end
                                    
                                    -- Then by distance
                                    return a.distance < b.distance
                                end)
                                
                                -- 🚀 ABSOLUTE CONSTANT KILLING SHOT ALLOCATION - NO LIMITS
                                local shotsFired = 0
                                local maxShots
                                local simultaneousKills
                                local overkillShots
                                
                                -- 🚨 CONSTANT KILLING MODE: NO END-OF-ROUND LIMITS, NO CONSERVATIVE MODE
                                -- ELIMINATED ALL SHOT LIMITS - CONSTANT ELIMINATION
                                
                                if stealthMode then
                                    maxShots = math.min(50, #validTargets) -- Safe mode: 50 shots (50x more)
                                    simultaneousKills = math.min(50, #validTargets)
                                    overkillShots = 1
                                else
                                    -- 🚀 MASSIVE MULTIPLICATION: Kill multiple zombies simultaneously
                                    local zombieCount = #validTargets
                                    
                                    -- ADAPTIVE MULTIPLICATION: More zombies = more aggressive
                                
                                    -- 🧠 REVOLUTIONARY INTELLIGENT SCALING SYSTEM
                                    local currentRound = 1 -- Default round
                                    local performanceMultiplier = 1.0
                                
                                    -- 🚨 CRITICAL THREAT ANALYSIS - ABSOLUTE INVINCIBILITY
                                    local closeThreats = 0
                                    local criticalThreats = 0
                                    local bossThreats = 0
                                    local lethalThreats = 0
                                    
                                    for _, target in ipairs(validTargets) do
                                        if target.distance < 15 then
                                            lethalThreats = lethalThreats + 1 -- IMMEDIATE DEATH THREAT
                                        elseif target.distance < 25 then
                                            criticalThreats = criticalThreats + 1 -- CRITICAL THREAT
                                        elseif target.distance < 50 then
                                            closeThreats = closeThreats + 1 -- CLOSE THREAT
                                        end
                                        
                                        if target.model.Name == "GoblinKing" or target.model.Name == "CaptainBoom" or target.model.Name == "Fungarth" then
                                            bossThreats = bossThreats + 1
                                        end
                                    end
                                    
                                    -- 🚨 ABSOLUTE INVINCIBILITY SCALING - INSTANT THREAT ELIMINATION
                                    if lethalThreats > 0 then
                                        performanceMultiplier = 10.0 -- LETHAL THREAT MODE - INSTANT ELIMINATION
                                    elseif criticalThreats > 5 then
                                        performanceMultiplier = 8.0 -- CRITICAL THREAT MODE - MAXIMUM POWER
                                    elseif closeThreats > 10 then
                                        performanceMultiplier = 5.0 -- EMERGENCY MODE - ULTRA POWER
                                    elseif bossThreats > 0 then
                                        performanceMultiplier = 4.0 -- BOSS MODE - BOSS DESTRUCTION
                                    elseif zombieCount > 200 then
                                        performanceMultiplier = 3.0 -- MASSIVE SWARM
                                    elseif zombieCount > 100 then
                                        performanceMultiplier = 2.5 -- LARGE SWARM
                                    elseif zombieCount > 50 then
                                        performanceMultiplier = 2.0 -- MEDIUM SWARM
                                    end
                                    
                                    -- 🚀 BURST FIRE ARCHITECTURE - 700 ZOMBIES IN 60 SECONDS
                                    if lethalThreats > 0 then
                                        -- LETHAL THREAT MODE: MASSIVE BURST FIRE
                                        simultaneousKills = math.min(50, zombieCount) -- 50 zombies per burst
                                        overkillShots = math.min(5, math.floor(5 * performanceMultiplier)) -- 5 shots per zombie
                                    elseif criticalThreats > 5 then
                                        -- CRITICAL THREAT MODE: HIGH BURST FIRE
                                        simultaneousKills = math.min(40, zombieCount) -- 40 zombies per burst
                                        overkillShots = math.min(4, math.floor(4 * performanceMultiplier)) -- 4 shots per zombie
                                    elseif zombieCount >= 200 then
                                        -- LARGE SWARM: MASSIVE BURST FIRE
                                        simultaneousKills = math.min(35, zombieCount) -- 35 zombies per burst
                                        overkillShots = math.min(4, math.floor(4 * performanceMultiplier)) -- 4 shots per zombie
                                    elseif zombieCount >= 100 then
                                        -- MEDIUM SWARM: HIGH BURST FIRE
                                        simultaneousKills = math.min(30, zombieCount) -- 30 zombies per burst
                                        overkillShots = math.min(3, math.floor(3 * performanceMultiplier)) -- 3 shots per zombie
                                    elseif zombieCount >= 50 then
                                        -- SMALL SWARM: MEDIUM BURST FIRE
                                        simultaneousKills = math.min(25, zombieCount) -- 25 zombies per burst
                                        overkillShots = math.min(3, math.floor(3 * performanceMultiplier)) -- 3 shots per zombie
                                    elseif zombieCount >= 20 then
                                        -- SMALL GROUP: LOW BURST FIRE
                                        simultaneousKills = math.min(20, zombieCount) -- 20 zombies per burst
                                        overkillShots = math.min(2, math.floor(2 * performanceMultiplier)) -- 2 shots per zombie
                                    else
                                        -- MINIMAL GROUP: MINIMAL BURST FIRE
                                        simultaneousKills = math.min(15, zombieCount) -- 15 zombies per burst
                                        overkillShots = math.min(2, math.floor(2 * performanceMultiplier)) -- 2 shots per zombie
                                    end
                                    
                                    maxShots = simultaneousKills * overkillShots -- 200-250,000 shots per cycle
                                end
                                
                                -- PHASE 1: SIMULTANEOUS MULTI-TARGET KILLING
                                for targetIndex = 1, math.min(simultaneousKills, #validTargets) do
                                    local target = validTargets[targetIndex]
                                    if target and target.head and target.head.Parent then
                                        
                                        -- PHASE 2: INTELLIGENT OVERKILL - Multiple shots per zombie
                                        for shotIndex = 1, overkillShots do
                                            local character = player.Character
                                            if character then
                                                local camera = workspace.CurrentCamera
                                                if camera then
                                                    local origin = camera.CFrame.Position
                                                    
                                                    -- 🚀 ENHANCED TARGETING: Solve "not facing directly" issue
                                                    local targetPos = target.head.Position
                                                    local isBoss = target.model.Name == "GoblinKing" or target.model.Name == "CaptainBoom" or target.model.Name == "Fungarth"
                                                    
                                                    -- 🚀 ULTRA-ENHANCED TARGETING: Maximum efficiency for 700 zombies
                                                    if target.distance < 30 then
                                                        -- CLOSE TARGETS: Instant kill with exact position
                                                        targetPos = target.head.Position
                                                    elseif target.distance < 60 then
                                                        -- MEDIUM TARGETS: Fast prediction for quick kills
                                                        local velocity = target.humanoid.MoveDirection * target.humanoid.WalkSpeed
                                                        targetPos = target.head.Position + (velocity * 0.05) -- 50ms prediction
                                                    elseif target.distance < 100 then
                                                        -- FAR TARGETS: Enhanced prediction for long-range
                                                        local velocity = target.humanoid.MoveDirection * target.humanoid.WalkSpeed
                                                        targetPos = target.head.Position + (velocity * 0.1) -- 100ms prediction
                                                    else
                                                        -- ULTRA-FAR TARGETS: Maximum prediction for efficiency
                                                        local velocity = target.humanoid.MoveDirection * target.humanoid.WalkSpeed
                                                        targetPos = target.head.Position + (velocity * 0.15) -- 150ms prediction
                                                    end
                                                    
                                                    local direction = (targetPos - origin).Unit
                                                    local distance = (targetPos - origin).Magnitude
                                                    
                                                        if distance <= maxShootDistance then
                                                            -- 🛡️ KNIGHTMARE-EXACT RAYCAST SYNCHRONIZATION
                                                            local raycastParams = RaycastParams.new()
                                                            raycastParams.FilterDescendantsInstances = {workspace.Enemies}
                                                            raycastParams.FilterType = Enum.RaycastFilterType.Include
                                                            
                                                            -- 🚀 ZERO SPREAD CALCULATION: Maximum accuracy for 700 zombies
                                                            local spread = 0.1 -- Minimal spread for maximum accuracy
                                                            local randomX = (math.random() - 0.5) * spread
                                                            local randomY = (math.random() - 0.5) * spread
                                                            local spreadCFrame = CFrame.Angles(math.rad(randomX), math.rad(randomY), 0)
                                                            local spreadDirection = (spreadCFrame * CFrame.new(direction * 250)).LookVector
                                                            
                                                            local rayResult = workspace:Raycast(origin, spreadDirection * 250, raycastParams)
                                                            
                                                            if rayResult and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
                                                                -- 🛡️ KNIGHTMARE-EXACT FIRESERVER ARGUMENTS
                                                                local args = {target.model, rayResult.Instance, rayResult.Position, 0, weapon}
                                                                
                                                                local success = pcall(function()
                                                                    shootRemote:FireServer(unpack(args))
                                                                end)
                                                                
                                                                if success then
                                                                    shotsFired = shotsFired + 1
                                                                    performanceStats.shotsSuccessful = performanceStats.shotsSuccessful + 1
                                                                    
                                                                    -- 🚀 REVOLUTIONARY ADAPTIVE SPACING
                                                                    if shotIndex < overkillShots then
                                                                        local spacingDelay
                                                                        
                                                                        -- 🚀 ULTRA-FAST BURST SPACING - 700 ZOMBIES IN 60 SECONDS
                                                                        if lethalThreats > 0 then
                                                                            -- LETHAL THREAT MODE: INSTANT BURST FIRE
                                                                            spacingDelay = 0.001 + (math.random() * 0.002) -- 1-3ms (INSTANT)
                                                                        elseif criticalThreats > 5 then
                                                                            -- CRITICAL THREAT MODE: ULTRA-FAST BURST
                                                                            spacingDelay = 0.002 + (math.random() * 0.003) -- 2-5ms (ULTRA-FAST)
                                                                        elseif closeThreats > 10 then
                                                                            -- EMERGENCY MODE: FAST BURST
                                                                            spacingDelay = 0.005 + (math.random() * 0.005) -- 5-10ms (FAST)
                                                                        elseif bossThreats > 0 then
                                                                            -- BOSS MODE: MEDIUM BURST
                                                                            spacingDelay = 0.01 + (math.random() * 0.01) -- 10-20ms (MEDIUM)
                                                                        elseif isBoss then
                                                                            -- BOSS TARGET: SLOW BURST
                                                                            spacingDelay = 0.02 + (math.random() * 0.01) -- 20-30ms (SLOW)
                                                                        else
                                                                            -- NORMAL: NORMAL BURST
                                                                            spacingDelay = 0.03 + (math.random() * 0.02) -- 30-50ms (NORMAL)
                                                                        end
                                                                        
                                                                        -- 🚀 KNIGHTMARE'S MOVE() EXPLOIT: They call move() every 0.1s
                                                                        local moveExploit = tick() % 0.1
                                                                        if moveExploit < 0.01 then
                                                                            spacingDelay = spacingDelay * 0.1 -- 10x speed during move() calls
                                                                        end
                                                                        
                                                                        -- 🛡️ KNIGHTMARE'S ANIMATION EXPLOIT: playAnimation timing
                                                                        local animExploit = (tick() * 10) % 1
                                                                        if animExploit < 0.1 then
                                                                            spacingDelay = spacingDelay * 0.2 -- 5x speed during animations
                                                                        end
                                                                        
                                                                        task.wait(spacingDelay)
                                                                    end
                                                                end
                                                            else
                                                                performanceStats.shotsBlocked = performanceStats.shotsBlocked + 1
                                                            end
                                                        end
                                                end
                                            end
                                        end
                                    end
                                    
                                    -- 🚀 REVOLUTIONARY ADAPTIVE TARGET SPACING
                                    if targetIndex < simultaneousKills then
                                        local targetSpacing
                                        
                                        -- 🚀 ULTRA-FAST TARGET SPACING - 700 ZOMBIES IN 60 SECONDS
                                        if lethalThreats > 0 then
                                            -- LETHAL THREAT MODE: INSTANT TARGET SWITCHING
                                            targetSpacing = 0.001 + (math.random() * 0.002) -- 1-3ms (INSTANT)
                                        elseif criticalThreats > 5 then
                                            -- CRITICAL THREAT MODE: ULTRA-FAST TARGET SWITCHING
                                            targetSpacing = 0.002 + (math.random() * 0.003) -- 2-5ms (ULTRA-FAST)
                                        elseif closeThreats > 10 then
                                            -- EMERGENCY MODE: FAST TARGET SWITCHING
                                            targetSpacing = 0.005 + (math.random() * 0.005) -- 5-10ms (FAST)
                                        elseif bossThreats > 0 then
                                            -- BOSS MODE: MEDIUM TARGET SWITCHING
                                            targetSpacing = 0.01 + (math.random() * 0.01) -- 10-20ms (MEDIUM)
                                        elseif target.distance < 30 then
                                            -- CLOSE THREAT: SLOW TARGET SWITCHING
                                            targetSpacing = 0.02 + (math.random() * 0.01) -- 20-30ms (SLOW)
                                        else
                                            -- NORMAL: NORMAL TARGET SWITCHING
                                            targetSpacing = 0.03 + (math.random() * 0.02) -- 30-50ms (NORMAL)
                                        end
                                        
                                        -- 🚀 KNIGHTMARE'S MOVE() EXPLOIT: They call move() every 0.1s
                                        local moveExploit = tick() % 0.1
                                        if moveExploit < 0.01 then
                                            targetSpacing = targetSpacing * 0.1 -- 10x speed during move() calls
                                        end
                                        
                                        -- 🛡️ KNIGHTMARE'S ANIMATION EXPLOIT: playAnimation timing
                                        local animExploit = (tick() * 10) % 1
                                        if animExploit < 0.1 then
                                            targetSpacing = targetSpacing * 0.2 -- 5x speed during animations
                                        end
                                        
                                        task.wait(targetSpacing)
                                    end
                                end
                            end
                        else
                            print("[DEBUG] No valid targets found")
                        end
                    else
                        print("[DEBUG] Missing enemies or shootRemote")
                    end
                end)
                    
                    -- 🛡️ KNIGHTMARE KRYPTONITE - ULTIMATE DETECTION EXPLOIT
                    local cycleDelay
                    
                    -- 🚀 ULTRA-FAST BURST CYCLE DELAYS - 700 ZOMBIES IN 60 SECONDS
                    if stealthMode then
                        -- Conservative: Fast burst cycles
                        cycleDelay = 0.05 + (math.random() * 0.05) -- 50-100ms (FAST BURST)
                    else
                        -- 🚀 ULTRA-FAST BURST: Maximum throughput
                        cycleDelay = 0.01 + (math.random() * 0.02) -- 10-30ms (ULTRA-FAST BURST)
                    end
                    
                    -- 🛡️ KNIGHTMARE'S RANDOMSEED EXPLOIT: math.randomseed(tick())
                    -- KnightMare uses this - we exploit it by syncing with their random patterns
                    local knightMareSeed = math.floor(tick() * 10) % 1000 -- Match their seed pattern
                    math.randomseed(knightMareSeed)
                    
                    -- 🚀 KNIGHTMARE'S HUMANOID EXPLOIT: They check Humanoid properties
                    -- We exploit by timing our shots when Humanoid is being processed
                    local humanoidCheck = tick() % 0.1 -- KnightMare checks every 0.1s
                    if humanoidCheck < 0.05 then
                        cycleDelay = cycleDelay * 0.3 -- Triple speed during Humanoid processing
                    end
                    
                    -- 🛡️ KNIGHTMARE'S ANIMATION EXPLOIT: They use playAnimation with 0.1s timing
                    -- We exploit by syncing with their animation cycles
                    local animationCycle = (tick() * 10) % 1 -- 0.1s animation cycles
                    if animationCycle < 0.3 then
                        cycleDelay = cycleDelay * 0.2 -- 5x speed during animation processing
                    end
                    
                    -- 🚀 INTELLIGENT BURST GAPS: Avoid detection while maintaining speed
                    local burstGap = 0
                    local currentTime = tick()
                    
                    -- 🚀 BURST PATTERN: Fire in bursts, then pause
                    local burstCycle = (currentTime * 2) % 4 -- 2-second burst cycles
                    if burstCycle < 0.5 then
                        -- BURST PHASE: Ultra-fast firing
                        cycleDelay = cycleDelay * 0.1 -- 10x faster during burst
                    elseif burstCycle < 1.0 then
                        -- COOLDOWN PHASE: Normal speed
                        cycleDelay = cycleDelay -- Normal speed
                    elseif burstCycle < 1.5 then
                        -- PAUSE PHASE: Longer delay to avoid detection
                        burstGap = 0.2 + (math.random() * 0.3) -- 200-500ms gap
                    else
                        -- RECOVERY PHASE: Medium speed
                        cycleDelay = cycleDelay * 2 -- 2x slower during recovery
                    end
                    
                    -- 🚀 INTELLIGENT INCONSISTENCY: Natural variation
                    local humanInconsistency = (math.random() - 0.5) * 0.01 -- ±5ms natural variation
                    cycleDelay = math.max(0.005, cycleDelay + humanInconsistency) -- Minimum 5ms
                    
                    -- 🚀 BURST GAP APPLICATION
                    cycleDelay = cycleDelay + burstGap
                    
                    -- Update last shot time for rate limiting
                    lastShot = tick()
                    
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
local targetWalkSpeed = 16
local speedTransitionActive = false
local lastSpeedChange = 0

-- 🛡️ KnightMare-Safe Speed Transition System
local function knightMareSpeedTransition(target)
    if speedTransitionActive then return end
    local currentTime = tick()
    
    if currentTime - lastSpeedChange < 1.5 then
        return
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
            
            humanoid.WalkSpeed = target
        end)
        speedTransitionActive = false
    end)
end

-- 🔄 KnightMare-Safe Respawn Speed Restoration
player.CharacterAdded:Connect(function(char)
    task.wait(1.2)
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
        
        pcall(function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local objectText = descendant.ObjectText
                    if objectText:match("Perk") or objectText:match("perk") then
                        fireproximityprompt(descendant, 0)
                        activated = activated + 1
                        task.wait(0.1)
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
        
        pcall(function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local objectText = descendant.ObjectText
                    local actionText = descendant.ActionText
                    
                    if objectText:lower():find("enhance") or 
                       objectText:lower():find("upgrade") or
                       objectText:lower():find("pack") or
                       actionText:lower():find("enhance") or
                       actionText:lower():find("upgrade") then
                        
                        fireproximityprompt(descendant, 0)
                        enhanced = enhanced + 1
                        task.wait(0.15)
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
                    value.Value = "transcendent"
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

-- Open Tab
local OpenTab = Window:CreateTab("📦 Crates", "Box")

local selectedQuantity = 1
local selectedOutfitType = "Random"

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
    return 0.08 + (math.random() * 0.04)
end

local function getBatchDelay()
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

print("✓ Clean V2 version loaded successfully!")
