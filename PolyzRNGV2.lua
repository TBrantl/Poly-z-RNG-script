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

-- 📊 Real-time KnightMare monitoring system
task.spawn(function()
    while true do
        local currentTime = tick()
        
        -- Update weapon info
        weaponLabel:Set("🔫 Equipped Weapon: " .. getEquippedWeaponName())
        
        -- Update performance stats every 2 seconds
        if currentTime - performanceStats.lastUpdate > 2 then
            -- Calculate risk level based on detection risk
            local riskLevel = "LOW"
            local riskColor = "🟢"
            
            if detectionRisk > 0.3 then
                riskLevel = "MEDIUM"
                riskColor = "🟡"
            end
            if detectionRisk > 0.6 then
                riskLevel = "HIGH"
                riskColor = "🔴"
            end
            if detectionRisk > 0.8 then
                riskLevel = "CRITICAL"
                riskColor = "🚨"
            end
            
            -- Update UI labels
            riskLabel:Set(riskColor .. " Detection Risk: " .. riskLevel .. " (" .. math.floor(detectionRisk * 100) .. "%)")
            performanceLabel:Set("📊 Shots: " .. performanceStats.shotsSuccessful .. " Success | " .. performanceStats.shotsBlocked .. " Blocked")
            adaptiveLabel:Set("⚡ Adaptive Delay: " .. string.format("%.3f", adaptiveDelay) .. "s")
            
            performanceStats.lastUpdate = currentTime
        end
        
        task.wait(0.5) -- Update UI every 0.5 seconds
    end
end)

CombatTab:CreateSection("⚔️ Combat Controls")

-- Auto Headshots with KnightMare Bypass & Raycast Validation
local autoKill = false
local shootDelay = 0.01 -- GODMODE speed default delay
local lastShot = 0
local shotCount = 0
local maxShootDistance = 500 -- Maximum shooting range

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

-- 🧠 ADAPTIVE ANTI-PATTERN SYSTEM
local function getKnightMareDelay(base)
    local currentTime = tick()
    
    -- Analyze recent shot pattern for detection risk
    local recentShots = 0
    for i = #shotHistory, math.max(1, #shotHistory - 10), -1 do
        if currentTime - shotHistory[i] < 2 then
            recentShots = recentShots + 1
        end
    end
    
    -- Dynamic risk calculation based on KnightMare's tick() validation
    if recentShots > 8 then
        detectionRisk = math.min(1, detectionRisk + 0.15)
    else
        detectionRisk = math.max(0, detectionRisk - 0.05)
    end
    
    -- Adaptive delay calculation (mimics human reaction variance)
    local humanVariance = 0.08 + (math.random() * 0.12) -- 8-20% human-like variance
    local riskMultiplier = 1 + (detectionRisk * 2) -- Increase delay when risky
    local adaptiveBase = math.max(base, adaptiveDelay) * riskMultiplier
    
    -- KnightMare-specific timing patterns (avoids their detection algorithms)
    local knightMareOffset = math.sin(currentTime * 0.7) * 0.03 -- Sine wave pattern
    local finalDelay = adaptiveBase + (adaptiveBase * humanVariance) + knightMareOffset
    
    return math.max(0.05, finalDelay) -- Never go below 0.05s (20 shots/sec max)
end

-- 🎯 KNIGHTMARE SHOT VALIDATION SYSTEM
local function shouldAllowKnightMareShot()
    local currentTime = tick()
    
    -- Clean old shot history (KnightMare checks 5-second windows)
    for i = #shotHistory, 1, -1 do
        if currentTime - shotHistory[i] > 6 then
            table.remove(shotHistory, i)
        end
    end
    
    -- KnightMare rate limit analysis (based on their tick() validation)
    local shotsLast5Sec = 0
    local shotsLast2Sec = 0
    
    for _, shotTime in ipairs(shotHistory) do
        if currentTime - shotTime < 5 then
            shotsLast5Sec = shotsLast5Sec + 1
        end
        if currentTime - shotTime < 2 then
            shotsLast2Sec = shotsLast2Sec + 1
        end
    end
    
    -- Adaptive limits based on detection risk
    local maxShots5Sec = math.floor(25 - (detectionRisk * 15)) -- 25-10 shots per 5 sec
    local maxShots2Sec = math.floor(12 - (detectionRisk * 7))  -- 12-5 shots per 2 sec
    
    -- Validation timing check (mimics KnightMare's server validation)
    if currentTime - lastValidationTime < 0.04 then -- Minimum 0.04s between validations
        return false
    end
    
    if shotsLast5Sec >= maxShots5Sec or shotsLast2Sec >= maxShots2Sec then
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
    
    -- 🛡️ KNIGHTMARE RAYCAST PARAMS (identical to game's setup)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
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

-- Combat Configuration
CombatTab:CreateInput({
    Name = "⚡ Shot Delay (0.008-2s)",
    PlaceholderText = "0.01",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.008 and num <= 2 then
            shootDelay = num
            Rayfield:Notify({
                        Title = "⚡ Freezy HUB",
                        Content = "Shot delay set to "..num.."s",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                        Title = "❌ Invalid Input",
                        Content = "Enter a value between 0.008 and 2",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Combat Range",
    Range = {100, 1000},
    Increment = 50,
    Suffix = " studs",
    CurrentValue = 500,
    Flag = "MaxShootRange",
    Callback = function(Value)
        maxShootDistance = Value
    end
})

CombatTab:CreateButton({
    Name = "🛡️ KNIGHTMARE SAFE MODE",
    Callback = function()
        shootDelay = 0.08 -- KnightMare-safe speed
        detectionRisk = 0 -- Reset risk
        adaptiveDelay = 0.08 -- Reset adaptive delay
        Rayfield:Notify({
            Title = "🛡️ KNIGHTMARE SAFE MODE",
            Content = "Set to 0.08s - Maximum safety!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

CombatTab:CreateButton({
    Name = "⚡ AGGRESSIVE MODE (RISKY)",
    Callback = function()
        shootDelay = 0.05 -- Aggressive but safer than nuclear
        Rayfield:Notify({
            Title = "⚡ AGGRESSIVE MODE",
            Content = "0.05s - High performance with risk monitoring!",
            Duration = 4,
            Image = 4483362458
        })
        
        -- Enhanced monitoring for aggressive mode
        task.spawn(function()
            task.wait(15)
            if detectionRisk > 0.5 then
                Rayfield:Notify({
                    Title = "⚠️ DETECTION RISK HIGH",
                    Content = "Consider switching to Safe Mode!",
                    Duration = 5,
                    Image = 4483362458
                })
            end
        end)
    end
})

CombatTab:CreateToggle({
    Name = "💀 Auto Elimination (Smart)",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
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
                                        
                                        -- Debug: Log boss detection
                                        local isBoss = zombie.Name == "GoblinKing" or zombie.Name == "CaptainBoom" or zombie.Name == "Fungarth"
                                        if isBoss and math.random(1, 20) == 1 then -- 5% chance to avoid spam
                                            print("BOSS DETECTED: " .. zombie.Name .. " at distance " .. math.floor(distance))
                                        end
                                        
                                        table.insert(validTargets, {
                                            model = zombie,
                                            head = head,
                                            humanoid = humanoid,
                                            distance = distance
                                        })
                                    end
                                end
                            end
                            
                            -- Try to shoot ONE target (with smart raycasting)
                            if #validTargets > 0 then
                                -- Prioritize: 1) Bosses, 2) Closer enemies
                                table.sort(validTargets, function(a, b)
                                    -- FIXED: Use exact boss names from the game
                                    local aBoss = a.model.Name == "GoblinKing" or a.model.Name == "CaptainBoom" or 
                                                  a.model.Name == "Fungarth"
                                    local bBoss = b.model.Name == "GoblinKing" or b.model.Name == "CaptainBoom" or 
                                                  b.model.Name == "Fungarth"
                                    
                                    -- Bosses always first
                                    if aBoss and not bBoss then return true end
                                    if bBoss and not aBoss then return false end
                                    
                                    -- If both bosses or both regular, prioritize by distance (closer first)
                                    return a.distance < b.distance
                                end)
                                
                                -- CROWD CONTROL: Try to shoot multiple targets per cycle for better defense
                                local shotsFired = 0
                                local maxShotsPerCycle = math.min(5, #validTargets) -- Up to 5 shots per cycle (MAXIMUM CARNAGE)
                                
                                for _, target in ipairs(validTargets) do
                                    if shotsFired >= maxShotsPerCycle then break end
                                    
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
                                            
                                            -- Notify when boss is targeted (for debugging)
                                            if isBoss and math.random(1, 30) == 1 then -- Reduced spam chance
                                                Rayfield:Notify({
                                                    Title = "🎯 BOSS TARGETED",
                                                    Content = "Shooting " .. target.model.Name .. "!",
                                                    Duration = 2,
                                                    Image = 4483362458
                                                })
                                            end
                                            
                                            -- Minimal delay between multi-shots for MAXIMUM SPEED
                                            if shotsFired < maxShotsPerCycle then
                                                task.wait(0.005) -- Ultra-tiny delay between rapid shots
                                            end
                                        end
                                    end
                                    
                                    -- If this target blocked, try next one (max 12 attempts for GODMODE)
                                    if #validTargets > 12 and _ >= 12 then
                                        break
                                    end
                                end
                                
                                -- If no shot fired, all targets blocked (legitimate game behavior)
                            end
                        end
                    end)
                    
                    -- 🛡️ Use KnightMare-synchronized delay system
                    task.wait(getKnightMareDelay(shootDelay))
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

MiscTab:CreateSection("💰 Auto Collection")

-- 💎 KNIGHTMARE-SYNCHRONIZED AUTO COLLECT SYSTEM
-- Advanced tween detection evasion with natural item magnetism simulation
local autoCollect = false
local collectRadius = 80 -- KnightMare-safe radius
local lastCollectTime = 0
local collectCooldown = 0.25 -- KnightMare-safe timing
local TweenService = game:GetService("TweenService")
local activeTweens = {} -- Track active tweens to avoid duplicates
local collectHistory = {} -- Track collection patterns for KnightMare evasion

-- 🛡️ KnightMare-Safe Collection Function
local function knightMareCollectItems()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local currentTime = tick()
    
    -- KnightMare timing validation with adaptive cooldown
    local adaptiveCooldown = collectCooldown + (math.random() * 0.1) -- 0.25-0.35s variance
    if currentTime - lastCollectTime < adaptiveCooldown then return end
    lastCollectTime = currentTime
    
    -- Clean old collection history (KnightMare pattern analysis evasion)
    for i = #collectHistory, 1, -1 do
        if currentTime - collectHistory[i] > 10 then
            table.remove(collectHistory, i)
        end
    end
    
    pcall(function()
        local collected = 0
        local recentCollections = #collectHistory
        
        -- KnightMare adaptive collection limits (based on recent activity)
        local maxItemsPerCycle = math.max(1, 3 - math.floor(recentCollections / 5)) -- 1-3 items
        
        -- Search for collectible items (KnightMare-optimized scope)
        for _, item in pairs(workspace:GetDescendants()) do
            if collected >= maxItemsPerCycle then break end
            
            -- Skip if already being tweened or recently collected
            if activeTweens[item] then continue end
            
            if item:IsA("BasePart") and item.CanCollide == false and not item.Anchored then
                -- Enhanced collectible detection
                local itemName = item.Name:lower()
                local isCollectible = itemName:find("gold") or 
                                     itemName:find("drop") or
                                     itemName:find("coin") or
                                     itemName:find("money") or
                                     itemName:find("cash") or
                                     itemName:find("loot") or
                                     itemName:find("gem") or
                                     itemName:find("crystal")
                
                if isCollectible then
                    local distance = (item.Position - root.Position).Magnitude
                    
                    if distance <= collectRadius and distance > 12 then -- Increased minimum distance
                        -- 🛡️ KnightMare-Safe Tween Parameters
                        local baseDuration = 0.5 + (math.random() * 0.4) -- 0.5-0.9s (more natural)
                        local tweenInfo = TweenInfo.new(
                            baseDuration,
                            Enum.EasingStyle.Quart, -- More natural easing
                            Enum.EasingDirection.Out,
                            0, -- No repeat
                            false, -- No reverse
                            math.random() * 0.1 -- Small random delay start
                        )
                        
                        -- Natural collection path (slight arc, not straight line)
                        local targetOffset = Vector3.new(
                            (math.random() - 0.5) * 4, -- ±2 stud X variance
                            2 + math.random() * 2,     -- 2-4 studs above player
                            (math.random() - 0.5) * 4  -- ±2 stud Z variance
                        )
                        
                        local tween = TweenService:Create(item, tweenInfo, {
                            CFrame = root.CFrame * CFrame.new(targetOffset.X, targetOffset.Y, targetOffset.Z)
                        })
                        
                        activeTweens[item] = true
                        tween:Play()
                        
                        -- Record collection for KnightMare pattern evasion
                        table.insert(collectHistory, currentTime)
                        
                        -- Clean up tween reference when done
                        tween.Completed:Connect(function()
                            activeTweens[item] = nil
                        end)
                        
                        collected = collected + 1
                        
                        -- Variable delay between collections (KnightMare evasion)
                        local itemDelay = 0.08 + (math.random() * 0.07) -- 0.08-0.15s variance
                        task.wait(itemDelay)
                    end
                end
            end
        end
    end)
end

MiscTab:CreateToggle({
    Name = "💎 Auto Loot Collector",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(state)
        autoCollect = state
        if state then
            Rayfield:Notify({
                Title = "💎 Freezy HUB",
                Content = "Auto-collector activated!",
                Duration = 3,
                Image = 4483362458
            })
            
            task.spawn(function()
                while autoCollect do
                    knightMareCollectItems()
                    -- KnightMare-safe adaptive timing
                    local adaptiveWait = collectCooldown + (math.random() * 0.15) -- 0.25-0.4s variance
                    task.wait(adaptiveWait)
                end
            end)
        end
    end
})

MiscTab:CreateSlider({
    Name = "📏 Collector Radius",
    Range = {40, 120},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 80,
    Flag = "CollectRadius",
    Callback = function(Value)
        collectRadius = Value
    end
})

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


-- Mod Tab
local ModTab = Window:CreateTab("🌀 Movement", "User")

-- Orbit System with Anti-Detection (Smooth Movement)
local spinning = false
local angle = 0
local speed = 5
local radius = 15
local lastCFrame = nil
local smoothness = 0.15 -- Interpolation smoothness (lower = smoother)

local TweenService = game:GetService("TweenService")
local HRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    HRP = char:WaitForChild("HumanoidRootPart")
    lastCFrame = nil -- Reset on respawn
end)

-- Boss finding with health check
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
            local humanoid = boss:FindFirstChild("Humanoid")
            -- Only target living bosses
            if humanoid and humanoid.Health > 0 then
                local distance = (boss.Head.Position - HRP.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestBoss = boss
                end
            end
        end
    end
    return nearestBoss
end

-- 🌪️ KNIGHTMARE-SYNCHRONIZED ORBITAL MOVEMENT
-- Advanced teleportation detection evasion with natural physics simulation
local lastOrbitTime = 0
local orbitVelocity = Vector3.new(0, 0, 0)
local maxOrbitSpeed = 50 -- KnightMare-safe maximum movement speed

RunService.RenderStepped:Connect(function(dt)
    if spinning and HRP then
        pcall(function()
            local currentTime = tick()
            
            -- KnightMare timing validation (prevent too frequent updates)
            if currentTime - lastOrbitTime < 0.03 then -- Max 33 FPS updates
                return
            end
            lastOrbitTime = currentTime
            
            local boss = findNearestBoss()
            if boss and boss:FindFirstChild("Head") then
                -- 🎯 Natural angle progression with physics-like acceleration
                local angleAcceleration = dt * speed * (0.8 + math.random() * 0.4) -- 20% variance
                angle = angle + angleAcceleration
                if angle >= math.pi * 2 then
                    angle = angle - math.pi * 2
                end
                
                local bossPos = boss.Head.Position
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
                local targetPos = bossPos + offset
                
                -- 🛡️ KnightMare-Safe Movement Calculation
                if lastCFrame then
                    local currentPos = lastCFrame.Position
                    local desiredVelocity = (targetPos - currentPos) / dt
                    
                    -- Limit velocity to prevent teleportation detection
                    if desiredVelocity.Magnitude > maxOrbitSpeed then
                        desiredVelocity = desiredVelocity.Unit * maxOrbitSpeed
                    end
                    
                    -- Smooth velocity interpolation (mimics natural physics)
                    orbitVelocity = orbitVelocity:Lerp(desiredVelocity, smoothness * 2)
                    local newPos = currentPos + (orbitVelocity * dt)
                    
                    -- Natural looking direction (face movement direction)
                    local lookDirection = orbitVelocity.Unit
                    if lookDirection.Magnitude > 0.1 then
                        local targetCFrame = CFrame.lookAt(newPos, newPos + lookDirection)
                        HRP.CFrame = lastCFrame:Lerp(targetCFrame, smoothness)
                    else
                        HRP.CFrame = CFrame.new(newPos, bossPos)
                    end
                else
                    -- Initial position setup
                    HRP.CFrame = CFrame.new(targetPos, bossPos)
                end
                
                lastCFrame = HRP.CFrame
            end
        end)
    end
end)

ModTab:CreateToggle({
    Name = "🌪️ Orbit Boss (360° Smooth)",
    CurrentValue = false,
    Callback = function(value)
        spinning = value
        if value then
            angle = 0 -- Reset angle
            lastCFrame = nil -- Reset interpolation
        end
    end
})

ModTab:CreateSlider({
    Name = "⚡ Orbit Speed",
    Range = {1, 20},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 5,
    Callback = function(val)
        speed = val
    end
})

ModTab:CreateSlider({
    Name = "📏 Orbit Radius",
    Range = {5, 100},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 15,
    Callback = function(val)
        radius = val
    end
})

ModTab:CreateSlider({
    Name = "🎯 Orbit Smoothness",
    Range = {0.05, 0.5},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.15,
    Callback = function(val)
        smoothness = val
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
            warn("❌ HumanoidRootPart not found")
            return
        end

        local currentPos = HRP.Position
        local targetPos = currentPos + Vector3.new(0, 60, 0)

        -- 🧱 Create platform
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(20, 1, 20)
        platform.Anchored = true
        platform.Position = targetPos - Vector3.new(0, 2, 0)
        platform.Color = Color3.fromRGB(120, 120, 120)
        platform.Material = Enum.Material.Metal
        platform.Name = "SmartPlatform"
        platform.Parent = workspace

        -- ⏫ Teleport player slightly above platform
        HRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))

        -- ⏱️ Self-destruct timer when player steps off
        local isStanding = true
        local lastTouch = tick()

        -- Check every frame
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
                -- Player is standing on platform
                lastTouch = tick()
            end

            -- If more than 10 seconds have passed since player stood on it - destroy
            if tick() - lastTouch > 10 then
                platform:Destroy()
                conn:Disconnect()
            end
        end)
    end
})

-- ❄️ FREEZY HUB SETTINGS SECTION
MiscTab:CreateSection("❄️ Freezy HUB Settings")

MiscTab:CreateButton({
    Name = "🔌 Unload Freezy HUB",
    Callback = function()
        -- Disable all active features
        autoKill = false
        autoSkip = false
        autoCollect = false
        autoOpenCamo = false
        autoOpenOutfit = false
        autoOpenPet = false
        autoOpenGun = false
        
        -- Immediate feedback that features are disabled
        Rayfield:Notify({
            Title = "🛑 Features Disabled",
            Content = "All auto-functions stopped!",
            Duration = 1,
            Image = 4483362458
        })
        
        -- Clear any active tweens
        for item, _ in pairs(activeTweens or {}) do
            activeTweens[item] = nil
        end
        
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
        
        -- Clean up any created platforms
        pcall(function()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "SmartPlatform" then
                    obj:Destroy()
                end
            end
        end)
        
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
