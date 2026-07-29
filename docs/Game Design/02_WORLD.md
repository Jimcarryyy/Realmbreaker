# Realmbreaker — World Architecture & Zone Specification

> **Document Code:** 02_WORLD.md  
> **Category:** Game Design / World & Level Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 03_CULTIVATION.md, 07_PVE.md, TERRAIN_IMPLEMENTATION.md

---

## 1. World Design Philosophy & Architecture

In **Realmbreaker**, world design is not about building vast, empty terrain maps. The world is built on **Concentrated POI Density** and **Realm-Gated Environmental Mechanics**.

Every zone serves a specific gameplay purpose:
1. **Verticality & Spatial Gating:** Certain regions can only be reached using spatial movement abilities unlocked through cultivation (e.g., Air Dashing to cross chasms, Flight to reach mountain shrines).
2. **Hazard Gating:** High-tier resource zones feature lethal environmental pressure (toxic miasma, extreme heat) that requires specific realm resistance or alchemy consumables to survive.
3. **Contested Nodes:** High-density Qi veins are situated in open PvP areas to drive player interaction and Sect rivalries.

---

## 2. V1.0 Zone Breakdown & Layout

For the Early Publish V1.0 release, the world consists of two interconnected zones and one instanced dungeon.

+-----------------------------------------------------------------------+
|                       WORLD MAP STRUCTURE (V1.0)                      |
+-----------------------------------------------------------------------+
|                                                                       |
|  [ ZONE 1: Bamboo Leaf Village ] (Safe Zone / Starter Grounds)        |
|               |                                                       |
|               v  (Miasma Barrier Gate)                                |
|  [ ZONE 2: Mistveil Forest ]     (Open PvP / Contested Wilds)         |
|        |              |                                               |
|        v              v                                               |
|  [ Ancient Caverns ]  [ Mystic Realm Portal ] (Dungeon 1 Instance)    |
|                                                                       |
+-----------------------------------------------------------------------+

---

## 3. Zone 1: Bamboo Leaf Village & Outer Sect Grounds

* **Target Realm:** Realm 0 (Mortal Body) to Realm 1 (Qi Condensation)
* **PvP Rules:** Safe Zone (PvP strictly disabled)
* **Primary Function:** Player onboarding, basic combat tutorial, low-tier resource gathering, safe meditation.

### 3.1 Key Landmarks & Points of Interest (POIs)
* **Bamboo Leaf Sect Pavilion:** Quest givers, basic skill trainers, item bank, and Sect tribute board.
* **Spirit Spring Pond:** Low-density Qi node (+1.0x Qi Meditation rate). Safe area for beginners to practice meditation mechanics.
* **Training Grounds:** Dummy targets programmed with parry and block triggers for players to practice timing.
* **Mortal Trade Plaza:** Player-to-player trading hub and basic alchemy NPC vendors.

### 3.2 Resource & Mob Distribution
* **Gathering Nodes:** Bamboo Spirit Leaf (Tier 1 Herb), Iron Stone (Basic Crafting).
* **Wild Fauna / Mobs:** Spirit Wild Boars (Level 1-5), Outer Sect Rogue Disciples (Level 5-10).

---

## 4. Zone 2: Mistveil Forest & Ancient Qi Caverns

* **Target Realm:** Realm 2 (Foundation Establishment) to Realm 3 (Core Formation)
* **PvP Rules:** Open PvP (Contested Territory)
* **Primary Function:** High-tier alchemy herb harvesting, high-density Qi node competition, dungeon access, open-world faction clashes.

### 4.1 Environmental Hazard — Toxic Miasma
The deep areas of Mistveil Forest are covered in a dense green mist:
* **Effect:** Deals 5% max HP damage per second to Realm 0 and Realm 1 players.
* **Bypass Condition:** Reaching Realm 2 (Foundation Establishment) unlocks natural meridian resistance, or consuming a Miasma Purifying Pill (crafted via Alchemy).

### 4.2 Key Landmarks & Points of Interest (POIs)
* **Mistveil Swamp:** Home to rare Tier 2 & Tier 3 alchemy herbs. Protected by elite spirit beasts.
* **Ancient Qi Caverns:** Underground tunnel network containing **Contested Qi Arteries** (+5.0x Qi Meditation rate). Sects fight for control over these nodes.
* **High Mountain Shrines:** Sky platforms suspended above the clouds. Only accessible via Air Dashing (Realm 2) or Flight (Realm 3). Contains rare breakthrough lotus flowers.
* **Mystic Realm Gate:** Teleportation portal leading to Dungeon 1 (`Ancient Sword Mystic Realm`).

### 4.3 Resource & Mob Distribution
* **Gathering Nodes:** Miasma Grass (Tier 2 Herb), Golden Core Lotus (Tier 3 Herb), Spirit Crystal Ore.
* **Wild Fauna / Mobs:** Mistveil Panthers (Level 15-25), Venom Serpents (Level 25-35), Ancient Cavern Golem (Zone World Boss).

---

## 5. Spatial Movement & Realm Progression Integration

World design directly rewards cultivation advancement through physical terrain access:

| Player Realm | Unlocked Movement Ability | Accessible World Features |
| :--- | :--- | :--- |
| **Mortal Body** | Standard Jump & Sprint | Bamboo Leaf Village, Main Roads, Basic Training Grounds. |
| **Qi Condensation** | Qi Sensing HUD [V] | Unlocks visual tracking of hidden Qi nodes and underground herb roots. |
| **Foundation Establishment** | Air Dash / Flash Step [Q] | Can cross wide mountain chasms and reach floating platform shortcuts in Zone 2. |
| **Core Formation** | Flight / Levitation [Space x2] | Full access to mountain peaks, cloud shrines, and aerial shortcuts across the entire world map. |

---

## 6. Technical Implementation & Streaming Strategy

To maintain high FPS on mobile and console platforms while preserving visual fidelity:

1. **Roblox StreamingEnabled Setup:**
   * Target Streaming Radius: 250 studs.
   * Streaming Mode: Opportunistic (prioritizes loading terrain and POIs directly in player camera view).

2. **Sub-Place Instancing:**
   * Zone 1 and Zone 2 exist within the main server place.
   * `Dungeon 1 (Ancient Sword Mystic Realm)` operates in a separate, instanced place server via Roblox TeleportService to preserve server memory and performance.

3. **Node Replication Security:**
   * Herb nodes and Qi veins use server-side random spawning with validation to prevent auto-teleport gathering bots.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Environmental Qi density multipliers vary by zone location; terrain hazards require specific realm ranks to survive.
* **Connections to 06_PVP.md:** Zone 2 features contested Qi veins that allow open-world combat and Sect dominance points.
* **Connections to 07_PVE.md:** Zone 2 houses the Mystic Realm Gate portal leading to instanced co-op dungeons.

---

> **Document Revision History**  
> *v1.0.0* — World architecture and zone specifications approved by Lead World Designer.