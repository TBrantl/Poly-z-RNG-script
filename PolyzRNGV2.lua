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

-- UI Window Configuration
local Window = Rayfield:CreateWindow({
    Name = "❄️ Freezy HUB ❄️ | POLY-Z",
    Icon = 71338090068856,
    LoadingTitle = "⚡ Initializing Freezy HUB...",
    LoadingSubtitle = "Ice Cold Performance",
    Theme = "Ocean",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHub",
        FileName = "FreezyConfig"
    }
})

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

-- Combat Tab
local CombatTab = Window:CreateTab("⚔️ Warfare", "Sword")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Equipped Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Equipped Weapon: " .. getEquippedWeaponName())
        task.wait(0.1)
    end
end)

-- Auto Headshots with KnightMare Bypass & Raycast Validation
local autoKill = false
local shootDelay = 0.1
local lastShot = 0
local shotCount = 0
local maxShootDistance = 500 -- Maximum shooting range

-- Anti-pattern: Humanized timing with variance
local function getSmartDelay(base)
    -- Add 15-30% random variance to prevent pattern detection
    local variance = base * (0.15 + math.random() * 0.15)
    local offset = (math.random() > 0.5) and variance or -variance
    return math.max(0.05, base + offset)
end

-- Anti-spam: Track shots and add cooldown if too many
local function shouldAllowShot()
    local currentTime = tick()
    
    -- Reset counter every 5 seconds
    if currentTime - lastShot > 5 then
        shotCount = 0
    end
    
    -- Limit to 50 shots per 5 seconds (very human-like)
    if shotCount >= 50 then
        return false
    end
    
    return true
end

-- Smart Shot Validation (Mimics Game's Raycast Behavior)
-- KEY INSIGHT: The game does CLIENT raycast, server validates enemy/distance only
-- We replicate the exact same behavior the real game uses
local function getSmartShotPosition(targetHead, targetModel)
    local character = player.Character
    if not character then return nil end
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    -- Mimic game's raycast from camera/head position
    local origin = camera.CFrame.Position
    local targetPos = targetHead.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    -- Distance sanity check (game would never shoot beyond render distance)
    if distance > maxShootDistance then
        return nil
    end
    
    -- Setup raycast EXACTLY like the game does
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    -- Perform raycast
    local rayResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    if rayResult then
        -- Check if we hit the enemy (or any part of enemies folder)
        if rayResult.Instance and rayResult.Instance:IsDescendantOf(workspace.Enemies) then
            -- We hit an enemy! Return the ACTUAL hit position (what game does)
            return rayResult.Position, rayResult.Instance
        else
            -- We hit an obstacle (wall, door, etc.)
            -- CLEVER WORKAROUND: Try shooting ANY visible body part
            -- This is what skilled players do - shoot what they CAN see
            
            -- Try multiple body parts (important for bosses with different structures)
            local bodyParts = {
                "Torso", "UpperTorso", "LowerTorso",
                "HumanoidRootPart", 
                "Left Arm", "Right Arm", "LeftUpperArm", "RightUpperArm",
                "Left Leg", "Right Leg", "LeftUpperLeg", "RightUpperLeg"
            }
            
            for _, partName in ipairs(bodyParts) do
                local part = targetModel:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    local partDir = (part.Position - origin).Unit
                    local partDist = (part.Position - origin).Magnitude
                    local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                    
                    if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                        -- This part is visible! Shoot it
                        return partRay.Position, partRay.Instance
                    end
                end
            end
            
                    -- Last resort: Try ANY part in the model that's visible (BOSS PRIORITY)
                    local isBoss = targetModel.Name == "GoblinKing" or targetModel.Name == "CaptainBoom" or targetModel.Name == "Fungarth"
                    
                    for _, part in pairs(targetModel:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            local partDir = (part.Position - origin).Unit
                            local partDist = (part.Position - origin).Magnitude
                            
                            if partDist <= maxShootDistance then
                                local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                                
                                if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                                    -- For bosses, be more aggressive - accept ANY hit
                                    if isBoss then
                                        return partRay.Position, partRay.Instance
                                    -- For regular enemies, check if it's the same model
                                    elseif partRay.Instance.Parent == targetModel then
                                        return partRay.Position, partRay.Instance
                                    end
                                end
                            end
                        end
                    end
            
            -- If nothing visible, return nil (skip this target)
            return nil
        end
    else
        -- No obstacle, direct line - return head position
        return targetPos, targetHead
    end
end

-- Enhanced target validation
local function isValidTarget(zombie, head, humanoid)
    -- Health check
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    
    -- Basic existence check
    if not head or not head.Parent then
        return false
    end
    
    -- Distance pre-check (optimization)
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

-- Combat Configuration
CombatTab:CreateInput({
    Name = "⚡ Shot Delay (0.08-2s)",
    PlaceholderText = "0.15",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.08 and num <= 2 then
            shootDelay = num
                    Rayfield:Notify({
                        Title = "⚡ Freezy HUB",
                        Content = "Shot delay set to "..num.."s",
                        Duration = 3,
                        Image = 4483362458
                    })
                else
                    Rayfield:Notify({
                        Title = "❌ Invalid Input",
                        Content = "Enter a value between 0.08 and 2",
                        Duration = 3,
                        Image = 4483362458
                    })
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Combat Range",
    Range = {100, 1000},
    Increment = 50,
    Suffix = " studs",
    CurrentValue = 500,
    Flag = "MaxShootRange",
    Callback = function(Value)
        maxShootDistance = Value
    end
})

CombatTab:CreateToggle({
    Name = "💀 Auto Elimination (Smart)",
    CurrentValue = false,
    Flag = "AutoKillZombies",
    Callback = function(state)
        autoKill = state
        if state then
            task.spawn(function()
                while autoKill do
                    pcall(function()
                        if not shouldAllowShot() then
                            task.wait(1) -- Cooldown if rate limited
                            return
                        end
                        
                        local enemies = workspace:FindFirstChild("Enemies")
                        local shootRemote = Remotes and Remotes:FindFirstChild("ShootEnemy")
                        
                        if enemies and shootRemote then
                            local weapon = getEquippedWeaponName()
                            local validTargets = {}
                            
                            -- Collect ALL living enemies with distance info
                            local character = player.Character
                            local root = character and character:FindFirstChild("HumanoidRootPart")
                            
                            for _, zombie in pairs(enemies:GetChildren()) do
                                if zombie:IsA("Model") then
                                    local head = zombie:FindFirstChild("Head")
                                    local humanoid = zombie:FindFirstChild("Humanoid")
                                    
                                    -- Basic validation only
                                    if isValidTarget(zombie, head, humanoid) then
                                        local distance = root and (head.Position - root.Position).Magnitude or 999999
                                        table.insert(validTargets, {
                                            model = zombie,
                                            head = head,
                                            humanoid = humanoid,
                                            distance = distance
                                        })
                                    end
                                end
                            end
                            
                            -- Try to shoot ONE target (with smart raycasting)
                            if #validTargets > 0 then
                                -- Prioritize: 1) Bosses, 2) Closer enemies
                                table.sort(validTargets, function(a, b)
                                    -- FIXED: Use exact boss names from the game
                                    local aBoss = a.model.Name == "GoblinKing" or a.model.Name == "CaptainBoom" or 
                                                  a.model.Name == "Fungarth"
                                    local bBoss = b.model.Name == "GoblinKing" or b.model.Name == "CaptainBoom" or 
                                                  b.model.Name == "Fungarth"
                                    
                                    -- Bosses always first
                                    if aBoss and not bBoss then return true end
                                    if bBoss and not aBoss then return false end
                                    
                                    -- If both bosses or both regular, prioritize by distance (closer first)
                                    return a.distance < b.distance
                                end)
                                
                                -- Try each target until we find one we can shoot
                                local shotFired = false
                                for _, target in ipairs(validTargets) do
                                    -- Debug: Check if we're targeting a boss
                                    local isBoss = target.model.Name == "GoblinKing" or target.model.Name == "CaptainBoom" or target.model.Name == "Fungarth"
                                    -- Smart raycast - returns actual hit position and part
                                    local hitPos, hitPart = getSmartShotPosition(target.head, target.model)
                                    
                                    if hitPos and hitPart then
                                        -- We can shoot this target!
                                        -- Args match EXACTLY what the game sends (line 12178):
                                        -- (EnemyModel, HitPart, HitPosition, 0, WeaponName)
                                        local args = {target.model, hitPart, hitPos, 0, weapon}
                                        
                                        local success = pcall(function()
                                            shootRemote:FireServer(unpack(args))
                                        end)
                                        
                                        if success then
                                            lastShot = tick()
                                            shotCount = shotCount + 1
                                            shotFired = true
                                            
                                            -- Notify when boss is targeted (for debugging)
                                            if isBoss and math.random(1, 20) == 1 then -- Only 5% chance to avoid spam
                                                Rayfield:Notify({
                                                    Title = "🎯 BOSS TARGETED",
                                                    Content = "Shooting " .. target.model.Name .. "!",
                                                    Duration = 2,
                                                    Image = 4483362458
                                                })
                                            end
                                            
                                            break -- Only shoot ONE target per cycle
                                        end
                                    end
                                    
                                    -- If this target blocked, try next one (max 3 attempts)
                                    if #validTargets > 3 and _ >= 3 then
                                        break
                                    end
                                end
                                
                                -- If no shot fired, all targets blocked (legitimate game behavior)
                            end
                        end
                    end)
                    
                    -- Use humanized delay
                    task.wait(getSmartDelay(shootDelay))
                end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "⏩ Round Skipper",
    CurrentValue = false,
    Flag = "AutoSkipRound",
    Callback = function(state)
        autoSkip = state
        if state then
            task.spawn(function()
                while autoSkip do
                    local skip = Remotes and Remotes:FindFirstChild("CastClientSkipVote")
                    if skip then
                        pcall(function() skip:FireServer() end)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Walk Speed with Smooth Transition (Anti-Detection)
local targetWalkSpeed = 16
local speedTransitionActive = false

local function smoothTransitionSpeed(target)
    if speedTransitionActive then return end
    speedTransitionActive = true
    
    task.spawn(function()
        pcall(function()
            local character = player.Character
            if not character then 
                speedTransitionActive = false
                return 
            end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then 
                speedTransitionActive = false
                return 
            end
            
            local current = humanoid.WalkSpeed
            local difference = target - current
            local steps = math.abs(difference) / 2 -- Gradual change
            
            -- Smooth transition over time (avoids instant detection)
            for i = 1, steps do
                if not character or not humanoid then break end
                local progress = i / steps
                humanoid.WalkSpeed = current + (difference * progress)
                task.wait(0.05) -- Smooth increment
            end
            
            if humanoid then
                humanoid.WalkSpeed = target
            end
        end)
        speedTransitionActive = false
    end)
end

-- Maintain speed on respawn
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if targetWalkSpeed ~= 16 then
        smoothTransitionSpeed(targetWalkSpeed)
    end
end)

CombatTab:CreateSlider({
    Name = "🏃‍♂️ Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        targetWalkSpeed = Value
        smoothTransitionSpeed(Value)
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("🔷 Utilities", "Settings")

MiscTab:CreateSection("💰 Auto Collection")

-- Auto Collect System (100% Safe - Smooth Tween Movement)
local autoCollect = false
local collectRadius = 80 -- Conservative radius for maximum safety
local lastCollectTime = 0
local collectCooldown = 0.2 -- Humanized timing with extra safety margin
local TweenService = game:GetService("TweenService")
local activeTweens = {} -- Track active tweens to avoid duplicates

-- Smart collection function - Smoothly brings items to player (mimics magnet pickup)
local function collectNearbyItems()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local currentTime = tick()
    if currentTime - lastCollectTime < collectCooldown then return end
    lastCollectTime = currentTime
    
    pcall(function()
        local collected = 0
        -- Search for collectible items in workspace (limited scope for performance)
        for _, item in pairs(workspace:GetDescendants()) do
            if collected >= 2 then break end -- Max 2 items per cycle (very conservative)
            
            -- Skip if already being tweened
            if activeTweens[item] then continue end
            
            if item:IsA("BasePart") and item.CanCollide == false and not item.Anchored then
                -- Check if it's a collectible based on name patterns
                local itemName = item.Name:lower()
                local isCollectible = itemName:find("gold") or 
                                     itemName:find("drop") or
                                     itemName:find("coin") or
                                     itemName:find("money") or
                                     itemName:find("cash") or
                                     itemName:find("loot")
                
                if isCollectible then
                    local distance = (item.Position - root.Position).Magnitude
                    
                    if distance <= collectRadius and distance > 8 then
                        -- Move item smoothly towards player (mimics legitimate magnet pickup)
                        local tweenInfo = TweenInfo.new(
                            0.4 + (math.random() * 0.2), -- 0.4-0.6s duration (varied, human-like)
                            Enum.EasingStyle.Sine, -- Smooth, natural movement
                            Enum.EasingDirection.In
                        )
                        
                        local tween = TweenService:Create(item, tweenInfo, {
                            CFrame = root.CFrame * CFrame.new(0, 2, 0) -- Slightly above player
                        })
                        
                        activeTweens[item] = true
                        tween:Play()
                        
                        -- Clean up tween reference when done
                        tween.Completed:Connect(function()
                            activeTweens[item] = nil
                        end)
                        
                        collected = collected + 1
                        task.wait(0.05) -- Small delay between each item (more natural)
                    end
                end
            end
        end
    end)
end

MiscTab:CreateToggle({
    Name = "💎 Auto Loot Collector",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(state)
        autoCollect = state
        if state then
            Rayfield:Notify({
                Title = "💎 Freezy HUB",
                Content = "Auto-collector activated!",
                Duration = 3,
                Image = 4483362458
            })
            
            task.spawn(function()
                while autoCollect do
                    collectNearbyItems()
                    task.wait(collectCooldown + math.random() * 0.05) -- Humanized timing
                end
            end)
        end
    end
})

MiscTab:CreateSlider({
    Name = "📏 Collector Radius",
    Range = {40, 120},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 80,
    Flag = "CollectRadius",
    Callback = function(Value)
        collectRadius = Value
    end
})

MiscTab:CreateSection("🔷 Quick Tools")

MiscTab:CreateButton({
    Name = "🚪 Remove Doors",
    Callback = function()
        local doorsFolder = workspace:FindFirstChild("Doors")
        if doorsFolder then
            for _, group in pairs(doorsFolder:GetChildren()) do
                if group:IsA("Folder") or group:IsA("Model") then
                    group:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "🚪 Freezy HUB",
                Content = "All doors removed!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

MiscTab:CreateButton({
    Name = "♾️ Infinite Ammo",
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
        Rayfield:Notify({
            Title = "♾️ Freezy HUB",
            Content = "Infinite ammo enabled!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateSection("⚡ Power Enhancements")

MiscTab:CreateButton({
    Name = "⚡ Unlock All Perks (Buy)",
    Callback = function()
        local activated = 0
        
        -- Find all perk machines in workspace
        pcall(function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local objectText = descendant.ObjectText
                    if objectText:match("Perk") or objectText:match("perk") then
                        -- Fire the prompt to buy the perk
                        fireproximityprompt(descendant, 0)
                        activated = activated + 1
                        task.wait(0.1) -- Small delay between purchases
                    end
                end
            end
        end)
        
        Rayfield:Notify({
            Title = "⚡ Freezy HUB",
            Content = activated .. " perks purchased!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateButton({
    Name = "🔫 Weapon Enhancer (Pack-a-Punch)",
    Callback = function()
        local enhanced = 0
        
        -- Find all weapon enhancement machines (Pack-a-Punch style)
        pcall(function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    local objectText = descendant.ObjectText
                    local actionText = descendant.ActionText
                    
                    -- Look for enhancement prompts (various patterns)
                    if objectText:lower():find("enhance") or 
                       objectText:lower():find("upgrade") or
                       objectText:lower():find("pack") or
                       actionText:lower():find("enhance") or
                       actionText:lower():find("upgrade") then
                        
                        -- Fire the prompt to enhance weapon
                        fireproximityprompt(descendant, 0)
                        enhanced = enhanced + 1
                        task.wait(0.15) -- Small delay between enhancements
                    end
                end
            end
        end)
        
        if enhanced > 0 then
            Rayfield:Notify({
                Title = "🔫 Freezy HUB",
                Content = enhanced .. " weapons enhanced (Pack-a-Punch)",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "⚠️ Freezy HUB",
                Content = "No enhancement machines found nearby!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})


MiscTab:CreateButton({
    Name = "❄️ Max Tier Weapons",
    Callback = function()
        local gunData = player:FindFirstChild("GunData")
        if not gunData then 
            Rayfield:Notify({
                Title = "❌ Error",
                Content = "Wait for game to load...",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        local modified = 0
        for _, value in ipairs(gunData:GetChildren()) do  
            if value:IsA("StringValue") then  
                pcall(function()
                    value.Value = "transcendent"  -- HIGHEST tier (0.00004% rarity = 2.4x multiplier)
                    modified = modified + 1
                end)
            end  
        end
        
        Rayfield:Notify({
            Title = "❄️ Freezy HUB",
            Content = modified .. " weapons maxed (0.00004% rarity!)",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Note: Pet bonuses removed - they are only visual and don't provide actual bonuses

-- Open Tab
local OpenTab = Window:CreateTab("📦 Crates", "Box")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local selectedQuantity = 1
local selectedOutfitType = "Random" -- For Outfit crates

OpenTab:CreateDropdown({
    Name = "🔢 Open Quantity",
    Options = {"1", "25", "50", "200"},
    CurrentOption = "1",
    Flag = "OpenQuantity",
    Callback = function(Option)
        selectedQuantity = tonumber(Option)
    end,
})

OpenTab:CreateSection("📦 Auto Open Crates")

-- 🎽 Dropdown list of types for Outfit crates
OpenTab:CreateDropdown({
    Name = "👕 Outfit Type",
    Options = {
        "Random", "Hat", "torseaccessory", "legaccessory", "faceaccessory", 
        "armaccessory", "backaccessory", "gloves", "shoes", "hair",
        "shirt", "pants", "haircolor", "skincolor", "face"
    },
    CurrentOption = "Random",
    Callback = function(option)
        selectedOutfitType = option
    end,
})

-- Crate Opening Anti-Spam System
local function getRandomCrateDelay()
    -- Random delay between 0.12-0.18 seconds
    return 0.12 + (math.random() * 0.06)
end

local function getBatchDelay()
    -- Random delay between batches: 0.7-1.3 seconds
    return 0.7 + (math.random() * 0.6)
end

-- 🕶️ Camo Crates
local autoOpenCamo = false
OpenTab:CreateToggle({
    Name = "🕶️ Camo Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenCamo = state
        if state then
            task.spawn(function()
                while autoOpenCamo do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenCamoCrate")
                            if remote then
                                remote:InvokeServer("Random")
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
                end
            end)
        end
    end
})

-- 👕 Outfit Crates
local autoOpenOutfit = false
OpenTab:CreateToggle({
    Name = "👕 Outfit Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenOutfit = state
        if state then
            task.spawn(function()
                while autoOpenOutfit do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenOutfitCrate")
                            if remote then
                                remote:InvokeServer(selectedOutfitType)
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
                end
            end)
        end
    end
})

-- 🐾 Pet Crates
local autoOpenPet = false
OpenTab:CreateToggle({
    Name = "🐾 Pet Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenPet = state
        if state then
            task.spawn(function()
                while autoOpenPet do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenPetCrate")
                            if remote then
                                remote:InvokeServer(1)
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
                end
            end)
        end
    end
})

-- 🔫 Weapon Crates
local autoOpenGun = false
OpenTab:CreateToggle({
    Name = "🔫 Weapon Crates",
    CurrentValue = false,
    Callback = function(state)
        autoOpenGun = state
        if state then
            task.spawn(function()
                while autoOpenGun do
                    pcall(function()
                        for i = 1, selectedQuantity do
                            local remote = ReplicatedStorage.Remotes:FindFirstChild("OpenGunCrate")
                            if remote then
                                remote:InvokeServer(1)
                                task.wait(getRandomCrateDelay())
                            end
                        end
                    end)
                    task.wait(getBatchDelay())
                end
            end)
        end
    end
})


-- Mod Tab
local ModTab = Window:CreateTab("🌀 Movement", "User")

-- Orbit System with Anti-Detection (Smooth Movement)
local spinning = false
local angle = 0
local speed = 5
local radius = 15
local lastCFrame = nil
local smoothness = 0.15 -- Interpolation smoothness (lower = smoother)

local TweenService = game:GetService("TweenService")
local HRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    HRP = char:WaitForChild("HumanoidRootPart")
    lastCFrame = nil -- Reset on respawn
end)

-- Boss finding with health check
local function findNearestBoss()
    local bosses = {
        workspace.Enemies:FindFirstChild("GoblinKing"),
        workspace.Enemies:FindFirstChild("CaptainBoom"),
        workspace.Enemies:FindFirstChild("Fungarth")
    }
    
    local nearestBoss = nil
    local shortestDistance = math.huge
    
    for _, boss in pairs(bosses) do
        if boss and boss:FindFirstChild("Head") then
            local humanoid = boss:FindFirstChild("Humanoid")
            -- Only target living bosses
            if humanoid and humanoid.Health > 0 then
                local distance = (boss.Head.Position - HRP.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestBoss = boss
                end
            end
        end
    end
    return nearestBoss
end

-- Smooth orbit with interpolation (prevents teleport detection)
RunService.RenderStepped:Connect(function(dt)
    if spinning and HRP then
        pcall(function()
            local boss = findNearestBoss()
            if boss and boss:FindFirstChild("Head") then
                -- Smooth angle progression
                angle = angle + (dt * speed)
                if angle >= math.pi * 2 then
                    angle = angle - math.pi * 2
                end
                
                local bossPos = boss.Head.Position
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
                local targetPos = bossPos + offset
                local targetCFrame = CFrame.new(
                    Vector3.new(targetPos.X, bossPos.Y, targetPos.Z),
                    Vector3.new(bossPos.X, bossPos.Y, bossPos.Z)
                )
                
                -- Smooth interpolation (avoids instant teleport)
                if lastCFrame then
                    HRP.CFrame = lastCFrame:Lerp(targetCFrame, smoothness)
                else
                    HRP.CFrame = targetCFrame
                end
                
                lastCFrame = HRP.CFrame
            end
        end)
    end
end)

ModTab:CreateToggle({
    Name = "🌪️ Orbit Boss (360° Smooth)",
    CurrentValue = false,
    Callback = function(value)
        spinning = value
        if value then
            angle = 0 -- Reset angle
            lastCFrame = nil -- Reset interpolation
        end
    end
})

ModTab:CreateSlider({
    Name = "⚡ Orbit Speed",
    Range = {1, 20},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 5,
    Callback = function(val)
        speed = val
    end
})

ModTab:CreateSlider({
    Name = "📏 Orbit Radius",
    Range = {5, 100},
    Increment = 1,
    Suffix = "units",
    CurrentValue = 15,
    Callback = function(val)
        radius = val
    end
})

ModTab:CreateSlider({
    Name = "🎯 Orbit Smoothness",
    Range = {0.05, 0.5},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.15,
    Callback = function(val)
        smoothness = val
    end
})


ModTab:CreateButton({
    Name = "🛸 TP & Smart Platform",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local HRP = player.Character and player.Character:WaitForChild("HumanoidRootPart")

        if not HRP then
            warn("❌ HumanoidRootPart not found")
            return
        end

        local currentPos = HRP.Position
        local targetPos = currentPos + Vector3.new(0, 60, 0)

        -- 🧱 Create platform
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(20, 1, 20)
        platform.Anchored = true
        platform.Position = targetPos - Vector3.new(0, 2, 0)
        platform.Color = Color3.fromRGB(120, 120, 120)
        platform.Material = Enum.Material.Metal
        platform.Name = "SmartPlatform"
        platform.Parent = workspace

        -- ⏫ Teleport player slightly above platform
        HRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))

        -- ⏱️ Self-destruct timer when player steps off
        local isStanding = true
        local lastTouch = tick()

        -- Check every frame
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not platform or not platform.Parent then
                conn:Disconnect()
                return
            end

            local char = player.Character
            local humanoidRoot = char and char:FindFirstChild("HumanoidRootPart")
            if not humanoidRoot then return end

            local rayOrigin = humanoidRoot.Position
            local rayDirection = Vector3.new(0, -5, 0)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            if raycastResult and raycastResult.Instance == platform then
                -- Player is standing on platform
                lastTouch = tick()
            end

            -- If more than 10 seconds have passed since player stood on it - destroy
            if tick() - lastTouch > 10 then
                platform:Destroy()
                conn:Disconnect()
            end
        end)
    end
})

-- ❄️ FREEZY HUB SETTINGS SECTION
MiscTab:CreateSection("❄️ Freezy HUB Settings")

MiscTab:CreateButton({
    Name = "🔌 Unload Freezy HUB",
    Callback = function()
        -- Disable all active features
        autoKill = false
        autoCollect = false
        autoOpenCrates = false
        orbitEnabled = false
        
        -- Clear any active tweens
        for item, _ in pairs(activeTweens or {}) do
            activeTweens[item] = nil
        end
        
        -- Reset player properties to normal
        pcall(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16 -- Default Roblox speed
                end
            end
        end)
        
        -- Clean up any created platforms
        pcall(function()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "SmartPlatform" then
                    obj:Destroy()
                end
            end
        end)
        
        -- Final notification and destroy GUI
        Rayfield:Notify({
            Title = "❄️ Freezy HUB",
            Content = "Script safely unloaded! Stay frosty! 🧊",
            Duration = 3,
            Image = 4483362458
        })
        
        -- Wait a moment then destroy the GUI
        task.wait(2)
        pcall(function()
            if Rayfield and Rayfield.Main then
                Rayfield.Main:Destroy()
            end
        end)
        
        -- Clean up global variables
        getgenv().FreezyHubLoaded = nil
    end
})

MiscTab:CreateButton({
    Name = "💾 Save Configuration",
    Callback = function()
        pcall(function()
            Rayfield:SaveConfiguration()
            Rayfield:Notify({
                Title = "❄️ Success",
                Content = "Configuration saved successfully!",
                Duration = 3,
                Image = 4483362458
            })
        end)
    end
})

-- Load config
Rayfield:LoadConfiguration()