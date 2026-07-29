# Realmbreaker — PvP Architecture & Contested Systems Specification

> **Document Code:** 06_PVP.md  
> **Category:** Game Design / PvP Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 02_WORLD.md, 03_CULTIVATION.md, 04_COMBAT.md, 09_ECONOMY.md

---

## 1. Executive Summary & PvP Philosophy

In traditional Xianxia literature, cultivation is a ruthless path where practitioners clash over limited celestial resources. **Realmbreaker** captures this core fantasy through **Objective-Driven PvP**.

PvP is not designed as mindless spawn-killing. It is built around high-stakes competition over **Contested Qi Arteries**, rare herb spawns, and Sect dominance in open-world wilderness zones.

> **Design Axiom:**  
> *"Violence requires purpose. Players do not fight simply to grief beginners; they fight to claim 5.0x Qi Arteries, harvest rare Golden Core Lotuses, and defend Sect honor."*

---

## 2. World PvP Zones & Hostility States

PvP engagement is strictly governed by spatial zone rules and player hostility flags:

```
+-----------------------------------------------------------------------+
|                       WORLD PVP ZONE STRUCTURE                        |
+-----------------------------------------------------------------------+
|  ZONE 1 (Bamboo Village)   : SAFE ZONE (PvP Completely Disabled)      |
|  ZONE 2 (Mistveil Forest)  : CONTESTED ZONE (Objective Open PvP)      |
|  ANCIENT CAVERNS           : FULL PVP (High Density Qi Arteries)      |
+-----------------------------------------------------------------------+
```

### 2.1 Player Hostility Modes

Players can toggle their hostility state via the HUD icon or `[P]` key when in Zone 2:

* **Peaceful Mode (Blue):** Cannot attack other Peaceful players. Automatically counter-attacks if ambushed by a Hostile player.
* **Hostile Mode (Red):** Can attack any player in Zone 2. Grants a **+15% Qi Extraction Bonus** at contested nodes, but makes the player a valid target for all nearby cultivators.

### 2.2 Infamy & Bounty System

To prevent high-realm players from endlessly griefing lower-realm players:

* **Infamy Points:** Killing a Peaceful player grants 50 Infamy Points.
* **Infamy Consequences:**
  * **0 - 49 Infamy (Clean):** Standard death penalties.
  * **50 - 199 Infamy (Wanted):** Name turns bright crimson; visible through obstacles via Qi Sensing HUD [V].
  * **200+ Infamy (Outlaw):** Dying in PvP causes a **20% inventory drop rate** of unequipped herbs and Spirit Stones.
* **Bounty Hunting:** Defeating an Outlaw player awards their accumulated bounty in Spirit Stones and Sect Reputation Tokens to the victor.

---

## 3. Contested Qi Vein Engine (Core Open-World PvP Objective)

The primary driver of open-world PvP in Zone 2 is the control of underground **Qi Arteries**.

```
+-----------------------------------------------------------------------+
|                    CONTESTED QI VEIN CAPTURE LOOP                     |
+-----------------------------------------------------------------------+
|  1. SPAWN     : Artery Node activates in Ancient Caverns (Every 30m)  |
|  2. CHANNEL   : Channel at Central Crystal (10s Uninterrupted)        |
|  3. CONTROL   : Holding Sect receives 5.0x Meditation Rate for 15m    |
|  4. DEFENSE   : Defend Node Radius against enemy Sect assault         |
+-----------------------------------------------------------------------+
```

### 3.1 Node Classifications

* **Minor Qi Node:**
  * Location: Zone 1 Borders & Zone 2 Wilds.
  * Meditation Bonus: 2.5x Base Qi Rate.
  * Capacity: 2 Players max.
* **Major Qi Artery (Contested Objective):**
  * Location: Deep Ancient Caverns (Zone 2).
  * Meditation Bonus: 5.0x Base Qi Rate + Tier 3 Herb Spawns.
  * Capacity: Entire Sect Team (up to 10 players inside the 20-stud aura ring).

---

## 4. Duel & Arena System (1v1 & 3v3 Structured Combat)

For players seeking pure skill-based combat without open-world third-party interruptions:

### 4.1 Safe Zone Wager Duels
* Initiated by interacting with another player in Zone 1 and selecting **Request Duel**.
* Players can set optional wagers: Spirit Stones, Crafting Materials, or Sect Reputation.
* Spawns a temporary 30-stud forcefield ring. Crossing the ring boundary counts as forfeiting the match.

### 4.2 Sect Arena Grounds
* Located in Zone 1 Outer Sect.
* Features automated 1v1 and 3v3 matchmaking queues with skill-based rating (Elo System).
* **Spectator Platform:** Non-combatant players can sit in the arena stands to watch high-level matches in real-time.

---

## 5. Anti-Griefing & Balance Safeguards

To protect early-game player retention and prevent abusive behavior:

1. **Realm Gap Protection:**
   * A Realm 3 (Core Formation) player receives a 60% damage scaling penalty when attacking a Realm 1 (Qi Condensation) player in open wild areas.
   * This ensures lower-realm players have time to use Air Dash or Flash Step [Q] to escape into safe zones.

2. **Respawn Protection:**
   * Respawning at a Zone 2 Waypoint grants a **10-second Invulnerability & Invisibility Shield**.
   * Moving outside the sanctuary zone or drawing a weapon cancels the shield instantly.

---

## 6. System Interconnections

* **Connections to 04_COMBAT.md:** Active parrying [F], stance switching, and stamina management determine the outcome of PvP duels and node defense.
* **Connections to 03_CULTIVATION.md:** High-tier mechanics like Domain Stances [G] and Flight are critical for controlling space during team fights over Qi Arteries.
* **Connections to 09_ECONOMY.md:** Infamy death penalties and wager duels create soft currency sinks and high-stakes trade loops.
* **Connections to 20_RETENTION.md:** Scheduled hourly Qi Artery spawns drive peak daily active user (DAU) play sessions.

---

> **Document Revision History**  
> *v1.0.0* — PvP architecture and contested vein systems approved by Lead PvP Systems Designer.