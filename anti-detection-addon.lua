-- Anti-Detection Addon for PolyzRNGV2
-- Add this BEFORE the main script loads

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ===== 1. NAMECALL HOOK (Intercept Remote Calls) =====
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Hook FireServer calls to modify suspicious parameters
    if method == "FireServer" or method == "InvokeServer" then
        local remoteName = self.Name
        
        -- Add random delays to ShootEnemy calls (anti-pattern detection)
        if remoteName == "ShootEnemy" then
            task.wait(math.random(1, 5) * 0.001) -- 1-5ms random delay
        end
        
        -- Block anti-cheat pings (if they exist)
        if remoteName:find("AntiCheat") or remoteName:find("KM_") or remoteName:find("Check") then
            return -- Silently block the call
        end
    end
    
    return oldNamecall(self, ...)
end)

print("[Anti-Detection] Namecall hook installed")

-- ===== 2. ANTI-KICK PROTECTION =====
local oldKick
oldKick = hookmetamethod(game.Players.LocalPlayer, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then
        warn("[Anti-Kick] Blocked kick attempt!")
        return -- Block the kick
    end
    return oldKick(self, ...)
end)

-- Also hook the Kick function directly
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldKickFunc = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == player and method == "Kick" then
        warn("[Anti-Kick] Prevented kick!")
        return
    end
    return oldKickFunc(self, ...)
end)
setreadonly(mt, true)

print("[Anti-Detection] Anti-kick protection enabled")

-- ===== 3. ENVIRONMENT SPOOFING =====
-- Spoof common detection checks
local function spoofEnvironment()
    -- Hide common executor globals
    local suspiciousGlobals = {
        "syn", "Synapse", "SENTINEL_V2", "KRNL", "OXYGEN_LOADED",
        "protosmasher", "WrapGlobal", "issentinelclosure", "is_synapse_function",
        "fluxus", "arceus", "delta"
    }
    
    for _, global in ipairs(suspiciousGlobals) do
        if _G[global] then
            _G[global] = nil
        end
        if getgenv()[global] then
            getgenv()[global] = nil
        end
    end
end

spoofEnvironment()
print("[Anti-Detection] Environment spoofed")

-- ===== 4. HEARTBEAT RANDOMIZATION =====
-- Add random micro-delays to avoid perfect timing detection
local heartbeatHook = game:GetService("RunService").Heartbeat:Connect(function()
    if math.random(1, 100) <= 5 then -- 5% chance
        task.wait(math.random(1, 10) * 0.001) -- 1-10ms delay
    end
end)

print("[Anti-Detection] Heartbeat randomization active")

-- ===== 5. ATTRIBUTE CHANGE SMOOTHING =====
-- Smooth attribute changes to avoid instant 9999 health spikes
local function smoothSetAttribute(instance, attribute, targetValue, duration)
    duration = duration or 0.5
    local currentValue = instance:GetAttribute(attribute) or 0
    local startTime = tick()
    
    task.spawn(function()
        while tick() - startTime < duration do
            local progress = (tick() - startTime) / duration
            local newValue = currentValue + (targetValue - currentValue) * progress
            instance:SetAttribute(attribute, newValue)
            task.wait(0.05)
        end
        instance:SetAttribute(attribute, targetValue)
    end)
end

-- Expose smooth setter
getgenv().smoothSetAttribute = smoothSetAttribute

print("[Anti-Detection] Smooth attribute system loaded")

-- ===== 6. REMOTE SPY BLOCKER =====
-- Block common remote spy tools
local function blockRemoteSpies()
    local suspiciousGUIs = {
        "SimpleSpy", "RemoteSpy", "Hydroxide", "Dex", "DarkDex"
    }
    
    for _, gui in ipairs(suspiciousGUIs) do
        local found = player.PlayerGui:FindFirstChild(gui)
        if found then
            found:Destroy()
            warn("[Anti-Detection] Removed remote spy: " .. gui)
        end
    end
end

task.spawn(function()
    while true do
        blockRemoteSpies()
        task.wait(5)
    end
end)

print("[Anti-Detection] Remote spy blocker active")

-- ===== 7. DETECTION ALERTS =====
-- Monitor for detection attempts
local Variables = player:WaitForChild("Variables")
local lastHealthCheck = 0

Variables:GetAttributeChangedSignal("Health"):Connect(function()
    local currentHealth = Variables:GetAttribute("Health")
    -- If health suddenly drops to 0 (possible detection/kill)
    if currentHealth <= 0 and tick() - lastHealthCheck < 0.1 then
        warn("[Anti-Detection] Possible detection! Health set to 0")
    end
    lastHealthCheck = tick()
end)

print("[Anti-Detection] Detection monitor active")

print("========================================")
print("✅ All Anti-Detection Systems Loaded!")
print("========================================")

