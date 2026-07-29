# Realmbreaker — Save System & Anti-Exploit Persistence Specification

> **Document Code:** 24_SAVE_SYSTEM.md  
> **Category:** Technical Design / Data Persistence Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 03_CULTIVATION.md, 09_ECONOMY.md, 21_FOLDER_STRUCTURE.md, 22_DATABASE_DESIGN.md, 23_NETWORK_ARCHITECTURE.md

---

## 1. Executive Summary & Persistence Philosophy

In an online MMORPG like **Realmbreaker**, data integrity is paramount. Item duplication exploits, loss of breakthrough progress, or currency wipes destroy player trust and ruin the game economy.

To ensure enterprise-grade reliability, the persistence engine is built entirely around **ProfileService** (with session locking) combined with strict server-side transaction atomic locks.

> **Technical Axiom:**  
> *"No client ever writes to data directly. All data edits occur inside isolated, server-authoritative transactions governed by strict session locking."*

---

## 2. Session Locking & Lifecycle Flow

Session locking guarantees that a player's profile can only be open on one server instance at any given time, rendering multi-server item duplication exploits impossible.

```
+-----------------------------------------------------------------------+
|                     PROFILE LIFECYCLE & SESSION LOCK                  |
+-----------------------------------------------------------------------+
|  1. PLAYER JOINS    ---> Server Requests Profile Load (Session Lock)  |
|  2. LOCK SUCCESS    ---> Load Data & Replicate to Client              |
|  3. AUTO-SAVE       ---> Background Auto-Save Loop (Every 300s)       |
|  4. TELEPORT/LEAVE  ---> Force Save & Release Session Lock              |
+-----------------------------------------------------------------------+
```

### 2.1 Lifecycle Protocol Steps
1. **Join Phase:** When a player joins a place server, `DataService` requests profile acquisition from Roblox DataStores.
2. **Session Verification:** If another server holds the session lock (e.g., rapid server switching), the server retries 5 times over 15 seconds. If lock acquisition fails, the player is kicked with a clear error message: *"Profile locked by another server. Please wait 30 seconds."*
3. **Session Release:** When a player leaves or teleports to the `Ancient Sword Mystic Realm` dungeon instance, the current server completes a final save and releases the session lock before teleportation finishes.

---

## 3. Master Data Schema (V1.0 Early Publish Baseline)

The player profile schema stores all progression, inventory, stance, and economy states in a single, versioned data table:

* **Profile Version:** 1 (Integer used for automatic data migration across updates)
* **Cultivation State:**
  * RealmTier: Number (0 = Mortal Body, 1 = Qi Condensation, 2 = Foundation, 3 = Core Formation)
  * SubStage: Number (0 = Early, 1 = Mid, 2 = Late, 3 = Peak)
  * CurrentQi: Float
  * MaxQi: Float
  * QiPurity: Float (0.50 to 1.00)
  * UnlockedMechanics: Dictionary (QiGauge, AirDash, QiShield, Flight, DomainStances)
* **Economy & Currencies:**
  * SpiritStones: Number
  * SectTokens: Number
  * PremiumGems: Number
* **Inventory Container:**
  * Array of Item Slots: ItemID, Quantity, Durability, ItemTier, TradeLockedFlag
* **Stance Mastery:**
  * ActiveStance: String ("FlowingWaterSword" / "ThunderPalm")
  * StanceProficiency: Dictionary (StanceID -> Level & XP)
* **Social & Sect State:**
  * SectID: String
  * SectRank: Number
  * InfamyPoints: Number
* **System Settings:**
  * KeybindCustomizations: Dictionary
  * AudioVolume: Dictionary

---

## 4. Anti-Duplication & Transaction Safety

Item duplication on Roblox typically occurs when trading items while abruptly disconnecting. **Realmbreaker** eliminates this vulnerability via **Atomic Transaction Locking**:

```
+-----------------------------------------------------------------------+
|                    ATOMIC TRADE TRANSACTION ENGINE                    |
+-----------------------------------------------------------------------+
|  1. INITIATE TRADE ---> Lock Both Profiles (IsTrading = True)        |
|  2. STAGING        ---> Stage Trade Items in Isolated Temp Table      |
|  3. VERIFY & SAVE  ---> Atomic Exchange & Save Both Profiles to DS    |
|  4. UNLOCK         ---> Clear IsTrading Flag & Confirm to Clients     |
+-----------------------------------------------------------------------+
```

### 4.1 Trade Safety Guarantee
* While `IsTrading = True`, neither player can drop items, sell items to vendors, consume potions, or teleport.
* If a server crashes midway through a trade, both profiles roll back safely to their pre-trade state upon lock release.

---

## 5. Schema Migration & Backward Compatibility

When live game updates introduce new mechanics (e.g., adding a new currency or stance slot in V1.1), existing player saves must not break or wipe.

### 5.1 Auto-Reconcile System
When loading a profile:
1. `DataService` compares the loaded profile schema version against `LATEST_SCHEMA_VERSION`.
2. Missing key-value pairs are automatically populated with default values from a template schema.
3. Obsolete keys are safely pruned without crashing the data loader.

---

## 6. Corruption Recovery & Backup Snapshots

To protect player investment against Roblox DataStore outages or unexpected code bugs:

1. **Auto-Backup Snapshots:**
   * Every major realm breakthrough (e.g., reaching Core Formation) creates a read-only **Breakthrough Milestone Snapshot** stored in a separate DataStore key.
2. **Data Recovery Protocol:**
   * If a profile fails schema validation on load due to DataStore corruption, the server automatically loads the most recent Milestone Snapshot and logs an emergency alert to Discord webhook logs for developer review.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Persists current Qi, sub-stages, unlocked spatial mechanics, and purity levels.
* **Connections to 09_ECONOMY.md:** Enforces atomic locks during trade transactions, auction house sales, and Spirit Stone edits.
* **Connections to 23_NETWORK_ARCHITECTURE.md:** Provides read-only data snapshots replicated via `ReplicaService` to client UI controllers.

---

> **Document Revision History**  
> *v1.0.0* — Data persistence, profile schema, and anti-duplication specifications approved by Lead Technical Designer.