# 🤖 AI Workflows & Templates

## Skill Generation Template
When generating a new skill, follow this flow:
1.  **Data:** Add entry to `SkillData.lua` (Cost, Realm, Cooldown).
2.  **Logic:** Add function to `SkillExecutors.lua`.
3.  **Visuals:** Add listener to `EffectController.lua` for the `SkillExecuted` signal.