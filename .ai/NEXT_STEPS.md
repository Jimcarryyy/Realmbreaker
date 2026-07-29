# 🚀 Next Steps

## 1. Combat & Character State Machine (Immediate)
- **I-Frames & Mobility**: Implement `Dash` and `Perfect Parry` windows in `SkillController.client.lua` and validate on `SkillService.lua`.
- **Status Effects**: Add Stun, Knockback, and Freeze primitives in `SkillExecutors.lua`.

## 2. World Interaction & Gathering (Short-Term)
- **Gathering System**: Wire `NodeData.lua` gatherable nodes to `WorldObjectService.lua` with server-validated interaction timers.
- **Zone Boundaries**: Enforce realm-gated Qi Pressure barriers using `ZoneData.lua` in `ZoneController.client.lua`.

## 3. Enemy AI & Boss Mechanics (Mid-Term)
- **Mortal Plane Mobs**: Create server-side mob state machines in `WorldService.lua`.
- **Boss Encounter Logic**: Implement non-sponge boss mechanics with dodgeable telegraph indicators.