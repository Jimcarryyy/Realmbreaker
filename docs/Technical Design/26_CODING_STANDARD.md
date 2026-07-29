# Realmbreaker — Luau Coding Standards & Style Guide

> **Document Code:** 26_CODING_STANDARD.md  
> **Category:** Technical Design / Engineering Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 10_TECHNICAL_ARCHITECTURE.md, 21_FOLDER_STRUCTURE.md, 23_NETWORK_ARCHITECTURE.md, 24_SAVE_SYSTEM.md

---

## 1. Executive Summary & Engineering Philosophy

The engineering pipeline for **Realmbreaker** demands high-performance, maintainable, and exploit-proof Luau code. 

Because Roblox instances must support mobile devices with limited CPU/RAM, every script must adhere strictly to memory safety, type checking, and zero-leak garbage collection protocols.

> **Engineering Axiom:**  
> *"Write code that is self-documenting, strictly typed, clean of memory leaks, and understandable by any senior Roblox developer without additional explanation."*

---

## 2. Strict Type Checking & Directives

Every Luau script in the repository MUST begin with the strict type checking directive on line 1:

`--!strict`

* **No Implicit `any`:** All function parameters, return values, and module state fields must be explicitly typed using Luau type annotations.
* **Shared Type Definitions:** Common data types (e.g., `PlayerProfile`, `CombatHitboxData`, `StanceState`) must be defined in `src/Shared/Types/` and imported into Services/Controllers.

---

## 3. Naming Conventions Matrix

Consistency across naming conventions eliminates ambiguity across client, server, and shared code boundaries:

| Identifier Type | Convention | Example |
| :--- | :--- | :--- |
| **Services & Controllers** | `PascalCase` | `CultivationService`, `CombatController` |
| **ModuleScripts & Classes** | `PascalCase` | `Maid`, `ReplicaBridge`, `QiNodeComponent` |
| **Local Variables & Params** | `camelCase` | `currentQi`, `targetPlayer`, `deltaTime` |
| **Global Constants** | `SCREAMING_SNAKE_CASE` | `MAX_QI_CAP`, `BASE_MEDITATION_RATE` |
| **Private Functions / Fields**| `_camelCase` (Leading `_`) | `_validateHitbox()`, `_calculateDamage()` |
| **Remote Events & Signals** | `PascalCase` (Verb-Noun) | `RequestBreakthrough`, `UpdateQiState` |
| **Luau Custom Types** | `PascalCase` | `type CultivationData = {...}` |

---

## 4. Code Formatting & Structural Rules

### 4.1 Guard Clauses over Nested Logic
Avoid deep nested `if-then` blocks. Validate conditions early and exit immediately:

* **DO THIS (Guard Clause):**
  * Check if player exists; if not, return.
  * Check if player is alive; if not, return.
  * Execute primary skill logic.

* **DO NOT DO THIS (Deep Nesting):**
  * Nested `if player then` inside `if character then` inside `if humanoid.Health > 0 then`.

### 4.2 Modern Task Library Standard
Legacy Lua global functions are strictly forbidden in the codebase:
* **Forbidden:** `wait()`, `spawn()`, `delay()`
* **Mandatory Replacement:** `task.wait()`, `task.spawn()`, `task.defer()`, `task.delay()`

---

## 5. Memory Management & Garbage Collection Protocols

Memory leaks on Roblox are primarily caused by dangling `RBXScriptConnection` event listeners and un-destroyed instances.

```
+-----------------------------------------------------------------------+
|                    MAID / CLEANUP MANAGEMENT PATTERN                  |
+-----------------------------------------------------------------------+
|  1. COMPONENT CREATED  ---> Initialize Maid Object                    |
|  2. LISTENERS BOUND    ---> Maid:GiveTask(Humanoid.Died:Connect(...)) |
|  3. COMPONENT DESTROYED---> Maid:DoCleaning() (Clears Connections/Instances)|
+-----------------------------------------------------------------------+
```

### 5.1 Event Disconnection & Cleanup Rules
1. **The Maid Pattern:** All dynamic components (e.g., `QiNodeComponent`, `CombatHitbox`) must maintain a `Maid` or `Janitor` instance.
2. **Connection Binding:** Every `.Touched`, `AncestryChanged`, or `RemoteEvent` connection created during runtime MUST be registered to the Maid task queue.
3. **Destruction Hook:** Calling `:Destroy()` or `:Clean()` on a module MUST clear all registered connections and set internal references to `nil`.

---

## 6. Performance Optimization & Execution Rules

To ensure constant 60 FPS execution across Mobile, PC, and Console platforms:

### 6.1 Frame Loop Optimization (`RunService`)
* **Never Instantiation in Loops:** Never instantiate new Part instances, Vector3 operations, or heavy tables inside `RunService.Heartbeat` or `RenderStepped`.
* **Table Pooling:** Combat raycasts and particle sweeps must reuse pre-allocated array tables to prevent Garbage Collector (GC) allocation spikes.

### 6.2 Defensive API Execution (`pcall`)
All external Roblox API requests (e.g., DataStores, TeleportService, MarketplaceService) MUST be wrapped inside `pcall` execution blocks with explicit error logging:

* Wrap Roblox API call inside `pcall`.
* If success, return result.
* If fail, log error to server console and trigger developer alert webhook.

---

## 7. System Interconnections

* **Connections to 21_FOLDER_STRUCTURE.md:** Enforces naming conventions and module organization across `Shared`, `Server`, and `Client`.
* **Connections to 23_NETWORK_ARCHITECTURE.md:** Standardizes RemoteEvent signal naming and server-side rate-limiting checks.
* **Connections to 24_SAVE_SYSTEM.md:** Mandates strict `pcall` wrapping and Luau typing for all `ProfileService` data schema interactions.

---

> **Document Revision History**  
> *v1.0.0* — Luau coding standards, naming conventions, and memory safety rules approved by Lead Software Architect.