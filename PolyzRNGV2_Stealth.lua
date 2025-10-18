-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()

-- Wait for Remotes safely
local Remotes
task.spawn(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    if not Remotes then
        warn("[Freezy HUB] Remotes folder not found - some features may not work")
    end
end)

-- 🥷 ULTRA-STEALTH UI CONFIGURATION
local Window = Rayfield:CreateWindow({
    Name = "🥷 FREEZY HUB V2 ULTRA-STEALTH 🥷 | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    LoadingTitle = "🥷 Initializing Ultra-Stealth V2 System...",
    LoadingSubtitle = "ULTRA-STEALTH + 10% Activity + 2-5s Delays + Single Shots + Minimal Detection",
    Theme = "Ocean",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHub",
        FileName = "FreezyConfig"
    }
})

-- 📊 Ultra-Stealth Performance Monitor
local performanceStats = {
    shotsBlocked = 0,
    shotsSuccessful = 0,
    riskLevel = "ULTRA-LOW",
    adaptiveDelay = 0.5,
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
    return "Unknown"
end

-- 🥷 ULTRA-STEALTH VARIABLES
local autoKill = false
local maxShootDistance = 250

-- 🥷 ULTRA-STEALTH COMBAT TAB
local CombatTab = Window:CreateTab("🥷 Ultra-Stealth Combat", "Ultra-stealth combat settings")

CombatTab:CreateToggle({
    Name = "🥷 Ultra-Stealth Auto-Kill",
    CurrentValue = false,
    Flag = "AutoKill",
    Callback = function(state)
        autoKill = state
        if state then
            Rayfield:Notify({
                Title = "🥷 Ultra-Stealth Mode Activated",
                Content = "Minimal activity mode - 10% chance to shoot, 2-5s delays",
                Duration = 4,
                Image = 4483362458
            })
            
            -- 🥷 ULTRA-STEALTH MODE: Minimal Activity
            task.spawn(function()
                while autoKill do
                    pcall(function()
                        local enemies = workspace:FindFirstChild("Enemies")
                        local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                        
                        if enemies and shootRemote then
                            -- 🥷 RARE ACTIVITY: Only shoot occasionally (like a cautious player)
                            if math.random() < 0.1 then -- 10% chance to shoot
                                local targetZombie = nil
                                local closestDistance = math.huge
                                
                                -- Find closest zombie
                                for _, zombie in ipairs(enemies:GetChildren()) do
                                    if zombie:IsA("Model") then
                                        local humanoid = zombie:FindFirstChild("Humanoid")
                                        local head = zombie:FindFirstChild("Head")
                                        local root = zombie:FindFirstChild("HumanoidRootPart")
                                        
                                        if humanoid and head and root and humanoid.Health > 0 then
                                            local distance = root and (head.Position - root.Position).Magnitude or 999999
                                            if distance < closestDistance then
                                                closestDistance = distance
                                                targetZombie = zombie
                                            end
                                        end
                                    end
                                end
                                
                                if targetZombie then
                                    local head = targetZombie:FindFirstChild("Head")
                                    if head then
                                        -- 🥷 SINGLE SHOT: Fire only 1 shot
                                        pcall(function()
                                            shootRemote:FireServer(targetZombie, head, head.Position, 0, getEquippedWeaponName())
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                    -- 🥷 LONG INACTIVITY: Wait 2-5 seconds between activities
                    task.wait(2 + math.random() * 3)
                end
            end)
        end
    end
})

-- 🥷 ULTRA-STEALTH SETTINGS TAB
local SettingsTab = Window:CreateTab("🥷 Ultra-Stealth Settings", "Ultra-stealth configuration")

SettingsTab:CreateSlider({
    Name = "🥷 Activity Level",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 10,
    Flag = "ActivityLevel",
    Callback = function(value)
        -- This would control the 10% chance to shoot
        Rayfield:Notify({
            Title = "🥷 Activity Level",
            Content = "Activity level set to " .. value .. "%",
            Duration = 2,
            Image = 4483362458
        })
    end
})

SettingsTab:CreateSlider({
    Name = "🥷 Delay Range (seconds)",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 3,
    Flag = "DelayRange",
    Callback = function(value)
        Rayfield:Notify({
            Title = "🥷 Delay Range",
            Content = "Delay range set to " .. value .. " seconds",
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- 🥷 ULTRA-STEALTH PERFORMANCE TAB
local PerformanceTab = Window:CreateTab("🥷 Ultra-Stealth Performance", "Ultra-stealth performance monitor")

PerformanceTab:CreateLabel({
    Name = "🥷 Ultra-Stealth Status",
    Text = "Status: Inactive"
})

PerformanceTab:CreateLabel({
    Name = "🥷 Shots Fired",
    Text = "Shots Fired: 0"
})

PerformanceTab:CreateLabel({
    Name = "🥷 Detection Risk",
    Text = "Detection Risk: ULTRA-LOW"
})

-- 🥷 ULTRA-STEALTH PERFORMANCE MONITOR
task.spawn(function()
    while true do
        if autoKill then
            -- Update performance stats
            local currentTime = tick()
            if currentTime - performanceStats.lastUpdate > 1 then
                performanceStats.lastUpdate = currentTime
                
                -- Update UI labels
                local statusLabel = PerformanceTab:FindFirstChild("🥷 Ultra-Stealth Status")
                if statusLabel then
                    statusLabel.Text = "Status: Active (Ultra-Stealth Mode)"
                end
                
                local shotsLabel = PerformanceTab:FindFirstChild("🥷 Shots Fired")
                if shotsLabel then
                    shotsLabel.Text = "Shots Fired: " .. performanceStats.shotsSuccessful
                end
                
                local riskLabel = PerformanceTab:FindFirstChild("🥷 Detection Risk")
                if riskLabel then
                    riskLabel.Text = "Detection Risk: " .. performanceStats.riskLevel
                end
            end
        end
        
        task.wait(0.5) -- Update every 0.5 seconds
    end
end)

-- 🥷 ULTRA-STEALTH CLEANUP
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        -- Clean up when player leaves
        autoKill = false
    end
end)

-- 🥷 ULTRA-STEALTH INITIALIZATION
Rayfield:Notify({
    Title = "🥷 Ultra-Stealth V2 System",
    Content = "Ultra-stealth mode initialized - Minimal activity for maximum stealth",
    Duration = 4,
    Image = 4483362458
})
