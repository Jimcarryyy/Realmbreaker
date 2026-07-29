# Realmbreaker — Live Operations Content Expansion Pipeline

> **Document Code:** 31_CONTENT_EXPANSION.md  
> **Category:** Live Operations / Expansion Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 02_WORLD.md, 03_CULTIVATION.md, 13_ROADMAP.md, 28_BALANCING_PHILOSOPHY.md

---

## 1. Executive Summary & Expansion Philosophy

The content expansion pipeline of **Realmbreaker** is engineered to allow seamless, long-term game updates post-launch without breaking legacy content, causing player burnout, or requiring codebase overhauls.

Instead of hardcoding features into static scripts, all realms, stances, zones, and alchemy recipes exist as **Modular Configuration Data Tables**. Adding a new realm or martial stance requires zero changes to core combat or data persistence engines.

> **Expansion Axiom:**  
> *"New expansions must add new mechanical dimensions and world verticality, rather than simply raising stat caps or invalidating early-game starter zones."*

---

## 2. Post-Launch Expansion Roadmap (V1.1 – V1.3)

Following the V1.0 Early Publish release (Mortal Body to Core Formation cap), post-launch content expands on a predictable 8- to 10-week major update cycle:

```
+-----------------------------------------------------------------------+
|                    POST-LAUNCH EXPANSION TIMELINE                     |
+-----------------------------------------------------------------------+
|  V1.0 LAUNCH BASELINE  : Realms 0-3 (Core Cap), Zones 1-2, 2 Stances   |
|  V1.1 EXPANSION       : Realm 4 (Nascent Soul), Zone 3, Spear Stance  |
|  V1.2 EXPANSION       : Realm 5 (Soul Formation), Zone 4, Siege PvP   |
|  V1.3 EXPANSION       : Realm 6 (Void Refining), Sect Island Housing  |
+-----------------------------------------------------------------------+
```

### 2.1 Expansion Content Specifications

#### Update V1.1: The Celestial Ascent (Month 3 Post-Launch)
* **New Cultivation Realm:** **Nascent Soul (Realm 4)**
  * *Primary Unlock:* **Soul Projection** (Allows temporary invulnerable spirit body scouting) and **Telekinesis** (Pick up and hurl physical environmental objects in combat).
* **New Zone:** **Zone 3: Floating Cloud Isles** — Sky platforms accessible only via Flight or Celestial Mounts.
* **New Martial Discipline:** **Heavenly Spear Stance** — High-reach thrusting stance specializing in mid-air combo catching.
* **New Dungeon:** `Sky Realm Shrine` — 6-player raid dungeon featuring aerial boss phases.

#### Update V1.2: Demon Realm & Faction Siege (Month 5 Post-Launch)
* **New Cultivation Realm:** **Soul Formation (Realm 5)**
  * *Primary Unlock:* **Avatar Manifestation** (Summon a giant spectral avatar body during domain battles).
* **New System:** **Cross-Server Faction Territory Siege Wars** — Sects clash weekly for control of ancient castles and global Spirit Stone tax revenue.
* **New Zone & Stance:** **Zone 4: Demon Abyss** & **Blood Blade Discipline**.

#### Update V1.3: Sovereign Realm & Guild Housing (Month 7 Post-Launch)
* **New Cultivation Realm:** **Void Refining / Sovereign (Realm 6)**.
* **New Feature:** **Custom Sect Island Housing** — Guilds purchase floating sky islands, build custom training pavilions, and plant private high-tier alchemy herb gardens.

---

## 3. The 5-Step Realm Addition Workflow

Adding a new Cultivation Realm to **Realmbreaker** follows a strict 5-step engineering pipeline:

```
+-----------------------------------------------------------------------+
|                      REALM ADDITION PIPELINE                          |
+-----------------------------------------------------------------------+
|  STEP 1: Data Definition in Shared Config (RealmsConfig.lua)          |
|  STEP 2: Code Mechanical Skill Controller (e.g., Soul Projection)      |
|  STEP 3: Build Zone & Environmental Hazard (Zone 3 Miasma/Pressure)   |
|  STEP 4: Integrate Alchemy Pills & Tribulation Mini-Game Target       |
|  STEP 5: Calibrate Cross-Realm Damage Scaling in Balancing Module     |
+-----------------------------------------------------------------------+
```

### 3.1 Step Breakdown
1. **Data Definition (`RealmsConfig.lua`):** Append new realm parameters (Sub-stages, base HP/Qi caps, breakthrough pill requirements, tribulation strike count).
2. **Mechanical Skill Controller (`src/Client/Controllers/`):** Code the unique mechanical ability unlocked by the realm (e.g., `SoulProjectionController.lua`).
3. **World & Environmental Hazard (`02_WORLD.md`):** Construct the new zone and implement realm-gated environmental pressure (e.g., High-Altitude Pressure requiring Realm 4 resistance).
4. **Alchemy & Economy (`09_ECONOMY.md`):** Add Tier 4 herbs, breakthrough pill recipes, and trade tax parameters.
5. **Balancing Calibration (`28_BALANCING_PHILOSOPHY.md`):** Update cross-realm damage normalization tables to ensure legacy realms remain competitive in PvP.

---

## 4. Legacy Content Preservation & Trade Chains

To prevent early zones (Zone 1 & Zone 2) from becoming empty, abandoned ghost towns when higher realms are released:

1. **Interdependent Crafting Chains:** Tier 4 & Tier 5 endgame breakthrough pills require Tier 1 herbs (Zone 1) combined with Tier 4 herbs (Zone 3). Higher-realm players must either return to harvest early zones or buy herbs from beginner players on the Sect Marketplace.
2. **Sect Mentorship Tokens:** Higher-realm disciples who guide lower-realm players through Zone 1 dungeons earn **Mentorship Tokens** redeemable for exclusive prestige cosmetics.

---

## 5. Live Operations Patch Cadence

To maintain high player retention and continuous community engagement:

* **Bi-Weekly Maintenance Patches:** Released every 14 days. Includes bug fixes, minor stance balancing tweaks, and Celestial Merchant inventory rotations.
* **Major Content Expansions:** Released every 8 to 10 weeks according to the post-launch roadmap.

---

## 6. System Interconnections

* **Connections to 02_WORLD.md:** Defines the architectural standards for adding Zone 3 and Zone 4 maps.
* **Connections to 03_CULTIVATION.md:** Uses the established modular schema for appending Realm 4 (Nascent Soul) and Realm 5 (Soul Formation).
* **Connections to 13_ROADMAP.md:** Aligns expansion release dates with live operations revenue planning.
* **Connections to 28_BALANCING_PHILOSOPHY.md:** Adjusts cross-realm damage normalization and HP scaling caps for new realm tiers.

---

> **Document Revision History**  
> *v1.0.0* — Content expansion pipeline, realm addition workflow, and live ops release cadence approved by Lead Live Operations Planner.