-- Pet Crate Opener Script
-- Uses OpenPetCrate remote to open pet crates with specified settings

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield
local rayfieldSuccess, rayfieldError = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
end)

if not rayfieldSuccess then
    warn("[PetCrateOpener] Failed to load Rayfield UI Library:", rayfieldError)
    -- Try backup URL
    local backupSuccess, backupError = pcall(function()
        Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/synnyyy/RobloxLua/main/Rayfield'))()
    end)
    
    if not backupSuccess then
        warn("[PetCrateOpener] Backup Rayfield also failed:", backupError)
        return
    end
end

-- Wait for Remotes safely
local OpenPetCrate
task.spawn(function()
    OpenPetCrate = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("OpenPetCrate", 10)
    if not OpenPetCrate then
        warn("[PetCrateOpener] OpenPetCrate remote not found")
    end
end)

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "🐾 Pet Crate Opener 🐾",
    Icon = 71338090068856,
    LoadingTitle = "🐾 Loading Pet Crate Opener...",
    LoadingSubtitle = "Open pet crates with custom settings",
    Theme = "Ocean",
    ToggleUIKeybind = Enum.KeyCode.P,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PetCrateOpener",
        FileName = "PetCrateConfig"
    }
})

-- Pet Tab
local PetTab = Window:CreateTab("🐾 Pet Crates", "Pet")

-- Variables
local isOpening = false
local openCount = 0
local totalOpened = 0

-- Pet rarity settings
local petSettings = {
    common = true,
    standard = false,
    cosmic = false,
    uncommon = true,
    rare = true,
    legendary = true,
    epic = true,
    immortal = true,
    godly = true
}

-- Function to open a pet crate
local function openPetCrate()
    if not OpenPetCrate then
        warn("[PetCrateOpener] OpenPetCrate remote not available")
        return false
    end
    
    local success, result = pcall(function()
        return OpenPetCrate:InvokeServer(
            1, -- Crate ID (1 = first crate)
            petSettings, -- Pet rarity settings
            1 -- Quantity
        )
    end)
    
    if success then
        openCount = openCount + 1
        totalOpened = totalOpened + 1
        return true
    else
        warn("[PetCrateOpener] Failed to open pet crate:", result)
        return false
    end
end

-- Pet Settings Section
PetTab:CreateSection("🐾 Pet Rarity Settings")

-- Create toggles for each pet rarity
local rarityToggles = {}

local rarities = {
    {name = "Common", key = "common", color = "⚪"},
    {name = "Standard", key = "standard", color = "⚫"},
    {name = "Cosmic", key = "cosmic", color = "🌌"},
    {name = "Uncommon", key = "uncommon", color = "🟢"},
    {name = "Rare", key = "rare", color = "🔵"},
    {name = "Legendary", key = "legendary", color = "🟡"},
    {name = "Epic", key = "epic", color = "🟣"},
    {name = "Immortal", key = "immortal", color = "🟠"},
    {name = "Godly", key = "godly", color = "✨"}
}

for _, rarity in ipairs(rarities) do
    rarityToggles[rarity.key] = PetTab:CreateToggle({
        Name = rarity.color .. " " .. rarity.name,
        CurrentValue = petSettings[rarity.key],
        Flag = "PetRarity_" .. rarity.key,
        Callback = function(state)
            petSettings[rarity.key] = state
            Rayfield:Notify({
                Title = "🐾 " .. rarity.name .. " " .. (state and "ENABLED" or "DISABLED"),
                Content = rarity.name .. " pets are now " .. (state and "included" or "excluded"),
                Duration = 2,
                Image = 4483362458
            })
        end
    })
end

-- Auto-Opener Section
PetTab:CreateSection("🚀 Auto-Opener")

-- Open Count Display
local openCountLabel = PetTab:CreateLabel("📊 Opened: 0 crates")
local totalCountLabel = PetTab:CreateLabel("📈 Total: 0 crates")

-- Update count labels
local function updateCounts()
    openCountLabel:Set("📊 Opened: " .. openCount .. " crates")
    totalCountLabel:Set("📈 Total: " .. totalOpened .. " crates")
end

-- Auto-Opener Toggle
PetTab:CreateToggle({
    Name = "🚀 Auto-Open Pet Crates",
    CurrentValue = false,
    Flag = "AutoOpen",
    Callback = function(state)
        isOpening = state
        if state then
            Rayfield:Notify({
                Title = "🚀 AUTO-OPENER STARTED",
                Content = "Automatically opening pet crates...",
                Duration = 3,
                Image = 4483362458
            })
            
            -- Auto-opener loop
            task.spawn(function()
                while isOpening do
                    pcall(function()
                        if OpenPetCrate then
                            local success = openPetCrate()
                            if success then
                                updateCounts()
                            end
                        end
                    end)
                    
                    -- Wait between opens (adjust delay as needed)
                    task.wait(0.5) -- 0.5 second delay between opens
                end
            end)
        else
            Rayfield:Notify({
                Title = "🚀 AUTO-OPENER STOPPED",
                Content = "Stopped opening pet crates",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

-- Manual Open Button
PetTab:CreateButton({
    Name = "🐾 Open Single Crate",
    Callback = function()
        if OpenPetCrate then
            local success = openPetCrate()
            if success then
                updateCounts()
                Rayfield:Notify({
                    Title = "🐾 CRATE OPENED",
                    Content = "Successfully opened pet crate!",
                    Duration = 2,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "❌ FAILED TO OPEN",
                    Content = "Failed to open pet crate",
                    Duration = 2,
                    Image = 4483362458
                })
            end
        else
            Rayfield:Notify({
                Title = "❌ REMOTE NOT FOUND",
                Content = "OpenPetCrate remote not available",
                Duration = 2,
                Image = 4483362458
            })
        end
    end
})

-- Reset Counts Button
PetTab:CreateButton({
    Name = "🔄 Reset Counts",
    Callback = function()
        openCount = 0
        totalOpened = 0
        updateCounts()
        Rayfield:Notify({
            Title = "🔄 COUNTS RESET",
            Content = "All counts have been reset",
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Settings Section
PetTab:CreateSection("⚙️ Settings")

-- Crate ID Slider
PetTab:CreateSlider({
    Name = "📦 Crate ID",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "CrateID",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "📦 CRATE ID SET",
            Content = "Crate ID set to: " .. Value,
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Quantity Slider
PetTab:CreateSlider({
    Name = "🔢 Quantity",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "Quantity",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "🔢 QUANTITY SET",
            Content = "Quantity set to: " .. Value,
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- Load config
Rayfield:LoadConfiguration()
