-- Minimal test version to isolate loading issues
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load Rayfield UI Library with error handling
local Rayfield
local success, error = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
end)

if not success then
    warn("[Freezy HUB] Failed to load Rayfield UI Library:", error)
    return
end

-- Create simple window
local Window = Rayfield:CreateWindow({
    Name = "❄️ Test HUB ❄️",
    Icon = 71338090068856,
    LoadingTitle = "Loading Freezy HUB...",
    LoadingSubtitle = "by Freezy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHUB",
        FileName = "FreezyHUBConfig"
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
        Note = "Join the discord (discord.gg/freezy) to get the key!",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"freezy"}
    }
})

-- Create simple tab
local TestTab = Window:CreateTab("🧪 Test", "Test")

-- Create simple toggle
TestTab:CreateToggle({
    Name = "🧪 Test Toggle",
    CurrentValue = false,
    Flag = "TestToggle",
    Callback = function(state)
        print("Test toggle:", state)
    end
})

print("✓ Minimal test version loaded successfully!")
