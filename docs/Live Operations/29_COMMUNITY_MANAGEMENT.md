# Realmbreaker — Community Management & Anti-Exploit Enforcement Specification

> **Document Code:** 29_COMMUNITY_MANAGEMENT.md  
> **Category:** Live Operations / Community Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 06_PVP.md, 13_ROADMAP.md, 24_SAVE_SYSTEM.md, 26_CODING_STANDARD.md

---

## 1. Executive Summary & Operational Philosophy

The community management architecture of **Realmbreaker** is designed to foster a healthy, competitive, and respectful player base while protecting the integrity of the in-game economy and combat systems.

Because **Realmbreaker** features open-world PvP, contested Qi nodes, and player-to-player trading, maintaining strict moderation standards and robust anti-cheat enforcement is critical to long-term player retention.

> **Operations Axiom:**  
> *"Competitive integrity is non-negotiable. Cheaters, real-money traders (RMT), and dupers destroy player trust; swift automated telemetry and firm moderation preserve community health."*

---

## 2. Code of Conduct & Player Guidelines

All players in **Realmbreaker** must adhere to the three core operational rules:

```
+-----------------------------------------------------------------------+
|                    REALMBREAKER CODE OF CONDUCT                       |
+-----------------------------------------------------------------------+
|  RULE 1: FAIR PLAY & EXPLOIT INTEGRITY (No Scripting / Duping)        |
|  RULE 2: NO REAL-MONEY TRADING (RMT) (In-game Trade Only)            |
|  RULE 3: COMMUNITY SAFETY & RESPECT (Roblox TOS Compliance)           |
+-----------------------------------------------------------------------+
```

### 2.1 Rule Breakdown
1. **Rule 1 — Fair Play & Exploit Integrity:** Using external scripts (auto-parry bots, speed-hacks, noclip), abusing game bugs for unearned Qi/items, or attempting item duplication is strictly prohibited.
2. **Rule 2 — No Real-Money Trading (RMT):** Buying or selling in-game Spirit Stones, items, or accounts for real-world currency or off-platform assets is forbidden.
3. **Rule 3 — Community Safety & Respect:** Harassment, hate speech, severe toxicity, and impersonation of staff members violate both Roblox Terms of Service and game community rules.

---

## 3. Moderation & In-Game Report Tools

To allow players to contribute to server safety directly from the client interface:

### 3.1 In-Game Reporting UI
* Players can click on any target cultivator or inspect card to open the **Report Modal**.
* **Report Categories:** Exploiting / Scripting, Chat Harassment, Bug Exploitation, Suspected RMT.
* **Automated Evidence Capture:** Submitting a report automatically attaches a 10-second server log snapshot containing recent player velocity, ping, position history, and chat logs.

### 3.2 Automated Telemetry & Webhook Logging
The server automatically flags suspicious behavior and logs alerts directly to private Discord staff webhooks:
* **Speed/Flight Anomalies:** Triggers when player movement velocity exceeds `Max_Allowed_Speed` without valid spatial skill flags.
* **Auto-Parry Detection:** Triggers when a player achieves >98% perfect parry rate across 50 consecutive attacks under high ping.
* **Trade Value Spikes:** Triggers when high-tier Tier 3 items are traded to a low-level account for zero currency (potential RMT flag).

---

## 4. Enforcement Escalation Matrix

Violations are handled strictly according to the standardized penalty matrix:

| Offense Category | First Offense | Second Offense | Third Offense |
| :--- | :--- | :--- | :--- |
| **Minor Chat Toxicity** | Official Warning | 24-Hour In-Game Mute | 7-Day In-Game Mute |
| **Griefing / Bug Abuse** | 3-Day Account Ban | 14-Day Account Ban | Permanent Account Ban |
| **Scripting / Exploiting**| **Permanent Ban + Data Wipe** | N/A | N/A |
| **Real-Money Trading (RMT)**| **Permanent Ban + Hardware ID Blacklist** | N/A | N/A |

---

## 5. Discord Integration & Live Operations

The official Discord server serves as the primary community hub and support ticket interface:

```
+-----------------------------------------------------------------------+
|                    DISCORD & LIVE OPS INTEGRATION                     |
+-----------------------------------------------------------------------+
|  VERIFICATION   : RoVer / Bloxlink Syncs Roblox Identity & Sect Roles |
|  LIVE ALERTS    : Webhooks Announce World Bosses & Qi Tide Events     |
|  TICKET ENGINE  : Support Tickets for Bug Reports & Trade Appeals     |
+-----------------------------------------------------------------------+
```

### 5.1 Verification & Role Syncing
* Players link their Roblox account to receive automatic Discord roles matching their in-game Cultivation Realm (e.g., `@Foundation Establishment`, `@Core Formation`) and Sect affiliation.

### 5.2 Dynamic Game Event Alerts
Webhooks broadcast automated announcements to community channels for:
* **World Boss Spawns:** *Ancient Cavern Golem* spawning in Zone 2.
* **Qi Tide Surges:** Automated 2-hour Qi surge events.
* **Weekly Leaderboards:** Top Sects and breakthrough speed leaders.

---

## 6. System Interconnections

* **Connections to 06_PVP.md:** Enforces Infamy point tracking, Outlaw bounty rules, and anti-griefing protections.
* **Connections to 09_ECONOMY.md:** Monitors trade logs to prevent real-money trading (RMT) and market manipulation.
* **Connections to 24_SAVE_SYSTEM.md:** Executes data wipes on verified exploiting accounts.
* **Connections to 26_CODING_STANDARD.md:** Mandates defensive `pcall` wrapping and automated webhook logging for security alerts.

---

> **Document Revision History**  
> *v1.0.0* — Community guidelines, reporting UI, moderation tools, and anti-exploit enforcement matrix approved by Lead Live Operations Planner.