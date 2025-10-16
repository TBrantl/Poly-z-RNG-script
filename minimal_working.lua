-- Minimal working version for testing
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

-- Create window
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

-- Create combat tab
local CombatTab = Window:CreateTab("⚔️ Warfare", "Sword")

-- Create section
CombatTab:CreateSection("⚔️ Perfect Defense System")

-- Create effectiveness slider
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

-- Create auto-headshot toggle
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

-- Load config
Rayfield:LoadConfiguration()

print("✓ Minimal working version loaded successfully!")
