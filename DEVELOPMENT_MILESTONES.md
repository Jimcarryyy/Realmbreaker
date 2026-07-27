# 🚀 Realmbreaker Development Milestones

> This document defines **how Realmbreaker will be built**, not the final content of the game.

The Game Bible describes the complete vision for Realmbreaker.

This document defines **which features are implemented at each milestone** so development remains focused, playable, and iterative.

---

# 🎯 Development Philosophy

Realmbreaker will **not** attempt to build every planned feature before releasing a playable version.

Instead, development follows an iterative approach:

1. Design the complete vision.
2. Build only the minimum systems required.
3. Release playable versions early.
4. Collect player feedback.
5. Improve existing systems.
6. Expand the game over time.

The goal is to validate gameplay through real players before investing months into additional systems.

---

# 📖 Relationship with the Game Bible

The Game Bible represents the **complete long-term vision** of Realmbreaker.

It is expected that many documented systems will **not exist** in early versions.

Every implementation milestone selects only the systems necessary for that stage.

Never assume every documented feature should be implemented immediately.

---

# 📦 Development Stages

```text
Documentation
      │
      ▼
Prototype
      │
      ▼
Vertical Slice
      │
      ▼
Closed Alpha
      │
      ▼
Open Alpha
      │
      ▼
Beta
      │
      ▼
Release
      │
      ▼
Live Service
```

---

# 🛠 Prototype (Internal)

## Goal

Prove the core gameplay loop is fun.

Players should be able to:

- Create a character
- Walk around
- Fight enemies
- Gain Cultivation
- Breakthrough to the next realm
- Loot basic items
- View a basic inventory
- Save and load progress

## Included Systems

- Basic Combat
- Basic Cultivation
- Inventory
- Equipment
- Enemy AI
- Simple UI
- Save System

## Excluded Systems

- PvP
- Trading
- Sects
- Alchemy
- Crafting
- Events
- Economy
- Monetization

---

# 🎮 Vertical Slice

## Goal

Create a polished gameplay experience that represents the final game's quality.

Players should be able to:

- Explore one complete region
- Join one sect
- Defeat one dungeon boss
- Reach Realm 2
- Unlock several skills
- Equip basic gear

## Included Systems

- One Region
- One Village
- One Dungeon
- One Sect
- One Boss
- Multiple Skills
- Character Progression
- Improved UI
- Better Visual Effects

---

# 🧪 Closed Alpha

## Goal

Test gameplay balance with a limited group of players.

## Added Systems

- PvP
- Rankings
- More Realms
- More Regions
- More Equipment
- Better AI
- More Skills

Focus Areas

- Balance
- Bugs
- Performance
- Progression
- Player Feedback

---

# 🌍 Open Alpha

## Goal

Begin testing the game's long-term systems.

## Added Systems

- Alchemy
- Herbalism
- Crafting
- Trading
- Economy
- World Events
- Rare Bosses

Focus Areas

- Economy
- Retention
- Social Gameplay

---

# ⚔ Beta

## Goal

Prepare for public launch.

## Added Systems

- Additional Regions
- More Cultivation Realms
- More Bosses
- Expanded Crafting
- Better Progression
- Additional UI Improvements

Focus Areas

- Performance
- Stability
- Optimization
- Server Load
- Mobile Experience

---

# 🚀 Version 1.0 Release

## Goal

Launch the first complete version of Realmbreaker.

Core gameplay systems should now feel cohesive and polished.

Release includes:

- Stable progression
- Multiple regions
- PvE
- PvP
- Economy
- Sects
- Crafting
- Alchemy
- Live Events
- Cosmetics
- Fair Monetization

The game should remain expandable without requiring major redesigns.

---

# 🌟 Live Service

Realmbreaker is intended to evolve continuously after launch.

Future updates may introduce:

- New Continents
- New Cultivation Realms
- New Sects
- New Dungeons
- New Bosses
- Seasonal Events
- New Professions
- New Artifacts
- New World Systems

Every update should strengthen the game's existing systems rather than replacing them.

---

# 📋 Milestone Rules

Before advancing to the next milestone:

- Core gameplay must be stable.
- Critical bugs should be resolved.
- Player feedback should be reviewed.
- Documentation should be updated.
- Technical debt should be addressed.
- Performance targets should be met.

Never move to the next milestone solely because all planned features have been implemented.

Quality and player experience take priority over feature count.

---

# 🧠 AI Development Guidelines

When assisting with development:

- Treat the Game Bible as the complete vision.
- Treat this document as the implementation roadmap.
- Only recommend features appropriate for the current milestone.
- Avoid suggesting late-game systems during early prototypes unless explicitly requested.
- Favor small, testable, modular implementations.
- Always consider player feedback before expanding the scope.

---

# 💡 Guiding Principle

> **Build the smallest version of Realmbreaker that players genuinely enjoy, then expand it one meaningful milestone at a time.**

A polished small game is always preferable to a massive unfinished one.