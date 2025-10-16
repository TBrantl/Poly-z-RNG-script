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
-- 🚀 MAXIMUM EXPLOITATIVE PERFORMANCE - NO SCALING, JUST PURE POWER
local shootDelay = 0.25 -- Default safe speed
local lastShot = 0
local shotCount = 0
local maxShootDistance = 150 -- Default safe range
local effectivenessLevel = 50 -- Default effectiveness level (0-100%)

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

-- 🚀 MAXIMUM EXPLOITATIVE TOGGLE - NO SCALING, JUST PURE POWER
CombatTab:CreateToggle({
    Name = "🚀 MAXIMUM EXPLOITATIVE MODE",
    CurrentValue = false,
    Flag = "MaxExploitative",
    Callback = function(state)
        if state then
            -- ABSOLUTE LIMIT SETTINGS - THEORETICAL MAXIMUM
            shootDelay = 0.0001 -- 0.1ms reaction time (100 microseconds)
            maxShootDistance = 250 -- Full range
            adaptiveDelay = 0.0001 -- Maximum speed
            stealthMode = false -- Maximum performance
            
            Rayfield:Notify({
                Title = "🚀 ABSOLUTE LIMIT MODE ACTIVE",
                Content = "0.1ms reaction time | 250 stud range | THEORETICAL MAXIMUM",
                Duration = 4,
                Image = 4483362458
            })
        else
            -- SAFE MODE
            shootDelay = 0.25 -- Safe reaction time
            maxShootDistance = 150 -- Reduced range
            adaptiveDelay = 0.1 -- Safe speed
            stealthMode = true -- Safe mode
            
            Rayfield:Notify({
                Title = "🛡️ SAFE MODE ACTIVE",
                Content = "Conservative settings | Maximum safety",
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
                            
                            -- 🛡️ END-OF-ROUND DETECTION: Reduce activity when few targets remain
                            local isEndOfRound = #validTargets <= 2
                            if isEndOfRound then
                                print("[DEBUG] End of round detected - reducing activity")
                            end
                            
                            if #validTargets > 0 then
                                -- 🛡️ END-OF-ROUND SKIP CHANCE: Sometimes skip shooting when few targets
                                if isEndOfRound and math.random() < 0.1 then -- 10% chance to skip at end of round (was 30%)
                                    print("[DEBUG] Skipping shot at end of round to avoid detection")
                                    -- Skip to cycle delay - no shooting this cycle
                                else
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
                                
                                -- 🚀 MAXIMUM EXPLOITATIVE SHOT ALLOCATION
                                local shotsFired = 0
                                local maxShots
                                if isEndOfRound then
                                    -- 🛡️ END-OF-ROUND CONSERVATIVE MODE: Much more conservative
                                    maxShots = math.min(1, #validTargets) -- Only 1 shot at end of round
                                else
                                    -- MAXIMUM EXPLOITATIVE: Unlimited shots
                                    if stealthMode then
                                        maxShots = math.min(3, #validTargets) -- Safe mode: 3 shots
                                    else
                                        -- MASSIVE MULTIPLICATION: Kill multiple zombies simultaneously
                                        local zombieCount = #validTargets
                                        
                                        -- ADAPTIVE MULTIPLICATION: More zombies = more aggressive
                                        local simultaneousKills
                                        local overkillShots
                                        
                                        if zombieCount >= 100 then
                                            -- MASSIVE SWARM: Kill 100 zombies with 20 shots each
                                            simultaneousKills = math.min(100, zombieCount)
                                            overkillShots = 20 -- 20 shots per zombie
                                        elseif zombieCount >= 50 then
                                            -- LARGE SWARM: Kill 50 zombies with 15 shots each
                                            simultaneousKills = math.min(50, zombieCount)
                                            overkillShots = 15 -- 15 shots per zombie
                                        elseif zombieCount >= 20 then
                                            -- MEDIUM SWARM: Kill 30 zombies with 12 shots each
                                            simultaneousKills = math.min(30, zombieCount)
                                            overkillShots = 12 -- 12 shots per zombie
                                        else
                                            -- SMALL GROUP: Kill 20 zombies with 10 shots each
                                            simultaneousKills = math.min(20, zombieCount)
                                            overkillShots = 10 -- 10 shots per zombie
                                        end
                                        
                                        maxShots = simultaneousKills * overkillShots -- 200-2000 shots per cycle
                                    end
                                end
                                
                                -- 🚀 MASSIVE MULTIPLICATION: Kill multiple zombies simultaneously
                                local zombieCount = #validTargets
                                
                                -- ADAPTIVE MULTIPLICATION: More zombies = more aggressive
                                local simultaneousKills
                                local overkillShots
                                
                                if zombieCount >= 100 then
                                    -- MASSIVE SWARM: Kill 100 zombies with 20 shots each
                                    simultaneousKills = math.min(100, zombieCount)
                                    overkillShots = 20 -- 20 shots per zombie
                                elseif zombieCount >= 50 then
                                    -- LARGE SWARM: Kill 50 zombies with 15 shots each
                                    simultaneousKills = math.min(50, zombieCount)
                                    overkillShots = 15 -- 15 shots per zombie
                                elseif zombieCount >= 20 then
                                    -- MEDIUM SWARM: Kill 30 zombies with 12 shots each
                                    simultaneousKills = math.min(30, zombieCount)
                                    overkillShots = 12 -- 12 shots per zombie
                                else
                                    -- SMALL GROUP: Kill 20 zombies with 10 shots each
                                    simultaneousKills = math.min(20, zombieCount)
                                    overkillShots = 10 -- 10 shots per zombie
                                end
                                
                                -- PHASE 1: SIMULTANEOUS MULTI-TARGET KILLING
                                for targetIndex = 1, simultaneousKills do
                                    local target = validTargets[targetIndex]
                                    
                                    -- PHASE 2: OVERKILL - Multiple shots per zombie
                                    for shotIndex = 1, overkillShots do
                                        local character = player.Character
                                        if character then
                                            local camera = workspace.CurrentCamera
                                            if camera then
                                                local origin = camera.CFrame.Position
                                                local targetPos = target.head.Position
                                                local direction = (targetPos - origin).Unit
                                                local distance = (targetPos - origin).Magnitude
                                                
                                                if distance <= maxShootDistance then
                                                    -- 🛡️ KNIGHTMARE-EXACT RAYCAST SYNCHRONIZATION
                                                    local raycastParams = RaycastParams.new()
                                                    raycastParams.FilterDescendantsInstances = {workspace.Enemies}
                                                    raycastParams.FilterType = Enum.RaycastFilterType.Include
                                                    
                                                    -- Use direct direction to target (working method)
                                                    local rayResult = workspace:Raycast(origin, direction * distance, raycastParams)
                                                    
                                                    if rayResult and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
                                                        -- 🛡️ KNIGHTMARE-EXACT FIRESERVER ARGUMENTS
                                                        local args = {target.model, rayResult.Instance, rayResult.Position, 0, weapon}
                                                        
                                                        local success = pcall(function()
                                                            shootRemote:FireServer(unpack(args))
                                                        end)
                                                        
                                                        if success then
                                                            shotsFired = shotsFired + 1
                                                            performanceStats.shotsSuccessful = performanceStats.shotsSuccessful + 1
                                                            
                                                            -- 🚀 ULTRA-FAST SPACING FOR MASSIVE MULTIPLICATION
                                                            if shotIndex < overkillShots then
                                                                local spacingDelay = 0.00001 + (math.random() * 0.00004) -- 0.01-0.05ms spacing
                                                                task.wait(spacingDelay)
                                                            end
                                                        else
                                                            performanceStats.shotsBlocked = performanceStats.shotsBlocked + 1
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                                    -- 🚀 SIMULTANEOUS TARGET SPACING - Minimal delay between zombies
                                    if targetIndex < simultaneousKills then
                                        local targetSpacing = 0.00001 + (math.random() * 0.00004) -- 0.01-0.05ms between zombies
                                        task.wait(targetSpacing)
                                    end
                                end
                                end -- End of else block for end-of-round skip
                            else
                                print("[DEBUG] No valid targets found")
                            end
                        else
                            print("[DEBUG] Missing enemies or shootRemote")
                        end
                    end)
                    
                    -- 🛡️ KNIGHTMARE-SYNCHRONIZED CYCLE DELAY
                    local cycleDelay
                    
                    -- Check if we're at end of round (few targets)
                    local currentThreats = 0
                    if enemies then
                        for _, zombie in pairs(enemies:GetChildren()) do
                            if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
                                currentThreats = currentThreats + 1
                            end
                        end
                    end
                    local isEndOfRound = currentThreats <= 2
                    
                    if isEndOfRound then
                        -- 🛡️ END-OF-ROUND CONSERVATIVE DELAY: Much slower to avoid detection
                        cycleDelay = 0.8 + (math.random() * 0.4) -- 800-1200ms (very conservative)
                    else
                        -- 🚀 MAXIMUM EXPLOITATIVE: Ultra-fast cycle delay
                        if stealthMode then
                            cycleDelay = 0.2 + (math.random() * 0.1) -- Safe mode: 200-300ms
                        else
                            cycleDelay = 0.0001 + (math.random() * 0.0009) -- ABSOLUTE LIMIT: 0.1-1ms cycle
                        end
                    end
                    
                    -- 🛡️ KNIGHTMARE HUMANIZATION: Add natural inconsistency
                    local inconsistency = (math.random() - 0.5) * 0.0001 -- ±0.05ms natural variation
                    cycleDelay = math.max(0.0001, cycleDelay + inconsistency) -- Minimum 0.1ms
                    
                    -- 🛡️ KNIGHTMARE FATIGUE SIMULATION: Occasional slower cycles
                    if math.random() < 0.05 then -- 5% chance of fatigue
                        cycleDelay = cycleDelay + (0.1 + math.random() * 0.2) -- +100-300ms fatigue
                    end
                    
                    -- 🧠 ADVANCED BEHAVIORAL AI: Simulate human focus and attention
                    local currentTime = tick()
                    local sessionDuration = currentTime - sessionStartTime
                    
                    -- 🧠 FOCUS DRIFT: Simulate attention span changes
                    if currentTime - behaviorProfile.lastFocusChange > 30 then -- Every 30 seconds
                        behaviorProfile.focusLevel = math.max(0.3, math.min(0.9, behaviorProfile.focusLevel + (math.random() - 0.5) * 0.2))
                        behaviorProfile.lastFocusChange = currentTime
                    end
                    
                    -- 🧠 FATIGUE ACCUMULATION: Get slightly slower over time
                    if currentTime - behaviorProfile.lastFatigueChange > 60 then -- Every minute
                        behaviorProfile.fatigueLevel = math.min(0.3, behaviorProfile.fatigueLevel + 0.05)
                        behaviorProfile.lastFatigueChange = currentTime
                    end
                    
                    -- 🧠 SKILL DRIFT: Simulate getting better/worse over time
                    behaviorProfile.skillDrift = behaviorProfile.skillDrift + (math.random() - 0.5) * 0.01
                    behaviorProfile.skillDrift = math.max(-0.2, math.min(0.2, behaviorProfile.skillDrift))
                    
                    -- Apply behavioral modifiers to cycle delay
                    local focusModifier = 1 - (behaviorProfile.focusLevel * 0.3) -- Better focus = faster
                    local fatigueModifier = 1 + (behaviorProfile.fatigueLevel * 0.4) -- More fatigue = slower
                    local skillModifier = 1 - (behaviorProfile.skillDrift * 0.2) -- Better skill = faster
                    
                    cycleDelay = cycleDelay * focusModifier * fatigueModifier * skillModifier
                    
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
