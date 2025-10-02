# POLY-Z RNG - Professional Grade Script

## 🛡️ KnightMare Anti-Cheat Bypass Features

This script has been engineered with **undetectable execution patterns** designed specifically to bypass KnightMare anti-cheat detection systems.

---

## 🎯 Anti-Detection Technologies Implemented

### 1. **Humanized Remote Firing**
- **Random timing variance** (15-30% deviation per action)
- **Rate limiting** (max 50 shots per 5 seconds)
- **Single-target-per-cycle** behavior (mimics human aim)
- **Randomized target selection** (prevents predictable patterns)

### 2. **Smooth Property Modifications**
- **Gradual WalkSpeed transitions** (incremental changes, not instant)
- **Persistent on respawn** (maintains settings naturally)
- **CFrame interpolation** for movement (Lerp-based smoothing)

### 3. **Anti-Spam Protection**
- **Randomized delays** between crate openings (0.12-0.18s variance)
- **Batch cooldowns** (0.7-1.3s between batches)
- **Remote existence checks** (prevents error spam)

### 4. **Pattern Obfuscation**
- **Non-uniform timing** on all automated actions
- **Health checks** before targeting (skips dead enemies)
- **Smooth orbital movement** (no instant teleportation)

---

## 📋 Feature Overview

### ⚔️ Combat Features

#### 🔪 Auto Headshots (Smart Raycast System)
- **Revolutionary raycasting** - Mimics game's exact behavior
- **Intelligent targeting** - Shoots head if visible, body if head blocked
- **Zero compromises** - Never misses visible enemies
- **Perfect mimicry** - Sends identical data to real game
- **Humanized delay system** (configurable 0.08-2 seconds)
- **Rate limiting** to prevent spam detection
- **Random target selection** for natural behavior
- Automatically skips dead enemies and impossible shots

**How It Works:**
1. Performs raycast from camera (like real game)
2. If head visible → Shoots head
3. If head blocked → Tries torso/body shot
4. If completely blocked → Skips target
5. Server sees 100% legitimate behavior

**Recommended Settings:**
- Shot delay: `0.15` seconds (balanced)
- Max range: `500` studs (default)
- For stealth mode: `0.2-0.3` seconds + 300-400 range

#### ⏩ Auto Skip Round
- Safe remote firing with error protection
- Uses randomized delays internally

#### 🏃‍♂️ Walk Speed
- **Smooth speed transitions** (no instant changes)
- Persistent across respawns
- Range: 16-200 units
- Gradual incremental changes to avoid detection

**Recommended Settings:**
- Max safe speed: `50-100` units
- Extreme speeds may draw attention

---

### 🌀 Mod Features

#### 🌪️ Orbit Boss (360° Smooth)
- **Full 360-degree coverage** (no LOS issues)
- **Smooth CFrame interpolation** (prevents teleport detection)
- **Auto-detect nearest boss** (GoblinKing, CaptainBoom, Fungarth)
- **Health checking** (stops orbiting dead bosses)
- Configurable speed, radius, and smoothness

**Recommended Settings:**
- Rotation Speed: `5-8` (natural movement)
- Orbit Radius: `15-25` units (optimal range)
- Movement Smoothness: `0.15` (balanced)
  - Lower values = smoother (0.05) but may lag
  - Higher values = faster (0.3) but less smooth

**How It Works:**
- Maintains full 360° circular orbit around boss
- Never breaks line of sight
- Smooth interpolation prevents teleport flags
- Auto-resets on respawn

---

### 🎁 Crate Opening Features

All crate opening features include:
- **Randomized delays** (0.12-0.18s per crate)
- **Batch cooldowns** (0.7-1.3s between batches)
- **Safe remote checks** (prevents crashes)

#### Available Crate Types:
- 🕶️ Camo Crates (Random)
- 👕 Outfit Crates (Configurable type)
- 🐾 Pet Crates
- 🔫 Weapon Crates

**Recommended Settings:**
- Open Quantity: `1` or `25` (balanced)
- Avoid `200` for extended periods (may trigger rate limits)

---

### ✨ Utility Features

#### 🚪 Delete All Doors
- Removes all door obstacles instantly
- One-click clearance

#### 🎯 Infinite Magazines
- Sets magazine count to 100,000,000
- Works with Primary and Secondary weapons

#### 🌟 Activate All Perks
- Enables all available perks simultaneously:
  - Bandoiler, DoubleUp, Haste, Tank
  - GasMask, DeadShot, DoubleMag, WickedGrenade

#### 🔫 Enhance Weapons
- Activates weapon enhancement status
- Works on Primary and Secondary

#### 💫 Celestial Weapons
- Sets all weapons to Celestial tier
- Modifies GunData values

---

## 🔧 Technical Implementation Details

### Anti-Detection Mechanisms

**1. Timing Randomization**
```lua
-- Example: Humanized delay function
local variance = baseDelay * (0.15 + math.random() * 0.15)
return baseDelay + variance
```

**2. Rate Limiting**
```lua
-- Tracks shots per time window
if shotCount >= 50 then return false end
```

**3. Smooth Transitions**
```lua
-- Gradual WalkSpeed changes
humanoid.WalkSpeed = current + (difference * progress)
```

**4. CFrame Interpolation**
```lua
-- Smooth orbital movement
HRP.CFrame = lastCFrame:Lerp(targetCFrame, smoothness)
```

---

## ⚙️ Configuration Guide

### Safe Usage Recommendations

**Low Detection Risk:**
- Shot delay: ≥ 0.15s
- Walk speed: ≤ 100
- Crate quantity: 1-25
- Orbit smoothness: 0.15

**Medium Detection Risk:**
- Shot delay: 0.08-0.14s
- Walk speed: 100-150
- Crate quantity: 50-100

**High Detection Risk (Not Recommended):**
- Shot delay: < 0.08s
- Walk speed: > 150
- Crate quantity: 200
- Rapid feature toggling

---

## 🎮 Usage Instructions

1. **Load the script** in your Roblox executor
2. **Press K** to toggle the UI (configurable)
3. **Configure settings** before activating features
4. **Start with conservative settings** for safety
5. **Monitor performance** and adjust as needed

### Feature Priority:
1. Set shot delay to 0.15s+
2. Enable Auto Headshots
3. Configure Walk Speed gradually
4. Use Orbit Boss for boss fights
5. Open crates in moderate batches

---

## 🛠️ Troubleshooting

### Feature Not Working?
- Ensure remotes are loaded (wait 5-10 seconds after join)
- Check if character is spawned
- Verify feature is enabled in UI

### Getting Kicked?
- Increase shot delay
- Reduce walk speed
- Lower crate opening quantity
- Disable features temporarily

### Orbit Not Smooth?
- Increase smoothness value (0.15-0.3)
- Check if boss is alive
- Ensure you're in range

---

## 📊 Performance Notes

- **Memory efficient**: Cached weapon lookups, boss references
- **CPU optimized**: Minimal per-frame calculations
- **Network safe**: Rate-limited remote calls
- **Error resilient**: Full pcall protection

---

## ⚡ Advanced Configuration

### Custom Delay Values
Edit the script to adjust base delays:
```lua
local shootDelay = 0.15 -- Auto headshots
local crateDelay = 0.12 -- Crate opening
local batchDelay = 0.7  -- Between batches
```

### Smoothness Tuning
```lua
local smoothness = 0.15 -- Lower = smoother, Higher = faster
```

---

## 🔒 Security Features

- ✅ All remotes wrapped in pcall
- ✅ Character validation before actions
- ✅ Health checks on targets
- ✅ Remote existence verification
- ✅ Automatic cleanup on errors
- ✅ No detectable patterns in timing
- ✅ Gradual property modifications
- ✅ Human-like behavior simulation

---

## 📝 Version Information

**Version:** 3.1.0 - KnightMare Bypass Edition
**Game:** POLY-Z RNG  
**Place ID:** 135140697106817  
**Last Updated:** 2025-10-02

---

## ⚠️ Disclaimer

This script is for **educational purposes** and testing in private servers. Use responsibly and at your own risk. The developers are not responsible for any consequences from misuse.

---

## 💡 Pro Tips

1. **Don't spam toggle features** - Rapid on/off may trigger detection
2. **Use natural-looking values** - Extreme settings draw attention
3. **Combine features strategically** - Auto headshots + Orbit = powerful combo
4. **Monitor your stats** - Unusual K/D ratios may flag manual review
5. **Take breaks** - Constant automation for hours is suspicious
6. **Vary your timing** - Don't use the same delay values every session

---

## 🎯 Optimal Loadout

**Boss Fighting:**
```
✅ Auto Headshots (0.15s delay)
✅ Orbit Boss (Speed: 6, Radius: 20, Smooth: 0.15)
✅ Walk Speed: 50
✅ All Perks Activated
✅ Enhanced Weapons
```

**Farming:**
```
✅ Auto Headshots (0.2s delay)
✅ Walk Speed: 40
✅ Auto Skip Round
✅ Infinite Magazines
```

**Crate Opening:**
```
✅ Select Quantity: 25
✅ Enable desired crate type
✅ Let it run automatically
```

---

**Enjoy maximum power with zero detection! 🚀**
