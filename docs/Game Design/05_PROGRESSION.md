# Realmbreaker — Progression Architecture & Player Journey

> **Document Code:** 05_PROGRESSION.md  
> **Category:** Game Design / Progression Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 03_CULTIVATION.md, 04_COMBAT.md, 09_ECONOMY.md, 20_RETENTION.md

---

## 1. Executive Summary & Progression Philosophy

Progression in **Realmbreaker** operates on two distinct parallel vectors: **Macro Realm Progression** (unlocking physical capabilities, spatial mobility, and environmental access) and **Micro Stance Mastery** (refining individual weapon skill trees and combat proficiencies).

To prevent early burnout and maximize Day-1, Day-7, and Day-30 player retention:
* **Anti-Grind Guarantee:** Progression pacing prioritizes active gameplay (parrying spirit beasts, competing for Qi nodes, clearing dungeons) over idle AFK clicking.
* **Dual Progression Velocity:** Casual players can maintain steady macro progress via resting Qi and daily Sect tributes, while hardcore players accelerate through active PvP and high-density node control.

---

## 2. Dual Progression Structure

+-----------------------------------------------------------------------+
|                    REALMBREAKER PROGRESSION ENGINE                     |
+-----------------------------------------------------------------------+
|                                                                       |
|   [ MACRO PROGRESSION ]               [ MICRO PROGRESSION ]           |
|   Cultivation Realm Advancement       Martial Stance Mastery          |
|   • Unlocks Spatial Abilities         • Unlocks Skill Modifiers       |
|   • Expands Qi & HP Gauges            • Reduces Cooldowns & Stamina   |
|   • Grants World Zone Access          • Unlocks Weapon Finisher Moves |
|                                                                       |
+-----------------------------------------------------------------------+

---

## 3. V1.0 Launch Progression Lifecycle (0 to 50+ Hours)

The V1.0 Early Publish lifecycle is mapped across four detailed progression phases:

### 3.1 Phase 1: Mortal Awakening (Hours 0 – 2)
* **Goal:** Master core combat controls (M1, M2, Parry [F], Dodge [Q]) and reach Qi Condensation.
* **Key Milestones:**
  * Complete Bamboo Leaf Village onboarding tutorial.
  * Practice block and parry mechanics against training dummies.
  * Harvest first Tier 1 herbs and perform body-refining meditation.
* **Major Unlock:** First major breakthrough into **Qi Condensation (Realm 1)**. Unlocks Qi Gauge and Qi Sensing HUD.

### 3.2 Phase 2: Qi Assembly & Forest Border (Hours 2 – 8)
* **Goal:** Explore Zone 1 wild areas, craft basic alchemy potions, and prepare for Zone 2 entry.
* **Key Milestones:**
  * Defeat Spirit Wild Boars and Rogue Sect Disciples.
  * Locate ambient Qi spring nodes in Zone 1.
  * Craft first Tier 1 Breakthrough Pill.
* **Major Unlock:** Second major breakthrough into **Foundation Establishment (Realm 2)**. Unlocks Air Dash [Q], Qi Shielding [F], and toxic miasma resistance for Zone 2.

### 3.3 Phase 3: Deep Wilds & Ancient Caverns (Hours 8 – 20)
* **Goal:** Enter Zone 2 (Mistveil Forest), run instanced dungeons, and compete for mid-density Qi nodes.
* **Key Milestones:**
  * Cross toxic miasma swamps to reach the Mystic Realm Portal.
  * Defeat the bosses in `Ancient Sword Mystic Realm` (Dungeon 1).
  * Harvest Tier 2/3 alchemy herbs and participate in open-world PvP over cavern veins.
* **Major Unlock:** Third major breakthrough into **Core Formation (Realm 3 - V1.0 Cap)** via the skill-based Heavenly Tribulation mini-game. Unlocks Flight and Domain Stances.

### 3.4 Phase 4: Core Dominance & End-Game (Hours 20 – 50+)
* **Goal:** Maximize Core Formation sub-stages, dominate contested Qi veins, and drive the Sect economy.
* **Key Milestones:**
  * Fly to hidden high-altitude mountain shrines to harvest Golden Core Lotuses.
  * Lead Sect raids on open-world World Bosses in Zone 2.
  * Craft high-tier tradeable elixirs for the server market.

---

## 4. Realm Progression Curves & Qi Scaling Formulas

Qi required to advance through sub-stages (Early -> Mid -> Late -> Peak) scales exponentially across realms:

Total_Qi_Required = Base_Qi_Cost * (1.8 ^ Sub_Stage_Index) * (3.5 ^ Realm_Tier_Index)

### 4.1 V1.0 Realm Qi Requirements Table

| Realm Tier | Sub-Stage | Required Qi | Estimated Active Time | Primary Source |
| :---: | :--- | :--- | :--- | :--- |
| **Realm 0** | Mortal Peak | 250 Qi | 30 - 45 Minutes | Training Dummies & Basic Herbs |
| **Realm 1** | Condensation Early | 600 Qi | 1 Hour | Spirit Spring Meditation |
| **Realm 1** | Condensation Peak | 2,200 Qi | 3 - 4 Hours | Spirit Beasts & Tier 1 Pills |
| **Realm 2** | Foundation Early | 5,500 Qi | 5 - 6 Hours | Cavern Qi Nodes & Tier 2 Pills |
| **Realm 2** | Foundation Peak | 18,000 Qi | 10 - 12 Hours | Dungeon Bosses & Contested Nodes |
| **Realm 3** | Core Formation Peak | 65,000 Qi | 20+ Hours | Contested Arteries & Tier 3 Pills |

---

## 5. Micro Stance Mastery Scaling

Weapon stances (e.g., Flowing Water Sword, Thunder-Palm) level up independently through combat usage:

* **Earning Stance XP:**
  * Successful Light Attack Hit: +5 XP
  * Successful Heavy Guard Break: +15 XP
  * Perfect Parry Executed: +25 XP
  * Dungeon Boss Defeated: +250 XP

### 5.1 Stance Mastery Rewards

* **Level 1 (Novice):** Default stance skills unlocked.
* **Level 5 (Adept):** Stamina cost of stance skills reduced by 15%.
* **Level 10 (Master):** Unlocks Stance Skill 2 variant and reduces skill cooldowns by 20%.
* **Level 15 (Grandmaster):** Unlocks unique cosmetic weapon aura and +5% stance damage modifier.

---

## 6. Retention Engine & Anti-Fatigue Mechanics

To maximize long-term retention and support casual player catchup:

1. **Resting Qi Pool (Offline Meditation):**
   * Accumulates Qi while offline at 25% of the standard meditation rate (capped at 12 hours of offline storage).
   * VIP Sect Pass holders receive a 50% offline rate and 24-hour cap (Monetization hook).

2. **Daily Sect Tributes:**
   * Completing 3 daily Sect tasks (e.g., gather 5 herbs, defeat 3 beasts, parry 5 attacks) awards daily Breakthrough Pill fragments and Sect reputation currency.

3. **Breakthrough Safeguards:**
   * Experiencing a Meridian Backfire failure grants a stacking +10% success probability bonus on the subsequent attempt, preventing unrewarding luck walls.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Dictates exact numeric Qi thresholds and sub-stage limits for all launch realms.
* **Connections to 04_COMBAT.md:** Stance Mastery XP rewards active skill usage (parries, combos, guard breaks).
* **Connections to 09_ECONOMY.md:** Daily quests and breakthrough requirements drive market demand for alchemy pills and herb trading.
* **Connections to 20_RETENTION.md:** Offline meditation caps and daily Sect tributes optimize Day-1 through Day-30 player lifecycles.

---

> **Document Revision History**  
> *v1.0.0* — Complete V1.0 progression blueprint approved by Lead Progression Designer.