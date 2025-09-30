### Script Quality Review Update

Based on the provided versions, I've reviewed both scripts. The first version (with the invalid theme keys) likely works because Rayfield falls back to a default theme when the custom table is unrecognized or invalid. The second version uses a valid custom theme structure (as per Rayfield documentation as of 2025), but given the release of Rayfield Gen2 in early 2025, there may be compatibility issues with certain custom theme keys or the library version loaded from the URL. Additionally, Rayfield Gen2 introduces "Super Themes," which could alter how custom themes are processed.

To address potential issues:
- **Theme Compatibility**: Switch to a predefined theme like "Amethyst" (purple-toned, matching your original intent) to avoid any custom table problems in Gen2.
- **Memory Leak Fix**: Updated the camera unlock toggle to store and disconnect input connections, preventing leaks.
- **Nil Safety**: Moved weapon declaration in the auto-headshot loop to avoid potential nil references (though Luau handles it as nil, this ensures robustness).
- **Other Improvements**: Kept the rest as-is, but if the menu still doesn't appear, it's likely due to a saved configuration hiding the UI. Delete the config file in your executor's workspace (e.g., `workspace/FreezyyHub/Config.json` or similar). Also, press `K` in-game to toggle visibility after loading.
- **Overall Quality Score**: Still 8/10; with these fixes, it's more reliable.

If console prints (e.g., "FreezyyHub: Initializing UI") appear but the menu doesn't, check for Lua errors in your executor console. If no prints, the loadstring may be failing—try a different executor.

Here's the updated script as `FreezyyHub.lua`:

```lua
-- FreezyyHub.lua
-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Debug: Confirm script start
print("FreezyyHub: Initializing UI")

-- UI Window with Predefined Theme (to avoid custom theme issues in Gen2)
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
    Theme = "Amethyst"  -- Predefined purple theme; fallback if custom fails
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
print("FreezyyHub: Combat Tab created")

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

-- Auto Headshots (kills zombies and bosses, bypasses detection)
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
                    local weapon = "M1911"  -- Default to avoid nil
                    if enemies and shootRemote and player.Character and player.Character.PrimaryPart and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
                        weapon = getEquippedWeaponName()
                        local playerPos = player.Character.PrimaryPart.Position
                        for _, enemy in pairs(enemies:GetChildren()) do
                            if enemy:IsA("Model") then
                                local humanoid = enemy:FindFirstChild("Humanoid")
                                local head = enemy:FindFirstChild("Head")
                                local torso = enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
                                if humanoid and humanoid.Health > 0 and head and torso then
                                    local dist = (head.Position - playerPos).Magnitude
                                    if dist < 100 then -- Max range 100 studs
                                        -- 360-degree LOS check
                                        local rayParams = RaycastParams.new()
                                        rayParams.FilterDescendantsInstances = {player.Character}
                                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                        local rayResult = workspace:Raycast(playerPos, (head.Position - playerPos).Unit * dist, rayParams)
                                        if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(enemy) then
                                            if tick() - lastShotTime >= math.max(0.5 / speedMultiplier, 0.05) then
                                                local isHeadshot = math.random() < 0.9 -- 90% headshots
                                                local targetPart = isHeadshot and head or torso
                                                local offset = Vector3.new(
                                                    math.random(-10, 10) / 10, -- ±1 stud offset
                                                    math.random(-10, 10) / 10,
                                                    math.random(-10, 10) / 10
                                                )
                                                local args = {enemy, targetPart, targetPart.Position + offset, 2, weapon}
                                                pcall(function()
                                                    shootRemote:FireServer(unpack(args))
                                                end)
                                                lastShotTime = tick()
                                                shotsFired = shotsFired + 1
                                                -- Random pause to simulate reloading
                                                if shotsFired >= math.random(5, 10) then
                                                    task.wait(math.random(100, 200) / 100) -- 1-2s pause
                                                    shotsFired = 0
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    -- Fire delay adjusted by multiplier
                    local baseDelay = weapon == "M1911" and math.random(25, 70) / 100 or math.random(20, 50) / 100
                    local fireDelay = math.max(baseDelay / speedMultiplier, 0.05)
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
print("FreezyyHub: Misc Tab created")

-- Camera Unlock Toggle with Click-and-Drag (fixed memory leak)
local cameraUnlocked = false
local cameraLoop
local inputBeganConnection
local inputEndedConnection
MiscTab:CreateToggle({
    Name = "Unlock Camera to 3rd Person Mode",
    CurrentValue = false,
    Flag = "CameraUnlock",
    Callback = function(state)
        print("FreezyyHub: Camera Unlock Toggle set to " .. tostring(state))
        cameraUnlocked = state
        if state then
            cameraLoop = task.spawn(function()
                while cameraUnlocked and player and player:IsDescendantOf(Players) do
                    if player.Character and player.Character.Humanoid and player.Character.Humanoid.Health > 0 then
                        player.CameraMode = Enum.CameraMode.Classic
                        player.CameraMinZoomDistance = 0.5
                        player.CameraMaxZoomDistance = 10 -- Adjustable zoom
                        player.DevEnableMouseLock = true -- Enable click-and-drag rotation
                    end
                    task.wait(0.1) -- Counter game overrides
                end
            end)
            -- Monitor mouse input for click-and-drag
            inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if cameraUnlocked and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        print("FreezyyHub: Mouse button held for rotation")
                    end
                end
            end)
            inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
                if cameraUnlocked then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        print("FreezyyHub: Mouse button released")
                    end
                end
            end)
        else
            if cameraLoop then
                task.cancel(cameraLoop)
                cameraLoop = nil
            end
            if inputBeganConnection then
                inputBeganConnection:Disconnect()
                inputBeganConnection = nil
            end
            if inputEndedConnection then
                inputEndedConnection:Disconnect()
                inputEndedConnection = nil
            end
            player.CameraMode = Enum.CameraMode.LockFirstPerson
            player.CameraMinZoomDistance = 0
            player.CameraMaxZoomDistance = 0
            player.DevEnableMouseLock = false -- Disable rotation
        end
    end
})
print("FreezyyHub: Camera Unlock Toggle created")

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
            if vars:GetAttribute(perk) != nil then
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
            if vars:GetAttribute(attr) != nil then
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
            if vars:GetAttribute(attr) != nil then
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
print("FreezyyHub: Crates Tab created")

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
print("FreezyyHub: Configuration loaded")
```
