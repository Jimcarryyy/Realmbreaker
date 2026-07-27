# ⚖️ Design Principles

Every feature added to Realmbreaker must be filtered through these principles to ensure consistency and quality.

## 1. The "Why" Rule
Before implementing a feature, we must answer:
> "Why would this make the player want to continue playing?"
If the answer is only "to get more XP," the feature is rejected. It must contribute to **Long-term Progression, Replayability, Competition, or Social Interaction.**

## 2. Skill > Stats
While progression is vital, raw stats should never be an "I-Win" button. 
*   **Active Defense:** Parries, dodges, and blocks are core.
*   **Counter-play:** Every skill must have a tell or a weakness that a skilled opponent can exploit.

## 3. Depth over Complexity
We avoid "bloat." Instead of 100 near-identical skills, we provide 10 skills with deep customization and mastery. 
*   **Easy to Learn:** Intuitive UI and controls.
*   **Hard to Master:** High ceiling for combo-stringing and resource management.

## 4. Connected Systems
No system should exist in a vacuum.
*   *Example:* Crafting an artifact should require a resource found only in a PvP territory, which is protected by a Sect, which requires a specific Cultivation Realm to enter.

## 5. Performance First
As a technical standard, we optimize from Day 1.
*   **Modular Architecture:** Use ModuleScripts and a Service/Controller pattern.
*   **Data-Driven:** Keep configurations in tables; avoid hard-coding values.
*   **Client-Side Prediction:** Ensure combat feels snappy regardless of ping.

## 6. Meaningful Breakthroughs
Reaching a new Realm must be a "Gamer Moment."
*   **Phase Shift:** If Qi Condensation is "Grounded Combat," Foundation Establishment should introduce "Verticality/Air Combat."
*   **World Access:** High-level areas should physically push back low-level players via "Qi Pressure."