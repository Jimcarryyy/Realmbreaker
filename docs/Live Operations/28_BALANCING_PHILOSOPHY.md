# Realmbreaker — Balancing Philosophy & Stat Scaling Specification

> **Document Code:** 28_BALANCING_PHILOSOPHY.md  
> **Category:** Live Operations / Combat & Systems Balance  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 03_CULTIVATION.md, 04_COMBAT.md, 05_PROGRESSION.md, 06_PVP.md

---

## 1. Executive Summary & Core Philosophy

In **Realmbreaker**, balance is governed by the principle of **Controlled Power Curve**. 

Traditional Roblox RPGs fail because high-level players gain 10,000x health and damage, rendering combat mindless and destroying lower-level engagement. **Realmbreaker** caps stat scaling strictly, ensuring that high-realm cultivators gain **utility, spatial options, and versatility**, while combat time-to-kill (TTK) remains grounded in skill.

> **Balancing Axiom:**  
> *"No hit should ever one-shot an equal-tier opponent. Stat scaling grants endurance and options, but timing, parries, and positioning decide the victor."*

---

## 2. Target Time-To-Kill (TTK) Metrics

All stat formulas, damage outputs, and cooldowns are tuned to maintain strict TTK boundaries across V1.0 content:

| Engagement Type | Target TTK Duration | Key Balance Goal |
| :--- | :---: | :--- |
| **1v1 Duel (Equal Realm)** | 18 – 30 Seconds | Allows 2-3 full skill rotations, multiple parry opportunities, and stance switches. |
| **Open World PvP (Zone 2)** | 12 – 25 Seconds | Provides time for attacked players to react, call for Sect aid, or use Air Dash to escape. |
| **Dungeon Boss Fight** | 3 – 5 Minutes | Requires consistent mechanics execution, staggering phases, and resource management. |

---

## 3. Stat Scaling Formulas & Hard Caps

To prevent unbalanceable stat inflation across V1.0 launch realms (Realm 0 to Realm 3):

### 3.1 Health (HP) Scaling Formula
Base HP begins at 100 for Mortal Body and scales moderately per realm tier:

Max_HP = Base_HP + (Realm_Tier * 75) + (Sub_Stage_Index * 15)

* **Realm 0 (Mortal Body):** 100 – 145 HP
* **Realm 1 (Qi Condensation):** 175 – 220 HP
* **Realm 2 (Foundation Establishment):** 250 – 295 HP
* **Realm 3 (Core Formation - V1.0 Cap):** 325 – 370 HP

### 3.2 Posture / Stamina & Qi Pool Caps

* **Stamina Pool:** Flat 100 Stamina for all players. Higher realms DO NOT increase stamina pool size; they reduce stamina consumption efficiency via Stance Mastery.
* **Qi Energy Pool:**
  * Realm 0: 0 Qi (No Qi usage)
  * Realm 1: 100 Qi
  * Realm 2: 250 Qi
  * Realm 3: 500 Qi

### 3.3 Single-Hit Damage Burst Cap
* **Anti-One-Shot Rule:** No single skill, combo finisher, or elixir-buffed attack may deal more than **35% of a target's maximum HP** in a single strike. Excess burst damage is automatically clipped by the server combat engine.

---

## 4. Combat Frame Data & Window Balance

Defensive mechanics follow strict frame data parameters to ensure skill-based counterplay:

```
+-----------------------------------------------------------------------+
|                    FRAME DATA & DEFENSIVE WINDOWS                     |
+-----------------------------------------------------------------------+
|  PARRY WINDOW    : 0.18s Base (11 frames at 60 FPS)                   |
|  QI SHIELD BUFFER: +0.15s Extension (Max total parry window: 0.33s)    |
|  DODGE I-FRAMES  : 0.20s Invulnerability Window                       |
|  POSTURE BREAK   : 1.50s Vulnerability Window (1.5x damage taken)     |
+-----------------------------------------------------------------------+
```

### 4.1 Parry Recovery & Cooldown Penalty
* **Successful Parry:** 0s cooldown, refunds 100% stamina, staggers attacker for 1.2s.
* **Missed Parry:** Applies a **1.0-second recovery penalty** during which blocking and dodging are disabled. Prevents parry button spamming.

---

## 5. Cross-Realm PvP Damage Normalization

To ensure open-world PvP in Zone 2 remains competitive while respecting progression gains:

When a higher-realm player attacks a lower-realm player, a dynamic damage scaling modifier is applied:

Attacker_Damage_Multiplier = 1.0 - (Realm_Tier_Difference * 0.25)

| Attacker Realm | Defender Realm | Tier Difference | Damage Multiplier |
| :---: | :---: | :---: | :---: |
| **Realm 3 (Core)** | **Realm 3 (Core)** | 0 | 1.00x (100% Full Damage) |
| **Realm 3 (Core)** | **Realm 2 (Foundation)** | 1 | 0.75x (75% Damage) |
| **Realm 3 (Core)** | **Realm 1 (Condensation)** | 2 | 0.50x (50% Damage) |

---

## 6. Launch Stance Tuning Parameters

V1.0 martial stances are balanced around clear counter-archetypes:

```
+-----------------------------------------------------------------------+
|                       STANCE BALANCE MATRIX                           |
+-----------------------------------------------------------------------+
|  FLOWING WATER SWORD     <--->     THUNDER-PALM UNARMED               |
|  • High Parry Recovery             • High Posture Damage              |
|  • Moderate Burst Damage           • Close Range Mobility             |
|  • Counter-Attacker                • Block Pressure                   |
+-----------------------------------------------------------------------+
```

### 6.1 Flowing Water Sword Stance
* **M1 Combo Damage:** 8 / 8 / 10 / 16 (Total: 42 Damage full string).
* **Parry Window Modifier:** +0.03s extra parry leniency.
* **Weakness:** Low posture damage against blocking opponents.

### 6.2 Thunder-Palm Unarmed Stance
* **M1 Combo Damage:** 6 / 6 / 8 / 12 (Total: 32 Physical Damage full string).
* **Posture Damage Multiplier:** 2.0x posture depletion against guarding targets.
* **Weakness:** Shorter attack range (requires gap closing via Flash Step).

---

## 7. Live Operations Telemetry & Balancing Workflow

To maintain long-term balance integrity post-launch:

1. **Automated Analytics Tracking:**
   * **Stance Win-Rates:** Monitored weekly. If any stance achieves >55% win-rate in 1v1 duels, it is flagged for tuning.
   * **Realm Defeat Ratios:** Tracks lower-realm vs higher-realm kill rates in Zone 2.
2. **Patch Cadence:**
   * **Micro-Adjustments:** Bi-weekly hotfixes for stance damage numbers or cooldown tweaks.
   * **Major Balance Passes:** Released alongside major content expansions (e.g., V1.1 Realm additions).

---

## 8. System Interconnections

* **Connections to 03_CULTIVATION.md:** Dictates HP, Stamina, and Qi pool scaling caps for all launch realms.
* **Connections to 04_COMBAT.md:** Governs exact parry frame data, posture break windows, and combo damage values.
* **Connections to 06_PVP.md:** Enforces cross-realm damage normalization in open-world contested zones.

---

> **Document Revision History**  
> *v1.0.0* — Stat scaling, frame data, and combat balance specifications approved by Lead Systems Designer.