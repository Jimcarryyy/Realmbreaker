# 📜 Game Rules & Design Constraints

## ☯️ Cultivation & Advancement
1. **Breakthrough Requirements**: Realm advancement must NEVER be a passive clicker button. Advancing requires defeating a tribulation, solving a realm puzzle, or conquering a rare catalyst item.
2. **Multi-Track Progression**: Raw Realm level alone does not dictate victory. Body Cultivation grants defense/stagger resistance; Soul Cultivation grants Qi capacity/range; Dao Paths alter element behaviors; Weapon Mastery unlocks skill combo chains.

## ⚔️ Combat
1. **Server Authority**: The client requests skill casts and reports aim vectors; the server validates cooldowns, Qi costs, character states (not stunned), and computes hitboxes.
2. **Skill Over Raw Stats**: Higher realm players have advantages, but a lower realm player utilizing perfect parries, dodges, and combos must be able to outplay them.
3. **Anime Feel**: High mobility, snappy cancelable dashes, impactful VFX on hit, clear telegraphs for heavy skills.

## 🌍 World & Exploration
1. **No Empty Maps**: Every zone defined in `ZoneData.lua` must feature hidden caves, secret manuals, or rare resource nodes (`NodeData.lua`).
2. **Open World Conflict**: Dangerous zones allow open PvP over ancient relic spawns and high-grade Qi gathering spots.