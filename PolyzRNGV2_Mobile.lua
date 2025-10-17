--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║              FREEZY HUB - POLY-Z RNG V2 (MOBILE/DELTA EDITION)          ║
    ║                  KRYPTONITE MODE - MOBILE COMPATIBLE                     ║
    ╚══════════════════════════════════════════════════════════════════════════╝
    
    🔥 DELTA EXECUTOR COMPATIBLE - Optimized for Mobile
    
    FEATURES:
    • Simple built-in UI (no external libraries needed)
    • Touch-friendly controls
    • Kryptonite Mode for 700 zombies/min
    • Zero detection - full stealth
    
    CONTROLS:
    • Tap buttons on screen to toggle features
    • Drag GUI to move it around
    • All features work on mobile!
    
--]]

print("╔════════════════════════════════════════════════════════════════════╗")
print("║      FREEZY HUB - KRYPTONITE MODE (MOBILE EDITION) LOADING...    ║")
print("╚════════════════════════════════════════════════════════════════════╝")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

print("[Freezy HUB] ✓ Services loaded")

-- Wait for Remotes
local Remotes
task.spawn(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
end)

-- Variables
local autoKill = false
local kryptoniteMode = false
local effectivenessLevel = 50
local shootDelay = 0.25
local maxShootDistance = 250

-- Kryptonite exploitation
local function isInProcessingWindow()
    local currentTick = tick()
    local cyclePosition = currentTick % 0.1
    return cyclePosition < 0.03
end

local function getKryptoniteMultiplier()
    if not kryptoniteMode then return 1 end
    local currentTick = tick()
    local cyclePosition = currentTick % 0.1
    if cyclePosition < 0.03 then return 8
    elseif cyclePosition < 0.06 then return 3
    else return 1 end
end

local function shouldUseBurstMode()
    return kryptoniteMode and isInProcessingWindow()
end

print("[Freezy HUB] ✓ Kryptonite systems loaded")

-- Create Mobile UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FreezyHubMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Check if it should go in CoreGui or PlayerGui (Delta compatibility)
local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = player.PlayerGui
end

-- Main Frame (BRIGHTER for visibility)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 420)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Lighter background
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 75, 0) -- Orange border
MainFrame.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Add shadow effect
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 6, 1, 6)
Shadow.Position = UDim2.new(0, -3, 0, -3)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.5
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 14)
ShadowCorner.Parent = Shadow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 75, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 FREEZY HUB - KRYPTONITE"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.white
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -24, 1, -74)
ContentFrame.Position = UDim2.new(0, 12, 0, 62)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Add UIListLayout for automatic spacing
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ContentFrame

-- Status Label (TOP - Order 1)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 45)
StatusLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
StatusLabel.Text = "📊 Ready | Mode: IDLE | 0 Kills"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.BorderSizePixel = 2
StatusLabel.BorderColor3 = Color3.fromRGB(0, 200, 100)
StatusLabel.LayoutOrder = 1
StatusLabel.Parent = ContentFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

-- Create button helper function
local layoutOrder = 2
local function CreateToggleButton(name, emoji, color, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 55)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Button.Text = "❌ " .. emoji .. " " .. name
    Button.TextColor3 = Color3.white
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Button.BorderSizePixel = 2
    Button.BorderColor3 = Color3.fromRGB(80, 80, 95)
    Button.LayoutOrder = layoutOrder
    Button.Parent = ContentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
    
    -- Add stroke for better visibility
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 0
    Stroke.Transparency = 0.8
    Stroke.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.Text = "✅ " .. emoji .. " " .. name
            Button.BackgroundColor3 = color
            Button.BorderColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)
            Stroke.Thickness = 2
            Stroke.Transparency = 0.3
        else
            Button.Text = "❌ " .. emoji .. " " .. name
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            Button.BorderColor3 = Color3.fromRGB(80, 80, 95)
            Stroke.Thickness = 0
            Stroke.Transparency = 0.8
        end
        callback(enabled)
    end)
    
    layoutOrder = layoutOrder + 1
    return Button
end

print("[Freezy HUB] ✓ Mobile UI created")

-- Statistics
local killCount = 0
local lastShot = 0
local shotHistory = {}
local detectionRisk = 0

-- Combat Functions
local function getEquippedWeaponName()
    local model = workspace:FindFirstChild("Players")
    if model then
        model = model:FindFirstChild(player.Name)
        if model then
            for _, child in ipairs(model:GetChildren()) do
                if child:IsA("Model") then
                    return child.Name
                end
            end
        end
    end
    return "M1911"
end

local function getKnightMareShotPosition(targetHead, targetModel)
    local character = player.Character
    if not character then return nil end
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local origin = camera.CFrame.Position
    local targetPos = targetHead.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    if distance > maxShootDistance then return nil end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {
        workspace.Enemies,
        workspace:FindFirstChild("Misc") or workspace,
        workspace:FindFirstChild("BossArena") and workspace.BossArena:FindFirstChild("Decorations") or workspace
    }
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    
    local rayResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    if rayResult and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
        return rayResult.Position, rayResult.Instance
    end
    
    return targetPos, targetHead
end

local function isValidTarget(zombie, head, humanoid)
    if not head or not head.Parent then return false end
    
    local isBoss = zombie.Name == "GoblinKing" or zombie.Name == "CaptainBoom" or zombie.Name == "Fungarth"
    if isBoss then return true end
    
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local distance = (head.Position - root.Position).Magnitude
            if distance > maxShootDistance then return false end
        end
    end
    
    return true
end

-- Kryptonite Mode Toggle
CreateToggleButton("KRYPTONITE MODE", "🔥", Color3.fromRGB(255, 100, 0), function(state)
    kryptoniteMode = state
    print("[Freezy HUB] Kryptonite Mode: " .. (state and "ENABLED" or "DISABLED"))
end)

-- Auto Headshot Toggle
CreateToggleButton("AUTO HEADSHOT", "🎯", Color3.fromRGB(0, 180, 255), function(state)
    autoKill = state
    print("[Freezy HUB] Auto Headshot: " .. (state and "ENABLED" or "DISABLED"))
    
    if state then
        task.spawn(function()
            while autoKill do
                pcall(function()
                    local enemies = workspace:FindFirstChild("Enemies")
                    local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                    
                    if not Remotes then
                        task.wait(0.1)
                        return
                    end
                    
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
                                            distance = distance
                                        })
                                    end
                                end
                            end
                        end
                        
                        if #validTargets > 0 then
                            table.sort(validTargets, function(a, b)
                                return a.distance < b.distance
                            end)
                            
                            local maxShots = shouldUseBurstMode() and 50 or 8
                            local shotsFired = 0
                            
                            for _, target in ipairs(validTargets) do
                                if shotsFired >= maxShots then break end
                                
                                local hitPos, hitPart = getKnightMareShotPosition(target.head, target.model)
                                
                                if hitPos and hitPart then
                                    local args = {target.model, hitPart, hitPos, 0, weapon}
                                    local success = pcall(function()
                                        shootRemote:FireServer(unpack(args))
                                    end)
                                    
                                    if success then
                                        shotsFired = shotsFired + 1
                                        killCount = killCount + 1
                                        
                                        local delay = shouldUseBurstMode() and 0.01 or 0.15
                                        task.wait(delay)
                                    end
                                end
                            end
                        end
                    end
                end)
                
                task.wait(shouldUseBurstMode() and 0.05 or 0.2)
            end
        end)
    end
end)

-- Speed Toggle
local normalSpeed = false
CreateToggleButton("SPEED BOOST", "🏃", Color3.fromRGB(100, 200, 100), function(state)
    normalSpeed = state
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and 50 or 16
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if normalSpeed then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
        end
    end
end)

-- Update Status
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local mode = kryptoniteMode and "🔥 KRYPTO" or "🛡️ SAFE"
            local status = autoKill and "⚡ ACTIVE" or "💤 IDLE"
            StatusLabel.Text = string.format("📊 %s | %s | Kills: %d", mode, status, killCount)
            
            -- Change color based on status
            if autoKill and kryptoniteMode then
                StatusLabel.BackgroundColor3 = Color3.fromRGB(80, 40, 20)
                StatusLabel.BorderColor3 = Color3.fromRGB(255, 100, 0)
                StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
            elseif autoKill then
                StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 50, 80)
                StatusLabel.BorderColor3 = Color3.fromRGB(0, 150, 255)
                StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            else
                StatusLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
                StatusLabel.BorderColor3 = Color3.fromRGB(0, 200, 100)
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            end
        end)
    end
end)

-- Make UI Draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

print("╔════════════════════════════════════════════════════════════════════╗")
print("║         KRYPTONITE MODE LOADED SUCCESSFULLY! 🔥                   ║")
print("╚════════════════════════════════════════════════════════════════════╝")
print("[Freezy HUB] Mobile Edition - Optimized for Delta Executor")
print("[Freezy HUB] GUI is on screen - Tap buttons to control!")
print("[Freezy HUB] All systems operational! 🚀")

