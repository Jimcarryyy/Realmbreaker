# 💻 Coding Guidelines

## 📂 Structure
*   **Services:** Logic only. No `Wait()`, no direct UI manipulation.
*   **Controllers:** Input and Visuals only. No data authority.
*   **Configs:** All magic numbers (Cooldowns, Costs, Speeds) live in `SkillData` or `GameConfig`.

## 🛠️ Standards
*   **Naming:** PascalCase for methods, camelCase for variables.
*   **Remotes:** Use `CastSkill` for requests and `SkillExecuted` for broadcast/feedback.
*   **Modularity:** Use `SkillExecutors` to keep individual technique logic isolated from the core `SkillService`.
*   **Optimization:** Use `CollectionService` tags for interactive objects (QiNodes).