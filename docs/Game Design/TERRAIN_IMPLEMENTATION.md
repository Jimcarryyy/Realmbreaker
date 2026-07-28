# 🗺️ World Design & Terrain Specification

## 📑 Overview
In **Realmbreaker**, the world is not merely a backdrop for combat; it is a physical manifestation of the player's progression. As a player ascends through the **12 Major Realms**, the environment transitions from grounded, realistic landscapes to abstract, high-concept celestial planes.

### ⚙️ System Integration Status
*   **Phase 1 (Scaling):** Complete. Terrain must now accommodate HP/Qi values reaching **Quadrillions**.
*   **Phase 2.1 (Qi Nodes):** Complete. Terrain must be designed with specific "pockets" for `SpiritSpring` and `QiCrystal` nodes.

---

## 🌎 The Ascension Hierarchy
The world is divided into four distinct **Geopolitical Tiers**. Each tier contains 3 Major Realms.

| Tier | Realms | Environmental Theme | Navigation Mechanic |
| :--- | :--- | :--- | :--- |
| **I. The Mortal Plane** | 1 - 3 | Grounded, Lush, Traditional | Walking / Dashing |
| **II. The Spirit Peaks** | 4 - 6 | Floating Islands, Verticality | Flight / Air-Stepping |
| **III. The Void Taint** | 7 - 9 | Fractured Reality, Crystalline | Teleportation / High-Speed |
| **IV. The Origin** | 10 - 12 | Celestial, Abstract, Nebulous | Trans-dimensional Travel |

---

## 🌲 Zone 1: The Mortal Plane (Starter Continent)
*The training ground for new cultivators. Focuses on horizontal exploration and basic node harvesting.*

### 🎨 Visual Aesthetic
*   **Materials:** Grass, Leafy Grass, Rock, Water.
*   **Atmosphere:** Soft golden sunlight, heavy low-hanging mist, traditional Wuxia architecture (Wood/Stone).
*   **Scale:** 2048 x 2048 studs.

### 📍 Key Landmarks
1.  **Azure Cloud City:** The neutral hub. High NPC density. No-PvP zone.
2.  **The Whispering Bamboo Grove:** A dense forest designed for early meditation. Contains hidden `SpiritSpring` nodes behind breakable bamboo.
3.  **Iron Mountain Caves:** A rocky subterranean area where the first `QiCrystal` nodes appear.

### ⚠️ Environmental Logic
*   **Qi Multiplier:** 1.0x - 1.2x.
*   **Gating:** Natural barriers (cliffs/ocean) prevent exit. The path to Zone 2 is guarded by the **"Qi Pressure Wall."**

---

## ☁️ Zone 2: The Spirit Peaks (Mid-Game)
*Accessible once a player reaches Realm 4 (Foundation Establishment). The world becomes vertical.*

### 🎨 Visual Aesthetic
*   **Materials:** Basalt, Glacier, Glowing Neon Sand.
*   **Atmosphere:** High-altitude "Skybox" lighting, floating islands connected by spirit-chains, upward-flowing waterfalls.
*   **Scale:** Vertical focus (Y-axis from 500 to 5000).

### 📍 Key Landmarks
1.  **The Sect Spires:** Massive floating palaces where players join factions.
2.  **The Sky-Anchor:** A giant pillar of stone that tethers the islands to the world below.
3.  **The Elder’s Perch:** A meditation platform at the highest peak with a 5.0x Qi Multiplier.

### ⚠️ Environmental Logic
*   **Qi Pressure:** Players below Realm 4 receive a `HeavyPressure` debuff, draining 5% HP/sec and reducing walkspeed by 50%.
*   **Movement:** Requires "Qi Flight" or "Flying Sword" artifacts to navigate between islands.

---

## 🛠️ Technical Building Standards

### 1. Performance Optimization
*   **StreamingEnabled:** Must be set to `Opportunistic`.
*   **Mesh vs Terrain:** 
    *   Use **Smooth Terrain** for large ground masses (LOD handling).
    *   Use **MeshParts** for cliffs and repetitive rocks (set to `CollisionFidelity: Box` or `Hull`).
*   **Decoration:** Enable `Terrain.Decoration` only in the Mortal Plane to preserve frames for lower-end devices.

### 2. Spatial Partitioning (Zones)
The world uses a **Zone-Attribute System** to handle logic:
*   **Attribute: `RequiredRealm` (Int):** The minimum realm needed to enter without taking damage.
*   **Attribute: `QiMultiplier` (Float):** Affects the rate of Qi gain from meditation in this area.
*   **Attribute: `IsSafeZone` (Bool):** Disables PvP and Combat skills.

### 3. Qi Node Placement Strategy
Nodes must be placed following the **"Reward for Exploration"** rule:
*   **Common Nodes:** Visible on main paths.
*   **Rare Nodes:** Placed inside caves, behind waterfalls, or on top of difficult-to-climb peaks.
*   **Sect Nodes:** Placed within Sect-controlled territories to encourage territory disputes (PvP).

---

## 🚀 Phase 1 - Step 2: Immediate Action Plan

1.  **Greyboxing (Blockout):** Define the 2048x2048 layout of the Mortal Plane using basic Parts.
2.  **Boundary Setup:** Implement the "Qi Pressure" script that checks `Player.Realm` against the `RequiredRealm` attribute of a zone.
3.  **Lighting Profiles:** Create unique `Atmosphere` and `Sky` objects for the Mortal Plane vs. the Spirit Peaks to ensure instant visual distinction.
4.  **Node Distribution:** Populate the greybox with `QiNode` tagged parts to test the "Meditation Loop" in a live environment.

> **Lead Designer Note:** Every landmark must be visible from a distance to act as a "Weenie" (a beacon that draws the player forward). If a player sees a floating island from the starter village, they have an immediate goal: "I need to cultivate so I can reach that."