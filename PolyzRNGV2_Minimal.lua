-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield
local rayfieldSuccess, rayfieldError = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
end)

if not rayfieldSuccess then
    warn("[Minimal] Failed to load Rayfield UI Library:", rayfieldError)
    -- Try backup URL
    local backupSuccess, backupError = pcall(function()
        Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/synnyyy/RobloxLua/main/Rayfield'))()
    end)
    
    if not backupSuccess then
        warn("[Minimal] Backup Rayfield also failed:", backupError)
        return
    end
end

-- Wait for Remotes safely
local Remotes
task.spawn(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    if not Remotes then
        warn("[Minimal] Remotes folder not found - some features may not work")
    end
end)

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "🚀 MINIMAL LIGHTWEIGHT 🚀",
    Icon = 71338090068856,
    LoadingTitle = "🚀 Loading...",
    LoadingSubtitle = "Minimal version",
    Theme = "Ocean",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MinimalHub",
        FileName = "MinimalConfig"
    }
})

-- Combat Tab
local CombatTab = Window:CreateTab("⚔️ Combat", "Sword")

-- Variables
local autoKill = false
local strengthMultiplier = 1
local effectivenessLevel = 50
local maxShootDistance = 250
local shootDelay = 0.25

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

-- Simple target validation
local function isValidTarget(zombie, head, humanoid)
    if not head or not head.Parent then
        return false
    end
    
    local isBoss = zombie.Name == "GoblinKing" or zombie.Name == "CaptainBoom" or zombie.Name == "Fungarth"
    
    if isBoss then
        return true
    end
    
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local distance = (head.Position - root.Position).Magnitude
            if distance > maxShootDistance then
                return false
            end
        end
    end
    
    return true
end

-- Simple raycast function
local function getShotPosition(targetHead, targetModel)
    local character = player.Character
    if not character then return nil end
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local origin = camera.CFrame.Position
    local targetPos = targetHead.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    if distance > maxShootDistance then
        return nil
    end
    
    local raycastParams = RaycastParams.new()
    local filterList = {
        workspace.Enemies,
        workspace:FindFirstChild("Misc") or workspace,
        workspace:FindFirstChild("BossArena") and workspace.BossArena:FindFirstChild("Decorations") or workspace
    }
    raycastParams.FilterDescendantsInstances = filterList
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    
    local rayResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    if rayResult then
        if rayResult.Instance and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
            return rayResult.Position, rayResult.Instance
        else
            -- Try body parts
            local bodyParts = {"Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
            for _, partName in ipairs(bodyParts) do
                local part = targetModel:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    local partDir = (part.Position - origin).Unit
                    local partDist = (part.Position - origin).Magnitude
                    local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                    
                    if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                        return partRay.Position, partRay.Instance
                    end
                end
            end
            return nil
        end
    else
        return targetPos, targetHead
    end
end

-- Combat Section
CombatTab:CreateSection("⚔️ Combat Settings")

-- Effectiveness Slider
CombatTab:CreateSlider({
    Name = "🎯 Combat Effectiveness",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "Effectiveness",
    Callback = function(Value)
        effectivenessLevel = Value
        local scaleFactor = Value / 100
        shootDelay = 0.30 - (scaleFactor * 0.15)
        maxShootDistance = math.floor(150 + (scaleFactor * 100))
        
        Rayfield:Notify({
            Title = "🎯 EFFECTIVENESS SET",
            Content = Value .. "% effectiveness | Delay: " .. string.format("%.2f", shootDelay) .. "s",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Strength Multiplier
CombatTab:CreateSlider({
    Name = "🚀 Strength Multiplier",
    Range = {1, 50},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "StrengthMultiplier",
    Callback = function(Value)
        strengthMultiplier = Value
        Rayfield:Notify({
            Title = "🚀 STRENGTH SET",
            Content = "Strength multiplier: " .. Value .. "x",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Auto-Kill Toggle
CombatTab:CreateToggle({
    Name = "🎯 Auto-Kill",
    CurrentValue = false,
    Flag = "AutoKill",
    Callback = function(state)
        autoKill = state
        if state then
            Rayfield:Notify({
                Title = "🎯 AUTO-KILL ACTIVE",
                Content = "Auto-kill enabled with " .. strengthMultiplier .. "x strength",
                Duration = 4,
                Image = 4483362458
            })
            
            -- Create multiple loops based on strength multiplier
            for i = 1, strengthMultiplier do
                task.spawn(function()
                    while autoKill do
                        pcall(function()
                            local enemies = workspace:FindFirstChild("Enemies")
                            local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                            
                            if enemies and shootRemote then
                                local weapon = getEquippedWeaponName()
                                local validTargets = {}
                                
                                local character = player.Character
                                local root = character and character:FindFirstChild("HumanoidRootPart")
                                
                                for _, zombie in pairs(enemies:GetChildren()) do
                                    if zombie:IsA("Model") then
                                        local head = zombie:FindFirstChild("Head")
                                        local humanoid = zombie:FindFirstChild("Humanoid")
                                        
                                        if isValidTarget(zombie, head, humanoid) then
                                            local distance = root and (head.Position - root.Position).Magnitude or 999999
                                            
                                            if distance <= maxShootDistance then
                                                table.insert(validTargets, {
                                                    model = zombie,
                                                    head = head,
                                                    humanoid = humanoid,
                                                    distance = distance
                                                })
                                            end
                                        end
                                    end
                                end
                                
                                if #validTargets > 0 then
                                    -- Sort by distance
                                    table.sort(validTargets, function(a, b)
                                        return a.distance < b.distance
                                    end)
                                    
                                    -- Shoot closest target
                                    local target = validTargets[1]
                                    local hitPos, hitPart = getShotPosition(target.head, target.model)
                                    
                                    if hitPos and hitPart then
                                        local args = {target.model, hitPart, hitPos, 0, weapon}
                                        pcall(function()
                                            shootRemote:FireServer(unpack(args))
                                        end)
                                    end
                                end
                            end
                        end)
                        
                        task.wait(shootDelay)
                    end
                end)
                
                task.wait(0.1) -- Small delay between loops
            end
        else
            Rayfield:Notify({
                Title = "🎯 AUTO-KILL STOPPED",
                Content = "Auto-kill disabled",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

-- Mouse Cursor Toggle
CombatTab:CreateToggle({
    Name = "🖱️ Always Show Mouse Cursor",
    CurrentValue = false,
    Flag = "AlwaysShowCursor",
    Callback = function(state)
        if state then
            Rayfield:Notify({
                Title = "🖱️ MOUSE CURSOR UNLOCKED",
                Content = "Mouse cursor will always be visible",
                Duration = 3,
                Image = 4483362458
            })
            
            task.spawn(function()
                while true do
                    pcall(function()
                        local UserInputService = game:GetService("UserInputService")
                        
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
                        UserInputService.MouseIconEnabled = true
                        
                        UserInputService:SetMouseIcon("rbxasset://textures/ArrowCursor.png")
                    end)
                    task.wait(0.01)
                end
            end)
        else
            Rayfield:Notify({
                Title = "🖱️ MOUSE CURSOR LOCKED",
                Content = "Mouse cursor follows game default",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

-- Load config
Rayfield:LoadConfiguration()
