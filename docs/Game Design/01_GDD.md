# Realmbreaker — Master Game Design Document (GDD)

> **Document Code:** 01_GDD.md  
> **Category:** Game Design / Master Specification  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** Consolidates 00_PROJECT_OVERVIEW.md through 33_PLAYER_PSYCHOLOGY.md

---

## 1. Executive Summary & Vision Statement

**Realmbreaker** is an action-driven Xianxia/Wuxia MMORPG developed for the Roblox platform (PC, Mobile, Console).

Unlike generic cultivation simulators that rely on mindless AFK clicking and inflated stat multipliers, **Realmbreaker** anchors progression to **Meaningful Mechanical Unlocks**—new spatial movement abilities, combat stances, tactical parrying buffers, environmental hazard access, and territorial competition.

> **Master Axiom:**  
> *"Every realm advancement unlocks new gameplay mechanics rather than simply increasing numbers."*

---

## 2. Core Game Loop & Design Pillars

```
+-----------------------------------------------------------------------+
|                      REALMBREAKER CORE GAME LOOP                      |
+-----------------------------------------------------------------------+
|  1. EXPLORE & GATHER : Harvest Herbs & Locate High-Density Qi Veins    |
|  2. MEDITATE & CRAFT : Accumulate Qi & Brew Breakthrough Elixirs      |
|  3. BREAKTHROUGH     : Survive Skill-Based Heavenly Tribulation       |
|  4. COMBAT & PVP     : Master Stances & Compete for Contested Arteries|
+-----------------------------------------------------------------------+
```

### The 4 Design Pillars
1. **Purposeful Progression:** Progression unlocks spatial and tactical mechanics (Air Dashing, Qi Shielding, Flight, Domain Stances).
2. **Interconnected World:** Alchemy requires herbs from dangerous PvP wild zones; dungeon clears award breakthrough pill catalysts.
3. **Skill-Based Combat:** Active parrying, animation-cancel dodging, posture breaks, and directional stances allow skilled players to outplay higher-realm opponents.
4. **Ethical Monetization:** Focus on convenience, time-efficiency, and social prestige without breaking PvP integrity.

---

## 3. V1.0 Cultivation Realms & Mechanical Unlocks

V1.0 Early Publish features four deeply designed realms:

| Realm Tier | Realm Name | Sub-Stages | Primary Mechanical Unlocks |
| :---: | :--- | :---: | :--- |
| **0** | **Mortal Body** | Early -> Peak | Physical combos, stamina roll, basic block. |
| **1** | **Qi Condensation** | Early -> Peak | **Qi Energy Pool**, ranged **Qi Projectiles**, **Qi Sensing HUD [V]**. |
| **2** | **Foundation Establishment** | Early -> Peak | **Air Dash [Q]**, **Qi Shielding [F]**, **Alchemy Crafting**, Miasma Immunity. |
| **3** | **Core Formation** *(V1.0 Cap)* | Early -> Peak | **Flight / Levitation**, **Domain Stances [G]**, **Contested Qi Extraction**. |

---

## 4. Combat Engine & Launch Stances

Combat relies on deterministic frame data, stamina management, and posture meters:

* **Basic Attacks:** Light Combo Chain (M1) and Heavy Guard Break (M2).
* **Defensive Reaction:** Active Parry [F] (0.18s base window; extended to 0.33s via Qi Shielding) and Dodge Roll / Flash Step [Q] (0.20s I-Frames).
* **Posture Break State:** Depleting a target's posture meter causes a 1.5-second stagger state dealing 1.5x damage.

### Launch Martial Disciplines
* **Flowing Water Sword Stance:** Defensive counter-striker stance with high parry rewards and unblockable ripostes.
* **Thunder-Palm Unarmed Stance:** Aggressive pressure stance with 2.0x posture damage against guarding opponents.

---

## 5. World Design & Content Scope

* **Zone 1: Bamboo Leaf Village (Safe Area):** Onboarding tutorial, spirit spring meditation (+1.0x Qi), low-tier herb gathering, non-PvP zone.
* **Zone 2: Mistveil Forest & Ancient Caverns (Contested Area):** Toxic miasma swamp, open-world PvP, high-density Qi Arteries (+5.0x Qi), World Boss (*Ancient Cavern Golem*).
* **Dungeon 1: Ancient Sword Mystic Realm (Instanced Co-Op):** 1 to 4 player dungeon ending in a two-phase boss battle against *The Fallen Swordmaster*.

---

## 6. PvP & Contested Qi Vein Engine

* **Hostility Modes:** Peaceful Mode (Safe) vs Hostile Mode (+15% Qi Extraction Bonus in Zone 2).
* **Infamy & Bounties:** Killing peaceful players builds Infamy points; Outlaw players drop 20% inventory herbs upon death and spawn public bounty markers.
* **Contested Qi Arteries:** Every 30 minutes, major subterranean Qi veins activate in Zone 2. Sects channel the node for 10 seconds to claim exclusive 5.0x meditation rates for 15 minutes.

---

## 7. Economy, Trading & Monetization Engine

* **Currencies:** Spirit Stones (Soft tradeable currency), Sect Tokens (Social currency), Robux / Spirit Gems (Premium currency).
* **Secure Trading:** 2-step verification trade window locked by server atomic data transactions to prevent item duplication.
* **Sect Marketplace:** Auction house featuring a 10% transaction tax (50% burned for anti-inflation; 50% sent to Sect Treasury).
* **Monetization Catalog:** Sect VIP Membership Pass (499 R$), Portable Alchemy Cauldron (299 R$), Qi Sense HUD Upgrade (199 R$), Heart Protection Pills (99 R$), Celestial Sword Flight Trails (399 R$).

---

## 8. Technical Architecture Baseline

* **Server-Authoritative:** Server validates all hitboxes, movement speed deltas, and state transitions via spatial raycasting.
* **ProfileService Persistence:** Session locking prevents multi-server item duplication exploits.
* **Strict Luau Standards:** `--!strict` type annotations, event-driven UI updates, and Maid/Janitor garbage collection.

---

## 9. Master Documentation Mapping

| Module Category | Primary Documentation Files |
| :--- | :--- |
| **Game Overview & Scope** | `00_PROJECT_OVERVIEW.md`, `01_GDD.md`, `15_GAME_IDENTITY.md` |
| **World & Progression** | `02_WORLD.md`, `03_CULTIVATION.md`, `05_PROGRESSION.md`, `12_LORE.md` |
| **Combat & Content** | `04_COMBAT.md`, `06_PVP.md`, `07_PVE.md`, `28_BALANCING_PHILOSOPHY.md` |
| **UI/UX & Art Direction** | `08_UI_UX.md`, `11_ART_DIRECTION.md` |
| **Economy & Monetization** | `09_ECONOMY.md`, `17_MONETIZATION.md`, `20_RETENTION.md`, `33_PLAYER_PSYCHOLOGY.md` |
| **Technical Design** | `21_FOLDER_STRUCTURE.md`, `23_NETWORK_ARCHITECTURE.md`, `24_SAVE_SYSTEM.md`, `26_CODING_STANDARD.md` |
| **Live Operations** | `13_ROADMAP.md`, `30_LIVE_EVENTS.md` |

---

> **Document Revision History**  
> *v1.0.0* — Master Game Design Document finalized and approved by Creative Director & Lead Systems Designer.