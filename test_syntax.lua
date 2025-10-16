-- Test syntax by loading the main script
local success, error = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TBrantl/Poly-z-RNG-script/main/PolyzRNGV2_clean.lua"))()
end)

if success then
    print("✓ Script loaded successfully!")
else
    print("✗ Script failed to load:", error)
end
