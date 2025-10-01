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

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
        task.wait(0.1)
    end
end)

-- Auto Headshots (Maximum Speed + Both Modes)
local autoKill = false
local autoBoss = false
local shootDelay = 0.06 -- MAC10 speed (fastest weapon)
local headshotAccuracy = 85
local cachedWeapon = nil
local weaponCacheTime = 0
local shotCount = 0
local lastShotTime = 0
local lastBossTime = 0

-- Weapon fire rates (RPM to seconds) - ALL SET TO FASTEST
local weaponFireRates = {
    ["AK47"] = 0.06, ["M4A1"] = 0.06, ["G36C"] = 0.06, ["AUG"] = 0.06,
    ["M16"] = 0.06, ["M4A1-S"] = 0.06, ["FAL"] = 0.06, ["Saint"] = 0.06,
    ["MAC10"] = 0.06, ["MP5"] = 0.06, ["M1911"] = 0.06, ["Glock"] = 0.06,
    ["Scar-H"] = 0.06, ["MP7"] = 0.06, ["UMP"] = 0.06, ["P90"] = 0.06
}

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
    -- Every 20-40 shots, take a micro-break (human-like)
    if shotCount >= math.random(20, 40) then
        shotCount = 0
        return true
    end
    return false
end

local function getWeaponFireDelay(weaponName, distance)
    -- PANIC MODE: Ultra fast if enemy is very close
    if distance and distance < 15 then
        return 0.03 -- Panic fire rate
    elseif distance and distance < 30 then
        return 0.05 -- Faster for nearby
    end
    
    -- Normal fire rate for distant enemies
    local baseDelay = weaponFireRates[weaponName] or 0.06
    -- Add slight jitter (±10%)
    return baseDelay + (math.random(-10, 10) * 0.001)
end

local function getDistancePriority(distance)
    -- Critical threat: < 15 studs
    if distance < 15 then return 1000 end
    -- High threat: 15-30 studs
    if distance < 30 then return 500 end
    -- Medium threat: 30-50 studs
    if distance < 50 then return 100 end
    -- Low threat: 50+ studs
    return 1
end

-- Stealth Settings
CombatTab:CreateInput({
    Name = "⏱️ Shot Delay (sec)",
    PlaceholderText = "0.12 (default)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.05 and num <= 2 then
            shootDelay = num
            Rayfield:Notify({
                Title = "✅ Updated",
                Content = "Delay: "..num.."s",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "⚠️ Invalid",
                Content = "Use 0.05-2 seconds",
                Duration = 2,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Headshot Accuracy %",
    Range = {50, 95},
    Increment = 5,
    CurrentValue = 85,
    Flag = "HeadshotAccuracy",
    Callback = function(value)
        headshotAccuracy = value
    end,
})

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
                            
                            -- Shoot high priority targets
                            for _, target in ipairs(priorityTargets) do
                                local timeSinceLastShot = tick() - lastShotTime
                                local weaponDelay = getWeaponFireDelay(cachedWeapon, target.distance)
                                
                                if timeSinceLastShot >= weaponDelay then
                                    -- Dynamic accuracy based on distance and slider
                                    local accuracyBonus = target.distance < 30 and 10 or 0 -- Better accuracy when close
                                    local targetPart = target.head
                                    if math.random(1, 100) > (headshotAccuracy + accuracyBonus) then
                                        targetPart = target.zombie:FindFirstChild("Torso") or target.zombie:FindFirstChild("UpperTorso") or target.head
                                    end
                                    
                                    -- Add human-like aim offset (less offset when close)
                                    local offsetMultiplier = target.distance < 20 and 0.5 or 1
                                    local targetPos = targetPart.Position + (getRandomOffset() * offsetMultiplier)
                                    
                                    -- CORRECT PARAMETERS: 4th param must be 0!
                                    local args = {target.zombie, targetPart, targetPos, 0, cachedWeapon}
                                    pcall(function() shootRemote:FireServer(unpack(args)) end)
                                    
                                    lastShotTime = tick()
                                    
                                    -- Only break if not in panic mode
                                    if target.distance > 30 and shouldTakeBreak() then
                                        task.wait(math.random(15, 40) * 0.01)
                                    end
                                    
                                    -- In panic mode, shoot multiple close targets rapidly
                                    if target.distance < 15 then
                                        continue -- Keep shooting close ones without delay
                                    else
                                        break -- Only shoot one distant target per cycle
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Minimal polling delay
                    task.wait(0.01)
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
                            
                            -- Shoot closest boss with distance-based fire rate
                            if closestBoss then
                                local timeSinceLastBoss = tick() - lastBossTime
                                local weaponDelay = getWeaponFireDelay(cachedWeapon, closestBoss.distance)
                                
                                if timeSinceLastBoss >= weaponDelay then
                                    -- Higher accuracy for bosses (98% base + bonus when close)
                                    local accuracyBonus = closestBoss.distance < 30 and 2 or 0
                                    local targetPart = closestBoss.head
                                    if math.random(1, 100) > (98 + accuracyBonus) then
                                        targetPart = closestBoss.enemy:FindFirstChild("Torso") or closestBoss.enemy:FindFirstChild("UpperTorso") or closestBoss.head
                                    end
                                    
                                    -- Less offset for bosses (more precise)
                                    local offsetMultiplier = closestBoss.distance < 20 and 0.3 or 0.5
                                    local targetPos = targetPart.Position + (getRandomOffset() * offsetMultiplier)
                                    
                                    -- CORRECT PARAMETERS: 4th param must be 0!
                                    local args = {closestBoss.enemy, targetPart, targetPos, 0, cachedWeapon}
                                    pcall(function() shootRemote:FireServer(unpack(args)) end)
                                    
                                    lastBossTime = tick()
                                end
                            end
                        end
                    end
                    
                    -- Minimal polling delay
                    task.wait(0.01)
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

ExploitsTab:CreateButton({
    Name = "💰 Max Health (9999)",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if vars then
            pcall(function() 
                vars:SetAttribute("Health", 9999)
                vars:SetAttribute("MaxHealth", 9999)
            end)
            Rayfield:Notify({
                Title = "✅ Health Maxed",
                Content = "Health set to 9999!",
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

ExploitsTab:CreateSlider({
    Name = "🏃 WalkSpeed",
    Range = {16, 200},
    Increment = 2,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

ExploitsTab:CreateSlider({
    Name = "🦘 JumpPower",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end,
})

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
    Name = "⚡ God Mode (Auto Heal)",
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
                            -- Keep health maxed
                            vars:SetAttribute("Health", 9999)
                            vars:SetAttribute("MaxHealth", 9999)
                            
                            -- Also set humanoid health if available
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.Health = humanoid.MaxHealth
                            end
                        end)
                    end
                    task.wait(0.05) -- Update very frequently
                end
            end)
        end
    end
})

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
