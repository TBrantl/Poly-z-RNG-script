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

-- Auto Headshots
-- Auto Headshots
local autoKill = false
CombatTab:CreateToggle({
    Name = "Auto Headshot Zombies",
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
                        local weapon = getEquippedWeaponName()
                        local playerPos = player.Character and player.Character.PrimaryPart.Position  -- Get player position for distance check
                        local closestZombie = nil
                        local minDist = math.huge

                        -- Find the closest zombie instead of all (less suspicious)
                        for _, zombie in pairs(enemies:GetChildren()) do
                            if zombie:IsA("Model") then
                                local humanoid = zombie:FindFirstChild("Humanoid")
                                local head = zombie:FindFirstChild("Head")
                                if humanoid and humanoid.Health > 0 and head and playerPos then
                                    local dist = (head.Position - playerPos).Magnitude
                                    if dist < minDist and dist < 100 then  -- Arbitrary range limit (adjust as needed)
                                        minDist = dist
                                        closestZombie = zombie
                                    end
                                end
                            end
                        end

                        -- Only shoot if a valid target found
                        if closestZombie then
                            local head = closestZombie:FindFirstChild("Head")
                            local args = {closestZombie, head, head.Position, 2, weapon}
                            pcall(function()
                                shootRemote:FireServer(unpack(args))
                            end)
                        end
                    end
                    -- Random delay to mimic human reaction time (0.2-0.5s)
                    task.wait(math.random(20, 50) / 100)
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
    Name = "Activate All Perks",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then return end

        local perks = {
            "Bandoiler_Perk",
            "DoubleUp_Perk",
            "Haste_Perk",
            "Tank_Perk"
        }

        for _, perk in ipairs(perks) do
            if vars:GetAttribute(perk) ~= nil then
                vars:SetAttribute(perk, true)
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Enhance Primary & Secondary",
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
