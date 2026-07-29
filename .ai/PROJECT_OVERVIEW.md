# 🚀 Realmbreaker — Project Overview

## 📌 Game Vision & Philosophy
**Realmbreaker** is a large-scale Xianxia/Wuxia Cultivation MMORPG built on Roblox.
Core Principle: *"Every realm advancement must unlock meaningful gameplay rather than simply increasing numbers."*

Cultivation is one part of a multi-system loop. Players progress through cultivation, body hardening, soul expansion, bloodlines, spirit roots, Dao paths, weapon mastery, and sect hierarchy.

## 🏗️ Repository Source of Truth Structure
src/
├── ReplicatedFirst/
├── ReplicatedStorage/
│ └── Shared/
│ ├── Assets/
│ │ └── Animations.lua
│ └── Configs/
│ ├── CultivationData.lua
│ ├── NodeData.lua
│ ├── SkillData.lua
│ └── ZoneData.lua
├── ServerScriptService/
│ ├── Main.server.lua
│ └── Services/
│ ├── CultivationService.lua
│ ├── DataService.lua
│ ├── SkillExecutors.lua
│ ├── SkillService.lua
│ ├── WorldObjectService.lua
│ └── WorldService.lua
├── ServerStorage/
├── StarterGui/
├── StarterPack/
└── StarterPlayer/
├── StarterCharacterScripts/
└── StarterPlayerScripts/
└── Controllers/
├── CultivationController.client.lua
├── CultivationUIController.client.lua
├── EffectController.client.lua
├── SkillController.client.lua
├── SkillEffectController.client.lua
└── ZoneController.client.lua

## 🔗 Architecture Relationship Overview
• **State Management**: `DataService.lua` (Server) handles profile persistence via ProfileService; syncs with `CultivationService.lua` and `SkillService.lua`.
• **Cultivation Loop**: `CultivationService.lua` <-> `CultivationData.lua` <-> `CultivationController.client.lua` <-> `CultivationUIController.client.lua`.
• **Combat & Skills**: `SkillService.lua` validates execution via `SkillData.lua` & `CultivationService.lua` (Qi costs), delegates execution to `SkillExecutors.lua`, and triggers client visuals via `EffectController.client.lua` & `SkillEffectController.client.lua`.
• **World & Zones**: `WorldService.lua` & `WorldObjectService.lua` consume `ZoneData.lua` and `NodeData.lua` to stream zones and gatherables, syncing client states through `ZoneController.client.lua`.

