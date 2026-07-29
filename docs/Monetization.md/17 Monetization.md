# Realmbreaker — Monetization & Revenue Strategy

> **Document Code:** 17_MONETIZATION.md  
> **Category:** Monetization & Live Operations Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 09_ECONOMY.md, 20_RETENTION.md

---

## 1. Executive Summary & Revenue Philosophy

The monetization design of **Realmbreaker** is structured to achieve steady **Roblox Developer Exchange (DevEx)** monthly payout thresholds while building long-term player trust.

> **Monetization Axiom:**  
> *"Sell Convenience, Time-Efficiency, and Social Prestige—Never Sell Unearnable Combat Power."*

* **No Pay-to-Win PvP:** Robux purchases never grant direct stat advantages, unblockable attacks, or invulnerability in PvP combat.
* **Ethical Time Savings:** Paid options reduce tedious backtracking or grinding time (e.g., auto-meditation offline, portable alchemy cauldrons) without locking free-to-play players out of any content.

---

## 2. Target Revenue Metrics (DevEx Target Baseline)

For V1.0 Early Publish, monetization systems target the following key performance indicators (KPIs):

* **Day 1 Retention (D1):** > 35%
* **Day 7 Retention (D7):** > 12%
* **Monthly Pay Conversion Rate:** 3.5% - 5.0% of active players
* **Average Revenue Per Paying User (ARPPU):** 450 - 600 Robux

---

## 3. Product Catalog & Pricing Matrix (V1.0 Launch)

Products are categorized into Gamepasses (one-time purchases) and Developer Products (repeatable consumables).

### 3.1 Gamepasses (One-Time Purchases)

| Product Name | Robux Price | Category | Gameplay & Aesthetic Value |
| :--- | :---: | :--- | :--- |
| **Sect VIP Membership Pass** | 499 R$ | Subscription / Pass | +10% Meditation Qi rate, custom gold chat tag, +5 Auction House listing slots, 24-hr offline meditation cap. |
| **Portable Alchemy Cauldron** | 299 R$ | Convenience | Craft breakthrough pills and elixirs anywhere in the world without returning to safe zone villages. |
| **Qi Sense HUD Upgrade** | 199 R$ | Quality of Life | Expands Qi sensing visual aura radius from 50 studs to 100 studs and color-codes herb rarity tiers on HUD. |
| **Celestial Sword Flying** | 399 R$ | Cosmetic Status | Replaces standard flight animation at Core Formation (Realm 3) with a glowing, glowing dual-sword flight trail. |

### 3.2 Developer Products (Repeatable Consumables)

| Product Name | Robux Price | Category | Gameplay Function |
| :--- | :---: | :--- | :--- |
| **Heart Protection Pill** | 99 R$ | Safety / Convenience | Consumed during major breakthroughs to prevent Meridian Backfire debuffs and Qi loss upon failure. *(Also craftable via high-tier in-game Alchemy).* |
| **Inventory Expansion (+20 Slots)** | 149 R$ | Storage | Permanently adds 20 extra inventory slots for herbs, ores, and equipment storage. |
| **Waystone Teleport Scroll (x5)** | 49 R$ | Fast Travel | Instant fast travel to unlocked waypoints in Zone 1 and Zone 2. |

---

## 4. Player Retention & Monetization Integration

Monetization is seamlessly woven into the daily player lifecycle to drive continuous retention:

```
+-----------------------------------------------------------------------+
|                    MONETIZATION RETENTION ENGINE                      |
+-----------------------------------------------------------------------+
|  1. DAILY LOG-IN     : Earn Daily Streak Tokens (Free-to-Play)        |
|  2. OFFLINE MEDITATE : Collect Accumulated Qi (Extended by VIP Pass)  |
|  3. CONTESTED VEINS  : Fight for Nodes (Use Heart Pill for Safety)    |
|  4. SOCIAL SHOWCASE  : Flex Cosmetic Sword Trails & Celestial Titles  |
+-----------------------------------------------------------------------+
```

---

## 5. Monetization Integrity & Anti-P2W Rules

To protect player sentiment, game balance, and Roblox community trust:

1. **Equal Access Guarantee:** Every consumable item available for Robux (e.g., Heart Protection Pills, Teleport Scrolls) MUST remain earnable or craftable through standard in-game play.
2. **Combat Isolation:** Purchased items cannot be activated during active combat or while taking damage in PvP zones.
3. **No Random Gacha Lootboxes:** Breakthroughs rely on player timing and skill; items are sold transparently at fixed prices without random loot box odds.

---

## 6. System Interconnections

* **Connections to 09_ECONOMY.md:** VIP passes increase listing limits on the Sect Marketplace and provide Spirit Stone sinks.
* **Connections to 03_CULTIVATION.md:** Heart Protection Pills provide a failure safety net during the skill-based Heavenly Tribulation mini-game.
* **Connections to 20_RETENTION.md:** Offline meditation caps and daily streak incentives build long-term player habit loops.

---

> **Document Revision History**  
> *v1.0.0* — Complete monetization strategy and product catalog approved by Lead Monetization Planner.