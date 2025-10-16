-- Comprehensive debug script to identify loadstring issues
print("🔍 Starting loadstring debug...")

-- Test 1: Basic HTTP request
local success1, error1 = pcall(function()
    local content = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
    print("✅ HTTP request successful, content length:", #content)
    return content
end)

if not success1 then
    print("❌ HTTP request failed:", error1)
    return
end

-- Test 2: Loadstring compilation
local success2, error2 = pcall(function()
    local content = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
    local func = loadstring(content)
    print("✅ Loadstring compilation successful")
    return func
end)

if not success2 then
    print("❌ Loadstring compilation failed:", error2)
    return
end

-- Test 3: Function execution
local success3, error3 = pcall(function()
    local content = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
    local func = loadstring(content)
    func()
    print("✅ Function execution successful")
end)

if not success3 then
    print("❌ Function execution failed:", error3)
    return
end

print("🎉 All tests passed! Loadstring should work.")
