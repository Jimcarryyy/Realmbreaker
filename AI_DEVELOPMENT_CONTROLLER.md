# Realmbreaker — AI Context Orchestrator & Development Controller

> **Instructions for AI Assistants (Google AI Studio / Cursor / Claude):**  
> You are acting as a Senior Roblox Luau Software Engineer and Systems Architect for **Realmbreaker** (Xianxia Action MMORPG).  
> Before writing or editing any code, read this entire document to align with our active phase, folder structure, coding rules, and progress state.

---

## 1. System Prompt & Strict Engineering Rules

Whenever you generate code or refactor systems for this project, you **MUST** strictly follow these engineering rules:

1. **Luau Strict Directive:** Every script MUST begin with `--!strict`.
2. **Directory Architecture:** All files MUST be placed according to [`21_FOLDER_STRUCTURE.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/21_FOLDER_STRUCTURE.md):
   * Shared Configs -> [`src/ReplicatedStorage/Shared/Config/`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/)
   * Server Services -> [`src/ServerScriptService/Server/Services/`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/)
   * Server Boot -> [`src/ServerScriptService/Server/Boot/ServerLoader.server.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Boot/ServerLoader.server.lua)
   * Client Controllers -> [`src/StarterPlayer/StarterPlayerScripts/Client/Controllers/`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/)
   * Client Boot -> [`src/StarterPlayer/StarterPlayerScripts/Client/Boot/ClientLoader.client.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Boot/ClientLoader.client.lua)
3. **No Stat Inflation:** HP scales strictly from **100 to 370 HP max** for V1.0 launch realms (*Mortal Realm* through *Golden Core Realm*). Never write arbitrary "trillions" or "K/M/B" stat bloat.
4. **Single Source of Truth:** The server (`CultivationService.lua`) governs player state. Client controllers (`UIController.lua`, `CultivationController.lua`) react to server state updates delivered via the player's replica.
5. **No Infinite Yields / Missing Returns:**
   * Every ModuleScript MUST end with `return ModuleName`.
   * Never require nested paths like `Client:WaitForChild("Client")`.
6. **Smooth Easing & Physics Safety:**
   * Never use `humanoid.PlatformStand = true` for meditation (causes 3s physics delay).
   * Use `TweenService` with `Sine` easing for smooth CFrame float-up and descent landings.
   * Use `meditationSessionId` tokens to prevent asynchronous thread race conditions.

---

## 2. V1.0 Implementation Phase Roadmap

Development is broken into 5 sequential implementation phases:

```
+-----------------------------------------------------------------------+
|                    V1.0 IMPLEMENTATION PHASE ROADMAP                  |
+-----------------------------------------------------------------------+
|  [PHASE 1] Core Architecture, Data Persistence & Cultivation (ACTIVE) |
|  [PHASE 2] World Zone Streaming, Hazard Miasma & Qi Vein Spawning     |
|  [PHASE 3] Fighting-Game Combat Engine, Parry Frames & Stances        |
|  [PHASE 4] Responsive HUD, Inventory UI & Qi Sense Overlay            |
|  [PHASE 5] Economy, Player Trading & Robux Monetization Engine        |
+-----------------------------------------------------------------------+
```

---

## 3. Active Progress Log & Living Memory

> **Note to AI:** Check this section to see what is already built, what is in progress, and what to build next.

### 3.1 Completed Components (DO NOT RE-INVENT)
* [x] **Sync Tooling:** VS Code + Argon 2-way sync verified.
* [x] **Directory Structure:** Refactored to official production paths in `src/`.
* [x] **Core Configs:** [`RealmsConfig.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ReplicatedStorage/Shared/Config/RealmsConfig.lua) updated to support all **12 Major Realms** featuring **9 Minor Orders** each, capped at *Golden Core Realm* (Level 5) for V1.0 launch.
* [x] **Bootloaders:** `ServerLoader.server.lua` and `ClientLoader.client.lua` working with zero crashes.
* [x] **Persistence:** [`SaveService.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/SaveService.lua) upgraded to full `ProfileService` standard with session-locking, GDPR compliant player tracking, automatic schema reconciliation, progressive schema migrations, and snapshot recovery [`24_SAVE_SYSTEM.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/24_SAVE_SYSTEM.md).
* [x] **Server Cultivation:** [`CultivationService.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Services/CultivationService.lua) updated to synchronize progressions dynamically with the player's profile data in real-time. Includes continuous progression math (no-reset Qi pool carrying over overflow, dynamic `MaxQi` scaling, and continuous $+5\text{ HP}$ to $+11.25\text{ HP}$ health scaling up to 370 HP).
* [x] **Client Cultivation:** [`CultivationController.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/CultivationController.lua) updated to use `ReplicaController` to automatically govern cultivation stats [`24_SAVE_SYSTEM.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/24_SAVE_SYSTEM.md). Maintains smooth 0.35s Sine float-up visuals and 0.3s input debounce.
* [x] **Client UI:** [`UIController.lua`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/StarterPlayer/StarterPlayerScripts/Client/Controllers/UIController.lua) upscaled to a centralized $300\text{px}\times 110\text{px}$ container utilizing a custom gold-trimmed image asset, matching squircle rounded corner health/Qi bars, bold/chubby `FredokaOne` game font, and high-quality `UIStroke` black text outlines. Has real-time health and Qi synchronization.
* [x] **Overhead Billboards:** Fixed character spawning bottlenecks; overhead titles and hp bars now dynamically cache and display the player's real-time progression immediately on character spawning.
* [x] **Replication Engine:** Integrated server-side `ReplicaService` and client-side `ReplicaController` (with dependencies `MadworkMaid`, `MadworkScriptSignal`, and `RateLimiter` moved into `ReplicatedStorage`) to automate and secure player data synchronization.

### 3.2 Currently In Progress (PHASE 1 - TASK 1.4)
* [ ] **Node Components & World Zone Detection:** Building `HerbNodeComponent.lua` & `QiNodeComponent.lua` in `Server/Components/` for world harvesting interactions, and `WorldController.lua` for zone boundary detection and visual triggers.

### 3.3 Next Priority Queue
1. Build `HerbNodeComponent.lua` & `QiNodeComponent.lua` in [`src/ServerScriptService/Server/Components/`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/src/ServerScriptService/Server/Components/) (or matching directory) for world harvesting interactions.
2. Build `WorldController.lua` for zone boundary detection and ambient fog/miasma visual alerts.
3. Initialize the Fighting-Game Combat Engine foundations (`CombatService.lua` on the server and `CombatController.lua` on the client) and bind hit registration.

---

## 4. Primary Documentation References for AI Context

When working on specific systems, refer to these primary design authority files:

| System Area | Primary GitHub Specification File |
| :--- | :--- |
| **Cultivation & Breakthroughs** | [`docs/Game Design/03_CULTIVATION.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/03_CULTIVATION.md) |
| **Combat & Parry Frame Data** | [`docs/Game Design/04_COMBAT.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/04_COMBAT.md) |
| **World Zones & Qi Density** | [`docs/Game Design/02_WORLD.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Game%20Design/02_WORLD.md) |
| **Code Base & File Layout** | [`docs/Technical Design/21_FOLDER_STRUCTURE.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/21_FOLDER_STRUCTURE.md) |
| **Database & Persistence** | [`docs/Technical Design/24_SAVE_SYSTEM.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/24_SAVE_SYSTEM.md) |
| **Network & Hit Registration** | [`docs/Technical Design/23_NETWORK_ARCHITECTURE.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/23_NETWORK_ARCHITECTURE.md) |
| **Coding Style & Safety** | [`docs/Technical Design/26_CODING_STANDARD.md`](https://raw.githubusercontent.com/Jimcarryyy/Realmbreaker/main/docs/Technical%20Design/26_CODING_STANDARD.md) |

---

## 5. End-of-Session Handoff Protocol (Mandatory for AI)

> **Instruction for AI at the end of a Chat Session:**  
> When the user types **"Generate Handoff"** or when a major feature task is completed, you MUST output a copyable Markdown block using the format below. The user will paste this block into Section 3 of this document to update the project's living memory for the next thread.

### Required Handoff Block Template:

```markdown
### 🔄 SESSION HANDOFF LOG — [Date / Task Name]
* **Completed in this session:**
  * Created/Updated `[File Path 1]`: [Short summary of changes]
  * Created/Updated `[File Path 2]`: [Short summary of changes]
* **Verified Functionality:** [Summary of what was tested and working in Roblox Studio]
* **Current Active Task:** [What is currently being worked on]
* **Next Task for Next AI Thread:** [The exact next file/feature to build]
* **Special Context/Notes for Next Thread:** [Any specific variables, remotes, or quirks to remember]
```

---

> **Document Version:** v1.2.0  
> **Maintained By:** Lead Game Designer & Technical Architect