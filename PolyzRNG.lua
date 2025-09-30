-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- UI Window with Custom Theme
local Window = Rayfield:CreateWindow({
    Name = "FreezyyHub",
    LoadingTitle = "Launching FreezyyHub...",
    LoadingSubtitle = "powered by Rayfield",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyyHub",
        FileName = "Config"
    },
    Theme = {
        PrimaryColor = Color3.fromRGB(128, 0, 255), -- Purple
        SecondaryColor = Color3.fromRGB(30, 30, 30), -- Dark Gray
        AccentColor = Color3.fromRGB(200, 150, 255), -- Light Purple
        TextColor = Color3.fromRGB(255, 255, 255), -- White
        BackgroundColor = Color3.fromRGB(20, 20, 20), -- Near Black
        BorderColor = Color3.fromRGB(100, 0, 200) -- Dark Purple
    }
})

-- Get equipped weapon name
local function getEquippedWeaponName()
    local model = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild(player.Name)
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

-- Ultra-Optimized Auto Headshots (2x Faster & Maximum Efficiency)
local autoKill = false
local lastShotTime = 0
local shotsFired = 0
local cachedRemotes = {}
local cachedWeapon = nil
local weaponCacheTime = 0
local rayParams = RaycastParams.new()

CombatTab:CreateToggle({
    Name = "Auto Headshot Zombies",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                -- Initialize caches
                cachedRemotes.enemies = workspace:FindFirstChild("Enemies")
                cachedRemotes.shootRemote = Remotes:FindFirstChild("ShootEnemy")
                
                while autoKill do
                    local enemies = cachedRemotes.enemies
                    local shootRemote = cachedRemotes.shootRemote
                    local char = player.Character
                    
                    if enemies and shootRemote and char then
                        local primaryPart = char.PrimaryPart
                        if not primaryPart then
                            task.wait(0.05)
                            continue
                        end
                        
                        local humanoid = char.Humanoid
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(0.05)
                            continue
                        end
                        
                        -- Ultra-fast weapon caching (1s cache)
                        local currentTime = tick()
                        if not cachedWeapon or currentTime - weaponCacheTime > 1 then
                            cachedWeapon = getEquippedWeaponName()
                            weaponCacheTime = currentTime
                        end
                        
                        local playerPos = primaryPart.Position
                        local closestZombie = nil
                        local closestHead = nil
                        local minDistSq = 1000000 -- Use squared distance (faster than magnitude)
                        
                        -- Update raycast params
                        rayParams.FilterDescendantsInstances = {char}
                        
                        -- Lightning-fast zombie scanning
                        for _, zombie in pairs(enemies:GetChildren()) do
                            local head = zombie:FindFirstChild("Head")
                            if not head then continue end
                            
                            -- Squared distance (no square root = faster)
                            local delta = head.Position - playerPos
                            local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
                            
                            if distSq >= minDistSq then continue end
                            
                            -- Skip health check for max speed (assume alive if head exists)
                            -- Raycast with pre-computed direction
                            local rayResult = workspace:Raycast(playerPos, delta, rayParams)
                            
                            if rayResult and rayResult.Instance:IsDescendantOf(zombie) then
                                minDistSq = distSq
                                closestZombie = zombie
                                closestHead = head
                            end
                        end
                        
                        -- Instant fire (no cooldown check for max speed)
                        if closestZombie and closestHead then
                            local torso = closestZombie:FindFirstChild("Torso") or closestZombie:FindFirstChild("UpperTorso")
                            
                            if torso then
                                -- 98% headshot rate (less RNG overhead)
                                local targetPart = math.random() < 0.98 and closestHead or torso
                                
                                -- Minimal offset (faster calculation)
                                local offset = Vector3.new(
                                    (math.random(0, 20) - 10) * 0.1,
                                    (math.random(0, 20) - 10) * 0.1,
                                    (math.random(0, 20) - 10) * 0.1
                                )
                                
                                -- Fire immediately
                                shootRemote:FireServer(closestZombie, targetPart, targetPart.Position + offset, 2, cachedWeapon)
                                
                                shotsFired = shotsFired + 1
                                
                                -- Minimal pauses (only after long bursts)
                                if shotsFired >= math.random(10, 20) then
                                    task.wait(math.random(10, 25) * 0.01) -- 0.1-0.25s pause
                                    shotsFired = 0
                                end
                            end
                        end
                    else
                        -- Re-cache if missing
                        if not cachedRemotes.enemies then
                            cachedRemotes.enemies = workspace:FindFirstChild("Enemies")
                        end
                        if not cachedRemotes.shootRemote then
                            cachedRemotes.shootRemote = Remotes:FindFirstChild("ShootEnemy")
                        end
                    end
                    
                    -- Minimal delay (weapon-independent for speed)
                    task.wait(0.01) -- 10ms = 100 iterations/second
                end
            end)
        else
            -- Clear caches
            cachedRemotes = {}
            cachedWeapon = nil
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
                    task.wait(math.random(300, 700) / 100) -- 3-7s delay
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
                if (group:IsA("Folder") or group:IsA("Model")) and not group:FindFirstChild("Critical") and not group:GetAttribute("ServerProtected") then
                    pcall(function() group:Destroy() end)
                end
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Activate All Perks",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then return end
        local perks = {"Bandoiler_Perk", "DoubleUp_Perk", "Haste_Perk", "Tank_Perk"}
        for _, perk in ipairs(perks) do
            if vars:GetAttribute(perk) ~= nil then
                pcall(function() vars:SetAttribute(perk, true) end)
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Enhance Primary & Secondary",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then return end
        local enchants = {"Primary_Enhanced", "Secondary_Enhanced"}
        for _, attr in ipairs(enchants) do
            if vars:GetAttribute(attr) ~= nil then
                pcall(function() vars:SetAttribute(attr, true) end)
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Set Mag to 9999",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then return end
        local ammoAttributes = {"Primary_Mag", "Secondary_Mag"}
        for _, attr in ipairs(ammoAttributes) do
            if vars:GetAttribute(attr) ~= nil then
                pcall(function() vars:SetAttribute(attr, 9999) end)
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
                pcall(function() value.Value = "immortal" end)
            end
        end
    end
})

-- Crate Tab
local crateTab = Window:CreateTab("Crates", "Skull")

-- Auto Open Crates
local function createCrateToggle(name, flag, remoteName, invokeArg)
    local loop = false
    local invocations = 0
    crateTab:CreateToggle({
        Name = "Auto Open " .. name .. " Crates",
        CurrentValue = false,
        Flag = flag,
        Callback = function(state)
            loop = state
            if state then
                task.spawn(function()
                    while loop do
                        if invocations < 20 then -- Max 20 invocations per minute
                            local remote = Remotes:FindFirstChild(remoteName)
                            if remote then
                                pcall(function()
                                    remote:InvokeServer(invokeArg)
                                    invocations = invocations + 1
                                end)
                            end
                        end
                        task.wait(math.random(100, 300) / 100) -- 1-3s delay
                        if invocations >= 20 then
                            task.wait(60) -- Wait 1 minute before resetting
                            invocations = 0
                        end
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
