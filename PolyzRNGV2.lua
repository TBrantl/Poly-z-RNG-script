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
        warn("[POLY-Z V2] Remotes folder not found - some features may not work")
    end
end)

-- UI Window Configuration
local Window = Rayfield:CreateWindow({
    Name = "✨ LimerHub V2 ✨ | POLY-Z",
    Icon = 71338090068856,
    LoadingTitle = "Loading V2...",
    LoadingSubtitle = "Enhanced Features",
    Theme = "BlackWhite",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ZombieHub",
        FileName = "ConfigV2"
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
local CombatTab = Window:CreateTab("⚔️ Combat", "Skull")

-- Weapon Label
local weaponLabel = CombatTab:CreateLabel("🔫 Current Weapon: Loading...")

-- Update label
task.spawn(function()
    while true do
        weaponLabel:Set("🔫 Current Weapon: " .. getEquippedWeaponName())
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
            
            -- Last resort: Try ANY part in the model that's visible
            for _, part in pairs(targetModel:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local partDir = (part.Position - origin).Unit
                    local partDist = (part.Position - origin).Magnitude
                    
                    if partDist <= maxShootDistance then
                        local partRay = workspace:Raycast(origin, partDir * partDist, raycastParams)
                        
                        if partRay and partRay.Instance:IsDescendantOf(workspace.Enemies) then
                            return partRay.Position, partRay.Instance
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
    Name = "⏱️ Shot delay (0.08-2 sec)",
    PlaceholderText = "0.15",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0.08 and num <= 2 then
            shootDelay = num
            Rayfield:Notify({
                Title = "Success",
                Content = "Shot delay set to "..num.." seconds",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a number between 0.08 and 2",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Max Shoot Range",
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
    Name = "🔪 Auto Headshots (Smart Ray)",
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
                                    local aBoss = a.model.Name:match("King") or a.model.Name:match("Captain") or 
                                                  a.model.Name:match("Fungarth") or a.model.Name:match("Boss")
                                    local bBoss = b.model.Name:match("King") or b.model.Name:match("Captain") or 
                                                  b.model.Name:match("Fungarth") or b.model.Name:match("Boss")
                                    
                                    -- Bosses always first
                                    if aBoss and not bBoss then return true end
                                    if bBoss and not aBoss then return false end
                                    
                                    -- If both bosses or both regular, prioritize by distance (closer first)
                                    return a.distance < b.distance
                                end)
                                
                                -- Try each target until we find one we can shoot
                                local shotFired = false
                                for _, target in ipairs(validTargets) do
                                    -- Smart raycast - returns actual hit position and part
                                    local hitPos, hitPart = getSmartShotPosition(target.head, target.model)
                                    
                                    if hitPos and hitPart then
                                        -- We can shoot this target!
                                        -- Args match EXACTLY what the game sends:
                                        -- (EnemyModel, HitPart, HitPosition, Damage, WeaponName)
                                        local args = {target.model, hitPart, hitPos, 0.5, weapon}
                                        
                                        local success = pcall(function()
                                            shootRemote:FireServer(unpack(args))
                                        end)
                                        
                                        if success then
                                            lastShot = tick()
                                            shotCount = shotCount + 1
                                            shotFired = true
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
    Name = "⏩ Auto Skip Round",
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
local MiscTab = Window:CreateTab("✨ Utilities", "Sparkles")

MiscTab:CreateSection("💰 Auto Collection")

-- Auto Collect System (Enhanced - Large Radius)
local autoCollect = false
local collectRadius = 150 -- Increased for better coverage
local lastCollectTime = 0
local collectCooldown = 0.05 -- Faster collection

-- Smart collection function
local function collectNearbyItems()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local currentTime = tick()
    if currentTime - lastCollectTime < collectCooldown then return end
    
    pcall(function()
        -- Method 1: Check for ProximityPrompts (common in modern games)
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                local parent = descendant.Parent
                if parent and parent:IsA("BasePart") then
                    local distance = (parent.Position - root.Position).Magnitude
                    
                    -- Check if it's a collectible (gold, drops, etc.)
                    local isCollectible = parent.Name:match("Gold") or 
                                         parent.Name:match("Drop") or
                                         parent.Name:match("Coin") or
                                         parent.Name:match("Money") or
                                         parent.Name:match("Cash") or
                                         descendant.ObjectText:match("Collect") or
                                         descendant.ObjectText:match("Pick")
                    
                    if isCollectible and distance <= collectRadius then
                        -- Trigger the prompt
                        fireproximityprompt(descendant)
                        lastCollectTime = currentTime
                        task.wait(0.05)
                    end
                end
            end
        end
        
        -- Method 2: Check for ClickDetectors (older games)
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant:IsA("ClickDetector") then
                local parent = descendant.Parent
                if parent and parent:IsA("BasePart") then
                    local distance = (parent.Position - root.Position).Magnitude
                    
                    local isCollectible = parent.Name:match("Gold") or 
                                         parent.Name:match("gold") or
                                         parent.Name:match("Drop") or
                                         parent.Name:match("drop") or
                                         parent.Name:match("Coin") or
                                         parent.Name:match("coin") or
                                         parent.Name:match("Money") or
                                         parent.Name:match("money") or
                                         parent.Name:match("Cash") or
                                         parent.Name:match("cash") or
                                         parent.Name:match("Loot") or
                                         parent.Name:match("loot")
                    
                    if isCollectible and distance <= collectRadius then
                        fireclickdetector(descendant)
                        lastCollectTime = currentTime
                        task.wait(0.05)
                    end
                end
            end
        end
        
        -- Method 3: Touch-based collection (multiple folder search)
        local searchFolders = {
            workspace:FindFirstChild("Drops"),
            workspace:FindFirstChild("DroppedItems"),
            workspace:FindFirstChild("Collectables"),
            workspace:FindFirstChild("Collectibles"),
            workspace:FindFirstChild("Loot"),
            workspace:FindFirstChild("Items"),
            workspace:FindFirstChild("Gold")
        }
        
        for _, folder in ipairs(searchFolders) do
            if folder then
                for _, item in pairs(folder:GetChildren()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local itemPos = item:IsA("Model") and item:GetPivot().Position or item.Position
                        local distance = (itemPos - root.Position).Magnitude
                        
                        -- Check if item name suggests it's collectible
                        local nameCheck = item.Name:match("Gold") or item.Name:match("gold") or
                                         item.Name:match("Drop") or item.Name:match("drop") or
                                         item.Name:match("Coin") or item.Name:match("coin") or
                                         item.Name:match("Money") or item.Name:match("money") or
                                         item.Name:match("Cash") or item.Name:match("cash") or
                                         item.Name:match("Loot") or item.Name:match("loot")
                        
                        if (nameCheck or folder.Name:match("Drop") or folder.Name:match("Gold")) and 
                           distance <= collectRadius and distance > 2 then
                            -- Brief teleport to touch item
                            local originalCFrame = root.CFrame
                            root.CFrame = CFrame.new(itemPos + Vector3.new(0, 1, 0))
                            task.wait(0.03)
                            root.CFrame = originalCFrame
                            lastCollectTime = currentTime
                            task.wait(0.02)
                        end
                    end
                end
            end
        end
    end)
end

MiscTab:CreateToggle({
    Name = "💰 Auto Collect Items",
    CurrentValue = false,
    Flag = "AutoCollect",
    Callback = function(state)
        autoCollect = state
        if state then
            Rayfield:Notify({
                Title = "Auto Collect",
                Content = "Now collecting nearby items!",
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
    Name = "📏 Collection Radius",
    Range = {50, 200},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 150,
    Flag = "CollectRadius",
    Callback = function(Value)
        collectRadius = Value
    end
})

MiscTab:CreateSection("🔧 Tools")

MiscTab:CreateButton({
    Name = "🚪 Delete All Doors",
    Callback = function()
        local doorsFolder = workspace:FindFirstChild("Doors")
        if doorsFolder then
            for _, group in pairs(doorsFolder:GetChildren()) do
                if group:IsA("Folder") or group:IsA("Model") then
                    group:Destroy()
                end
            end
            Rayfield:Notify({
                Title = "Success",
                Content = "All doors deleted!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

MiscTab:CreateButton({
    Name = "🎯 Infinite Magazines",
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
            Title = "Magazines",
            Content = "Infinite magazines set!",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateSection("💎 Enhancements (FUNCTIONAL)")

MiscTab:CreateButton({
    Name = "🌟 Activate All Perks (FULL)",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then 
            Rayfield:Notify({
                Title = "Error",
                Content = "Variables not found! Wait for game to load.",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        local perks = {  
            "Bandoiler_Perk",      -- +30% max ammo
            "DoubleUp_Perk",       -- 2x points per kill
            "Haste_Perk",          -- +20% movement speed
            "Tank_Perk",           -- +100 HP
            "GasMask_Perk",        -- Immunity to gas
            "DeadShot_Perk",       -- +33% damage
            "DoubleMag_Perk",      -- 2x magazine size
            "WickedGrenade_Perk"   -- Better grenades
        }  

        local activated = 0
        for _, perk in ipairs(perks) do  
            pcall(function()
                vars:SetAttribute(perk, true)
                activated = activated + 1
            end)
        end
        
        Rayfield:Notify({
            Title = "Perks Activated",
            Content = activated .. "/8 perks enabled (FUNCTIONAL)",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MiscTab:CreateButton({
    Name = "🔫 Enhance Weapons (FULL)",
    Callback = function()
        local vars = player:FindFirstChild("Variables")
        if not vars then 
            Rayfield:Notify({
                Title = "Error",
                Content = "Variables not found!",
                Duration = 3,
                Image = 4483362458
            })
            return 
        end

        -- Weapon enhancements (Pack-a-Punch style)
        local enchants = {  
            "Primary_Enhanced",   -- +50% damage, special effects
            "Secondary_Enhanced"  -- +50% damage, special effects
        }  

        local enhanced = 0
        for _, attr in ipairs(enchants) do  
            pcall(function()
                vars:SetAttribute(attr, true)
                enhanced = enhanced + 1
            end)
        end
        
        Rayfield:Notify({
            Title = "Weapons Enhanced",
            Content = enhanced .. "/2 weapons upgraded (FUNCTIONAL)",
            Duration = 3,
            Image = 4483362458
        })
    end
})


MiscTab:CreateButton({
    Name = "💫 Transcendent Weapons (MAX)",
    Callback = function()
        local gunData = player:FindFirstChild("GunData")
        if not gunData then 
            Rayfield:Notify({
                Title = "Error",
                Content = "GunData not found!",
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
            Title = "Transcendent Applied",
            Content = modified .. " weapons set to MAX tier (0.00004% rarity!)",
            Duration = 3,
            Image = 4483362458
        })
    end
})

-- Open Tab
local OpenTab = Window:CreateTab("🎁 Crates", "Gift")

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
local ModTab = Window:CreateTab("🌀 Mods", "Skull")

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
    Name = "⚡ Rotation Speed",
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
    Name = "🎯 Movement Smoothness",
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




-- Load config
Rayfield:LoadConfiguration()