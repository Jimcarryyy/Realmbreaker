# Realmbreaker — PvE & Dungeon Content Specification

> **Document Code:** 07_PVE.md  
> **Category:** Game Design / PvE Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 02_WORLD.md, 03_CULTIVATION.md, 04_COMBAT.md, 09_ECONOMY.md

---

## 1. Executive Summary & PvE Philosophy

PvE content in **Realmbreaker** is designed to train players in combat mechanics, provide rare cultivation resources, and create high-cohesion cooperative moments.

Rather than featuring passive sponge enemies that simply stand still and absorb damage, spirit beasts and dungeon bosses utilize **Telegraphed Stance Attacks, Breakable Poise Meters, and Mechanical Parry-Checks**.

> **Design Axiom:**  
> *"A boss fight is a dialogue of skill. Players who learn telegraphs, time parries, and stagger the boss earn rare breakthrough catalysts; players who blindly button-mash M1 get punished."*

---

## 2. Enemy AI Architecture & Attack Mechanics

All PvE entities follow a standardized combat state machine to ensure readable, skill-based interactions:

```
+-----------------------------------------------------------------------+
|                       ENEMY AI STATE MACHINE                          |
+-----------------------------------------------------------------------+
|  IDLE / PATROL  ---> SENSE TARGET ---> TELEGRAPH WINDUP (Visual/Audio) |
|                                                    |                  |
|  POSTURE BREAK <--- PARRIED / STAGGERED <--- EXECUTE ATTACK           |
+-----------------------------------------------------------------------+
```

### 2.1 Attack Indicators & Telegraphed Telegraphs
* **Light Attack (White Flash):** Fast attack; blockable or parryable.
* **Heavy Attack (Yellow Flash):** Windup attack; breaks block if not dodged or parried.
* **Unblockable / Grab (Red Flash):** Telegraphed AoE or grab attack; CANNOT be blocked or parried. Must be dodged [Q] or avoided using Air Dash.

### 2.2 Poise / Stagger Meter
* Every spirit beast and boss has a **Poise Meter** under their HP bar.
* Landing M2 heavy attacks, perfect parries, or stance skills drains Poise.
* **Stagger Phase:** When Poise reaches zero, the boss enters a 3.0-second Stagger Phase where all incoming damage is multiplied by 1.75x.

---

## 3. World Mobs & Open-World Bosses (V1.0 Scope)

### 3.1 Tier 1 Mobs (Zone 1: Bamboo Leaf Village)
* **Spirit Wild Boars:** Low poise, linear charge attacks (teaches dodge timing).
* **Outer Sect Rogue Disciples:** Uses basic M1 3-hit combo and block (teaches M2 guard breaking).

### 3.2 Tier 2 Mobs (Zone 2: Mistveil Forest)
* **Mistveil Panthers:** High agility, shadow jump attack (teaches camera lock-on and fast parry reactions).
* **Venom Serpents:** Ranged poison spit (teaches environmental positioning and miasma resistance).

### 3.3 Zone 2 World Boss: Ancient Cavern Golem
* **Location:** Deep Ancient Caverns (Zone 2 Contested Area).
* **Spawn Timer:** Every 2 hours (Server Announcement broadcast).
* **Target Realm:** Group of 3-5 Foundation Establishment (Realm 2) or Core Formation (Realm 3) players.
* **Key Mechanics:**
  * **Earthquake Stomp (AoE):** Red circle indicator expanding on floor. Requires jumping or double-jumping to dodge ground shockwave.
  * **Rock Shield Phase:** At 50% HP, gains a shield that absorbs 80% damage until players break 4 surrounding elemental pillar nodes.
* **Primary Drops:** Core Formation Breakthrough Crystals, Tier 3 Ore, High-Grade Spirit Stones.

---

## 4. Instanced Dungeon — Ancient Sword Mystic Realm

* **Requirement:** Realm 2 (Foundation Establishment)
* **Party Size:** 1 to 4 Players (Dynamic health and damage scaling)
* **Instance Type:** TeleportService Sub-Place (Preserves main server memory)

```
+-----------------------------------------------------------------------+
|               ANCIENT SWORD MYSTIC REALM STRUCTURE                    |
+-----------------------------------------------------------------------+
|  STAGE 1: Floating Sword Corridor (Spatial Dodging & Trash Mobs)      |
|                                  |                                    |
|                                  v                                    |
|  STAGE 2: Trial of the Four Pillars (Co-op Puzzle & Mob Waves)        |
|                                  |                                    |
|                                  v                                    |
|  STAGE 3: FINAL BOSS — The Fallen Swordmaster                         |
+-----------------------------------------------------------------------+
```

### 4.1 Boss Deep-Dive: The Fallen Swordmaster
The boss utilizes a dark variation of the Flowing Water Sword Stance across two phases:

* **Phase 1 (100% - 50% HP):**
  * Uses fast 4-hit sword combos, teleport slashes, and ranged sword wave projectiles.
  * **Parry Check:** Executes a 3-strike frenzy combo. Parrying all 3 hits stuns the boss for 3 seconds.

* **Phase 2 (50% - 0% HP - Dark Domain Activation):**
  * Activates **Shadow Domain**, dimming the arena lighting and boosting boss attack speed by 20%.
  * **Ultimate Move - Thousand Sword Rain:** Flying swords circle the arena ceiling and rain down in telegraphed zones. Players must use Air Dash [Q] to move between safe ground pockets.

---

## 5. Loot Tables & Drop Pity System

To respect player time and prevent unrewarding RNG fatigue:

### 5.1 Dungeon Loot Table (`Ancient Sword Mystic Realm`)

| Item Name | Drop Chance | Item Category | Usage / Economy Value |
| :--- | :---: | :--- | :--- |
| **Spirit Stone Stack (x500)** | 100% | Currency | Standard soft currency reward. |
| **Tier 2 Breakthrough Pill Core** | 65% | Crafting Material | Essential catalyst for Foundation -> Core Formation pills. |
| **Swordmaster Armor Shard** | 30% | Crafting Material | Used to craft Tier 2 Robes (+10% Stamina Regen). |
| **Celestial Sword Flight Skin** | 3% | Rare Cosmetic | Weapon flight visual aura (Tradeable on Marketplace). |

### 5.2 Bad Luck Protection (Pity Token Barter)
* Every successful dungeon completion awards **1x Mystic Realm Token**.
* Players can turn in 15x Tokens at the NPC vendor to directly purchase any rare item from the loot table, guaranteeing steady progression even with unlucky RNG drops.

---

## 6. System Interconnections

* **Connections to 03_CULTIVATION.md:** Boss drops provide essential catalysts and pills required for major realm breakthroughs.
* **Connections to 04_COMBAT.md:** Boss attack patterns test player mastery of parry frame windows, poise staggering, and stamina management.
* **Connections to 09_ECONOMY.md:** Rare dungeon cosmetics and crafting shards drive player marketplace trade volume.

---

> **Document Revision History**  
> *v1.0.0* — PvE and dungeon content blueprint approved by Lead Content Designer.