# Realmbreaker — Codebase & Directory Structure Specification

> **Document Code:** 21_FOLDER_STRUCTURE.md  
> **Category:** Technical Design / Code Architecture  
> **Status:** Active Standard — Version 1.0 (Argon Sync Production Standard)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 10_TECHNICAL_ARCHITECTURE.md, 23_NETWORK_ARCHITECTURE.md, 24_SAVE_SYSTEM.md, 26_CODING_STANDARD.md

---

## 1. Executive Summary & Architectural Philosophy

The codebase of **Realmbreaker** is structured for strict modularity, scalability, and two-way live synchronization using **Argon** in VS Code.

To transition from early prototyping to AAA-grade production:
1. **Service-Controller Pattern:** The server operates strictly through decoupled **Services** (handling logic, database, and validation), while the client operates through **Controllers** (handling input, local prediction, animations, and UI).
2. **Single Responsibility Principle (SRP):** Each ModuleScript governs a single isolated feature (e.g., `CultivationService` handles Qi math; `CombatService` handles hitboxes; `SaveService` handles data persistence).
3. **No Direct Cross-Boundary Calls:** Client and Server communicate exclusively through defined network bridge interfaces (`BridgeNet` / `Knit Signals`).

---

## 2. Master Directory Tree Hierarchy (Argon Mapped)

Below is the official production directory layout mapped directly to your local `src/` folder for Argon sync:

```
src/
├── ReplicatedFirst/            --> Preloading screens & initial splash UI
├── ReplicatedStorage/          --> Shared client-server assets & logic
│   └── Shared/
│       ├── Config/             --> Central game balance configurations
│       │   ├── RealmsConfig.lua  --> 4 Launch realms, sub-stages & HP caps
│       │   ├── StancesConfig.lua --> Martial stances, skill frame data & combos
│       │   ├── NodesConfig.lua   --> Qi vein density multipliers & spawn rates
│       │   ├── ZonesConfig.lua   --> Zone boundaries & miasma hazard parameters
│       │   ├── ItemsConfig.lua   --> Alchemy herbs, pills & equipment definitions
│       │   └── AssetsConfig.lua  --> Centralized Animation, Sound & Mesh IDs
│       ├── Network/            --> Remote communication bridges
│       │   └── BridgeSignals.lua --> RemoteEvent/Function definitions
│       ├── Utils/              --> Utility library modules
│       │   ├── Maid.lua        --> Garbage collection & memory cleanup manager
│       │   ├── Signal.lua      --> Custom fast signal implementation
│       │   └── Promise.lua     --> Asynchronous execution handler
│       └── Types/              --> Luau strict type definitions
│           ├── PlayerTypes.lua
│           └── CombatTypes.lua
│
├── ServerScriptService/        --> Server-authoritative logic execution
│   └── Server/
│       ├── Boot/               --> Server initialization entry point
│       │   └── ServerLoader.server.lua
│       ├── Services/           --> Authoritative server logic managers
│       │   ├── SaveService.lua        --> ProfileService persistence & session locking
│       │   ├── CultivationService.lua --> Qi accumulation, purity & breakthrough logic
│       │   ├── CombatService.lua      --> Server hitboxes, parry checks & damage
│       │   ├── WorldService.lua       --> Zone 1/2 state & Qi node spawning
│       │   ├── EconomyService.lua     --> Trade transactions & inventory management
│       │   └── PvPService.lua         --> Hostility modes, infamy & node control
│       └── Components/         --> Physical world object behaviors
│           ├── QiNodeComponent.lua    --> Contested Qi vein interaction zones
│           └── HerbNodeComponent.lua  --> World herb gathering nodes
│
├── ServerStorage/              --> Private server storage (Templates & Maps)
├── StarterGui/                 --> ScreenGui templates
├── StarterPack/                --> Default tools (Empty - combat handled via scripts)
├── StarterPlayer/
│   ├── StarterCharacterScripts/
│   └── StarterPlayerScripts/
│       └── Client/             --> Client-side Controllers & UI handlers
│           ├── Boot/
│           │   └── ClientLoader.client.lua
│           ├── Controllers/
│           │   ├── InputController.lua       --> Keybindings, mobile touch & gamepad mapping
│           │   ├── CombatController.lua      --> Local combo prediction & parry timing
│           │   ├── CultivationController.lua --> Meditation triggers & Qi Sense HUD [V]
│           │   ├── UIController.lua          --> Unified HUD, Qi bar & menu updates
│           │   ├── EffectController.lua      --> Client particle bursts & light trails
│           │   └── WorldController.lua       --> Local zone ambient fog & hazard alerts
│           └── UI/
│               ├── Components/               --> Reusable buttons, frames & progress bars
│               └── Views/                    --> Full screen layouts (Cultivation Panel)
│
└── Workspace/                  --> Map terrain, physical Qi nodes, & workspace models
```

---

## 3. Migration Roadmap for Prototype Code

To refactor existing prototype scripts safely without losing work:

### 3.1 Step 1: Config & Data Re-alignment
* Move `ReplicatedStorage/Configs/CultivationData.lua` to `ReplicatedStorage/Shared/Config/RealmsConfig.lua`.
* Edit `RealmsConfig.lua` to replace simulator stat bloat (`120.0K HP`) with standard grounded values:
  * Realm 0 (Mortal Body): 100 HP
  * Realm 1 (Qi Condensation): 175 HP
  * Realm 2 (Foundation Establishment): 250 HP
  * Realm 3 (Core Formation): 325 HP

### 3.2 Step 2: Server Services Consolidation
* Move `ServerScriptService/Main.server.lua` into `ServerScriptService/Server/Boot/ServerLoader.server.lua`.
* Rename `DataService.lua` to `SaveService.lua` and verify `ProfileService` session locking implementation.
* Merge `SkillService.lua` and `SkillExecutors.lua` into `CombatService.lua` to ensure all combat validation occurs in a single service.

### 3.3 Step 3: Client Controllers Consolidation
* Move `StarterPlayerScripts/Controllers/` to `StarterPlayerScripts/Client/Controllers/`.
* Remove the `.client.lua` suffix from ModuleScript controllers (Argon syncs pure ModuleScripts required by `ClientLoader.client.lua`).
* Consolidate `CultivationUIController` into `UIController.lua` to keep UI updates event-driven from a single manager.

---

## 4. System Interconnections

* **Connections to 23_NETWORK_ARCHITECTURE.md:** Maps the remote signal location in `Shared/Network/BridgeSignals.lua`.
* **Connections to 24_SAVE_SYSTEM.md:** Dictates the location of `SaveService.lua` in `Server/Services/`.
* **Connections to 26_CODING_STANDARD.md:** Defines naming conventions (`PascalCase` for modules, `camelCase` for variables) enforced across all directories.

---

> **Document Revision History**  
> *v1.0.1* — Updated to reflect active Argon 2-way sync setup and prototype migration mapping by Lead Technical Architect.