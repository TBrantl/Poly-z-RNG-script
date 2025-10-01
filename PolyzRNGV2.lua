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

-- Auto Headshots (Undetectable + Super Effective)
local autoKill = false
local autoBoss = false
local shootDelay = 0.12 -- Matches weapon fire rates (500-600 RPM)
local headshotAccuracy = 85
local cachedWeapon = nil
local weaponCacheTime = 0
local shotCount = 0
local lastShotTime = 0

-- Weapon fire rates (RPM to seconds)
local weaponFireRates = {
    ["AK47"] = 0.12, ["M4A1"] = 0.10, ["G36C"] = 0.086, ["AUG"] = 0.086,
    ["M16"] = 0.109, ["M4A1-S"] = 0.092, ["FAL"] = 0.133, ["Saint"] = 0.12,
    ["MAC10"] = 0.06, ["MP5"] = 0.075, ["M1911"] = 0.15, ["Glock"] = 0.12
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

local function getWeaponFireDelay(weaponName)
    -- Get weapon-specific fire rate or use default
    local baseDelay = weaponFireRates[weaponName] or 0.12
    -- Add slight jitter (±10%)
    return baseDelay + (math.random(-10, 10) * 0.001)
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
                        
                        -- Respect weapon fire rate cooldown
                        local timeSinceLastShot = currentTime - lastShotTime
                        local weaponDelay = getWeaponFireDelay(cachedWeapon)
                        
                        if timeSinceLastShot >= weaponDelay then
                            local zombieList = enemies:GetChildren()
                            
                            -- Find closest living zombie (more natural)
                            local closestZombie = nil
                            local closestDist = math.huge
                            local char = player.Character
                            
                            if char and char.PrimaryPart then
                                local playerPos = char.PrimaryPart.Position
                                
                                for _, zombie in pairs(zombieList) do
                                    if zombie:IsA("Model") then
                                        local head = zombie:FindFirstChild("Head")
                                        local humanoid = zombie:FindFirstChildOfClass("Humanoid")
                                        
                                        if head and humanoid and humanoid.Health > 0 then
                                            local dist = (head.Position - playerPos).Magnitude
                                            if dist < closestDist then
                                                closestDist = dist
                                                closestZombie = zombie
                                            end
                                        end
                                    end
                                end
                                
                                -- Shoot closest zombie
                                if closestZombie then
                                    local head = closestZombie:FindFirstChild("Head")
                                    local humanoid = closestZombie:FindFirstChildOfClass("Humanoid")
                                    
                                    if head and humanoid and humanoid.Health > 0 then
                                        -- Dynamic accuracy based on slider
                                        local targetPart = head
                                        if math.random(1, 100) > headshotAccuracy then
                                            targetPart = closestZombie:FindFirstChild("Torso") or closestZombie:FindFirstChild("UpperTorso") or head
                                        end
                                        
                                        -- Add human-like aim offset
                                        local targetPos = targetPart.Position + getRandomOffset()
                                        
                                        -- CORRECT PARAMETERS: 4th param must be 0!
                                        local args = {closestZombie, targetPart, targetPos, 0, cachedWeapon}
                                        pcall(function() shootRemote:FireServer(unpack(args)) end)
                                        
                                        lastShotTime = tick()
                                        
                                        -- Human-like break pattern
                                        if shouldTakeBreak() then
                                            task.wait(math.random(30, 80) * 0.01) -- 0.3-0.8s break
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Fast polling but respects fire rate
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
                        
                        -- Respect weapon fire rate cooldown
                        local timeSinceLastShot = currentTime - lastShotTime
                        local weaponDelay = getWeaponFireDelay(cachedWeapon)
                        
                        if timeSinceLastShot >= weaponDelay then
                            -- Super effective boss targeting
                            for _, enemy in pairs(enemies:GetChildren()) do
                                if enemy:IsA("Model") then
                                    local isBoss = false
                                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                                    
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
                                    
                                    if isBoss and humanoid and humanoid.Health > 0 then
                                        local head = enemy:FindFirstChild("Head")
                                        if head then
                                            -- Higher accuracy for bosses (90%)
                                            local targetPart = head
                                            if math.random(1, 100) > 90 then
                                                targetPart = enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso") or head
                                            end
                                            
                                            local targetPos = targetPart.Position + getRandomOffset()
                                            
                                            -- CORRECT PARAMETERS: 4th param must be 0!
                                            local args = {enemy, targetPart, targetPos, 0, cachedWeapon}
                                            pcall(function() shootRemote:FireServer(unpack(args)) end)
                                            
                                            lastShotTime = tick()
                                            
                                            -- Focus fire on boss (break after shots)
                                            if shouldTakeBreak() then
                                                task.wait(math.random(25, 60) * 0.01) -- 0.25-0.6s break
                                            end
                                            
                                            break -- Focus one boss at a time
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Fast polling but respects fire rate
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
