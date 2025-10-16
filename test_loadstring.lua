-- Test script to debug loadstring issues
local success, error = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2.lua"))()
end)

if success then
    print("✅ Loadstring executed successfully!")
else
    print("❌ Loadstring failed with error:")
    print(error)
end
