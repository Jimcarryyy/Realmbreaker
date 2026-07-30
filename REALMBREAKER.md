# 🌌 Realmbreaker — Xianxia Action MMORPG

> **Official Roblox Project Repository & AI Architecture Guide**  
> **Target Engine:** Roblox (PC, Mobile, Console) | **Language:** Luau (`--!strict`)  
> **Version Baseline:** Phase 1 (v1.0 Early Release)  
> **Genre:** Action Xianxia / Wuxia Cultivation MMORPG  

---

## 🤖 AI Context Controller Link
For active development tasks, state tracking, and current implementation priorities, refer directly to:
* **AI Development Controller:** https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/AI_DEVELOPMENT_CONTROLLER.md

---

## 📜 1. Executive Overview & Design Identity

**Realmbreaker** redefines the Xianxia / Wuxia genre on Roblox by eliminating AFK auto-clicking, stat inflation bloat (no arbitrary "Trillions" or "10,000x" multipliers), and pay-to-win gacha traps. 

The game operates on a **Mechanical Progression Architecture**: every realm breakthrough grants mechanical spatial agency, tactical defensive options, and environmental access—rather than simply inflating stats.

### 🌟 Core Pillars

1. **Purposeful Progression:** Advancement unlocks physical mechanics, not stat bloat.
2. **Skill-Based Combat:** Frame-precise parries, dodge i-frames, posture breaks, and directional stances.
3. **Interconnected World:** Integrated alchemy, contested Qi Arteries, and open-world wild zones.
4. **Ethical Monetization:** Time-efficiency, cosmetics, and quality-of-life options without pay-to-win stat advantages.

---

## 🔄 2. Core Gameplay Loop

1. **EXPLORATION & GATHERING:** Harvest Herbs, Locate Qi Arteries, Explore Caverns, Defeat Spirit Beasts.
2. **CULTIVATION & ALCHEMY:** Refine Qi, Brew Pills, Condense Core, Survive High-Stakes Heavenly Tribulation.
3. **COMBAT & TERRITORY:** Unlock Stances, Enter Mystic Realms, Compete for Open-World Contested Qi Nodes.
4. **ECONOMY & MONETIZATION:** Player Trading, Sect Tributes, QoL Passes, Cosmetic Auras, VIP Convenience.

---

## 📈 3. V1.0 Cultivation Progression Hierarchy

Health scaling for V1.0 launch realms (*Mortal Realm* through *Golden Core Realm*) is strictly capped between **100 HP to 370 HP max** to maintain fighting-game combat fidelity.

| Realm Tier | Realm Name | Minor Orders | Key Mechanical Unlocks | World Access / Hazards |
| :---: | :--- | :---: | :--- | :--- |
| **0** | **Mortal Body** | 9 Orders | Light/Heavy combos, stamina roll, basic block | Zone 1: Safe Village |
| **1** | **Qi Condensation** | 9 Orders | **Qi Energy Pool**, **Qi Projectiles**, **Qi Sense HUD [V]** | Zone 1: Outer Wilds |
| **2** | **Foundation Establishment** | 9 Orders | **Air Dash [Q]**, **Qi Shielding [F]**, **Portable Alchemy** | Zone 2: Mistveil Forest (Miasma) |
| **3** | **Core Formation** *(V1.0 Cap)* | 9 Orders | **Flight / Levitation**, **Domain Stances [G]**, **Contested Qi Nodes** | Zone 2: Ancient Qi Caverns |

---

## ⚔️ 4. Combat Engine & Martial Disciplines

Combat is deterministic, animation-driven, and server-validated:

* **Active Parry Window:** Base `0.18s` reaction window (extended to `0.33s` under *Qi Shielding*). Parrying drains enemy posture and awards instant riposte frames.
* **Posture Break System:** Depleting an opponent's posture triggers a `1.5s` stagger state taking `1.5x` bonus damage.
* **Dodge / Flash Step:** `0.20s` invincibility frames (I-Frames) bound to stamina consumption.
* **Launch Martial Disciplines:**
  * **Flowing Water Sword Stance:** Counter-striking defensive stance with unblockable ripostes.
  * **Thunder-Palm Unarmed Stance:** High-pressure stance dealing `2.0x` posture damage against guarding opponents.

---

## 🗺️ 5. World Zones & Territorial Competition

1. **Zone 1: Bamboo Leaf Village (Safe Area):** Onboarding tutorial, Spirit Spring meditation (+1.0x Qi rate), non-PvP zone.
2. **Zone 2: Mistveil Forest & Ancient Caverns (Contested PvP):** Toxic miasma hazard requiring Foundation stage pills, open-world PvP, high-density Qi Arteries (+5.0x Qi rate).
3. **Contested Qi Arteries:** Activate every 30 minutes in Zone 2. Sects channel the node for 10 seconds to claim exclusive +5.0x meditation rates for 15 minutes.

---

## 🌐 6. Technical Architecture & Security

* **State Governance:** Server-authoritative data using `ProfileService` (session locking, schema migrations, GDPR compliance) and `ReplicaService` for secure client data replication.
* **Code Directive:** 100% strictly typed Luau (`--!strict`).
* **Physics Safety:** Smooth floating meditation via `TweenService` with `Sine` easing (no `Humanoid.PlatformStand` to avoid network physics delays).

---

## 📁 7. Repository Directory Structure

Realmbreaker/
├── AI_DEVELOPMENT_CONTROLLER.md      # Living AI Context & Master Memory
├── README.md                          # Repository Master Documentation
├── docs/                              # Design & Technical Specifications
│   ├── Game Design/                   # Specs 00 - 16 (GDD, World, Combat, Cultivation, etc.)
│   ├── Monetization.md/               # Specs 17 - 20 (Monetization, Retention, Analytics)
│   ├── Technical Design/              # Specs 21 - 27 (Folder Structure, Database, Save System)
│   └── Live Operations/               # Specs 28 - 33 (Balancing, Live Events, Patching)
└── src/                               # Luau Source Files (Rojo Sync Path)
    ├── ReplicatedStorage/
    │   └── Shared/
    │       ├── Config/                # Shared Game Configurations (RealmsConfig.lua, etc.)
    │       └── Packages/              # Shared Modules (ReplicaController, Maid, etc.)
    ├── ServerScriptService/
    │   └── Server/
    │       ├── Boot/                  # ServerLoader.server.lua
    │       ├── Components/            # Harvesting & World Components
    │       └── Services/              # SaveService.lua, CultivationService.lua, etc.
    └── StarterPlayer/
        └── StarterPlayerScripts/
            └── Client/
                ├── Boot/              # ClientLoader.client.lua
                └── Controllers/       # UIController.lua, CultivationController.lua, etc.

---

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