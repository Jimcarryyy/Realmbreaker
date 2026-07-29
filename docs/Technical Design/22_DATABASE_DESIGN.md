# Realmbreaker — Database & DataStore Architecture Specification

> **Document Code:** 22_DATABASE_DESIGN.md  
> **Category:** Technical Design / Database Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 10_TECHNICAL_ARCHITECTURE.md, 21_FOLDER_STRUCTURE.md, 24_SAVE_SYSTEM.md, 26_CODING_STANDARD.md

---

## 1. Executive Summary & Database Philosophy

The database architecture of **Realmbreaker** is designed to provide high-throughput, exploit-proof persistence on Roblox `DataStoreService`, managed via `ProfileService` session locking.

To prevent item duplication, database throttling, and data corruption across servers:
1. **Isolated DataStores:** Player data, Sect guild data, market listings, and leaderboards are decoupled into distinct DataStore scopes.
2. **Byte-Efficient Payload Design:** Data structures utilize compact key naming and optimized arrays to remain far below Roblox's 4MB DataStore key limit.
3. **Atomic Writes & Versioning:** All data structures enforce explicit schema version tags to enable non-destructive background migration during live updates.

---

## 2. DataStore Key Hierarchy & Naming Conventions

All DataStore keys follow a strict production naming convention incorporating major version tags (`_v1.0`):

```
+-----------------------------------------------------------------------+
|                     DATASTORE SCOPE & KEY MATRIX                      |
+-----------------------------------------------------------------------+
|  PLAYER PROFILES   : PlayerData_v1.0     --> Key: Player_{UserId}    |
|  SECT / GUILD DATA : SectData_v1.0       --> Key: Sect_{SectId}      |
|  MARKETPLACE DATA  : MarketData_v1.0     --> Key: Listing_{GUID}     |
|  MILESTONE BACKUPS : PlayerBackups_v1.0  --> Key: Snap_{UserId}_{TS} |
+-----------------------------------------------------------------------+
```

| DataStore Name | Scope / Type | Key Format | Description |
| :--- | :--- | :--- | :--- |
| **`PlayerData_v1.0`** | Standard DataStore | `Player_{UserId}` | Primary player profile (Cultivation, Inventory, Currencies). |
| **`SectData_v1.0`** | Standard DataStore | `Sect_{SectId}` | Guild profiles (Treasury, Member Roster, Node Upgrades). |
| **`MarketData_v1.0`** | Standard DataStore | `Listing_{ListingGUID}` | Active auction house listings and pending trade transactions. |
| **`PlayerBackups_v1.0`**| Standard DataStore | `Snap_{UserId}_{Timestamp}` | Read-only milestone backup snapshots created during breakthroughs. |
| **`Leaderboard_Core_v1`**| OrderedDataStore | `{UserId}` | Global Core Formation breakthrough speed leaderboards. |

---

## 3. Detailed Data Schemas

### 3.1 Player Profile Master Schema (`PlayerData_v1.0`)

```
PlayerProfileSchema = {
    SchemaVersion = 1,
    MetaData = {
        FirstJoined = Number (Unix Timestamp),
        LastOnline = Number (Unix Timestamp),
        PlayTimeTotal = Number (Seconds)
    },
    Cultivation = {
        RealmTier = Number (0 = Mortal, 1 = Qi Condensation, 2 = Foundation, 3 = Core),
        SubStage = Number (0 = Early, 1 = Mid, 2 = Late, 3 = Peak),
        CurrentQi = Float,
        MaxQi = Float,
        QiPurity = Float (0.50 to 1.00),
        UnlockedMechanics = {
            QiGauge = Boolean,
            AirDash = Boolean,
            QiShield = Boolean,
            Flight = Boolean,
            DomainStance = Boolean
        }
    },
    Economy = {
        SpiritStones = Number,
        SectTokens = Number,
        PremiumGems = Number
    },
    Inventory = {
        MaxSlots = 30,
        Items = Array of Slots [
            {
                SlotID = Number,
                ItemID = String ("Herb_Tier2_MiasmaGrass"),
                Quantity = Number,
                Durability = Number,
                ItemTier = Number,
                IsBound = Boolean
            }
        ]
    },
    StanceMastery = {
        ActiveStance = String ("FlowingWaterSword"),
        Proficiencies = Dictionary {
            FlowingWaterSword = { Level = Number, XP = Number },
            ThunderPalm = { Level = Number, XP = Number }
        }
    },
    Social = {
        SectID = String,
        SectRank = Number (1 = Member, 2 = Elder, 3 = Leader),
        InfamyPoints = Number,
        BountyAmount = Number
    },
    Settings = {
        QiSenseColor = String ("Cyan"),
        Keybinds = Dictionary,
        AudioVolume = Dictionary
    }
}
```

### 3.2 Sect / Guild Profile Schema (`SectData_v1.0`)

```
SectProfileSchema = {
    SchemaVersion = 1,
    SectID = String (GUID),
    SectName = String,
    Tag = String (3-4 Characters),
    LeaderUserId = Number,
    Treasury = {
        SpiritStones = Number,
        SectTokens = Number
    },
    Members = Array [
        { UserId = Number, Rank = Number, JoinedTimestamp = Number }
    ],
    TerritoryControl = {
        ClaimedNodes = Array of NodeIDs,
        WeeklyNodePoints = Number
    }
}
```

---

## 4. Payload Budgeting & Optimization Limits

Roblox imposes a strict **4MB limit per DataStore key**. To ensure **Realmbreaker** player profiles consume less than 5% of this limit (under 200KB per save):

1. **Short String Keys:** Database keys use concise identifiers (e.g., `ItemID`, `SlotID`) to minimize JSON serialization overhead.
2. **Dynamic Pruning:** Expired temporary quest flags and non-essential logs are automatically cleared from memory before the save payload is serialized.
3. **Inventory Arrays:** Inventories are stored as compact numerical arrays rather than heavy nested objects.

---

## 5. Migration Engine & Schema Upgrades

When live updates introduce new data keys (e.g., adding a new currency in Update V1.1):

```
+-----------------------------------------------------------------------+
|                     SCHEMA MIGRATION PIPELINE                         |
+-----------------------------------------------------------------------+
|  1. LOAD PROFILE  ---> Compare SchemaVersion vs LATEST_VERSION (v1)   |
|  2. MIGRATION RUN ---> Execute Migration Function (v1 -> v2)           |
|  3. RECONCILE     ---> Merge Missing Default Template Keys             |
|  4. SAVE UPDATED  ---> Write Upgraded Profile back to DataStore        |
+-----------------------------------------------------------------------+
```

### 5.1 Reconcile Function Rules
* When loading a player profile, `SaveService` executes `Profile:Reconcile()`.
* If a new feature adds a key to the template schema (e.g., `StanceMastery.SpearStance`), the reconcile function automatically inserts the key with default zero values without overwriting existing progress.

---

## 6. System Interconnections

* **Connections to 24_SAVE_SYSTEM.md:** Governs session locking, ProfileService integration, and backup snapshot creation.
* **Connections to 09_ECONOMY.md:** Defines currency schemas, inventory slot structures, and trade transaction atomic locks.
* **Connections to 26_CODING_STANDARD.md:** Mandates strict Luau type annotations for all database schema representations.

---

> **Document Revision History**  
> *v1.0.0* — Database schemas, key hierarchy, and payload budgeting approved by Lead Software Architect.