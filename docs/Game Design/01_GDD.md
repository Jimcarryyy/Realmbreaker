# 📖 Game Design Document (GDD)

## 🔄 Core Gameplay Loop
1.  **Cultivate:** Absorb Qi through meditation, quests, or rare treasures.
2.  **Breakthrough:** Complete a "Tribulation" or challenge to unlock the next Realm.
3.  **Explore/Compete:** Use new mechanical unlocks (e.g., Water Walking, Teleportation) to access new zones and resources.
4.  **Social/Warfare:** Join a Sect, participate in wars, and defend territory.

## ⚔️ Combat System
*   **Action-Based:** No tab-targeting. M1/M2 combos with skill hotkeys.
*   **Defensive Layers:** 
    *   *Block:* Reduces incoming damage.
    *   *Perfect Parry:* Stuns the attacker and restores stamina.
    *   *Dash/Dodge:* I-frame based movement.
*   **Status Effects:** Burn, Freeze, Qi-Block, Suppression.

## 🧘 Cultivation & Progression
Players progress through several parallel systems:
| System | Impact |
| :--- | :--- |
| **Major Realm** | Unlocks new mechanics (Flight, Perception, Map Access). |
| **Body Cultivation** | Passives: Defense, Stamina, and Physical Strength. |
| **Bloodlines** | Unique innate abilities and transformation modes. |
| **Dao Path** | Elemental specializations (Fire, Sword, Karma, etc.). |

## 🗺️ World Design
*   **The Mortal Plane:** The starting open-world continent.
*   **Secret Realms:** Instanced dungeons with unique environmental mechanics.
*   **Sect Territories:** Player-controllable zones with tax and resource benefits.

## 🛠️ Technical Stack (The Realmbreaker Framework)
*   **Architecture:** Custom Modular Framework (Shared/Server/Client).
*   **Networking:** BridgeNet2 or custom Bit-buffer for high-frequency combat data.
*   **State Management:** Strict State-Machine for players (Idle, Attacking, Stunned, Knockdown).
*   **Data:** ProfileService for robust, transaction-based player saving.

## 📈 Monetization Philosophy (Fairness)
*   **No P2W:** You cannot buy a "Power Level." 
*   **Convenience & Cosmetics:** Skins, VIP titles, faster (but not instant) Qi gathering, and storage.
*   **Economy:** Player-driven marketplace for rare materials and manuals.