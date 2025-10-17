-- Simplified main script to isolate issues
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

-- Wait for Remotes safely
local Remotes
task.spawn(function()
    Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    if not Remotes then
        warn("[Freezy HUB] Remotes folder not found - some features may not work")
    end
end)

-- Basic variables
local autoKill = false
local shootDelay = 0.1
local maxShootDistance = 200
local effectivenessLevel = 100
local stealthMode = false

-- Create window
local Window = Rayfield:CreateWindow({
    Name = "❄️ Freezy HUB ❄️ | POLY-Z | 🛡️ KnightMare Sync",
    Icon = 71338090068856,
    LoadingTitle = "🛡️ Initializing KnightMare Synchronicity...",
    LoadingSubtitle = "Advanced Detection Evasion Active",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FreezyHub",
        FileName = "FreezyConfig"
    }
})

-- Create combat tab
local CombatTab = Window:CreateTab("⚔️ Warfare", "Sword")

-- Create basic toggle
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

print("✓ Simplified script loaded successfully!")
