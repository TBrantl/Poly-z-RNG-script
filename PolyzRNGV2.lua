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

-- Speed Multiplier Slider
local speedMultiplier = 1 -- Default 1x
CombatTab:CreateSlider({
    Name = "Auto Headshot Speed Multiplier",
    Range = {1, 3},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "HeadshotSpeed",
    Callback = function(value)
        speedMultiplier = value
    end
})

-- Auto Headshots with 360-Degree LOS (Stealthy, Powerful, Works on Bosses)
local autoKill = false
local lastShotTime = 0
local shotsFired = 0
CombatTab:CreateToggle({
    Name = "Auto Headshot Zombies & Bosses",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                while autoKill do
                    local enemies = workspace:FindFirstChild("Enemies")
                    local shootRemote = Remotes:FindFirstChild("ShootEnemy")
                    if enemies and shootRemote and player.Character and player.Character.PrimaryPart and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
                        local weapon = getEquippedWeaponName()
                        local playerPos = player.Character.PrimaryPart.Position
                        local closestEnemy = nil
                        local minDist = math.huge

                        -- Scan all enemies (zombies and bosses) in 360 degrees
                        for _, enemy in pairs(enemies:GetChildren()) do
                            if enemy:IsA("Model") then
                                local humanoid = enemy:FindFirstChild("Humanoid")
                                local head = enemy:FindFirstChild("Head")
                                local torso = enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
                                if humanoid and humanoid.Health > 0 and head and torso then
                                    local dist = (head.Position - playerPos).Magnitude
                                    if dist < minDist and dist < 100 then -- Max range 100 studs
                                        -- 360-degree LOS check using raycast
                                        local rayParams = RaycastParams.new()
                                        rayParams.FilterDescendantsInstances = {player.Character}
                                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                        local rayResult = workspace:Raycast(playerPos, (head.Position - playerPos).Unit * dist, rayParams)
                                        if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(enemy) then
                                            minDist = dist
                                            closestEnemy = enemy
                                        end
                                    end
                                end
                            end
                        end

                        -- Fire at closest enemy with randomized behavior
                        if closestEnemy and tick() - lastShotTime >= math.max(0.5 / speedMultiplier, 0.05) then -- Global cooldown adjusted by multiplier
                            local head = closestEnemy:FindFirstChild("Head")
                            local torso = closestEnemy:FindFirstChild("Torso") or closestEnemy:FindFirstChild("UpperTorso")
                            local isHeadshot = math.random() < 0.9 -- 90% headshots, 10% body shots
                            local targetPart = isHeadshot and head or torso
                            local offset = Vector3.new(
                                math.random(-10, 10) / 10, -- ±1 stud offset
                                math.random(-10, 10) / 10,
                                math.random(-10, 10) / 10
                            )
                            local args = {closestEnemy, targetPart, targetPart.Position + offset, 2, weapon}
                            pcall(function()
                                shootRemote:FireServer(unpack(args))
                            end)
                            lastShotTime = tick()
                            shotsFired = shotsFired + 1

                            -- Random pause to simulate reloading/repositioning
                            if shotsFired >= math.random(5, 10) then
                                task.wait(math.random(100, 200) / 100) -- 1-2s pause
                                shotsFired = 0
                            end
                        end
                    end
                    -- Weapon-specific fire delay, adjusted by multiplier
                    local baseDelay = weapon == "M1911" and math.random(25, 70) / 100 or math.random(20, 50) / 100
                    local fireDelay = math.max(baseDelay / speedMultiplier, 0.05) -- Minimum 0.05s
                    task.wait(fireDelay)
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
                        pcall(function() shootRemote:FireServer() end)
                    end
                    task.wait(math.random(300, 700) / 100) -- 3-7s delay
                end
            end)
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", "skull")

-- Camera Unlock Toggle
local cameraUnlocked = false
MiscTab:CreateToggle({
    Name = "Unlock Camera to 3rd Person Mode",
    CurrentValue = false,
    Flag = "CameraUnlock",
    Callback = function(state)
        cameraUnlocked = state
        if state then
            task.spawn(function()
                while cameraUnlocked and player and player:IsDescendantOf(Players) do
                    if player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
                        player.CameraMode = Enum.CameraMode.Classic
                        player.CameraMinZoomDistance = 0.5
                        player.CameraMaxZoomDistance = 10 -- Adjustable zoom for third-person
                    end
                    task.wait(0.1) -- Check frequently to counter game overrides
                end
            end)
        else
            player.CameraMode = Enum.CameraMode.LockFirstPerson
            player.CameraMinZoomDistance = 0
            player.CameraMaxZoomDistance = 0
        end
    end
})

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
    Name = "Set Mag to 1 Million",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then return end
        local ammoAttributes = {"Primary_Mag", "Secondary_Mag"}
        for _, attr in ipairs(ammoAttributes) do
            if vars:GetAttribute(attr) ~= nil then
                pcall(function() vars:SetAttribute(attr, 100000000) end)
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
                        task.wait(0.1) -- Match provided script
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
