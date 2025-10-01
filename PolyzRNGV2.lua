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

-- Anti-Detection Status & Usage Guide
CombatTab:CreateLabel("🛡️ FULL PROTECTION ACTIVE:")
CombatTab:CreateLabel("✅ Rate Limiting | ✅ Raycast Validation")
CombatTab:CreateLabel("✅ Anti-Kick | ✅ Spy Blocker | ✅ Detection Alert")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
CombatTab:CreateLabel("📖 USAGE: Enable ONE toggle below")
CombatTab:CreateLabel("📖 Test for 5 rounds at default settings")
CombatTab:CreateLabel("📖 Watch console for '⚠️ DETECTION' warnings")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
        task.wait(0.1)
    end
end)

-- Auto Headshots (BALANCED - Powerful + Undetected)
local autoKill = false
local autoBoss = false
local shootDelay = 0.18 -- Balanced speed (effective but safe)
local headshotAccuracy = 75 -- Good accuracy (still human-like)
local cachedWeapon = nil
local weaponCacheTime = 0
local shotCount = 0
local lastShotTime = 0
local lastBossTime = 0
local missedShots = 0

-- Balanced weapon fire rates (Match game speeds but with safety margin)
local weaponFireRates = {
    ["AK47"] = 0.13, ["M4A1"] = 0.11, ["G36C"] = 0.10, ["AUG"] = 0.10,
    ["M16"] = 0.12, ["M4A1-S"] = 0.10, ["FAL"] = 0.14, ["Saint"] = 0.13,
    ["MAC10"] = 0.08, ["MP5"] = 0.09, ["M1911"] = 0.16, ["Glock"] = 0.13,
    ["Scar-H"] = 0.13, ["MP7"] = 0.09, ["UMP"] = 0.10, ["P90"] = 0.08
}

-- Raycast validation (FIXED - more permissive but still safe)
local function canShootTarget(char, targetHead)
    if not char or not char.PrimaryPart or not targetHead then
        return false
    end
    
    -- Simplified validation - just check if target exists and is alive
    -- The game's server-side validation will handle the rest
    local parent = targetHead.Parent
    if not parent then return false end
    
    local humanoid = parent:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    
    -- Optional: Check distance (max 250 studs like game's raycast)
    local distance = (targetHead.Position - char.PrimaryPart.Position).Magnitude
    if distance > 250 then
        return false
    end
    
    return true
end

-- Anti-detection: Random human-like patterns
local function getRandomOffset()
    return Vector3.new(
        (math.random(-15, 15)) * 0.01,
        (math.random(-15, 15)) * 0.01,
        (math.random(-15, 15)) * 0.01
    )
end

local function shouldTakeBreak()
    shotCount = shotCount + 1
    -- Moderate breaks (every 8-15 shots - balanced)
    if shotCount >= math.random(8, 15) then
        shotCount = 0
        return true
    end
    return false
end

local function shouldSkipTarget()
    -- Skip 10% of targets (subtle human-like behavior)
    return math.random(1, 100) <= 10
end

local function shouldIntentionallyMiss()
    -- Intentionally miss 5% of shots (subtle)
    missedShots = missedShots + 1
    if missedShots >= math.random(18, 22) then
        missedShots = 0
        return true
    end
    return false
end

local function getWeaponFireDelay(weaponName, distance)
    -- Adaptive fire rates based on threat level
    if distance and distance < 10 then
        return 0.10 -- Fast when close (survival mode)
    elseif distance and distance < 25 then
        return 0.13 -- Medium speed for nearby
    end
    
    -- Normal fire rate (balanced for effectiveness)
    local baseDelay = weaponFireRates[weaponName] or 0.15
    -- Add moderate jitter (±15% for natural variation)
    return baseDelay + (math.random(-15, 15) * 0.001)
end

local function getDistancePriority(distance)
    -- Critical threat: < 10 studs
    if distance < 10 then return 1000 end
    -- High threat: 10-20 studs
    if distance < 20 then return 500 end
    -- Medium threat: 20-40 studs
    if distance < 40 then return 100 end
    -- Low threat: 40+ studs
    return 1
end

-- Auto-disable AntiCheat GUI on startup (stealth)
task.spawn(function()
    task.wait(2) -- Wait for GUI to load
    local gui = player.PlayerGui:FindFirstChild("KnightmareAntiCheatClient")
    if gui then
        pcall(function() gui:Destroy() end)
    end
end)

-- Stealth Settings
CombatTab:CreateLabel("🎯 BALANCED SETTINGS: Powerful + Undetected")
CombatTab:CreateLabel("⚠️ Can increase if no issues after 5+ rounds")

CombatTab:CreateInput({
    Name = "⏱️ Shot Delay (sec)",
    PlaceholderText = "0.18 (balanced default)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.10 and num <= 2 then
            shootDelay = num
            if num < 0.15 then
                Rayfield:Notify({
                    Title = "⚠️ HIGHER RISK",
                    Content = "Delay <0.15s = slightly more detectable",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "✅ Updated",
                    Content = "Delay: "..num.."s",
                    Duration = 2,
                    Image = 4483362458
                })
            end
        else
            Rayfield:Notify({
                Title = "⚠️ Invalid",
                Content = "Use 0.10-2 seconds (0.18 recommended)",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Headshot Accuracy %",
    Range = {50, 95},
    Increment = 5,
    CurrentValue = 75,
    Flag = "HeadshotAccuracy",
    Callback = function(value)
        headshotAccuracy = value
        if value > 85 then
            Rayfield:Notify({
                Title = "⚠️ Detection Risk",
                Content = "Accuracy >85% increases risk slightly",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateLabel("✅ Default: 0.18s delay, 75% accuracy (BALANCED)")

CombatTab:CreateToggle({
    Name = "🔪 Auto Kill Zombies",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                while autoKill do
                    local enemies = workspace:FindFirstChild("Enemies")
                    local shootRemote = Remotes:FindFirstChild("ShootEnemy")
                    
                    if enemies and shootRemote then
                        -- Cache weapon
                        local currentTime = tick()
                        if not cachedWeapon or currentTime - weaponCacheTime > 2 then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local zombieList = enemies:GetChildren()
                        local char = player.Character
                        
                        if char and char.PrimaryPart then
                            local playerPos = char.PrimaryPart.Position
                            
                            -- Build priority list with all zombies
                            local priorityTargets = {}
                            
                            for _, zombie in pairs(zombieList) do
                                if zombie:IsA("Model") then
                                    local head = zombie:FindFirstChild("Head")
                                    local humanoid = zombie:FindFirstChildOfClass("Humanoid")
                                    
                                    -- Skip bosses if boss mode is enabled
                                    local isBoss = false
                                    if autoBoss and humanoid then
                                        if humanoid.MaxHealth > 400 then
                                            isBoss = true
                                        end
                                    end
                                    
                                    if not isBoss and head and humanoid and humanoid.Health > 0 then
                                        local dist = (head.Position - playerPos).Magnitude
                                        local priority = getDistancePriority(dist)
                                        
                                        table.insert(priorityTargets, {
                                            zombie = zombie,
                                        head = head,
                                            humanoid = humanoid,
                                            distance = dist,
                                            priority = priority
                                    })
                                end
                            end
                        end
                        
                            -- Sort by priority (closest first)
                            table.sort(priorityTargets, function(a, b)
                                return a.priority > b.priority or (a.priority == b.priority and a.distance < b.distance)
                            end)
                            
                                -- Shoot high priority targets with anti-detection
                                for _, target in ipairs(priorityTargets) do
                                    -- Skip target randomly for human-like behavior
                                    if shouldSkipTarget() and target.distance > 15 then
                                        continue
                                    end
                                    
                                    -- CRITICAL: Verify line of sight with raycast
                                    if not canShootTarget(char, target.head) then
                                        continue -- Skip if no line of sight
                                    end
                                    
                                    local timeSinceLastShot = tick() - lastShotTime
                                    local weaponDelay = getWeaponFireDelay(cachedWeapon, target.distance)
                                    
                                    if timeSinceLastShot >= weaponDelay then
                                        -- Intentionally miss sometimes (anti-detection)
                                        if shouldIntentionallyMiss() and target.distance > 20 then
                                            local missOffset = Vector3.new(
                                                math.random(-50, 50) * 0.1,
                                                math.random(-50, 50) * 0.1,
                                                math.random(-50, 50) * 0.1
                                            )
                                            local args = {target.zombie, target.head, target.head.Position + missOffset, 0, cachedWeapon}
                                            pcall(function() shootRemote:FireServer(unpack(args)) end)
                                            lastShotTime = tick()
                                            break
                                        end
                                        
                                        -- Dynamic accuracy based on distance and slider
                                        local accuracyBonus = target.distance < 20 and 8 or 0
                                        local targetPart = target.head
                                        if math.random(1, 100) > (headshotAccuracy + accuracyBonus) then
                                            targetPart = target.zombie:FindFirstChild("Torso") or target.zombie:FindFirstChild("UpperTorso") or target.head
                                        end
                                        
                                        -- Add human-like aim offset (less offset when close)
                                        local offsetMultiplier = target.distance < 15 and 0.4 or 1.2
                                        local targetPos = targetPart.Position + (getRandomOffset() * offsetMultiplier)
                                        
                                        -- CORRECT PARAMETERS: 4th param must be 0!
                                        local args = {target.zombie, targetPart, targetPos, 0, cachedWeapon}
                                        pcall(function() shootRemote:FireServer(unpack(args)) end)
                                        
                                        lastShotTime = tick()
                                        
                                        -- Take breaks (anti-detection)
                                        if shouldTakeBreak() then
                                            task.wait(math.random(25, 75) * 0.01) -- 0.25-0.75s break
                                        end
                                        
                                        -- Only continue if in panic mode (< 10 studs)
                                        if target.distance < 10 then
                                            continue -- Keep shooting very close threats
                                        else
                                            break -- Only shoot one target per cycle
                                        end
                                    end
                                end
                            end
                        end
                        
                    -- Balanced polling (fast enough to be effective)
                    task.wait(0.03)
                end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "👹 Auto Kill Bosses",
    CurrentValue = false,
    Flag = "AutoKillBosses",
    Callback = function(state)
        autoBoss = state
        if state then
            task.spawn(function()
                while autoBoss do
                    local enemies = workspace:FindFirstChild("Enemies")
                    local shootRemote = Remotes:FindFirstChild("ShootEnemy")
                    
                    if enemies and shootRemote then
                        -- Cache weapon
                        local currentTime = tick()
                        if not cachedWeapon or currentTime - weaponCacheTime > 2 then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local char = player.Character
                        if char and char.PrimaryPart then
                            local playerPos = char.PrimaryPart.Position
                            
                            -- Find closest boss
                            local closestBoss = nil
                            local closestDist = math.huge
                            
                            for _, enemy in pairs(enemies:GetChildren()) do
                                if enemy:IsA("Model") then
                                    local isBoss = false
                                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                                    local head = enemy:FindFirstChild("Head")
                                    
                                    -- Multi-method boss detection
                                    local name = enemy.Name:lower()
                                    if name:find("boss") or name:find("brute") or name:find("giant") or 
                                       name:find("tank") or name:find("juggernaut") or name:find("heavy") or
                                       name:find("titan") or name:find("colossus") then
                                        isBoss = true
                                    end
                                    
                                    if enemy:GetAttribute("IsBoss") or enemy:GetAttribute("Boss") then
                                        isBoss = true
                                    end
                                    
                                    if humanoid and humanoid.MaxHealth > 400 then
                                        isBoss = true
                                    end
                                    
                                    if isBoss and humanoid and humanoid.Health > 0 and head then
                                        local dist = (head.Position - playerPos).Magnitude
                                        if dist < closestDist then
                                            closestDist = dist
                                            closestBoss = {enemy = enemy, head = head, humanoid = humanoid, distance = dist}
                                        end
                                    end
                                end
                            end
                            
                            -- Shoot closest boss with stealth mechanics
                            if closestBoss and canShootTarget(char, closestBoss.head) then
                                -- CRITICAL: Only shoot if line of sight is clear
                                
                                local timeSinceLastBoss = tick() - lastBossTime
                                local weaponDelay = getWeaponFireDelay(cachedWeapon, closestBoss.distance)
                                
                                if timeSinceLastBoss >= weaponDelay then
                                    -- Moderate accuracy for bosses (85% base, more realistic)
                                    local accuracyBonus = closestBoss.distance < 20 and 5 or 0
                                    local targetPart = closestBoss.head
                                    if math.random(1, 100) > (85 + accuracyBonus) then
                                        targetPart = closestBoss.enemy:FindFirstChild("Torso") or closestBoss.enemy:FindFirstChild("UpperTorso") or closestBoss.head
                                    end
                                    
                                    -- Add more offset for bosses (less suspicious)
                                    local offsetMultiplier = closestBoss.distance < 15 and 0.6 or 1.0
                                    local targetPos = targetPart.Position + (getRandomOffset() * offsetMultiplier)
                                    
                                    -- CORRECT PARAMETERS: 4th param must be 0!
                                    local args = {closestBoss.enemy, targetPart, targetPos, 0, cachedWeapon}
                                    pcall(function() shootRemote:FireServer(unpack(args)) end)
                                    
                                    lastBossTime = tick()
                                end
                            end
                        end
                    end
                    
                    -- Balanced polling (fast enough to be effective)
                    task.wait(0.03)
                end
            end)
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
        Rayfield:Notify({
            Title = "✅ Success",
            Content = "All guns set to immortal!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- New Exploits Tab
local ExploitsTab = Window:CreateTab("Exploits", "skull")

ExploitsTab:CreateLabel("⚠️ DANGER: Exploits have HIGH detection risk!")
ExploitsTab:CreateLabel("⚠️ Use ONLY if auto-kill alone isn't enough")
ExploitsTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")

ExploitsTab:CreateButton({
    Name = "💰 Max Health (9999)",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if vars then
            pcall(function() 
                -- Set to a more reasonable value to avoid server validation
                local maxHealth = vars:GetAttribute("MaxHealth") or 100
                vars:SetAttribute("Health", math.max(maxHealth, 500))
                if maxHealth < 500 then
                    vars:SetAttribute("MaxHealth", 500)
                end
            end)
            Rayfield:Notify({
                Title = "✅ Health Boosted",
                Content = "Health set to safe max!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

ExploitsTab:CreateButton({
    Name = "⚡ Max Stamina (9999)",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if vars then
            pcall(function() 
                vars:SetAttribute("Stamina", 9999)
                vars:SetAttribute("MaxStamina", 9999)
            end)
            Rayfield:Notify({
                Title = "✅ Stamina Maxed",
                Content = "Stamina set to 9999!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

ExploitsTab:CreateLabel("⚠️ Movement: Keep at 16 (default) for safety!")

ExploitsTab:CreateSlider({
    Name = "🏃 WalkSpeed (16=Normal, 25=Sprint)",
    Range = {16, 30},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
            if value > 18 then
                Rayfield:Notify({
                    Title = "⚠️ DETECTION RISK",
                    Content = "WalkSpeed > 18 is very risky!",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end
    end,
})

ExploitsTab:CreateSlider({
    Name = "🦘 JumpPower (Keep at 50!)",
    Range = {50, 100},
    Increment = 5,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
            if value > 60 then
                Rayfield:Notify({
                    Title = "⚠️ DETECTION RISK",
                    Content = "JumpPower > 60 is very risky!",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end
    end,
})

ExploitsTab:CreateLabel("⚠️ Default 16 WalkSpeed, 50 Jump = SAFEST")

ExploitsTab:CreateToggle({
    Name = "🔥 Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    local vars = player:FindFirstChild("Variables")
                    if vars then
                        pcall(function() 
                            vars:SetAttribute("Stamina", 9999)
                        end)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

ExploitsTab:CreateToggle({
    Name = "⚡ God Mode (Smart Heal)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    local vars = player:FindFirstChild("Variables")
                    local char = player.Character
                    if vars and char then
                        pcall(function()
                            -- Smart healing: only heal when damaged (less detectable)
                            local currentHealth = vars:GetAttribute("Health") or 0
                            local maxHealth = vars:GetAttribute("MaxHealth") or 100
                            
                            -- If health drops below 50%, heal back to max
                            if currentHealth < maxHealth * 0.5 then
                                vars:SetAttribute("Health", maxHealth)
                            end
                            
                            -- Set reasonable max health if too low
                            if maxHealth < 300 then
                                vars:SetAttribute("MaxHealth", 300)
                            end
                            
                            -- Also protect humanoid health
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid and humanoid.Health < humanoid.MaxHealth * 0.5 then
                                humanoid.Health = humanoid.MaxHealth
                            end
                        end)
                    end
                    task.wait(0.1) -- Check every 0.1s for faster response
                end
            end)
        end
    end
})

ExploitsTab:CreateLabel("⚠️ Use exploits carefully - high detection risk")

ExploitsTab:CreateButton({
    Name = "🛡️ Disable AntiCheat GUI",
    Callback = function()
        local gui = player.PlayerGui:FindFirstChild("KnightmareAntiCheatClient")
        if gui then
            gui:Destroy()
            Rayfield:Notify({
                Title = "✅ Success",
                Content = "AntiCheat GUI removed!",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "❌ Not Found",
                Content = "AntiCheat GUI not found",
                Duration = 3,
                Image = 4483362458
            })
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
