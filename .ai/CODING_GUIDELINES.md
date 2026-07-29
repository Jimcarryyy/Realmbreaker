# 💻 Luau Coding Guidelines & Architecture Standards

## 🏛️ Code Architecture Standards
1. **Modular Architecture**:
   - Single Responsibility Principle: Every Service and Controller manages one clear domain.
   - Shared configuration modules (`CultivationData.lua`, `SkillData.lua`, etc.) reside in `ReplicatedStorage.Shared.Configs`.
2. **Server Authority & Security**:
   - RemoteEvents must NEVER trust client damage values or state flags.
   - All resource consumption (`SpendQi`) must be performed on the server inside `CultivationService.lua`.
3. **Code Style Rules**:
   - PascalCase for Module Names, Methods, and Services (`CultivationService`, `ExecuteSkill`).
   - camelCase for local variables and parameters (`playerData`, `skillName`).
   - ALL-CAPS for constants (`MAX_QI_REGEN_RATE`, `DEFAULT_COOLDOWN`).
   - Strongly type Luau function signatures where possible (`player: Player, skillId: string`).
   - No magic numbers: Reference configuration modules for pure data.

## 🛠️ Luau Template Structure
```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Configs = Shared:WaitForChild("Configs")

local SkillData = require(Configs:WaitForChild("SkillData"))

local SkillService = {}
SkillService.__index = SkillService

function SkillService.Init()
    -- Subscriptions & Initialization
end

return SkillService

---

### File 7: `.ai/DECISIONS.md`
```markdown
# 📋 Architectural & Design Decisions

| ID | Date | Topic | Decision | Justification |
| :--- | :--- | :--- | :--- | :--- |
| **AD-001** | 2026-07-27 | Data Persistence | Adopt ProfileService via `DataService.lua` | Guarantees session locking, prevents data loss and duplicate item glitches. |
| **AD-002** | 2026-07-28 | Skill Hitboxes | Server-side box/sphere spatial query in `SkillExecutors.lua` | Prevents client exploiters from faking hit registration vectors. |
| **AD-003** | 2026-07-28 | Visual Rendering | Split client rendering between `EffectController` & `SkillEffectController` | Keeps combat FX decoupled from environmental visuals for better optimization. |
| **AD-004** | 2026-07-29 | Memory Guardrails | Standardized `.ai` system instructions and GitHub single source of truth | Prevents AI model hallucination and code fragmentation across sessions. |