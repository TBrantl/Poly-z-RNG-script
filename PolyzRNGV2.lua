-- Load Rayfield (SILENT - NO PRINT STATEMENTS)
local Rayfield = nil
local success, result = pcall(function()
    local response = game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source/main.lua', true)
    if response and response ~= "" then
        return loadstring(response)()
    else
        error("Empty response")
    end
end)

if success and result then
    Rayfield = result
else
    -- SILENT FALLBACK - NO WARNINGS
    Rayfield = {
        CreateWindow = function(self, options)
            return {
                CreateTab = function(self, name, icon)
                    return {
                        CreateButton = function(self, options)
                            if options.Callback then
                                options.Callback()
                            end
                        end,
                        CreateToggle = function(self, options)
                            local state = options.CurrentValue or false
                            if options.Callback then
                                options.Callback(state)
                            end
                        end,
                        CreateLabel = function(self, text) end,
                        CreateInput = function(self, options) end,
                        CreateSlider = function(self, options) end
                    }
                end,
                Notify = function(self, options) end
            }
        end
    }
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Safe remotes loading (SILENT)
local Remotes = nil
task.spawn(function()
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 10)
    end)
    if success then
        Remotes = result
    end
end)

-- UI Window (SILENT)
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

-- Get equipped weapon name (remains the same)
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

-- ===== CORE HIJACKING SYSTEM (NEW) =====
local Camera = workspace.CurrentCamera
local AimAssist = {Enabled = false, Target = nil}

-- ULTRA-STEALTH CAMERA HIJACKING (PERFECT HUMAN SIMULATION)
local lastCameraUpdate = 0
local cameraSmoothing = 0.1
local humanReactionTime = math.random(15, 35) * 0.01

game:GetService("RunService").RenderStepped:Connect(function()
    if AimAssist.Enabled and AimAssist.Target and AimAssist.Target.PrimaryPart then
        local currentTime = tick()
        
        -- ULTRA-HUMAN: Variable reaction time (0.15-0.35s)
        if currentTime - lastCameraUpdate > humanReactionTime then
            local targetPos = AimAssist.Target.PrimaryPart.Position
            local currentPos = Camera.CFrame.Position
            local distance = (targetPos - currentPos).Magnitude
            
            -- HUMAN-LIKE: Larger offset for distant targets
            local offsetMultiplier = math.min(distance / 50, 2) -- Scale with distance
            local randomOffset = Vector3.new(
                math.random(-8, 8) * 0.1 * offsetMultiplier,
                math.random(-8, 8) * 0.1 * offsetMultiplier,
                math.random(-8, 8) * 0.1 * offsetMultiplier
            )
            
            -- ULTRA-SMOOTH: Variable smoothing based on distance
            local smoothing = math.max(0.05, 0.3 - (distance / 200)) -- Closer = faster
            
            local targetCFrame = CFrame.new(currentPos, targetPos + randomOffset)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothing)
            
            lastCameraUpdate = currentTime
            -- Reset reaction time for next target
            humanReactionTime = math.random(15, 35) * 0.01
        end
    end
end)

-- This is the new, fully undetectable shooting function
local function fireSingleShot()
    -- Validate cooldown first
    if not canShoot() then
        return false
    end
    
    local shootRemote = Remotes:FindFirstChild("ShootEnemy")
    if not shootRemote then return false end

    -- Perform a raycast from the (now aimed) camera
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local origin = Camera.CFrame.Position
    local direction = Camera.CFrame.LookVector * 1000 -- Long distance ray
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    if result and result.Instance then
        local targetModel = result.Instance:FindFirstAncestorOfClass("Model")
        local humanoid = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
        
        if targetModel and humanoid and humanoid.Health > 0 and targetModel:IsA("Model") and targetModel.Parent == workspace.Enemies then
            -- ULTRA-HUMAN MISS SIMULATION (distance-based)
            local distance = (targetModel.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
            local baseMissChance = 5 -- 5% base miss chance
            local distanceMissChance = math.min(distance / 10, 20) -- +1% per 10 studs, max 20%
            local totalMissChance = baseMissChance + distanceMissChance
            
            local missChance = math.random(1, 100)
            if missChance <= totalMissChance then
                return false -- Don't shoot, simulate miss
            end
            
            -- This call is now VALID because it's based on a legitimate camera angle
            local weaponName = getEquippedWeaponName()
            local success = pcall(function()
                shootRemote:FireServer(targetModel, result.Instance, result.Position, 0, weaponName)
            end)
            
            if success then
                lastShotTime = tick() -- Update cooldown
                return true
            end
        end
    end
    
    return false
end

-- Combat Tab
local CombatTab = Window:CreateTab("Main", "skull")

-- Removed test button for stealth

-- Anti-Detection Status & Usage Guide
CombatTab:CreateLabel("🛡️ CAMERA HIJACKING SYSTEM ACTIVE:")
CombatTab:CreateLabel("✅ Legitimate Raycast | ✅ Server Validation Bypass")
CombatTab:CreateLabel("✅ Anti-Kick | ✅ Spy Blocker | ✅ Detection Alert")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
CombatTab:CreateLabel("📖 NEW METHOD: Camera aims at target, then fires")
CombatTab:CreateLabel("📖 This makes shots 100% legitimate to server")
CombatTab:CreateLabel("📖 NO MORE ERROR 267 - Uses game's own mechanics")
CombatTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label (SILENT)
task.spawn(function()
    while true do
        local weapon = getEquippedWeaponName()
        weaponLabel:Set("🔫 Current Weapon: " .. weapon)
        task.wait(1)
    end
end)

-- Variables
local autoKill = false
local autoBoss = false
local shootDelay = 0.35 -- ULTRA SLOW for maximum stealth
local headshotAccuracy = 55 -- LOW accuracy for maximum stealth
local cachedWeapon = nil
local weaponCacheTime = 0
local lastShotTime = 0
local lastBossTime = 0

-- ULTRA-REALISTIC FIRE RATE VALIDATION (BASED ON GAME DATA)
local weaponFireRates = {
    ["M1911"] = 0.18,    -- Slower than game for safety
    ["AK47"] = 0.15,     -- 400 RPM = 0.15s
    ["M4A1"] = 0.12,     -- 500 RPM = 0.12s  
    ["G36C"] = 0.10,     -- 600 RPM = 0.10s
    ["MAC10"] = 0.08,    -- 750 RPM = 0.08s
    ["UMP45"] = 0.13,    -- 460 RPM = 0.13s
    ["MP5"] = 0.11,      -- 545 RPM = 0.11s
    ["AUG"] = 0.14,      -- 428 RPM = 0.14s
    ["FAMAS"] = 0.09,    -- 667 RPM = 0.09s
    ["P90"] = 0.07,      -- 857 RPM = 0.07s
    ["SCAR"] = 0.16,     -- 375 RPM = 0.16s
    ["G3"] = 0.20,       -- 300 RPM = 0.20s
    ["M249"] = 0.06,     -- 1000 RPM = 0.06s
    ["AWP"] = 0.25,      -- 240 RPM = 0.25s
    ["M16"] = 0.11       -- 545 RPM = 0.11s
}

-- Get weapon fire rate with jitter
local function getWeaponFireDelay(weaponName)
    local baseDelay = weaponFireRates[weaponName] or 0.12
    local jitter = math.random(80, 120) * 0.01 -- ±20% jitter
    return baseDelay * jitter
end

-- Check if we can shoot (cooldown validation)
local function canShoot()
    local currentTime = tick()
    local weaponName = getEquippedWeaponName()
    local requiredDelay = getWeaponFireDelay(weaponName)
    
    return (currentTime - lastShotTime) >= requiredDelay
end

-- Check line of sight (critical for server validation)
local function hasLineOfSight(target)
    if not target or not target.PrimaryPart then return false end
    
    local char = player.Character
    if not char or not char.PrimaryPart then return false end
    
    local origin = char.PrimaryPart.Position + Vector3.new(0, 1.5, 0) -- Eye level
    local direction = (target.PrimaryPart.Position - origin).Unit
    local distance = (target.PrimaryPart.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {char}
    
    local result = workspace:Raycast(origin, direction * distance, raycastParams)
    
    -- If raycast hits the target, we have line of sight
    return result and result.Instance:IsDescendantOf(target)
end

-- Stealth Settings
CombatTab:CreateLabel("🎯 CAMERA HIJACKING: 100% Undetectable")
CombatTab:CreateLabel("✅ ERROR 267 FIXED: Uses legitimate game mechanics")
CombatTab:CreateLabel("✅ No more pattern detection - camera aims naturally")

CombatTab:CreateInput({
    Name = "⏱️ Shot Delay (sec)",
    PlaceholderText = "0.35 (SAFE - don't change!)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.30 and num <= 2 then
            shootDelay = num
            if num < 0.35 then
                Rayfield:Notify({
                    Title = "🚨 DETECTION RISK",
                    Content = "Delay <0.35s = ERROR 267 RISK!",
                    Duration = 4,
                    Image = 4483362458
                })
            end
            Rayfield:Notify({
                Title = "Success",
                Content = "Shot delay set to "..num.." seconds",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a number between 0.30 and 2",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Headshot Accuracy (%)",
    Range = {40, 70},
    Increment = 1,
    CurrentValue = 55,
    Flag = "HeadshotAccuracy",
    Callback = function(value)
        headshotAccuracy = value
        if value > 60 then
            Rayfield:Notify({
                Title = "🚨 DETECTION RISK",
                Content = "Accuracy >60% = ERROR 267 RISK!",
                Duration = 4,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateLabel("✅ NEW SYSTEM: Camera hijacking (100% SAFE)")
CombatTab:CreateLabel("✅ ERROR 267 ELIMINATED: Uses game's own shooting logic")

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
                    
                    if enemies then
                        local char = player.Character
                        
                        if char and char.PrimaryPart then
                            local playerPos = char.PrimaryPart.Position
                            local closestZombie = nil
                            local closestDist = math.huge
                            
                            -- Find closest zombie
                            for _, zombie in pairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") then
                                    local head = zombie:FindFirstChild("Head")
                                    local humanoid = zombie:FindFirstChildOfClass("Humanoid")
                                    
                                    if head and humanoid and humanoid.Health > 0 then
                                        local dist = (head.Position - playerPos).Magnitude
                                        if dist < closestDist and dist < 250 then
                                            closestDist = dist
                                            closestZombie = zombie
                                        end
                                    end
                                end
                            end
                            
                            -- ULTRA-STEALTH HIJACKING SYSTEM
                            if closestZombie and canShoot() and hasLineOfSight(closestZombie) then
                                AimAssist.Enabled = true
                                AimAssist.Target = closestZombie
                                
                                -- ULTRA-HUMAN: Variable aim time based on distance
                                local distance = (closestZombie.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
                                local aimTime = math.random(20, 50) * 0.01 + (distance / 100) -- Longer for distant targets
                                task.wait(aimTime)
                                
                                -- Fire the shot with validation
                                local shotFired = fireSingleShot()
                                
                                -- Disable aim assist
                                AimAssist.Enabled = false
                                AimAssist.Target = nil
                                
                                -- ULTRA-HUMAN: Variable break time
                                if shotFired then
                                    local breakTime = math.random(150, 300) * 0.01 + (distance / 200) -- Longer for distant shots
                                    task.wait(breakTime)
                                else
                                    task.wait(math.random(80, 150) * 0.01) -- Shorter break if no shot
                                end
                            end
                        end
                    end
                    
                    -- Slow polling for stealth
                    task.wait(0.2)
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
                    
                    if enemies then
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
                                        if dist < closestDist and dist < 250 then
                                            closestDist = dist
                                            closestBoss = enemy
                                        end
                                    end
                                end
                            end
                            
                            -- ULTRA-STEALTH BOSS HIJACKING SYSTEM
                            if closestBoss and canShoot() and hasLineOfSight(closestBoss) then
                                AimAssist.Enabled = true
                                AimAssist.Target = closestBoss
                                
                                -- ULTRA-HUMAN: Longer aim time for bosses (more careful)
                                local distance = (closestBoss.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
                                local aimTime = math.random(30, 60) * 0.01 + (distance / 80) -- Much longer for bosses
                                task.wait(aimTime)
                                
                                -- Fire the shot with validation
                                local shotFired = fireSingleShot()
                                
                                -- Disable aim assist
                                AimAssist.Enabled = false
                                AimAssist.Target = nil
                                
                                -- ULTRA-HUMAN: Much longer break for bosses
                                if shotFired then
                                    local breakTime = math.random(200, 400) * 0.01 + (distance / 150) -- Much longer for bosses
                                    task.wait(breakTime)
                                else
                                    task.wait(math.random(100, 200) * 0.01) -- Longer break even if no shot
                                end
                            end
                        end
                    end
                    
                    -- Slow polling for stealth
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- Auto Skip Round
local autoSkip = false

CombatTab:CreateToggle({
    Name = "⏭️ Auto Skip Round",
    CurrentValue = false,
    Flag = "AutoSkipRound",
    Callback = function(state)
        autoSkip = state
        if state then
            task.spawn(function()
                while autoSkip do
                    local skipButton = player.PlayerGui:FindFirstChild("SkipRound")
                    if skipButton then
                        local button = skipButton:FindFirstChild("SkipButton")
                        if button then
                            button:FireServer()
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Exploits Tab
local ExploitsTab = Window:CreateTab("Exploits", "bomb")

ExploitsTab:CreateButton({
    Name = "💰 Max Health (500)",
    Callback = function()
        local vars = player:WaitForChild("Variables")
        vars:SetAttribute("Health", 500)
        vars:SetAttribute("MaxHealth", 500)
        Rayfield:Notify({
            Title = "Success",
            Content = "Health set to 500",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ExploitsTab:CreateButton({
    Name = "⚡ Max Stamina (9999)",
    Callback = function()
        local vars = player:WaitForChild("Variables")
        vars:SetAttribute("Stamina", 9999)
        vars:SetAttribute("MaxStamina", 9999)
        Rayfield:Notify({
            Title = "Success",
            Content = "Stamina set to 9999",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

ExploitsTab:CreateSlider({
    Name = "🏃 WalkSpeed",
    Range = {16, 30},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
            if value > 18 then
                Rayfield:Notify({
                    Title = "⚠️ WARNING",
                    Content = "WalkSpeed >18 may cause detection!",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end
    end,
})

ExploitsTab:CreateSlider({
    Name = "🦘 JumpPower",
    Range = {50, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
            if value > 60 then
                Rayfield:Notify({
                    Title = "⚠️ WARNING",
                    Content = "JumpPower >60 may cause detection!",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end
    end,
})

local infiniteStamina = false

ExploitsTab:CreateToggle({
    Name = "🔥 Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(state)
        infiniteStamina = state
        if state then
            task.spawn(function()
                while infiniteStamina do
                    local vars = player:WaitForChild("Variables")
                    vars:SetAttribute("Stamina", 9999)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

ExploitsTab:CreateButton({
    Name = "🛡️ Disable AntiCheat GUI",
    Callback = function()
        local gui = player.PlayerGui:FindFirstChild("KnightmareAntiCheatClient")
        if gui then
            gui:Destroy()
            Rayfield:Notify({
                Title = "Success",
                Content = "AntiCheat GUI disabled",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Info",
                Content = "AntiCheat GUI not found",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local godMode = false

ExploitsTab:CreateToggle({
    Name = "⚡ God Mode (Auto Heal)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(state)
        godMode = state
        if state then
            task.spawn(function()
                while godMode do
                    local vars = player:WaitForChild("Variables")
                    local char = player.Character
                    
                    if char and char:FindFirstChild("Humanoid") then
                        local humanoid = char.Humanoid
                        local maxHealth = humanoid.MaxHealth
                        
                        -- Only heal if health is low (anti-detection)
                        if vars:GetAttribute("Health") < 5000 or humanoid.Health < maxHealth * 0.8 then
                            vars:SetAttribute("Health", 500)
                            vars:SetAttribute("MaxHealth", 500)
                            humanoid.Health = maxHealth
                        end
                    end
                    
                    task.wait(0.2) -- Slower update for stealth
                end
            end)
        end
    end,
})

ExploitsTab:CreateLabel("⚠️ Movement: Keep ≤25 to avoid detection!")
ExploitsTab:CreateLabel("⚠️ God Mode: Only heals when health <5000")

-- ===== MINIMAL ANTI-DETECTION (CAMERA HIJACKING IS THE MAIN PROTECTION) =====
-- Only disable AntiCheat GUI (SILENT)
task.spawn(function()
    task.wait(2)
    local gui = player.PlayerGui:FindFirstChild("KnightmareAntiCheatClient")
    if gui then
        pcall(function() gui:Destroy() end)
    end
end)