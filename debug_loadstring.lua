-- Diagnostic script to identify loadstring issues
print("=== LOADSTRING DIAGNOSTIC START ===")

-- Test 1: Basic services
print("Test 1: Loading services...")
local success1, error1 = pcall(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    print("✓ Services loaded successfully")
end)

if not success1 then
    print("❌ Services failed:", error1)
    return
end

-- Test 2: Rayfield loading
print("Test 2: Loading Rayfield...")
local Rayfield
local success2, error2 = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
    print("✓ Rayfield loaded successfully")
end)

if not success2 then
    print("❌ Rayfield failed:", error2)
    return
end

-- Test 3: Window creation
print("Test 3: Creating window...")
local success3, error3 = pcall(function()
    local Window = Rayfield:CreateWindow({
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
    print("✓ Window created successfully")
end)

if not success3 then
    print("❌ Window creation failed:", error3)
    return
end

-- Test 4: Basic variables
print("Test 4: Testing variables...")
local success4, error4 = pcall(function()
    local effectivenessLevel = 50
    local shootDelay = 0.25
    local detectionRisk = 0
    local adaptiveDelay = 0.1
    print("✓ Variables initialized successfully")
end)

if not success4 then
    print("❌ Variable initialization failed:", error4)
    return
end

print("=== ALL TESTS PASSED ===")
print("The issue might be in the main script structure or a specific function.")
