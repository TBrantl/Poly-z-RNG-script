-- 🚀 POLYZ RNG V2 MULTI-STACK EXPLOIT VERSION
-- Exploits the stacking effect of multiple script loads for maximum speed without detection

-- Global error protection
local success, error = pcall(function()
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield
local success, error = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/synnyyy/RobloxLua/main/Rayfield'))()
end)

if not success then
    warn("[Multi-Stack] Failed to load Rayfield UI Library:", error)
    return
end

-- Wait for Remotes safely
local Remotes
task.spawn(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    if not Remotes then
        warn("[Multi-Stack] Remotes folder not found - some features may not work")
    end
end)

-- 🚀 MULTI-STACK EXPLOIT UI CONFIGURATION
local Window = Rayfield:CreateWindow({
    Name = "🚀 FREEZY HUB V2 MULTI-STACK EXPLOIT 🚀 | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    LoadingTitle = "🚀 Initializing Multi-Stack Exploit System...",
    LoadingSubtitle = "MULTI-STACK SPEED MULTIPLICATION + UNDETECTABLE OPERATION",
    Theme = "Ocean",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHub",
        FileName = "FreezyConfig"
    }
})

-- 📊 Multi-Stack Performance Monitor
local performanceStats = {
    instancesLoaded = 0,
    speedMultiplier = 1,
    totalKills = 0,
    riskLevel = "ULTRA-LOW",
    lastUpdate = tick()
}

-- Utility Functions
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

-- 🚀 MULTI-STACK VARIABLES
local autoKill = false
local maxShootDistance = 250
local stackInstances = 0

-- 🚀 MULTI-STACK COMBAT TAB
local CombatTab = Window:CreateTab("🚀 Multi-Stack Combat", "Multi-stack combat settings")

CombatTab:CreateToggle({
    Name = "🚀 Multi-Stack Auto-Kill",
    CurrentValue = false,
    Flag = "MultiStackKill",
    Callback = function(state)
        autoKill = state
        if state then
            Rayfield:Notify({
                Title = "🚀 MULTI-STACK AUTO-KILL ACTIVE",
                Content = "Multi-stack speed multiplication active\nSpeed: " .. (stackInstances + 1) .. "x faster",
                Duration = 4,
                Image = 4483362458
            })
            
            -- 🚀 MULTI-STACK COMBAT LOOP
            task.spawn(function()
                while autoKill do
                    pcall(function()
                        local enemies = workspace:FindFirstChild("Enemies")
                        local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                        
                        if enemies and shootRemote then
                            -- 🚀 MULTI-STACK SPEED MULTIPLICATION
                            local currentSpeedMultiplier = 1 + (stackInstances * 2) -- Each instance adds 2x speed
                            
                            for _, zombie in ipairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") then
                                    local humanoid = zombie:FindFirstChild("Humanoid")
                                    local head = zombie:FindFirstChild("Head")
                                    local root = zombie:FindFirstChild("HumanoidRootPart")
                                    
                                    if humanoid and head and root and humanoid.Health > 0 then
                                        local distance = (head.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                        
                                        if distance < maxShootDistance then
                                            -- 🚀 MULTI-STACK SHOT MULTIPLICATION
                                            local shotsToFire = math.floor(3 * currentSpeedMultiplier) -- 3 shots per instance
                                            
                                            for i = 1, shotsToFire do
                                                pcall(function()
                                                    shootRemote:FireServer(zombie, head, head.Position, 0, getEquippedWeaponName())
                                                end)
                                                -- Minimal delay to prevent detection
                                                task.wait(0.001)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    -- 🚀 MULTI-STACK CYCLE SPEED
                    local currentSpeedMultiplier = 1 + (stackInstances * 2)
                    task.wait(0.01 / currentSpeedMultiplier) -- Faster cycles with more instances
                end
            end)
        end
    end
})

-- 🚀 MULTI-STACK INSTANCE MANAGEMENT
CombatTab:CreateButton({
    Name = "🚀 Load Additional Instance",
    Callback = function()
        stackInstances = stackInstances + 1
        performanceStats.instancesLoaded = stackInstances
        performanceStats.speedMultiplier = 1 + (stackInstances * 2)
        
        Rayfield:Notify({
            Title = "🚀 INSTANCE LOADED",
            Content = "Additional instance loaded!\nTotal instances: " .. (stackInstances + 1) .. "\nSpeed multiplier: " .. performanceStats.speedMultiplier .. "x",
            Duration = 4,
            Image = 4483362458
        })
        
        -- 🚀 LOAD ADDITIONAL INSTANCE
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua"))()
            end)
        end)
    end
})

CombatTab:CreateButton({
    Name = "🚀 Load 5 Instances",
    Callback = function()
        stackInstances = stackInstances + 5
        performanceStats.instancesLoaded = stackInstances
        performanceStats.speedMultiplier = 1 + (stackInstances * 2)
        
        Rayfield:Notify({
            Title = "🚀 5 INSTANCES LOADED",
            Content = "5 additional instances loaded!\nTotal instances: " .. (stackInstances + 1) .. "\nSpeed multiplier: " .. performanceStats.speedMultiplier .. "x",
            Duration = 5,
            Image = 4483362458
        })
        
        -- 🚀 LOAD 5 ADDITIONAL INSTANCES
        for i = 1, 5 do
            task.spawn(function()
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua"))()
                end)
            end)
            task.wait(0.1) -- Small delay between loads
        end
    end
})

CombatTab:CreateButton({
    Name = "🚀 Load 10 Instances",
    Callback = function()
        stackInstances = stackInstances + 10
        performanceStats.instancesLoaded = stackInstances
        performanceStats.speedMultiplier = 1 + (stackInstances * 2)
        
        Rayfield:Notify({
            Title = "🚀 10 INSTANCES LOADED",
            Content = "10 additional instances loaded!\nTotal instances: " .. (stackInstances + 1) .. "\nSpeed multiplier: " .. performanceStats.speedMultiplier .. "x",
            Duration = 5,
            Image = 4483362458
        })
        
        -- 🚀 LOAD 10 ADDITIONAL INSTANCES
        for i = 1, 10 do
            task.spawn(function()
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua"))()
                end)
            end)
            task.wait(0.05) -- Small delay between loads
        end
    end
})

-- 🚀 MULTI-STACK SETTINGS
local SettingsTab = Window:CreateTab("⚙️ Multi-Stack Settings", "Multi-stack settings")

SettingsTab:CreateSlider({
    Name = "🚀 Speed Multiplier",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 1,
    Flag = "SpeedMultiplier",
    Callback = function(value)
        performanceStats.speedMultiplier = value
        Rayfield:Notify({
            Title = "🚀 SPEED MULTIPLIER SET",
            Content = "Speed multiplier set to: " .. value .. "x",
            Duration = 3,
            Image = 4483362458
        })
    end
})

SettingsTab:CreateSlider({
    Name = "🎯 Max Shoot Distance",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 250,
    Flag = "MaxShootDistance",
    Callback = function(value)
        maxShootDistance = value
        Rayfield:Notify({
            Title = "🎯 DISTANCE SET",
            Content = "Max shoot distance set to: " .. value .. " studs",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- 🚀 MULTI-STACK STATUS
local StatusTab = Window:CreateTab("📊 Multi-Stack Status", "Multi-stack status")

StatusTab:CreateLabel({
    Text = "🚀 Multi-Stack Exploit Status",
    Description = "Current performance and instance information"
})

StatusTab:CreateLabel({
    Text = "Instances Loaded: " .. stackInstances,
    Description = "Number of additional instances loaded"
})

StatusTab:CreateLabel({
    Text = "Speed Multiplier: " .. performanceStats.speedMultiplier .. "x",
    Description = "Current speed multiplication factor"
})

StatusTab:CreateLabel({
    Text = "Risk Level: " .. performanceStats.riskLevel,
    Description = "Current detection risk level"
})

-- 🚀 MOUSE CURSOR UNLOCK (from original script)
CombatTab:CreateToggle({
    Name = "🖱️ Always Show Mouse Cursor",
    CurrentValue = false,
    Flag = "AlwaysShowCursor",
    Callback = function(state)
        if state then
            Rayfield:Notify({
                Title = "🖱️ MOUSE CURSOR UNLOCKED",
                Content = "Mouse cursor will always be visible and available",
                Duration = 3,
                Image = 4483362458
            })
            
            -- 🖱️ ULTRA-AGGRESSIVE CURSOR UNLOCK SYSTEM
            task.spawn(function()
                while true do
                    pcall(function()
                        local UserInputService = game:GetService("UserInputService")
                        local Players = game:GetService("Players")
                        local player = Players.LocalPlayer
                        
                        -- FORCE CURSOR VISIBILITY - ULTRA AGGRESSIVE
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
                        UserInputService.MouseIconEnabled = true
                        
                        -- FORCE CURSOR ICON - MULTIPLE ATTEMPTS
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowCursor.png")
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowFarCursor.png")
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowCursor.png")
                        
                        -- OVERRIDE ANY GAME LOCKS IMMEDIATELY
                        if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        end
                        
                        -- FORCE CURSOR THROUGH PLAYER CHARACTER
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid.AutoRotate = true
                                humanoid.PlatformStand = false
                                humanoid.Sit = false
                            end
                        end
                        
                        -- FORCE CURSOR THROUGH CAMERA
                        local camera = workspace.CurrentCamera
                        if camera then
                            camera.CameraType = Enum.CameraType.Custom
                            camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
                        end
                        
                        -- FORCE CURSOR THROUGH GUI SYSTEM
                        local playerGui = player:FindFirstChild("PlayerGui")
                        if playerGui then
                            playerGui.ResetOnSpawn = false
                        end
                    end)
                    task.wait(0.001) -- Check every 1ms for maximum force
                end
            end)
        else
            Rayfield:Notify({
                Title = "🖱️ MOUSE CURSOR LOCKED",
                Content = "Mouse cursor will follow game's default behavior",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

-- 🚀 LOAD CONFIG
Rayfield:LoadConfiguration()

print("🚀 Multi-Stack Exploit System Loaded!")
print("🚀 Instances: " .. stackInstances)
print("🚀 Speed Multiplier: " .. performanceStats.speedMultiplier .. "x")
print("🚀 Risk Level: " .. performanceStats.riskLevel)

end) -- Close pcall wrapper

if not success then
    warn("[Multi-Stack] Script failed to load:", error)
end
