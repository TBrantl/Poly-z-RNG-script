-- Load Rayfield with reliable source
local Rayfield = nil
local success, result = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source/main.lua'))()
end)

if success and result then
    Rayfield = result
else
    -- Try alternative source
    local success2, result2 = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/itsyoboizkzl/Rayfield/main/source/main.lua'))()
    end)
    
    if success2 and result2 then
        Rayfield = result2
    else
        error("Failed to load Rayfield from all sources")
    end
end
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

-- Auto Headshots (Undetectable + Super Effective)
local autoKill = false
local autoBoss = false
local shootDelay = 0.08
local headshotAccuracy = 85
local cachedWeapon = nil
local weaponCacheTime = 0
local shotCount = 0
local lastBreakTime = tick()

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
    -- Every 15-30 shots, take a micro-break (human-like)
    if shotCount >= math.random(15, 30) then
        shotCount = 0
        return true
    end
    return false
end

local function getHumanizedDelay()
    -- Add random jitter to delay (0.08 base ± 0.03)
    return shootDelay + (math.random(-30, 30) * 0.001)
end

-- Stealth Settings
CombatTab:CreateInput({
    Name = "⏱️ Shot Delay (sec)",
    PlaceholderText = "0.08",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.01 and num <= 2 then
            shootDelay = num
            Rayfield:Notify({
                Title = "✅ Updated",
                Content = "Delay: "..num.."s",
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
                        
                        -- Super effective: Process in batches but with stealth
                        for i = 1, math.min(#zombieList, 3) do -- Max 3 per cycle
                            local zombie = zombieList[math.random(1, #zombieList)]
                            
                            if zombie and zombie:IsA("Model") then
                                local head = zombie:FindFirstChild("Head")
                                local humanoid = zombie:FindFirstChildOfClass("Humanoid")
                                
                                if head and humanoid and humanoid.Health > 0 then
                                    -- Dynamic accuracy based on slider
                                    local targetPart = head
                                    if math.random(1, 100) > headshotAccuracy then
                                        targetPart = zombie:FindFirstChild("Torso") or zombie:FindFirstChild("UpperTorso") or head
                                    end
                                    
                                    -- Add human-like aim offset
                                    local targetPos = targetPart.Position + getRandomOffset()
                                    
                                    local args = {zombie, targetPart, targetPos, math.random(45, 55) * 0.01, cachedWeapon}
                                    pcall(function() shootRemote:FireServer(unpack(args)) end)
                                    
                                    -- Human-like break pattern
                                    if shouldTakeBreak() then
                                        task.wait(math.random(20, 50) * 0.01) -- 0.2-0.5s break
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(getHumanizedDelay())
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
                                        
                                        local args = {enemy, targetPart, targetPos, math.random(45, 55) * 0.01, cachedWeapon}
                                        pcall(function() shootRemote:FireServer(unpack(args)) end)
                                        
                                        -- Focused fire on boss
                                        task.wait(shootDelay * 0.5) -- Faster for bosses
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(getHumanizedDelay())
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
