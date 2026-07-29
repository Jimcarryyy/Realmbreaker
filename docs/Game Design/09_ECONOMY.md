# Realmbreaker — Economy & Trade System Specification

> **Document Code:** 09_ECONOMY.md  
> **Category:** Game Design / Economy & Systems Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 02_WORLD.md, 03_CULTIVATION.md, 17_MONETIZATION.md, 24_SAVE_SYSTEM.md

---

## 1. Executive Summary & Economy Philosophy

The **Realmbreaker** economy is engineered to maintain long-term stability, control inflation, and drive active player trade without allowing real-money trading (RMT) or pay-to-win mechanics to compromise the competitive landscape.

### Core Economic Principles
1. **Supply Driven by Danger:** High-tier crafting ingredients (e.g., Tier 3 Golden Core Lotuses) only spawn in open PvP contested zones (Zone 2), linking economic wealth directly to player risk and combat skill.
2. **Aggressive Resource Sinks:** Breakthrough elixirs, gear repairs, and alchemy failures permanently remove materials from circulation to prevent hyper-inflation.
3. **Exploit-Proof Architecture:** All trade transactions are validated on the server via `ProfileService` atomic data transactions, eliminating item duplication glitches.

---

## 2. Currency Architecture

V1.0 features three primary economy currencies:

| Currency | Type | How It Is Earned | Economy Function / Sinks | Tradeable? |
| :--- | :--- | :--- | :--- | :---: |
| **Spirit Stones** | Primary Soft Currency | Defeating spirit beasts, completing daily quests, selling herbs to NPCs. | Used for alchemy crafting fees, basic vendor purchases, and market trading taxes. | **Yes** |
| **Sect Tokens** | Social Guild Currency | Contributing herbs/materials to the Sect Vault, winning contested Qi vein wars. | Unlocks exclusive Sect vendor pills, Sect title badges, and Sect buff passes. | **No** |
| **Robux / Spirit Gems** | Premium Currency | Direct purchase via Roblox platform. | Spent on cosmetics, quality-of-life storage, fast travel, and convenience passes. | **No** |

---

## 3. Resource & Alchemy Crafting Loop

Alchemy is the foundational economic engine of **Realmbreaker**. Cultivators require pills for safe breakthroughs, temporary combat buffs, and meridian cleansing.

```
+-----------------------------------------------------------------------+
|                       ALCHEMY CRAFTING LOOP                           |
+-----------------------------------------------------------------------+
|  1. GATHERING    : Harvest Herbs in Wilds (Zone 1 & Zone 2)           |
|  2. PROCESSING   : Combine Herbs + Spirit Stones at Alchemy Cauldron  |
|  3. EXECUTION    : Mini-game (Heat Balance Control)                   |
|  4. OUTCOME      : High Quality Pill / Standard Pill / Failed Ash     |
+-----------------------------------------------------------------------+
```

### 3.1 Material & Pill Tiers

* **Tier 1 (Bamboo Leaf / Basic Herbs):**
  * Spawns: Zone 1 (Safe Area).
  * Output: Minor Healing Salves, Mortal Body Conditioning Pills.
* **Tier 2 (Miasma Grass / Spirit Ore):**
  * Spawns: Zone 2 Swamps & Caverns.
  * Output: Foundation Breakthrough Pills, Miasma Cleansing Elixirs.
* **Tier 3 (Golden Core Lotus / Dragon Vein Core):**
  * Spawns: Zone 2 High-Altitude Shrines & Contested Qi Arteries.
  * Output: Core Formation Breakthrough Pills, Heart Protection Pills (Breakthrough Safety).

---

## 4. Player-to-Player Trading & Marketplace

To protect the server economy while giving players full mercantile freedom:

### 4.1 Secure Direct Trade Window
* **Unlocking Access:** Direct player trading unlocks at **Qi Condensation (Realm 1)** to prevent fresh alt-account spamming.
* **Two-Step Verification:** Both players must lock items, review the summary for 5 seconds, and confirm.
* **Server Atomic Locks:** Server locks player profiles during trade state execution to ensure zero item duplication under high ping or unexpected disconnects.

### 4.2 Sect Marketplace (Auction House)
* **Tax Sink:** A **10% Spirit Stone transaction tax** is applied to all market sales. 50% of the tax is burned permanently (inflation sink), and 50% enters the local Sect Treasury.
* **Listing Limits:** Standard players can list up to 5 items simultaneously; Sect VIP Pass holders can list up to 10 items.

---

## 5. Anti-Inflation & Resource Sinks

To ensure items retain value over months of live service:

1. **Breakthrough Consumption:** Every major realm breakthrough attempt consumes 1 to 3 rare pills regardless of success or failure.
2. **Cauldron Wear & Tear:** Alchemy cauldrons require Spirit Stones to repair after every 20 crafting cycles.
3. **Death Durability Loss:** Dying in Zone 2 reduces non-equipped inventory herb stacks by 10% (dropped as lootable spirit ash).

---

## 6. System Interconnections

* **Connections to 03_CULTIVATION.md:** Alchemy pills crafted in the economy directly govern breakthrough success rates and Qi purity levels.
* **Connections to 02_WORLD.md:** High-tier material spawns are geographically locked in contested open-PvP zones.
* **Connections to 17_MONETIZATION.md:** Monetization provides convenience and time efficiency (e.g., Portable Cauldrons, Inventory Expansion) without directly selling tradeable power items.

---

> **Document Revision History**  
> *v1.0.0* — Economy architecture and trade rules approved by Lead Economy Designer.