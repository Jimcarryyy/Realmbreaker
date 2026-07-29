# Realmbreaker — Core Design Principles & Evaluation Framework

> **Document Code:** 16_DESIGN_PRINCIPLES.md  
> **Category:** Game Design / Decision Framework  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 01_GDD.md, 03_CULTIVATION.md, 04_COMBAT.md, 15_GAME_IDENTITY.md

---

## 1. Executive Summary & Design Authority

This document serves as the supreme game design authority for **Realmbreaker**.

During production and live operations, when any feature proposal, mechanics expansion, or balancing tweak is debated, it **must be evaluated against these design principles**. If a proposed feature violates these axioms, it must be redesigned or discarded.

> **Design Authority Axiom:**  
> *"Complexity is not depth. Every mechanic added to Realmbreaker must serve player agency, foster system interconnection, and respect player skill."*

---

## 2. The 5 Supreme Design Axioms

```
+-----------------------------------------------------------------------+
|                    THE 5 REALMBREAKER DESIGN AXIOMS                   |
+-----------------------------------------------------------------------+
|  AXIOM 1: Mechanical Agency Over Stat Inflation                        |
|  AXIOM 2: Mandatory System Interconnection                            |
|  AXIOM 3: Deterministic Skill Supremacy                               |
|  AXIOM 4: Ethical Time Value & Respect for Player Investment          |
|  AXIOM 5: Authentic Xianxia World Integration                         |
+-----------------------------------------------------------------------+
```

### Axiom 1: Mechanical Agency Over Stat Inflation
Advancing progression must grant the player **new options and spatial capabilities** (Air Dashing, Qi Shielding, Flight, Domain Stances) rather than simply inflating damage numbers. Raw stat increases are strictly moderated to preserve skill-based combat across all realms.

### Axiom 2: Mandatory System Interconnection
No standalone mechanics are allowed. Every feature must connect to at least two existing systems. For example: Alchemy is tied to World Gathering (inputs) and Cultivation Breakthrough Safety (outputs); Contested Qi Arteries are tied to World Exploration (location), Open PvP (conflict), and Economy (Sect taxes).

### Axiom 3: Deterministic Skill Supremacy
Execution, frame timing, spatial positioning, and stamina management always beat raw stat differences. A lower-realm player who executes a perfect parry, reads telegraphs, and manages posture must always have a tactical path to victory against an arrogant higher-realm player.

### Axiom 4: Ethical Time Value & Respect for Player Investment
Player time must result in lasting mastery, social prestige, and meaningful choices. Predatory paywalls that sell unearned combat power or catastrophic unmitigated progress wipes are strictly forbidden.

### Axiom 5: Authentic Xianxia World Integration
Game mechanics must be grounded in real Xianxia mythos and literary tropes (Meridian channels, Qi Purity, Heavenly Tribulations, Sect honor, Contested Arteries) rather than generic westernized RPG tropes.

---

## 3. Forbidden Game Design Anti-Patterns (The "Never Do" List)

Developers and systems designers must strictly avoid the following anti-patterns:

```
+-----------------------------------------------------------------------+
|                    FORBIDDEN GAME DESIGN ANTI-PATTERNS                |
+-----------------------------------------------------------------------+
|  [X] AFK CLICKER SIMULATION : Mindless auto-clicking without engagement|
|  [X] UNCOUNTERABLE ONE-SHOTS: Skills dealing >35% HP unblockable burst|
|  [X] PAY-TO-WIN COMBAT      : Direct stat/damage buying via Robux     |
|  [X] ISOLATED ORPHAN FEATURES: Systems that do not feed the core loop |
|  [X] CATASTROPHIC PROGRESS LOSS: Wiping player progress without pity  |
+-----------------------------------------------------------------------+
```

### 3.1 Anti-Pattern Breakdown
1. **Never build AFK Clickers:** Meditation and training require active positioning at nodes, alchemy timing, or active combat. Mindless auto-clickers destroy long-term retention.
2. **Never allow un-counterable one-shots:** Single skill attacks are capped at 35% of target max HP, and all heavy strikes must feature readable visual telegraphs.
3. **Never sell competitive combat power:** Robux products sell convenience, time savings, storage, and cosmetics—NEVER unearned combat stats or unblockable spell passes.
4. **Never create orphan systems:** Do not code isolated mini-games or features that exist solely for their own sake without feeding the core cultivation loop.

---

## 4. Developer Feature Evaluation Framework

Before submitting any new feature proposal, pull request, or design expansion, developers must pass the **4-Question Evaluation Gate**:

```
                  ┌──────────────────────────────────────────┐
                  │ 1. What NEW mechanical choice does this  │
                  │    give the player during gameplay?      │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                  ┌──────────────────────────────────────────┐
                  │ 2. What 2 existing systems does this     │
                  │    feature DIRECTLY connect with?        │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                  ┌──────────────────────────────────────────┐
                  │ 3. How does this preserve combat skill   │
                  │    integrity and parry counterplay?      │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                  ┌──────────────────────────────────────────┐
                  │ 4. Does this preserve player trust and   │
                  │    avoid pay-to-win perception?        │
                  └──────────────────────────────────────────┘
```

If a proposed feature fails to provide satisfying answers to all four questions, it is rejected and sent back for redesign.

---

## 5. System Interconnections

* **Connections to 00_PROJECT_OVERVIEW.md:** Defines the foundational pillars governing all game documentation.
* **Connections to 01_GDD.md:** Consolidates design axioms across core gameplay, combat, world, and economy systems.
* **Connections to 03_CULTIVATION.md:** Enforces Axiom 1 (Mechanical Agency Over Stat Inflation).
* **Connections to 04_COMBAT.md:** Enforces Axiom 3 (Deterministic Skill Supremacy).
* **Connections to 17_MONETIZATION.md:** Enforces Axiom 4 (Ethical Time Value & Non-P2W Rules).

---

> **Document Revision History**  
> *v1.0.0* — Core design principles, anti-patterns, and developer evaluation framework approved by Creative Director & Lead Game Designer.