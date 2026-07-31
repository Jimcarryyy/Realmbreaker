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
4. **Modern Roblox Xianxia Aesthetic:** Clean, soft-glass Obsidian (`#0D1117`), Spirit Jade glowing accents (`#4AE3B5`), Imperial Gold realm highlights (`#FFD700`), smooth rounded geometry (`UICorner`), and soft friendly typography (`FredokaOne` & `GothamBold`) for maximum clarity and all-ages appeal.

---

## 📜 2. Cultivation Hierarchy & Realm Scaling (V1.0 Launch Cap)

Progression follows 4 Major Realms, each with 9 Minor Orders (1st through 9th Order):

1. **Mortal Body Realm (Realm 1):** `100 HP – 160 HP` | Basic physical martial arts & parrying (`[F]`).
2. **Qi Condensation Realm (Realm 2):** `160 HP – 230 HP` | Unlocks Spirit Qi Pool, Qi Projectiles, and **Qi Sense Vision (`[V]`)**.
3. **Foundation Establishment Realm (Realm 3):** `230 HP – 300 HP` | Unlocks Air Dash (`[Q]`), Qi Shielding (`[F]`), and Miasma Resistance.
4. **Core Formation Realm (Realm 4 — Launch Cap):** `300 HP – 370 HP` | Unlocks Domain Stances (`[G]`) and Flying Sword Spatial Travel.

---

## 3. UI/UX System Architecture & Asset Registry

### A. Master 37-Asset Directory Structure
All 2D UI asset shells, icons, skills, map pins, and currencies are organized into 6 standardized subfolders under `ReplicatedStorage.Shared.Assets.UI`:

* **`Panels/` (7 Shells):** `Panel1_AlchemyPanelShell` (ID: `84276737641585`), `Panel2_InventoryPanelShell` (ID: `123841032076360`), `Panel3_CharacterPanelShell` (ID: `86012045244236`), `Panel4_SkillsPanelShell` (ID: `107226547729026`), `Panel5_MapQuestPanelShell` (ID: `131488945229260`), `SettingsPanel_SettingsShell` (ID: `127613233097676`), `DialogueFrame_DialogueShell` (ID: `79576725327950`).
* **`HUD/` (6 Overlays):** `Panel6_CombatHUDOverlayShell` (ID: `110381792485649`), `TopNavigationFrame_TopNavShell` (ID: `122415586898423`), `BossHealthBarShell_BossBarShell` (ID: `134065637826617`), `TargetFrame_TargetFrameShell` (ID: `112564321533982`), `QuestTrackerWidget_QuestTrackerShell` (ID: `131670772422654`), `TutorialHintBanner_TutorialBannerShell` (ID: `92283672177848`).
* **`Templates/` (3 Controls):** `Panel7_ModularSlotTemplate` (ID: `78377208477701`), `AssetA_CloseButton` (ID: `113605743209527`), `AssetB_PrimaryActionButton` (ID: `139131406784954`).
* **`Items/` (11 Items & Currencies):** `Item_JadeSpiritBlade` (ID: `102309054006524`), `Item_InitiateRobe` (ID: `110436079253993`), `Item_QiGatheringRing` (ID: `138394758283116`), `Item_SpiritHerb` (ID: `90866060513740`), `Item_DragonBloodFlower` (ID: `122623665914573`), `Item_FrostLotus` (ID: `76826036711416`), `Item_QiGatheringPill` (ID: `87497192233934`), `Item_VitalityPill` (ID: `112990324747062`), `Item_SkillManualScroll` (ID: `78648040440784`), `Currency_SpiritStones` (ID: `79573528943998`), `Currency_SectTokens` (ID: `75450655299271`).
* **`Skills/` (6 Abilities):** `Skill_QiDash` (ID: `137358656097564`), `Skill_Parry` (ID: `129890118103154`), `Skill_QiSense` (ID: `128617837655590`), `Skill_FlowingWaterSlash` (ID: `95178149840421`), `Skill_ThunderPalmStrike` (ID: `139060977395032`), `Skill_SpiritBlast` (ID: `71547589196383`).
* **`Icons/` (4 Pins):** `MapPin_PlayerArrow` (ID: `113587700256481`), `MapPin_SectTemple` (ID: `106421270342595`), `MapPin_QiNodeCrystal` (ID: `115576917375343`), `MapPin_QuestExclamation` (ID: `120838027568021`).

### B. AssetRegistry Configuration (`ReplicatedStorage.Shared.Configs.AssetRegistry`)
Central configuration module mapping human-readable keys to real uploaded Roblox Asset IDs:

```lua
--!strict
local AssetRegistry = {}

AssetRegistry.Panels = {
	Alchemy = "rbxassetid://84276737641585",
	Inventory = "rbxassetid://123841032076360",
	Character = "rbxassetid://86012045244236",
	Skills = "rbxassetid://107226547729026",
	WorldMap = "rbxassetid://131488945229260",
	Settings = "rbxassetid://127613233097676",
	Dialogue = "rbxassetid://79576725327950",
}

AssetRegistry.HUD = {
	CombatOverlay = "rbxassetid://110381792485649",
	TopNavigation = "rbxassetid://122415586898423",
	BossHealthBar = "rbxassetid://134065637826617",
	TargetFrame = "rbxassetid://112564321533982",
	QuestTracker = "rbxassetid://131670772422654",
	TutorialBanner = "rbxassetid://92283672177848",
}

AssetRegistry.Templates = {
	ModularSlot = "rbxassetid://78377208477701",
	CloseButton = "rbxassetid://113605743209527",
	PrimaryActionButton = "rbxassetid://139131406784954",
}

AssetRegistry.Items = {
	JadeSpiritBlade = "rbxassetid://102309054006524",
	InitiateRobe = "rbxassetid://110436079253993",
	QiGatheringRing = "rbxassetid://138394758283116",
	SpiritHerb = "rbxassetid://90866060513740",
	DragonBloodFlower = "rbxassetid://122623665914573",
	FrostLotus = "rbxassetid://76826036711416",
	QiGatheringPill = "rbxassetid://87497192233934",
	VitalityPill = "rbxassetid://112990324747062",
	SkillManualScroll = "rbxassetid://78648040440784",
	SpiritStones = "rbxassetid://79573528943998",
	SectTokens = "rbxassetid://75450655299271",
}

AssetRegistry.Skills = {
	QiDash = "rbxassetid://137358656097564",
	Parry = "rbxassetid://129890118103154",
	QiSense = "rbxassetid://128617837655590",
	FlowingWaterSlash = "rbxassetid://95178149840421",
	ThunderPalmStrike = "rbxassetid://139060977395032",
	SpiritBlast = "rbxassetid://71547589196383",
}

AssetRegistry.Icons = {
	PlayerArrow = "rbxassetid://113587700256481",
	SectTemple = "rbxassetid://106421270342595",
	QiNodeCrystal = "rbxassetid://115576917375343",
	QuestExclamation = "rbxassetid://120838027568021",
}

return AssetRegistry


C. Overhead World-Space Display Rules (OverheadBillboardGui)
Player Overhead: Renders Player Display Name, Sect Tag [Jade Cloud Sect], Color-Coded Realm Rank [Qi Condensation - Stage 4], and a dynamic mini-HP/Posture bar that fades in during active combat.
Parenting: Character.Head (MaxDistance = 80 studs, AlwaysOnTop = false).

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


## 🔗 8. Complete AI Documentation & Raw GitHub Context Links

Use the raw links below for direct AI browsing and full context retrieval across all development phases:

### 🎮 Game Design
* **Game Design README:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/README.md
* **00 Project Overview:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/00_PROJECT_OVERVIEW.md
* **01 Game Design Document (GDD):** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/01_GDD.md
* **02 World Design:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/02_WORLD.md
* **03 Cultivation System:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/03_CULTIVATION.md
* **04 Combat System:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/04_COMBAT.md
* **05 Progression System:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/05_PROGRESSION.md
* **06 PvP Mechanics:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/06_PVP.md
* **07 PvE Mechanics:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/07_PVE.md
* **08 UI/UX Design:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/08_UI_UX.md
* **09 Economy System:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/09_ECONOMY.md
* **10 Technical Architecture:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/10_TECHNICAL_ARCHITECTURE.md
* **11 Art Direction:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/11_ART_DIRECTION.md
* **12 Lore & Narrative:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/12_LORE.md
* **13 Development Roadmap:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/13_ROADMAP.md
* **14 Coding Standards:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/14_CODING_STANDARD.md
* **15 Game Identity:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/15_GAME_IDENTITY.md
* **16 Design Principles:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/16_DESIGN_PRINCIPLES.md
* **Terrain Implementation:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/TERRAIN_IMPLEMENTATION.md

### 💎 Monetization & Live Operations
* **17 Monetization Strategy:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Monetization.md/17%20Monetization.md
* **18 Live Services:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Monetization.md/18%20Live%20Service.md
* **19 Game Analytics:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Monetization.md/19%20Analytics.md
* **20 Player Retention:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Monetization.md/20%20Retention.md

### 🛠️ Technical Design
* **21 Folder Structure:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/21_FOLDER_STRUCTURE.md
* **22 Database Design:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/22_DATABASE_DESIGN.md
* **23 Network Architecture:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/23_NETWORK_ARCHITECTURE.md
* **24 Save System:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/24_SAVE_SYSTEM.md
* **25 Asset Pipeline:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/25_ASSET_PIPELINE.md
* **26 Technical Coding Standard:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/26_CODING_STANDARD.md
* **27 Naming Convention:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/27_NAMING_CONVENTION.md

### 📡 Live Operations & Management
* **28 Balancing Philosophy:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Live%20Operations/28_BALANCING_PHILOSOPHY.md
* **29 Community Management:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Live%20Operations/29_COMMUNITY_MANAGEMENT.md
* **30 Live Events:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Live%20Operations/30_LIVE_EVENTS.md
* **31 Content Expansion:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Live%20Operations/31_CONTENT_EXPANSION.md
* **32 Patch Notes Format:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Live%20Operations/32_PATCH_NOTES.md
* **33 Player Psychology:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Live%20Operations/33_PLAYER_PSYCHOLOGY.md

---

## 📦 9. Source Raw GitHub Links

Base raw source path: `https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/`

### ReplicatedStorage
- [MadworkMaid.luau](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/MadworkMaid.luau)
- [MadworkMaid.meta.json](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/MadworkMaid.meta.json)
- [MadworkScriptSignal.luau](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/MadworkScriptSignal.luau)
- [MadworkScriptSignal.meta.json](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/MadworkScriptSignal.meta.json)
- [RateLimiter.luau](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/RateLimiter.luau)
- [RateLimiter.meta.json](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/RateLimiter.meta.json)
- [ReplicaController.luau](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/ReplicaController.luau)
- [ReplicaController.meta.json](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/ReplicaController.meta.json)

### ReplicatedStorage / Shared / Assets
- [AssetsConfig.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Assets/AssetsConfig.lua)

### ReplicatedStorage / Shared / Config
- [ItemsConfig.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/ItemsConfig.lua)
- [NodesConfig.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/NodesConfig.lua)
- [RealmsConfig.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/RealmsConfig.lua)
- [StancesConfig.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/StancesConfig.lua)
- [ZonesConfig.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/ZonesConfig.lua)

### ServerScriptService / Server / Boot
- [ServerLoader.server.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Boot/ServerLoader.server.lua)

### ServerScriptService / Server / Modules
- [ProfileService.luau](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Modules/ProfileService.luau)
- [ProfileService.meta.json](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Modules/ProfileService.meta.json)
- [ReplicaService.luau](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Modules/ReplicaService.luau)
- [ReplicaService.meta.json](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Modules/ReplicaService.meta.json)

### ServerScriptService / Server / Services
- [CombatService.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/CombatService.lua)
- [CultivationService.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/CultivationService.lua)
- [SaveService.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/SaveService.lua)
- [WorldObjectService.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/WorldObjectService.lua)
- [WorldService.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/WorldService.lua)

### StarterPlayer / StarterPlayerScripts / Client / Boot
- [ClientLoader.client.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Boot/ClientLoader.client.lua)

### StarterPlayer / StarterPlayerScripts / Client / Controllers
- [CombatController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/CombatController.lua)
- [CultivationController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/CultivationController.lua)
- [EffectController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/EffectController.lua)
- [InventoryController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/InventoryController.lua)
- [QiSenseController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/QiSenseController.lua)
- [SkillEffectController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/SkillEffectController.lua)
- [UIController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/UIController.lua)
- [WorldController.lua](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/WorldController.lua)
