# Realmbreaker — Patch Notes & Versioning Specification

> **Document Code:** 32_PATCH_NOTES.md  
> **Category:** Live Operations / Patch Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 13_ROADMAP.md, 28_BALANCING_PHILOSOPHY.md, 31_CONTENT_EXPANSION.md

---

## 1. Executive Summary & Versioning Philosophy

Transparent, developer-to-player communication is essential for maintaining community trust, player retention, and competitive balance in **Realmbreaker**.

All live updates follow strict **Semantic Versioning (SemVer)** standards (`vMAJOR.MINOR.PATCH`). Every change—whether a minor frame data tweak or a major realm expansion—must be logged using the standardized patch notes template.

> **Live Ops Axiom:**  
> *"Patch notes must be clear, precise, and educational. Players should understand not just WHAT changed in balance or mechanics, but WHY the design team made the change."*

---

## 2. Semantic Versioning Standard (`vMAJOR.MINOR.PATCH`)

```
+-----------------------------------------------------------------------+
|                    SEMANTIC VERSIONING FRAMEWORK                      |
+-----------------------------------------------------------------------+
|  vMAJOR  (e.g., v1.0, v2.0) : Public Launch & Full Engine Overhauls   |
|  vMINOR  (e.g., v1.1, v1.2) : New Realms, New Zones, Major Expansions |
|  vPATCH  (e.g., v1.0.1)     : Bug Fixes, Stance Balance & Hotfixes    |
+-----------------------------------------------------------------------+
```

### 2.1 Versioning Definitions
* **MAJOR Version (v1.0.0):** The initial Early Publish launch baseline, or a complete structural revamp of core game loops.
* **MINOR Version (v1.1.0):** Post-launch major content expansions (e.g., adding Realm 4: Nascent Soul, Zone 3 Floating Cloud Isles, or Faction Siege Wars). Released every 8 to 10 weeks.
* **PATCH Version (v1.0.1):** Bi-weekly balance passes, bug fixes, performance optimizations, and Celestial Merchant stock rotations.

---

## 3. Patch Notes Distribution & Communication Channels

When a patch is published, release notes are automatically distributed across three primary touchpoints:

1. **In-Game "What's New" Modal:** Displays automatically upon player login following a patch.
2. **Official Discord `#patch-notes` Channel:** Posted via automated GitHub release webhooks.
3. **Roblox Game Page DevLog / DevForum:** Formatted summary linked in the Roblox game description.

---

## 4. Standardized Patch Notes Template

All future update logs must adhere to the following GitHub Markdown layout:

```
# Realmbreaker Update Log — Version [vX.Y.Z]

> **Release Date:** [YYYY-MM-DD]  
> **Patch Theme / Focus:** [Short Summary of Update Focus]

### 🌟 Major Highlights & New Content
* **[New Feature/Zone/Realm]:** Description of primary addition.
* **[New System]:** Description of mechanics unlocked.

### ⚔️ Combat & Stance Balancing
* **[Stance / Skill Name]:** 
  * Change 1 (e.g., Parry window adjusted from 0.18s to 0.20s).
  * Developer Rationale: Explanation of why the balance tweak was made.

### 🌿 Economy & World Adjustments
* Item drop rates, market tax updates, or herb spawn adjustments.

### 🛠️ Quality of Life (QoL) & UI/UX
* HUD improvements, menu additions, or mobile touch control tweaks.

### 🐛 Bug Fixes & Security
* Resolved issues, memory leak cleanup, and anti-cheat hardening.
```

---

## 5. Sample Baseline Patch Note — Version 1.0.0 (Public Release)

Below is the authoritative release log for the initial Early Publish launch of **Realmbreaker**:

```markdown
# Realmbreaker Update Log — Version 1.0.0 (Public Release)

> **Release Date:** 2026-10-15  
> **Patch Theme:** Official Public Release — Early Publish V1.0 Baseline

### 🌟 Major Highlights & Launch Features
* **4 Launch Cultivation Realms:** Advance from Mortal Body (Realm 0) through Qi Condensation (Realm 1), Foundation Establishment (Realm 2), and Core Formation (Realm 3 - V1.0 Cap).
* **Mechanical Progression:** Unlock physical skills per realm—Qi Gauge & Ranged Blasts (Realm 1), Air Dashing & Qi Shielding (Realm 2), and Flight & Domain Stances (Realm 3).
* **Skill-Based Combat Engine:** Master active 0.18s parrying [F], posture stagger breaks, animation-cancel dodging [Q], and directional combos.
* **Launch Martial Disciplines:** Choose between *Flowing Water Sword Stance* (Defensive Counter) and *Thunder-Palm Unarmed Stance* (High Posture Pressure).
* **2 Exploration Zones & Instanced Dungeon:** Explore Bamboo Leaf Village (Zone 1 Safe Area) and Mistveil Forest (Zone 2 Open-World Contested PvP), and conquer `Ancient Sword Mystic Realm` (Dungeon 1).
* **Contested Qi Arteries:** Compete in open-world cavern PvP to control 5.0x Qi Meditation nodes for your Sect.
* **Sect Marketplace & Safe Trading:** Trade alchemy herbs and elixirs freely via secure 2-step verification and auction house trading.

### ⚙️ Technical & Security Features
* **ProfileService Persistence:** Session-locked profile loading ensuring zero item duplication or data loss.
* **Server-Authoritative Combat:** Server-validated hitboxes, lag compensation (150ms buffer), and automated anti-speedhack checks.
* **Cross-Platform Support:** Full input parity across PC (Keyboard/Mouse), Mobile (Touch Controls), and Console (Gamepad).
```

---

## 6. System Interconnections

* **Connections to 13_ROADMAP.md:** Governs the versioning schedule for V1.0 Launch and V1.1–V1.3 Live Ops updates.
* **Connections to 28_BALANCING_PHILOSOPHY.md:** Formats combat balance notes and developer rationale using telemetry metrics.
* **Connections to 31_CONTENT_EXPANSION.md:** Aligns MINOR version bumps with major realm and zone expansions.

---

> **Document Revision History**  
> *v1.0.0* — Semantic versioning rules, patch distribution strategy, and release log templates approved by Lead Live Operations Planner.