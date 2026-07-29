# Realmbreaker — Project Overview & Early Publish Blueprint

> **Official Game Design Authority**  
> **Target Platform:** Roblox (PC, Mobile, Console)  
> **Genre:** Xianxia / Wuxia Cultivation MMORPG  
> **Status:** Pre-Production / Design Bible Phase  
> **Release Target:** Version 1.0 (Early Publish / DevEx Viable Baseline)

---

## 1. Executive Summary

**Realmbreaker** is an action-driven Xianxia/Wuxia MMORPG designed to break away from traditional "afk clicker" cultivation simulators on Roblox. 

Instead of relying on artificial stat inflation, **Realmbreaker** anchors every tier of progression to meaningful mechanical unlocks—new combat stances, movement abilities, environmental access, and world interactions.

> **Early Publish Mandate (V1.0):**  
> To maximize early player retention and establish early Developer Exchange (DevEx) monetization, Version 1.0 focuses on a tight, hyper-polished 4-Realm progression loop with deep interconnected gameplay mechanics, rather than an expansive but empty world.

---

## 2. Core Design Pillars

| Pillar | Principle | Gameplay Execution |
| :--- | :--- | :--- |
| **1. Purposeful Progression** | No meaningless numbers. | Advancing a realm unlocks physical mechanics (e.g., Qi Shielding, Air Dashing, Flight, Domain Stances) rather than just inflated stats. |
| **2. Interconnected World** | No isolated systems. | Alchemy requires herbs from dangerous PvP zones; crafting requires rare drops; breakthroughs require environmental Qi density. |
| **3. Skill-Based Combat** | Strategy over pure stats. | Active parrying, animation-cancel dodging, stamina management, and positional Qi stances enable lower-realm players to outplay careless higher-realm players. |
| **4. Ethical Monetization** | Respect the player. | Focus on convenience, time-efficiency, and cosmetic status. No paywalls that break competitive PvP integrity. |

---

## 3. Interconnected Core Loop

+---------------------------------------------------+
|            1. EXPLORATION & GATHERING             |
|   Harvest Herbs, Locate Qi Arteries,              |
|   Explore Caves, Defeat Spirit Beasts             |
+-------------------------+-------------------------+
                          |
                          v
+---------------------------------------------------+
|              2. CULTIVATION & ALCHEMY             |
|   Refine Qi, Brew Pills, Condense Core,           |
|   Survive High-Stakes Tribulation                 |
+-------------------------+-------------------------+
                          |
                          v
+---------------------------------------------------+
|               3. COMBAT & TERRITORY               |
|   Unlock Stances, Enter Mystic Realms,            |
|   Compete for Open-World Qi Nodes                 |
+-------------------------+-------------------------+
                          |
                          v
+---------------------------------------------------+
|            4. ECONOMY & MONETIZATION              |
|   Player Trading, Sect Tributes, QoL Passes       |
|   Cosmetic Auras, VIP Convenience                 |
+---------------------------------------------------+

---

## 4. Early Publish Scope Boundaries (V1.0 Launch Baseline)

To ensure rapid time-to-market while delivering maximum replayability, feature scope is strictly governed for V1.0:

### 4.1 Cultivation Realms Matrix (V1.0 Cap)

[ Mortal Body ] ---> [ Qi Condensation ] ---> [ Foundation Establishment ] ---> [ Core Formation ]
 (Basic Combat)        (Qi Gauge & Blast)       (Air Dash & Alchemy)           (Flight & Domains)

| Realm Tier | Name | Key Gameplay Unlocks | World Access |
| :---: | :--- | :--- | :--- |
| **0** | **Mortal Body** | Basic Light/Heavy M1 combos, stamina roll, martial stance selection. | Safe Zone (Zone 1) |
| **1** | **Qi Condensation** | Qi Energy Bar, ranged Qi projectiles, Qi Sensing HUD. | Outer Wilds (Zone 1) |
| **2** | **Foundation Establishment** | Air Dashing, Qi Shielding (Parry Buffer), Portable Alchemy Crafting. | Mistveil Forest (Zone 2) |
| **3** | **Core Formation** *(V1.0 Cap)* | Flight / Levitation, Domain Stance Buffs, Sect Leadership capabilities. | Ancient Qi Caverns & Contested Nodes |

### 4.2 Content Scope Comparison

| Included in V1.0 Launch | Deferred to Post-Launch (V1.1+) |
| :--- | :--- |
| 4 Cultivation Realms (Mortal to Core Formation) | Upper Realms (Nascent Soul, Soul Formation, etc.) |
| 2 World Zones (Sect Village + Mistveil Forest) | Upper Celestial Plane Maps & Floating Isles |
| 2 Martial Disciplines (Sword Mastery + Unarmed) | Spear, Blood Blade & Staff Disciplines |
| 1 Co-op Mystic Realm Dungeon | Infinite Tower & World Raid Bosses |
| Open-World Contested Qi Vein PvP | Cross-Server Faction Territory Siege Wars |
| Player Economy & Safe Trade System | Player Housing / Custom Sect Base Building |

---

## 5. DevEx & Monetization Engine

The monetization model is built around driving high average revenue per paying user (ARPPU) while maintaining high day-7 and day-30 retention:

> **Monetization Architecture:** All paid items focus on Time Efficiency, Quality of Life (QoL), and Social Status without breaking PvP integrity.

| Quality of Life | Status & Cosmetics | Convenience Passes |
| :--- | :--- | :--- |
| Extra Inventory Slots | Custom Sword Flight Trails | Portable Alchemy Cauldron |
| Auto-Meditation Off-line | Title Badges & Name Colors | Qi Sense HUD Upgrade |
| Sect VIP Pass (+10% Qi Rate) | Visual Body Auras | Fast-Travel Waypoints |

---

## 6. Technical Architecture & Data Standards

To guarantee cross-platform performance (PC, Mobile, Console) and absolute data security:

1. **State Management:** Single-authority state handling via ProfileService and ReplicaService to neutralize duplication exploits in trading and inventory systems.
2. **Deterministic Combat Engine:** Client-side prediction for visual feedback paired with server-side validation for hitboxes and parry windows.
3. **Modular Framework:** Decoupled Services (Server) and Controllers (Client) following strict single-responsibility principles.

---

## 7. Master Documentation Index

### Game Design Documentation
* `01_GDD.md` — Game Design Document & Core Mechanics
* `02_WORLD.md` — World Architecture & Zone Specifications
* `03_CULTIVATION.md` — Cultivation System, Breakthroughs & Stats
* `04_COMBAT.md` — Combat Engine, Stances & Hitboxes
* `05_PROGRESSION.md` — Player Journey & Leveling Curves
* `06_PVP.md` — Open-World PvP & Contested Qi Veins
* `07_PVE.md` — Dungeon System & Spirit Beast Bosses
* `08_UI_UX.md` — User Interface Architecture & HUD Layout
* `09_ECONOMY.md` — Player Trading, Currencies & Resource Sinks

### Technical Design Documentation
* `21_FOLDER_STRUCTURE.md` — Code Base Layout
* `22_DATABASE_DESIGN.md` — Data Schemas & Persistence
* `23_NETWORK_ARCHITECTURE.md` — Client-Server Replication
* `24_SAVE_SYSTEM.md` — Anti-Exploit Profile Management

### Monetization & Live Operations
* `17_MONETIZATION.md` — Revenue Strategy & Robux Sinks
* `20_RETENTION.md` — Daily Loops & Player Lifecycles
* `28_BALANCING_PHILOSOPHY.md` — Stat Scaling & Meta Management

---

> **Document Revision History**  
> *v1.0.0* — Initial Early Publish Scope Blueprint established by Creative Director.