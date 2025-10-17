-- Test script to isolate loading issues
print("Starting test...")

-- Test 1: Basic services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
print("✓ Services loaded")

-- Test 2: Rayfield loading
local Rayfield
local success, error = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
end)

if not success then
    warn("Failed to load Rayfield:", error)
    return
end
print("✓ Rayfield loaded")

-- Test 3: Basic window creation
local Window = Rayfield:CreateWindow({
    Name = "Test Window",
    Icon = 71338090068856,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHUB",
        FileName = "Configuration"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Freezy HUB",
        Subtitle = "Key System",
        Note = "Join the discord (discord.gg/freezyhub)",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"freezyhub"}
    }
})

print("✓ Window created")

-- Test 4: Basic tab creation
local TestTab = Window:CreateTab("Test", "TestIcon")
print("✓ Tab created")

-- Test 5: Basic toggle creation
TestTab:CreateToggle({
    Name = "Test Toggle",
    CurrentValue = false,
    Flag = "TestToggle",
    Callback = function(state)
        print("Toggle state:", state)
    end
})
print("✓ Toggle created")

print("✓ All tests passed - script should load successfully!")
