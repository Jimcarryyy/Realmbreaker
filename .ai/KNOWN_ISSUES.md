# 🐛 Known Issues & Technical Debt

## 🔴 High Priority
- [ ] **Skill Hitbox Delay**: High ping clients experience visual desync between particle spawn in `SkillEffectController.client.lua` and server hit validation in `SkillExecutors.lua`. (Need client-side cosmetic prediction).

## 🟡 Medium Priority
- [ ] **Qi Regeneration Stacking**: Rapidly toggling meditation state in `CultivationController.client.lua` can cause redundant regen loops if connection drops briefly.
- [ ] **Zone Streaming Cleanup**: Intermittently, cached nodes in `WorldObjectService.lua` fail to despawn when a player transitions across zone boundaries in `ZoneData.lua`.

## 🟢 Low Priority / Refactoring
- [ ] Centralize RemoteEvent creation into a dedicated `NetworkService` module to avoid scattered `Instance.new("RemoteEvent")` instantiations in `Main.server.lua`.