# Realmbreaker — Production Roadmap & Live Operations Schedule

> **Document Code:** 13_ROADMAP.md  
> **Category:** Live Operations / Production Roadmap  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 03_CULTIVATION.md, 17_MONETIZATION.md, 31_CONTENT_EXPANSION.md

---

## 1. Executive Summary & Production Philosophy

The production roadmap for **Realmbreaker** is governed by an **Early Publish / Disciplined Live Service** model.

Rather than remaining in development for years trying to build a massive, empty world, **Realmbreaker** executes a hyper-focused 15-week release schedule for Version 1.0 (Early Publish). 

This delivers a tight, highly polished 4-Realm baseline with complete combat, economy, and monetization loops, allowing us to:
1. Publish early to gather real player telemetry and retention metrics.
2. Establish immediate **Roblox Developer Exchange (DevEx)** monthly revenue streams.
3. Fund and scale subsequent major updates (V1.1 to V1.3) through a predictable bi-weekly live operations pipeline.

---

## 2. V1.0 Early Publish Timeline (Weeks 1 – 15)

The launch path is organized into five disciplined sprint phases:

```
+-----------------------------------------------------------------------+
|                    V1.0 EARLY PUBLISH SPRINT TIMELINE                 |
+-----------------------------------------------------------------------+
|  WEEKS 1-4   : Core Architecture & Combat Engine                      |
|  WEEKS 5-8   : World Assembly, Dungeon & PvP Engine                   |
|  WEEKS 9-11  : Economy, Monetization & UI/UX Cross-Platform            |
|  WEEKS 12-14 : Closed Beta, Stress Testing & Telemetry Balancing      |
|  WEEK 15     : OFFICIAL V1.0 PUBLIC RELEASE (DEVEX READY)            |
+-----------------------------------------------------------------------+
```

### 2.1 Sprint Phase Breakdown

#### Phase 1: Core Systems & Data Architecture (Weeks 1 – 4)
* **Deliverables:**
  * Implement `SaveService` via `ProfileService` with session locking (`24_SAVE_SYSTEM.md`).
  * Implement 4-Realm Cultivation engine and Qi gauge math (`03_CULTIVATION.md`).
  * Build server-validated combat engine with parry frames and posture meters (`04_COMBAT.md`).
* **Milestone Gate:** Internal tech demo with 0% data loss and functional parry mechanics.

#### Phase 2: World & PvE/PvP Engine (Weeks 5 – 8)
* **Deliverables:**
  * Assemble Zone 1 (Bamboo Leaf Village) and Zone 2 (Mistveil Forest) (`02_WORLD.md`).
  * Build `Ancient Sword Mystic Realm` instanced dungeon and boss AI (`07_PVE.md`).
  * Implement Contested Qi Artery capture zones and open-world PvP hostility flags (`06_PVP.md`).
* **Milestone Gate:** Playable 4-player dungeon run and multi-player Qi node territory fight.

#### Phase 3: Economy, Monetization & UI/UX (Weeks 9 – 11)
* **Deliverables:**
  * Build secure 2-step trade window and Sect Marketplace tax engine (`09_ECONOMY.md`).
  * Integrate Robux Gamepasses, Sect VIP Pass, and Developer Products (`17_MONETIZATION.md`).
  * Deploy responsive cross-platform HUD and Qi Sensing vision overlay (`08_UI_UX.md`).
* **Milestone Gate:** Full economy audit confirming zero item duplication vulnerabilities.

#### Phase 4: Closed Beta & Telemetry Balancing (Weeks 12 – 14)
* **Deliverables:**
  * Invite 250 Closed Beta testers from community Discord.
  * Execute server load stress testing (up to 50 concurrent players per instance).
  * Calibrate combat frame data, damage curves, and TTK metrics using live telemetry (`28_BALANCING_PHILOSOPHY.md`).
* **Milestone Gate:** D1 retention >35% and D7 retention >12% in beta cohort.

#### Phase 5: Official V1.0 Early Publish Launch (Week 15)
* **Deliverables:**
  * Full public game release on Roblox platform.
  * Launch sponsor marketing push via Roblox Ads and content creator creator codes.
  * Activate live server monitoring and hotfix support.

---

## 3. Post-Launch Live Operations Roadmap (V1.1 – V1.3)

Post-launch content expansions follow a strict 8-week major update cycle, supported by bi-weekly bug fixes and balancing patches:

```
+-----------------------------------------------------------------------+
|                   POST-LAUNCH LIVE SERVICE ROADMAP                    |
+-----------------------------------------------------------------------+
|  V1.0 (Month 1)  : Launch Baseline (Realms 0-3, Zones 1-2, 2 Stances)  |
|  V1.1 (Month 3)  : Celestial Ascent (Realm 4: Nascent Soul, Zone 3)   |
|  V1.2 (Month 5)  : Faction Siege (Realm 5: Soul Formation, Cross-PvP)|
|  V1.3 (Month 7)  : Sovereign Realm (Realm 6, Sect Island Housing)     |
+-----------------------------------------------------------------------+
```

### 3.1 Update V1.1: The Celestial Ascent (Month 3 Post-Launch)
* **New Cultivation Realm:** **Nascent Soul (Realm 4)** — Unlocks Soul Projection (temporary invulnerable scouting body) and Telekinesis.
* **New Zone:** **Zone 3: Floating Cloud Isles** — Sky platforms accessible only via Flight or Celestial Flight Mounts.
* **New Martial Discipline:** **Heavenly Spear Stance** — High-reach thrusting stance specializing in airborne combat.
* **New Dungeon:** `Sky Realm Shrine` — 6-player raid dungeon.

### 3.2 Update V1.2: Faction Siege & Demon Domain (Month 5 Post-Launch)
* **New Cultivation Realm:** **Soul Formation (Realm 5)** — Unlocks Avatar Manifestation (giant spectral body during domain battles).
* **New System:** **Cross-Server Faction Territory Siege Wars** — Sects compete for weekly castle control and global tax revenue.
* **New Zone & Weapon:** **Demon Abyss Zone** & **Blood Blade Discipline**.

### 3.3 Update V1.3: Sovereign Realm & Guild Base Building (Month 7 Post-Launch)
* **New Cultivation Realm:** **Void Refining / Sovereign (Realm 6 - End-Game Cap)**.
* **New Feature:** **Custom Sect Island Housing** — Guilds can purchase floating islands, build custom training pavilions, and plant private alchemy herb gardens.

---

## 4. Production Risk Management & Scope Containment

To guarantee on-time delivery without burning out the development team:

1. **Feature Freeze Rule:** Feature scope for V1.0 is locked as of `00_PROJECT_OVERVIEW.md`. Any new mechanic suggested during development is automatically moved to V1.1+ backlog.
2. **Buffer Weeks:** Weeks 13 and 14 are dedicated strictly to bug fixes, optimization, and polish. No new features may be added during buffer weeks.
3. **Data Safety First:** If a data persistence bug is detected in beta, launch is delayed until `SaveService` integrity is 100% verified.

---

## 5. System Interconnections

* **Connections to 00_PROJECT_OVERVIEW.md:** Dictates the exact scope boundaries for V1.0 vs V1.1+ live service.
* **Connections to 17_MONETIZATION.md:** Aligns production milestones with Roblox DevEx payout targets.
* **Connections to 31_CONTENT_EXPANSION.md:** Governs the live ops content pipeline post-launch.

---

> **Document Revision History**  
> *v1.0.0* — Production roadmap, sprint schedule, and live ops pipeline approved by Lead Live Operations Planner & Creative Director.