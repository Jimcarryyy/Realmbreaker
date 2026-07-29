# 🚩 Current Phase: Phase 2 — Core Mechanics & Skill Integration

## 🗓️ Status: In-Progress

We have completed the foundational architecture (Phase 1) and are actively integrating interactive gameplay mechanics (Phase 2). The core character controller, meditation loop, server-authoritative skill pipeline, and zone streaming framework are operational.

## 🟢 Completed in this Phase
1. **Server-Authoritative Skill Pipeline**:
   - `SkillService.lua` created for server-side validation and cooldown tracking.
   - `SkillExecutors.lua` built for skill behavior execution.
   - `SkillData.lua` configured with base cost, cooldown, damage, and range tables.
2. **Resource Management**:
   - Centralized `SpendQi()` logic in `CultivationService.lua` tied to `SkillService.lua`.
3. **Client-Side Skill Controller & VFX**:
   - `SkillController.client.lua` capturing player skill input.
   - `EffectController.client.lua` & `SkillEffectController.client.lua` listening for skill triggers to play visuals and animations.
4. **Zone & Node Foundation**:
   - `ZoneData.lua` & `NodeData.lua` connected to `WorldService.lua` and `WorldObjectService.lua`.

## 🟡 Active Objectives
- Complete starter skill animation mapping in `Animations.lua`.
- Connect skill hitboxes to target damage handling in `SkillExecutors.lua`.
- Add client-side stamina/Qi bar updates in `CultivationUIController.client.lua`.