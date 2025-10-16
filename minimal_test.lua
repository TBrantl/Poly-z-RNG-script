-- Minimal test version to isolate issues
print("🔍 Testing minimal version...")

-- Basic services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Test Rayfield loading
local success, error = pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
    
    -- Create minimal window
    local Window = Rayfield:CreateWindow({
        Name = "Test Window",
        Icon = 71338090068856,
        Theme = "Ocean"
    })
    
    -- Create minimal tab
    local TestTab = Window:CreateTab("Test", "Sword")
    TestTab:CreateLabel("Test Label")
    
    print("✅ Minimal UI created successfully")
end)

if not success then
    print("❌ Minimal test failed:", error)
else
    print("🎉 Minimal test passed!")
end
