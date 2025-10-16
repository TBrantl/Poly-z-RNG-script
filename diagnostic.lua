-- Comprehensive diagnostic script
print("🔍 Starting comprehensive diagnostic...")

-- Test 1: Basic services
print("Test 1: Basic services...")
local success1, error1 = pcall(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    print("✅ Services loaded successfully")
end)

if not success1 then
    print("❌ Services failed:", error1)
    return
end

-- Test 2: HTTP request
print("Test 2: HTTP request...")
local success2, error2 = pcall(function()
    local content = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
    print("✅ HTTP request successful, content length:", #content)
    print("First 200 characters:", string.sub(content, 1, 200))
end)

if not success2 then
    print("❌ HTTP request failed:", error2)
    return
end

-- Test 3: Rayfield loading
print("Test 3: Rayfield loading...")
local success3, error3 = pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://limerbro.github.io/Roblox-Limer/rayfield.lua'))()
    print("✅ Rayfield loaded successfully")
end)

if not success3 then
    print("❌ Rayfield loading failed:", error3)
    return
end

-- Test 4: Script compilation
print("Test 4: Script compilation...")
local success4, error4 = pcall(function()
    local content = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
    local func = loadstring(content)
    print("✅ Script compilation successful")
end)

if not success4 then
    print("❌ Script compilation failed:", error4)
    return
end

-- Test 5: Script execution (with error catching)
print("Test 5: Script execution...")
local success5, error5 = pcall(function()
    local content = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
    local func = loadstring(content)
    func()
    print("✅ Script execution successful")
end)

if not success5 then
    print("❌ Script execution failed:", error5)
    print("Error details:", tostring(error5))
    return
end

print("🎉 All tests passed! The script should work.")
