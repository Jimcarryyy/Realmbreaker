# Realmbreaker — Live Events Architecture & Seasonal Operations

> **Document Code:** 30_LIVE_EVENTS.md  
> **Category:** Live Operations / Event Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 02_WORLD.md, 03_CULTIVATION.md, 09_ECONOMY.md, 13_ROADMAP.md, 20_RETENTION.md

---

## 1. Executive Summary & Event Philosophy

In **Realmbreaker**, live events serve as the primary engine for driving Concurrent Users (CCU), boosting weekend retention, and stimulating the server economy.

Events are divided into **Automated Micro-Events** (running on server clock cycles), **Weekend Boosts** (driving Friday-Sunday play spikes), and **Major Seasonal Festivals** (tied to major game expansions).

> **Live Ops Axiom:**  
> *"Events must create excitement and community convergence without causing economic hyperinflation or invalidating past player achievements."*

---

## 2. Event Architecture Classification Matrix

```
+-----------------------------------------------------------------------+
|                       LIVE EVENT CLASSIFICATION                       |
+-----------------------------------------------------------------------+
|  1. AUTOMATED MICRO-EVENTS   : Every 2-4 Hours (15-Minute Spikes)     |
|  2. WEEKEND BOOST EVENTS     : Friday - Sunday (50% Qi Boosts)        |
|  3. SEASONAL FESTIVALS       : 2-Week Limited Events (Unique Cosmetics)|
+-----------------------------------------------------------------------+
```

| Event Type | Frequency | Duration | Primary Objective | Economy & Balance Impact |
| :--- | :--- | :---: | :--- | :--- |
| **Qi Tide Surge** | Every 2 Hours | 15 Mins | Concentrates players at Zone 2 Qi Arteries. | +50% Meditation Qi Rate (Capped). |
| **Spirit Beast Stampede** | Every 4 Hours | 20 Mins | Drives open-world beast hunting and materials. | Increases Tier 1-2 herb supply by 25%. |
| **Double Qi Weekend** | Fri 6 PM – Sun 11:59 PM | 54 Hours | Boosts weekend D7/D30 player retention. | +50% Meditation Qi rate server-wide. |
| **Celestial Merchant** | Every Saturday | 24 Hours | Soft currency sink (Spirit Stones). | Sells rare seeds & limited pill recipes. |
| **Seasonal Festival** | Quarterly (4x / Year) | 14 Days | Drives major marketing pushes & DevEx revenue. | Event currency + Time-limited cosmetics. |

---

## 3. Automated Micro-Events (Daily Schedule)

Automated micro-events run on deterministic UTC server timers to ensure predictable active play windows:

### 3.1 Qi Tide Surge (Every 2 Hours)
* **Trigger:** Server broadcasts banner alert: *"The Qi Tides rise! Ambient energy concentrates in Zone 2 Ancient Caverns!"*
* **Gameplay Effect:**
  * All Qi Vein Meditation Nodes yield **2.0x base Qi rate**.
  * Spawns 3 **Overcharged Qi Arteries** in deep Zone 2 caverns, triggering open-world PvP skirmishes between rival Sects.

### 3.2 Spirit Beast Stampede (Every 4 Hours)
* **Trigger:** Spawn notification broadcast across Zone 1 and Zone 2.
* **Gameplay Effect:**
  * Spawns 15 Elite Spirit Beasts across Mistveil Forest.
  * Beasts drop guaranteed **Tier 2 Alchemy Herbs** and double Spirit Stones, encouraging group hunting parties.

---

## 4. Weekend Boost Events & Celestial Merchant

To maximize weekend active play hours and drive high weekend retention numbers:

### 4.1 Double Qi Weekend (Friday 6 PM – Sunday 11:59 PM UTC)
* **Mechanic:** Server-wide **+50% Meditation Qi accumulation boost**.
* **Purpose:** Allows casual players to catch up on macro realm progress and encourages players to attempt major breakthroughs during high-population weekend hours.

### 4.2 Celestial Traveling Merchant (Saturdays)
* **Location:** Randomly appears in Zone 1 (Bamboo Leaf Village) or Zone 2 (Mistveil Forest).
* **Inventory Sinks:** Sells rare alchemy seeds, high-tier cauldron repair kits, and exclusive tradeable cosmetic titles.
* **Economy Guard:** Purchases require large quantities of **Spirit Stones**, actively pulling excess soft currency out of circulation to control inflation.

---

## 5. Major Seasonal Event Framework (V1.0 Roadmap Integration)

Seasonal events run for 14 days and introduce time-limited event currencies and prestige cosmetics:

```
+-----------------------------------------------------------------------+
|                    SEASONAL EVENT OPERATIONAL LOOP                    |
+-----------------------------------------------------------------------+
|  1. EVENT QUESTS  ---> Earn Time-Limited Event Tokens (e.g., Moon Gems)|
|  2. EVENT BOSS    ---> Participate in World Raid Boss Battles        |
|  3. REWARD SHOP   ---> Redeem Tokens for Event Titles & Sword Skins   |
+-----------------------------------------------------------------------+
```

### 5.1 Example Event: The Moonlit Eclipse Festival (Autumn Event)
* **Event Lore:** The moon passes through an ancient spiritual rift, flooding the world with celestial lunar energy.
* **Special Event Currency:** **Moonlit Tokens** (earned via daily event quests and dungeon clears).
* **Exclusive Event Rewards:**
  * *Lunar Crescent Flight Skin* (Cosmetic sword flight aura).
  * *Title:* "Moonlit Sovereign" (Cosmetic chat tag).
  * *Lunar Pill Recipe:* Temporary 1-hour +10% movement speed elixir.

---

## 6. Technical Automation & Remote Trigger Architecture

To allow live ops managers to trigger events dynamically without taking down live servers:

1. **UTC Server Sync:** Event managers calculate active windows using `os.time()` synced to UTC standard time.
2. **MessagingService Dynamic Overrides:** Developers can broadcast global MessagingService signals to instantly trigger or extend events across all live server instances without publishing a game update.
3. **Multiplier Hard Caps:** Event multipliers (e.g., double Qi) are hard-capped at 2.0x to prevent stacking glitches from breaking cultivation formulas in `03_CULTIVATION.md`.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Event Qi multipliers apply directly to active meditation and node extraction rates.
* **Connections to 09_ECONOMY.md:** Celestial Merchant visits act as primary Spirit Stone sinks to control inflation.
* **Connections to 13_ROADMAP.md:** Aligns quarterly seasonal event releases with major content version launches (V1.1, V1.2).
* **Connections to 20_RETENTION.md:** Scheduled micro-events and weekend boosts drive daily and weekly player return loops.

---

> **Document Revision History**  
> *v1.0.0* — Live event classification, micro-event timers, and automation framework approved by Lead Live Operations Planner.