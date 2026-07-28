# 🐛 Known Issues & Technical Debt

*   **Animations:** Skills currently lack dedicated `AnimationTrack` execution on the client. (Primary focus for Task 1).
*   **Hitbox Latency:** Current server-side hit detection needs lag compensation for high-speed anime combat.
*   **VFX Bloat:** `EffectController` needs a pooling system for particles to prevent frame drops during large sect wars.