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
        TextColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(20, 20, 20),
        Topbar = Color3.fromRGB(30, 30, 30),
        Shadow = Color3.fromRGB(0, 0, 0),
        NotificationBackground = Color3.fromRGB(30, 30, 30),
        NotificationActionsBackground = Color3.fromRGB(30, 30, 30),
        TabBackground = Color3.fromRGB(30, 30, 30),
        TabStroke = Color3.fromRGB(100, 0, 200),
        TabBackgroundSelected = Color3.fromRGB(128, 0, 255),
        TabTextColor = Color3.fromRGB(255, 255, 255),
        SelectedTabTextColor = Color3.fromRGB(200, 150, 255),
        ElementBackground = Color3.fromRGB(30, 30, 30),
        ElementBackgroundHover = Color3.fromRGB(50, 50, 50),
        SecondaryElementBackground = Color3.fromRGB(30, 30, 30),
        ElementStroke = Color3.fromRGB(100, 0, 200),
        SecondaryElementStroke = Color3.fromRGB(100, 0, 200),
        SliderBackground = Color3.fromRGB(30, 30, 30),
        SliderProgress = Color3.fromRGB(128, 0, 255),
        SliderStroke = Color3.fromRGB(100, 0, 200),
        ToggleBackground = Color3.fromRGB(30, 30, 30),
        ToggleEnabled = Color3.fromRGB(128, 0, 255),
        ToggleDisabled = Color3.fromRGB(100, 0, 200),
        ToggleEnabledStroke = Color3.fromRGB(200, 150, 255),
        ToggleDisabledStroke = Color3.fromRGB(100, 0, 200),
        ToggleEnabledOuterStroke = Color3.fromRGB(200, 150, 255),
        ToggleDisabledOuterStroke = Color3.fromRGB(100, 0, 200),
        DropdownSelected = Color3.fromRGB(128, 0, 255),
        DropdownUnselected = Color3.fromRGB(30, 30, 30),
        InputBackground = Color3.fromRGB(30, 30, 30),
        InputStroke = Color3.fromRGB(100, 0, 200),
        PlaceholderColor = Color3.fromRGB(200, 150, 255)
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

-- Auto Headshots ( kills zombies and bosses, bypasses detection)
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

-- Camera Unlock Toggle with Click-and-Drag
local cameraUnlocked = false
local cameraLoop
MiscTab:CreateToggle({
    Name = "Unlock Camera to 3rd Person Mode",
    CurrentValue = false,
    Flag = "CameraUnlock
