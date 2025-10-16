-- Simple test to check if basic functionality works
print("🔍 Testing basic functionality...")

-- Test 1: Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
print("✅ Services loaded")

-- Test 2: Rayfield loading
local success, error = pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
    print("✅ Rayfield loaded successfully")
    return Rayfield
end)

if not success then
    print("❌ Rayfield loading failed:", error)
    return
end

print("🎉 Basic test passed!")
