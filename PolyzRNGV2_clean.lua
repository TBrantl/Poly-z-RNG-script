-- Clean V2 version - Minimal working version
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()

-- Wait for Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)

-- Create window
local Window = Rayfield:CreateWindow({
    Name = "❄️ Freezy HUB ❄️ | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHub",
        FileName = "FreezyConfig"
    }
})

-- Create combat tab
local CombatTab = Window:CreateTab("⚔️ Warfare", "Sword")

-- Variables
local autoKill = false
local shootDelay = 0.1
local maxShootDistance = 200
local effectivenessLevel = 100
local stealthMode = false

-- Create toggle
CombatTab:CreateToggle({
    Name = "🎯 Perfect Defense | Auto-Headshot",
    CurrentValue = false,
    Flag = "PerfectDefense",
    Callback = function(state)
        autoKill = state
        if state then
            Rayfield:Notify({
                Title = "🎯 PERFECT DEFENSE ACTIVE",
                Content = "Auto-headshot enabled",
                Duration = 3,
                Image = 4483362458
            })
            
            -- Simple combat loop
            task.spawn(function()
                while autoKill do
                    pcall(function()
                        local enemies = workspace:FindFirstChild("Enemies")
                        local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                        
                        if enemies and shootRemote then
                            local character = player.Character
                            if character then
                                local camera = workspace.CurrentCamera
                                if camera then
                                    local origin = camera.CFrame.Position
                                    
                                    -- Find targets
                                    local validTargets = {}
                                    for _, enemy in pairs(enemies:GetChildren()) do
                                        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("Head") then
                                            local distance = (enemy.Head.Position - origin).Magnitude
                                            if distance <= maxShootDistance then
                                                table.insert(validTargets, {
                                                    model = enemy,
                                                    head = enemy.Head,
                                                    distance = distance
                                                })
                                            end
                                        end
                                    end
                                    
                                    -- Sort by distance
                                    table.sort(validTargets, function(a, b)
                                        return a.distance < b.distance
                                    end)
                                    
                                    -- Shoot first target
                                    if #validTargets > 0 then
                                        local target = validTargets[1]
                                        local direction = (target.head.Position - origin).Unit
                                        
                                        local raycastParams = RaycastParams.new()
                                        raycastParams.FilterDescendantsInstances = {workspace.Enemies}
                                        raycastParams.FilterType = Enum.RaycastFilterType.Include
                                        
                                        local rayResult = workspace:Raycast(origin, direction * 250, raycastParams)
                                        
                                        if rayResult and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
                                            local args = {target.model, rayResult.Instance, rayResult.Position, 0, "M1911"}
                                            shootRemote:FireServer(unpack(args))
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    
                    task.wait(shootDelay)
                end
            end)
        else
            Rayfield:Notify({
                Title = "🎯 PERFECT DEFENSE DISABLED",
                Content = "Auto-headshot disabled",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

-- Load configuration
Rayfield:LoadConfiguration()

print("✓ Clean V2 version loaded successfully!")