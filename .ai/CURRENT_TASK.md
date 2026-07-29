# 🎯 Current Task: Skill Polish & Visual Integration

## 🛠️ Objective
Bridge the server-authoritative skill pipeline with client-side animations, hitboxes, and particle VFX to deliver responsive, skill-based anime combat.

## 📋 Specific Requirements & File Touches
1. **`src/ReplicatedStorage/Shared/Configs/SkillData.lua`**:
   - Define exact metadata (AnimationID, VFXEffectName, SoundID, QiCost, Cooldown, HitboxDimensions) for starter skills (`MortalStrike`, `QiBlast`, `GaleDash`).
2. **`src/ServerScriptService/Services/SkillExecutors.lua`**:
   - Implement spatial spatial/overlap querying (`Workspace:GetPartsInPart` / `GetPartBoundsInBox`) for hit detection.
   - Calculate damage scaling using cultivation realm stats from `CultivationService.lua`.
3. **`src/StarterPlayer/StarterPlayerScripts/Controllers/SkillEffectController.client.lua`**:
   - Hook into `SkillExecuted` RemoteEvent to load and play animations from `Animations.lua`.
   - Instantiate client-side particle emitters and camera shakes.
4. **`src/StarterPlayer/StarterPlayerScripts/Controllers/CultivationUIController.client.lua`**:
   - Smoothly interpolate Qi/Health resource bars when skills consume Qi or deal damage.