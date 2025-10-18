-- Simple test version to identify loading issues
print("🚀 Starting Lightweight Test Script...")

-- Global error protection
local success, error = pcall(function()
    print("🚀 Inside pcall wrapper...")
    
    -- Services
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    
    print("🚀 Services loaded...")
    
    -- Load Rayfield UI Library
    local Rayfield
    local rayfieldSuccess, rayfieldError = pcall(function()
        print("🚀 Attempting to load Rayfield...")
        Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
        print("🚀 Rayfield loaded successfully!")
    end)
    
    if not rayfieldSuccess then
        warn("[Test] Failed to load Rayfield UI Library:", rayfieldError)
        print("🚀 Trying backup Rayfield URL...")
        
        -- Try backup URL
        local backupSuccess, backupError = pcall(function()
            Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/synnyyy/RobloxLua/main/Rayfield'))()
        end)
        
        if not backupSuccess then
            warn("[Test] Backup Rayfield also failed:", backupError)
            return
        else
            print("🚀 Backup Rayfield loaded successfully!")
        end
    end
    
    print("🚀 Creating window...")
    
    -- Create simple window
    local Window = Rayfield:CreateWindow({
        Name = "🚀 TEST WINDOW 🚀",
        Icon = 71338090068856,
        LoadingTitle = "🚀 Test Loading...",
        LoadingSubtitle = "Testing script loading",
        Theme = "Ocean",
        ToggleUIKeybind = Enum.KeyCode.K,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "TestHub",
            FileName = "TestConfig"
        }
    })
    
    print("🚀 Window created successfully!")
    
    -- Create simple tab
    local TestTab = Window:CreateTab("🧪 Test", "Test")
    
    TestTab:CreateLabel({
        Text = "🚀 Test Script Loaded Successfully!",
        Description = "If you can see this, the script is working!"
    })
    
    TestTab:CreateButton({
        Name = "🚀 Test Button",
        Callback = function()
            print("🚀 Test button clicked!")
            Rayfield:Notify({
                Title = "🚀 Test Success",
                Content = "Script is working properly!",
                Duration = 3,
                Image = 4483362458
            })
        end
    })
    
    print("🚀 Test script completed successfully!")
    
end) -- Close pcall wrapper

if not success then
    warn("[Test] Script failed to load:", error)
    print("🚀 Error details:", error)
else
    print("🚀 Test script loaded successfully!")
end
