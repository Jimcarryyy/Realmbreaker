# 🗡️ Realmbreaker – Xianxia Action MMORPG

**Platform:** Roblox (PC, Mobile, Console)  
**Language:** Luau (`--!strict`)  
**Genre:** Action Xianxia / Wuxia Cultivation MMORPG  
**Architecture:** Server-Authoritative, Modular Workflow (`ProfileService`, `ReplicaService`, `Rojo`)

---

## 📐 1. Core Philosophy & Design Pillars

1. **Skill-Based Combat over AFK Bloat:** Mechanical mastery over passive auto-clicking. Progression is driven by frame-precise parrying, stamina management, martial stances, and cultivation breakthroughs.
2. **Strict Anti-Stat-Bloat Scale:** Health is capped at **100 HP to 370 HP max** across launch realms (V1.0). Stat bloat notation (`3.8K`, `10M`) is strictly forbidden; all numbers are exact and unrounded (`3800 / 4000 Spirit Qi`).
3. **Server-Authoritative Validation:** Damage calculation, parry windows, i-frame dodges, and posture staggers are validated strictly on the server to prevent exploits.
4. **Wuxia/Xianxia Aesthetic:** Minimalist Dark Slate Obsidian (`#12161A`), Imperial Gold (`#D4AF37`), Weathered Bronze (`#2A3A35`), and Spirit Jade filigree (`#3A7869`).

---

## 📜 2. Cultivation Hierarchy & Realm Scaling (V1.0 Launch Cap)

Progression follows 4 Major Realms, each with 9 Minor Orders (1st through 9th Order):

1. **Mortal Body Realm (Realm 1):** `100 HP – 160 HP` | Basic physical martial arts & parrying (`[F]`).
2. **Qi Condensation Realm (Realm 2):** `160 HP – 230 HP` | Unlocks Spirit Qi Pool, Qi Projectiles, and **Qi Sense Vision (`[V]`)**.
3. **Foundation Establishment Realm (Realm 3):** `230 HP – 300 HP` | Unlocks Air Dash (`[Q]`), Qi Shielding (`[F]`), and Miasma Resistance.
4. **Core Formation Realm (Realm 4 — Launch Cap):** `300 HP – 370 HP` | Unlocks Domain Stances (`[G]`) and Flying Sword Spatial Travel.

---

## 🎨 3. UI/UX Architecture & 2D Asset Registry

All 8 UI panels and HUD components use dynamic background templates (`ImageLabel`) with **hollow, unfilled track grooves** so Luau code (`ScrollingFrame`, `UIGridLayout`, `TweenService`) can animate fills and content dynamically without visual clipping.

### Panel Registry & Screen Placement:
* **Panel 1 (`TopNavigationFrame`):** Top-center banner (`850x60` px). Renders Roblox headshot thumbnail (`GetUserThumbnailAsync`), player display name, realm rank, 6 navigation tab buttons, and live currency counters (**Spirit Stones** and **Sect Tokens**).
* **Panel 2 (`CombatHUDGui` Slices):** In-game HUD overlay:
  * **`VitalityCluster`** (Bottom-Left, `280x110` px): Holds 4 pill-shaped bars (**Health**, **Posture**, **Stamina**, **Qi**) using `UICorner` (`UDim.new(1, 0)`) and `ClipsDescendants = true`.
  * **`HotbarCluster`** (Bottom-Center, `320x55` px): Holds 6 action slots (`[F] Parry`, `[Q] Dash`, `[V] Qi Sense`, `[1]`, `[2]`, `[3]`).
  * **`TargetFrame`** (Top-Center, `350x50` px): Enemy HP and Posture gauge tracks.
  * **`MiasmaHazard`** (Top-Right, `180x35` px): Environmental toxicity bar.
* **Panel 3 (`CharacterPanel` - `[C]`):** Center modal (`0.65, 0` scale + `1.778` AspectRatio). 3D viewport, base stats, breakthrough checklist, and Heavenly Tribulation button.
* **Panel 4 (`InventoryPanel` - `[B]` / `[I]`):** Center modal. Paperdoll gear slots, center item grid container (`ItemGridContainer` + `ScrollingFrame`), category filter tabs, right Item Inspector.
* **Panel 5 (`SkillsPanel` - `[K]`):** Center modal. Martial stance selector, node canvas grid, proficiency progress bar, skill upgrade inspector.
* **Panel 6 (`AlchemyPanel`):** Center modal. Recipe book list, central cauldron with 3 herb docking slots, temperature slider, and brewing progress track.
* **Panel 7 (`WorldMapPanel` - `[N]`):** Center modal. Widescreen 2D interactive zone map, contested Qi artery markers (`+3.0x` density), and sector status sidebar.
* **Panel 8 (`SettingsPanel` - `[O]`):** Center modal. Keybind remapping, graphics particle toggles, and audio volume sliders.

---

## 🛠️ 4. Active Codebase Implementations (`--!strict`)

### A. Client UI Manager (`StarterPlayerScripts/Client/Controllers/UIController.lua`)
* **Dual Keybinding & Input Guard:** Handles hotkeys `[C]`, `[B]` (Bag/Inventory), `[K]`, `[N]` (World Map), `[O]`, and `[Escape]`. Includes chat focus check (`isTypingInChat()`) to prevent Roblox camera zoom key conflicts.
* **Double-Firing Guard:** Protected by `isInitialized` guard flag.
* **Zero-Flicker Texture Preloading:** Uses `ContentProvider:PreloadAsync()` to preload all 8 panel assets into GPU memory, setting `BackgroundTransparency = 1` and `BackgroundColor3 = Color3.fromRGB(18, 22, 26)` to eliminate white flashbang loading flicker.
* **Top Navigation Bar:** Renders live user avatar headshots, rank labels, and currency formatting (`formatCommas`). Highlight states glow in gold when a panel is open.

### B. Dynamic Inventory Engine (`ReplicatedStorage/Shared/Config/ItemsConfig.lua` & `InventoryController.lua`)
* **Item Database (`ItemsConfig`):** Categorized item registry for Pills, Weapons, Armor, and Materials across Mortal, Earth, Heaven, and Immortal grades.
* **Dynamic Grid Generation:** Populates item slots inside `ItemGridContainer` `ScrollingFrame` at runtime.
* **Category Filters:** Supports real-time filtering across `All`, `Weapons`, `Pills`, and `Materials`.
* **Item Inspector:** Clicking any inventory slot highlights its border in gold and populates the right inspection pane with the item's name, grade, icon, and lore description.

### C. Server-Authoritative Action Combat Engine (`CombatService.lua` & `CombatController.lua`)
* **Frame-Precise Parry (`[F]` Key):** Validates a `0.18s` parry window on the server. Successful parrying negates 100% incoming damage, triggers counter FX, and inflicts `-30` Posture Damage to the attacker.
* **I-Frame Dodge (`[Q]` Key):** Grants a `0.20s` invincibility window and triggers a directional physics impulse (`LinearVelocity`). Consumes `25` Stamina per dodge (Max Stamina: `100`).
* **Posture Break & Stagger:** Reaching `0` Posture triggers a **`1.5s` Stagger Stun** (`WalkSpeed = 0`) and applies a **`1.5x` Critical Damage Multiplier**.
* **Auto-Regeneration Loop:** Posture and Stamina regenerate automatically after `2.0s` without taking damage.

### D. Qi Sense Visual Scanner (`QiSenseController.lua`)
* **Spiritual Vision (`[V]` Key):** Toggles an atmospheric cyan color shift (`ColorCorrectionEffect` Tint `#82FFE6`, Saturation `0.3`, Contrast `0.25`).
* **Resource Cost:** Consumes `5 Spirit Qi / sec` while active, auto-deactivating when Qi reaches `0`.
* **World Scanning Engine:** Scans a 300-stud radius around the player for tagged objects:
  * **🌱 Alchemy Herbs (`Tag: AlchemyHerb`):** Glowing Emerald Green outline (`#2ECC71`) + billboard label.
  * **🌊 Qi Arteries (`Tag: QiNode`):** Glowing Spirit Cyan outline (`#00FFFF`) + `+3.0x Qi` density label.
  * **🐉 Spirit Beasts (`Tag: SpiritBeast`):** Glowing Crimson Violet outline (`#E74C3C`).

---

## 🗺️ 5. Next Development Phases

1. **Inventory Drag-and-Drop & Equipment System:** Dragging consumable pills onto hotbar slots (`[1]`, `[2]`, `[3]`) and equipping gear onto Paperdoll slots.
2. **Martial Skill Tree Population (`SkillsPanel` - `[K]`):** Technique node progression trees for *Flowing Water Sword Style* and *Thunder-Palm Unarmed*.
3. **Portable Alchemy Cauldron (`AlchemyPanel`):** Herb insertion, flame temperature slider control, and pill refining yield calculations.
4. **Contested Qi Nodes & Open-World Arteries:** Claiming spirit springs to grant zone-wide cultivation multipliers (`+3.0x` / `+5.0x`).

---

## 📁 7. Repository Directory Structure

```text
Realmbreaker/
├── docs/                               # Master Project Specifications & AI Documentation
│   ├── Game Design/                    # Lore, Roadmap, Coding Standards, Terrain
│   ├── Technical Design/               # Folder Structure, Database, Save System, Asset Pipeline
│   ├── Live Operations/                # Balancing, Events, Player Psychology
│   └── Monetization.md/                # Monetization, Analytics, Retention
├── src/
│   ├── ReplicatedStorage/
│   │   └── Shared/
│   │       ├── Config/                 # RealmsConfig, ItemsConfig, StancesConfig
│   │       ├── Packages/               # ProfileService, ReplicaService, Signal
│   │       └── Types/                  # Strict Luau Type Definitions
│   ├── ServerScriptService/
│   │   ├── Boot/                       # ServerLoader.server.lua
│   │   ├── Components/                 # CombatService, SaveService, CultivationService
│   │   └── Services/                   # AlchemyService, WorldService
│   └── StarterPlayer/
│       └── StarterPlayerScripts/
│           ├── Boot/                   # ClientLoader.client.lua
│           └── Client/
│               └── Controllers/        # UIController, InventoryController, CombatController, QiSenseController, WorldController
├── default.project.json                # Rojo Synchronization Config
└── REALMBREAKER.md                     # Master Architecture & Development Brief