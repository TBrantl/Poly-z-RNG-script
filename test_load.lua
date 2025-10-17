-- DIAGNOSTIC TEST SCRIPT
print("========================================")
print("FREEZY HUB - DIAGNOSTIC TEST")
print("========================================")
print("Test 1: Script executed successfully")

-- Test HttpGet
print("Test 2: Testing HttpGet...")
local testGet = game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua")
if testGet then
    print("Test 2: HttpGet SUCCESS - Downloaded " .. #testGet .. " characters")
else
    print("Test 2: HttpGet FAILED")
end

-- Test loadstring
print("Test 3: Testing loadstring...")
local success, func = pcall(function()
    return loadstring(testGet)
end)

if success and func then
    print("Test 3: Loadstring SUCCESS")
    print("Test 4: Executing script...")
    local execSuccess, execError = pcall(func)
    if execSuccess then
        print("Test 4: Script execution SUCCESS")
    else
        print("Test 4: Script execution FAILED: " .. tostring(execError))
    end
else
    print("Test 3: Loadstring FAILED: " .. tostring(func))
end

print("========================================")
print("DIAGNOSTIC TEST COMPLETE")
print("========================================")

