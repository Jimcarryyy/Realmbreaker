# Realmbreaker — Xianxia Action MMORPG

> **Official Game Design Bible & Technical Authority**  
> *Target Platform:* Roblox (PC, Mobile, Console)  
> *Genre:* Xianxia / Wuxia Cultivation Action MMORPG  
> *Release Target:* Version 1.0 (Early Publish / DevEx Viable Baseline)  
> *Language & Sync:* Luau Strict (`--!strict`) | Argon 2-Way Sync (VS Code)

---

## 1. Executive Summary

**Realmbreaker** is an action-driven Xianxia/Wuxia MMORPG designed to break away from traditional "AFK clicker" cultivation simulators on Roblox. 

Instead of relying on artificial stat inflation, **Realmbreaker** anchors every tier of progression to **Mechanical Unlocks**—new spatial movement abilities, combat stances, tactical parrying buffers, environmental hazard access, and territorial competition.

> **Core Design Axiom:**  
> *"A Foundation Establishment cultivator does not defeat a Qi Condensation cultivator simply because they have 10,000 HP vs 1,000 HP. They win because they possess Air Dashing, Qi Shielding, and superior tactical positioning."*

---

## 2. The 4 Design Pillars

| Pillar | Principle | Gameplay Execution |
| :--- | :--- | :--- |
| **1. Purposeful Progression** | No meaningless numbers. | Advancing a realm unlocks physical mechanics (Air Dashing, Qi Shielding, Flight, Domain Stances) rather than inflated stats. |
| **2. Interconnected World** | No isolated systems. | Alchemy requires herbs from dangerous PvP zones; crafting requires rare drops; breakthroughs require environmental Qi density. |
| **3. Skill-Based Combat** | Strategy over pure stats. | Active 0.18s parries, animation-cancel dodging, stamina management, and posture breaks allow lower-realm players to outplay careless higher-realm players. |
| **4. Ethical Monetization** | Respect the player. | Focus on convenience, time-efficiency, storage, and cosmetic status. No paywalls that break competitive PvP integrity. |

---

## 3. V1.0 Early Publish Scope Boundaries

To ensure rapid time-to-market while delivering maximum replayability and DevEx monetization, feature scope is strictly governed for Version 1.0:

```
[ Realm 0: Mortal Body ] ──► [ Realm 1: Qi Condensation ] ──► [ Realm 2: Foundation Est. ] ──► [ Realm 3: Core Formation ]
    (Physical Combos)            (Qi Gauge & Ranged Blasts)      (Air Dash & Alchemy Crafting)       (Flight & Domain Stances)
```

| Realm Tier | Realm Name | Key Gameplay Unlocks | Accessible World Zones |
| :---: | :--- | :--- | :--- |
| **0** | **Mortal Body** | Physical combos, stamina roll, martial stance selection. | Bamboo Leaf Village (Zone 1 Safe Area) |
| **1** | **Qi Condensation** | Qi Pool, ranged Qi Projectiles, **Qi Sensing HUD [V]**. | Outer Sect Wilds (Zone 1) |
| **2** | **Foundation Establishment** | **Air Dash [Q]**, **Qi Shielding [F]**, **Alchemy Crafting**. | Mistveil Forest (Zone 2 Miasma Area) |
| **3** | **Core Formation** *(V1.0 Cap)* | **Flight / Levitation**, **Domain Stances [G]**, Sect Node Extraction. | Ancient Qi Caverns (Zone 2 Contested PvP) |

---

## 4. Repository Directory Layout

The codebase follows a modular Service-Controller architecture synchronized live via **Argon** in VS Code:

```
src/
├── ReplicatedFirst/            --> Preloading screens & initial splash UI
├── ReplicatedStorage/          --> Shared client-server assets & logic
│   └── Shared/
│       ├── Config/             --> Central game configs (RealmsConfig, StancesConfig, AssetsConfig)
│       ├── Network/            --> Remote communication bridges
│       ├── Utils/              --> Utility library modules (Maid, Signal, Promise)
│       └── Types/              --> Luau strict type definitions
│
├── ServerScriptService/        --> Server-authoritative logic execution
│   └── Server/
│       ├── Boot/               --> ServerLoader.server.lua entry point
│       ├── Services/           --> Authoritative Services (SaveService, CultivationService, CombatService)
│       └── Components/         --> Physical world object behaviors (QiNodeComponent)
│
├── StarterPlayer/
│   └── StarterPlayerScripts/
│       └── Client/             --> Client-side Controllers & UI handlers
│           ├── Boot/           --> ClientLoader.client.lua entry point
│           ├── Controllers/     --> Controllers (UIController, CultivationController, CombatController)
│           └── UI/             --> Declarative UI views & components
│
└── Workspace/                  --> World terrain, physical Qi nodes, & map geometry
```

---

## 5. Developer Quickstart (VS Code + Argon Setup)

1. **Clone the Repository:**
   `git clone https://github.com/Jimcarryyy/Realmbreaker.git`
2. **Open in VS Code:**
   Open the `Realmbreaker` root directory in VS Code.
3. **Start Argon 2-Way Sync:**
   * Open Roblox Studio with a blank place or project map.
   * In VS Code, open the Command Palette (`Ctrl + Shift + P`) and select **`Argon: Start`**.
   * Argon will automatically build and synchronize the full `src/` directory tree into Roblox Studio.
4. **Run Game:** Press **Play** in Roblox Studio to initialize server services and client controllers.

---

## 6. Master Game Design Bible Index

All detailed specifications live within the designated documentation modules:

### 📁 Game Design
* [`docs/Game Design/00_PROJECT_OVERVIEW.md`](docs/Game%20Design/00_PROJECT_OVERVIEW.md) — High-Level Blueprint & Launch Scope
* [`docs/Game Design/01_GDD.md`](docs/Game%20Design/01_GDD.md) — Master Game Design Document
* [`docs/Game Design/02_WORLD.md`](docs/Game%20Design/02_WORLD.md) — World Architecture, Zones & Qi Density
* [`docs/Game Design/03_CULTIVATION.md`](docs/Game%20Design/03_CULTIVATION.md) — 4 Launch Realms & Mechanical Progression
* [`docs/Game Design/04_COMBAT.md`](docs/Game%20Design/04_COMBAT.md) — Fighting Game Combat Engine & Frame Data
* [`docs/Game Design/05_PROGRESSION.md`](docs/Game%20Design/05_PROGRESSION.md) — Player Lifecycle & Leveling Curves
* [`docs/Game Design/06_PVP.md`](docs/Game%20Design/06_PVP.md) — Contested Qi Veins, Infamy & Arena Duels
* [`docs/Game Design/07_PVE.md`](docs/Game%20Design/07_PVE.md) — Boss AI Mechanics & `Ancient Sword Mystic Realm` Dungeon
* [`docs/Game Design/08_UI_UX.md`](docs/Game%20Design/08_UI_UX.md) — HUD Architecture & Cross-Platform Controls
* [`docs/Game Design/09_ECONOMY.md`](docs/Game%20Design/09_ECONOMY.md) — Player Trading, Alchemy Market & Inflation Sinks
* [`docs/Game Design/11_ART_DIRECTION.md`](docs/Game%20Design/11_ART_DIRECTION.md) — Visual Identity, Lighting & Qi VFX Hierarchy
* [`docs/Game Design/12_LORE.md`](docs/Game%20Design/12_LORE.md) — World Mythos, Sect Histories & Main Campaign
* [`docs/Game Design/13_ROADMAP.md`](docs/Game%20Design/13_ROADMAP.md) — 15-Week Launch Timeline & V1.1–V1.3 Live Ops
* [`docs/Game Design/15_GAME_IDENTITY.md`](docs/Game%20Design/15_GAME_IDENTITY.md) — Market Positioning & Competitive USPs
* [`docs/Game Design/16_DESIGN_PRINCIPLES.md`](docs/Game%20Design/16_DESIGN_PRINCIPLES.md) — Core Axioms & Feature Evaluation Framework

### 📁 Technical Design
* [`docs/Technical Design/10_TECHNICAL_ARCHITECTURE.md`](docs/Technical%20Design/10_TECHNICAL_ARCHITECTURE.md) — Service-Controller Engine Architecture
* [`docs/Technical Design/21_FOLDER_STRUCTURE.md`](docs/Technical%20Design/21_FOLDER_STRUCTURE.md) — Code Base Layout & Argon Migration
* [`docs/Technical Design/22_DATABASE_DESIGN.md`](docs/Technical%20Design/22_DATABASE_DESIGN.md) — DataStore Schemas & Payload Limits
* [`docs/Technical Design/23_NETWORK_ARCHITECTURE.md`](docs/Technical%20Design/23_NETWORK_ARCHITECTURE.md) — Lag Compensation & Hit Registration
* [`docs/Technical Design/24_SAVE_SYSTEM.md`](docs/Technical%20Design/24_SAVE_SYSTEM.md) — ProfileService Session Locking & Anti-Dupe
* [`docs/Technical Design/25_ASSET_PIPELINE.md`](docs/Technical%20Design/25_ASSET_PIPELINE.md) — 3D Mesh Budgets, Animation Markers & Audio
* [`docs/Technical Design/26_CODING_STANDARD.md`](docs/Technical%20Design/26_CODING_STANDARD.md) — Strict Luau Style Guide & Garbage Collection

### 📁 Monetization & Live Operations
* [`docs/Monetization.md/17 Monetization.md`](docs/Monetization.md/17%20Monetization.md) — Revenue Strategy & DevEx Target Catalog
* [`docs/Monetization.md/20 Retention.md`](docs/Monetization.md/20%20Retention.md) — Retention Engine & 4-Stage Lifecycle
* [`docs/Live Operations/28_BALANCING_PHILOSOPHY.md`](docs/Live%20Operations/28_BALANCING_PHILOSOPHY.md) — Stat Caps & Cross-Realm Damage Scaling
* [`docs/Live Operations/29_COMMUNITY_MANAGEMENT.md`](docs/Live%20Operations/29_COMMUNITY_MANAGEMENT.md) — Moderation Matrix & Anti-Exploit Policy
* [`docs/Live Operations/30_LIVE_EVENTS.md`](docs/Live%20Operations/30_LIVE_EVENTS.md) — Automated Qi Surges & Seasonal Festivals
* [`docs/Live Operations/31_CONTENT_EXPANSION.md`](docs/Live%20Operations/31_CONTENT_EXPANSION.md) — 5-Step Realm Addition Pipeline
* [`docs/Live Operations/32_PATCH_NOTES.md`](docs/Live%20Operations/32_PATCH_NOTES.md) — Semantic Versioning & Release Logs
* [`docs/Live Operations/33_PLAYER_PSYCHOLOGY.md`](docs/Live%20Operations/33_PLAYER_PSYCHOLOGY.md) — Behavioral Archetypes & Loss-Aversion Safeguards

---

> **Document Revision History**  
> *v1.0.0* — Master Root README finalized and approved by Creative Director & Lead Software Architect.