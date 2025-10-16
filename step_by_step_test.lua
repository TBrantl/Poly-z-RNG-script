-- Step-by-step diagnostic to identify the exact loadstring issue
print("=== STEP-BY-STEP LOADSTRING DIAGNOSTIC ===")

-- Step 1: Test basic services
print("Step 1: Testing basic services...")
local success1, error1 = pcall(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    print("✓ Step 1 PASSED: Services loaded")
end)

if not success1 then
    print("❌ Step 1 FAILED:", error1)
    return
end

-- Step 2: Test Rayfield loading
print("Step 2: Testing Rayfield loading...")
local Rayfield
local success2, error2 = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
    print("✓ Step 2 PASSED: Rayfield loaded")
end)

if not success2 then
    print("❌ Step 2 FAILED:", error2)
    return
end

-- Step 3: Test window creation
print("Step 3: Testing window creation...")
local Window
local success3, error3 = pcall(function()
    Window = Rayfield:CreateWindow({
        Name = "❄️ Freezy HUB ❄️ | POLY-Z | 🛡️ KnightMare Sync",
        Icon = 71338090068856,
        LoadingTitle = "🛡️ Initializing KnightMare Synchronicity...",
        LoadingSubtitle = "Advanced Detection Evasion Active",
        Theme = "Ocean",
        ToggleUIKeybind = Enum.KeyCode.K,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "FreezyHub",
            FileName = "FreezyConfig"
        }
    })
    print("✓ Step 3 PASSED: Window created")
end)

if not success3 then
    print("❌ Step 3 FAILED:", error3)
    return
end

-- Step 4: Test tab creation
print("Step 4: Testing tab creation...")
local CombatTab
local success4, error4 = pcall(function()
    CombatTab = Window:CreateTab("⚔️ Warfare", "Sword")
    print("✓ Step 4 PASSED: Tab created")
end)

if not success4 then
    print("❌ Step 4 FAILED:", error4)
    return
end

-- Step 5: Test section creation
print("Step 5: Testing section creation...")
local success5, error5 = pcall(function()
    CombatTab:CreateSection("⚔️ Perfect Defense System")
    print("✓ Step 5 PASSED: Section created")
end)

if not success5 then
    print("❌ Step 5 FAILED:", error5)
    return
end

-- Step 6: Test variable initialization
print("Step 6: Testing variable initialization...")
local success6, error6 = pcall(function()
    local effectivenessLevel = 50
    local shootDelay = 0.25
    local detectionRisk = 0
    local adaptiveDelay = 0.1
    local autoKill = false
    local lastShot = 0
    local shotCount = 0
    local maxShootDistance = 250
    local lastValidationTime = 0
    local shotHistory = {}
    local stealthMode = true
    local sessionStartTime = tick()
    local behaviorProfile = {
        focusLevel = 0.5,
        fatigueLevel = 0,
        consistencyProfile = math.random() * 0.3 + 0.1,
        skillDrift = 0,
        lastFocusChange = tick(),
        lastFatigueChange = tick(),
    }
    print("✓ Step 6 PASSED: Variables initialized")
end)

if not success6 then
    print("❌ Step 6 FAILED:", error6)
    return
end

-- Step 7: Test function definitions
print("Step 7: Testing function definitions...")
local success7, error7 = pcall(function()
    local function getEquippedWeaponName()
        local model = workspace:FindFirstChild("Players"):FindFirstChild(game.Players.LocalPlayer.Name)
        if model then
            for _, child in ipairs(model:GetChildren()) do
                if child:IsA("Model") then
                    return child.Name
                end
            end
        end
        return "M1911"
    end
    
    local function updateEffectiveness(level)
        local scaleFactor = level / 100
        if level >= 99 then
            shootDelay = 0.005 - ((level - 99) / 1 * 0.004)
        elseif level >= 95 then
            shootDelay = 0.015 - ((level - 95) / 4 * 0.01)
        elseif level >= 85 then
            shootDelay = 0.03 - ((level - 85) / 10 * 0.015)
        elseif level >= 70 then
            shootDelay = 0.08 - ((level - 70) / 15 * 0.05)
        else
            shootDelay = 0.20 - (scaleFactor * 0.12)
        end
    end
    
    print("✓ Step 7 PASSED: Functions defined")
end)

if not success7 then
    print("❌ Step 7 FAILED:", error7)
    return
end

-- Step 8: Test slider creation
print("Step 8: Testing slider creation...")
local success8, error8 = pcall(function()
    local effectivenessLevel = 50
    CombatTab:CreateSlider({
        Name = "🎯 Combat Effectiveness",
        Range = {0, 100},
        Increment = 5,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "Effectiveness",
        Callback = function(Value)
            effectivenessLevel = Value
            Rayfield:Notify({
                Title = "🎯 EFFECTIVENESS UPDATED",
                Content = Value .. "% effectiveness",
                Duration = 3,
                Image = 4483362458
            })
        end
    })
    print("✓ Step 8 PASSED: Slider created")
end)

if not success8 then
    print("❌ Step 8 FAILED:", error8)
    return
end

-- Step 9: Test toggle creation
print("Step 9: Testing toggle creation...")
local success9, error9 = pcall(function()
    local autoKill = false
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
                    Duration = 4,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "🎯 PERFECT DEFENSE DISABLED",
                    Content = "Auto-headshot disabled",
                    Duration = 4,
                    Image = 4483362458
                })
            end
        end
    })
    print("✓ Step 9 PASSED: Toggle created")
end)

if not success9 then
    print("❌ Step 9 FAILED:", error9)
    return
end

-- Step 10: Test config loading
print("Step 10: Testing config loading...")
local success10, error10 = pcall(function()
    Rayfield:LoadConfiguration()
    print("✓ Step 10 PASSED: Config loaded")
end)

if not success10 then
    print("❌ Step 10 FAILED:", error10)
    return
end

print("=== ALL STEPS PASSED ===")
print("The issue might be in the complex combat loop or specific functions.")
print("Try the minimal working version first to confirm Rayfield works.")
