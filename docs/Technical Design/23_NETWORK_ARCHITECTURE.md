# Realmbreaker — Network Architecture & Replication Specification

> **Document Code:** 23_NETWORK_ARCHITECTURE.md  
> **Category:** Technical Design / Network Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 04_COMBAT.md, 08_UI_UX.md, 21_FOLDER_STRUCTURE.md, 24_SAVE_SYSTEM.md

---

## 1. Executive Summary & Networking Philosophy

The network architecture of **Realmbreaker** is built on a **Server-Authoritative with Client-Side Prediction** model. 

On Roblox, trusting the client for combat hitboxes, currency, or movement verification results in rampant exploitation, item duplication, and unfair PvP. Conversely, waiting for server round-trips for visual effects creates unacceptable input latency.

> **Technical Axiom:**  
> *"The Client predicts visuals and audio for immediate responsiveness; the Server validates physics, state changes, hitboxes, and data persistence."*

---

## 2. Network Data Flow & Replication Pattern

To maintain high tick rates and low bandwidth consumption (targeting mobile network compatibility), network traffic is structured into clean data flows:

```
+-----------------------------------------------------------------------+
|                    CLIENT-SERVER REPLICATION FLOW                     |
+-----------------------------------------------------------------------+
|  [ CLIENT ]                                           [ SERVER ]      |
|  1. Player Inputs Action (M1/Parry/Dash)                              |
|  2. Plays Local Anim & FX Immediately  ---> (Remote) ---> 3. Validates Input Timing|
|  4. Receives Server Confirmation       <--- (Replica) <--- 5. Executes Damage & State|
+-----------------------------------------------------------------------+
```

### 2.1 Communication Channels
* **RemoteEvents (Unreliable/Reliable Channels):** Used for non-critical visual triggers, ambient sound sync, and rapid combat input bursts.
* **RemoteFunctions (Strict Usage):** Reserved exclusively for synchronous UI requests (e.g., initiating market trade, confirming item purchases). Never used inside active combat loops to prevent thread blocking.
* **Replica Data Bridge:** Read-only data synchronization layer streams player cultivation stats, active buffs, and inventory states from Server to Client.

---

## 3. Server-Side Hit Registration & Lag Compensation

To eliminate ghost hits and guarantee competitive fairness across varying ping levels (up to 150ms latency buffer):

```
+-----------------------------------------------------------------------+
|                  HIT REGISTRATION VALIDATION ENGINE                   |
+-----------------------------------------------------------------------+
|  Client Requests Attack Hit  ---> Check Server Position History (150ms)|
|                                                   |                   |
|  [ INVALID ] <--- Fails Distance / Line-of-Sight <--- [ VALID ]       |
|  Discard Hit       Check Target I-Frames & Parry   Apply Damage & Poise|
+-----------------------------------------------------------------------+
```

### 3.1 Hit Validation Pipeline
When a player executes an attack:
1. **Client Signal:** Client sends target ID and local timestamp to the server.
2. **History Rewind (150ms Buffer):** Server retrieves the historical position of both attacker and defender at the target timestamp.
3. **Shapecast Verification:** Server performs a `WorldRoot:Shapecast` or `WorldRoot:Raycast` sweep using the attacker's weapon bounds.
4. **State Checks:** Server verifies whether the defender was in an active Parry Window [F] or Dodge I-Frame [Q] state at that exact millisecond.
5. **Damage Application:** If verified, server applies health and posture damage, broadcasting hit reaction visuals to surrounding clients.

---

## 4. Bandwidth Optimization & Rate Limiting

To prevent Remote Event spam, memory leaks, and Denial-of-Service (DoS) attacks on server performance:

### 4.1 Input Rate Limiting
* **Combat Inputs:** Capped at 15 Remote requests per second per client. Excess requests are silently dropped and logged.
* **Inventory Transactions:** Capped at 3 requests per second per client.

### 4.2 Spatial Interest Management (Replication Radius)
* High-frequency combat animations and particle effects are replicated only to clients within a **200-stud spatial radius**.
* Out-of-range combat effects are culled to reduce client CPU rendering load on mobile devices.

---

## 5. Anti-Exploit Security Protocols

The server continuously monitors player state invariants to detect and neutralize cheats automatically:

### 5.1 Movement & Physics Validation
* **Speed / Teleport Check:** Server calculates the player's displacement delta per frame:
  
  `Max_Allowed_Distance = (Current_Move_Speed * Delta_Time) + Tolerance_Buffer`

  * If displacement exceeds `Max_Allowed_Distance` (without an active Air Dash or Flight flag), the player is instantly rubber-banded back to their last valid position.
* **Flight Validation:** Server raycasts downward to verify ground contact. If a player is airborne without Realm 3 (Core Formation) or an active Air Dash skill unlocked, Flight physics are disabled.

### 5.2 Resource & Stat Security
* **Stamina & Qi Integrity:** Server maintains authoritative stamina/Qi pools. Client UI bars are purely decorative mirrors of server state.
* **Item Duplication Safeguard:** All trade transfers and crafting transactions execute inside atomic mutex locks. Inventory profiles cannot be edited while a trade or breakthrough transaction is pending.

---

## 6. Technical Framework Architecture

The codebase follows a modular service/controller pattern:

* **Server Framework (Services):**
  * `CombatService.lua` — Handles hit validation, damage calculation, parry states.
  * `CultivationService.lua` — Authoritative Qi tracking, breakthrough logic.
  * `NetworkService.lua` — Remote routing, rate-limiting middleware.
* **Client Framework (Controllers):**
  * `CombatController.lua` — Handles local input detection, animation playback, hit prediction.
  * `UIController.lua` — Listens to replica state changes and updates HUD elements.

---

## 7. System Interconnections

* **Connections to 04_COMBAT.md:** Provides the server-side raycasting and lag compensation engine for weapon strikes and parries.
* **Connections to 08_UI_UX.md:** Feeds data to client UI controllers via latency-optimized replica streams.
* **Connections to 24_SAVE_SYSTEM.md:** Enforces atomic locks on profile data during remote transactions.

---

> **Document Revision History**  
> *v1.0.0* — Network architecture and hit validation engine specifications approved by Lead Technical Designer.