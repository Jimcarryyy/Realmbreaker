🌏 World & Terrain Design Specification

🗺️ The "Layered Ascension" Philosophy
The world of Realmbreaker is not a flat map. It is a vertical and spiritual hierarchy. As players progress through the 12 Major Realms, the environment must transition from Realistic/Grounded to Ethereal/Fractured.
Zone Tier	Applicable Realms	Visual Theme	Gravity & Physics
Tier 1: Mortal Plane	1 - 3	Lush forests, bamboo groves, rivers.	Standard Roblox Physics.
Tier 2: Spirit Peaks	4 - 6	Floating islands, waterfalls flowing upward.	Low Gravity / Flight Enabled.
Tier 3: The Void Void	7 - 9	Crystalline Deserts, Shattered Moons.	High Speed / Teleportation.
Tier 4: The Origin	10 - 12	Abstract, Celestial, Nebulous.	Total Freedom of Movement.

🌲 Zone 1: The Mortal Plane (Starter Region)
This is where the player learns the Meditation and QiNode mechanics.

🎨 Visual Aesthetic
Terrain Materials: Grass, Leafy Grass, Rock, and Water.
Atmosphere: Soft sunlight (warm colors), heavy fog in the distance to hide map edges.
Architecture: Wood and stone pagodas, humble villages.

📍 Key Landmarks
The Whispering Bamboo Grove: High density of SpiritSpring nodes.
The Azure River: A winding river that connects the starter village to the first Sect gate.
Iron Mountain: A rocky outcrop where QiCrystal nodes are found in caves.

⚙️ Technical Constraints
Terrain Decoration: Enabled.
Water Wave Size: Small (0.5 - 1.0).
Qi Density: 1x Multiplier.

☁️ Zone 2: The Spirit Peaks (Mid-Game Region)
Requires "Foundation Establishment" (Realm 4) to survive the Qi Pressure.

🎨 Visual Aesthetic
Terrain Materials: Basalt, Cracked Lava (glowing blue), Glacier.
Atmosphere: High altitude, thin blue clouds, visible "Spirit Veins" in the sky.
Verticality: The map is composed of 5-7 large floating islands at different Y-levels.

📍 Key Landmarks
The Sky-Anchor Pillar: A massive stone chain connecting a floating island to the ground.
The Upside-Down Falls: A waterfall that flows from a lower island to a higher one.
The Elder’s Perch: A high-altitude meditation platform with a 5x Qi Multiplier.

⚙️ Technical Constraints
StreamingEnabled: High Priority. We must use ModelStreamingMode.Persistent for the main islands to prevent players from falling through when flying.
Qi Pressure: Scripts will check if Player.Realm < 4. If true, apply a "Suppression" UI effect and drain HP.

🌌 Zone 3: The Void Tainted Lands (End-Game Region)
Where numbers reach the Trillions (T) and Quadrillions (Qa).

🎨 Visual Aesthetic
Terrain Materials: Salt, Neon Blue Sand, Glass.
Atmosphere: Purple/Black skybox, twin moons, lightning strikes that spawn temporary High-Tier Qi Nodes.
Chaos: Floating debris that moves slowly using TweenService.

📍 Key Landmarks
The Dao Fracture: A literal tear in the terrain showing a galaxy texture beneath.
The Crystal Spires: Massive structures that pulse with light whenever a player performs a Breakthrough.

🛠️ Technical Standards for World Building
1. Performance & Optimization
Smooth Terrain vs. Parts: Use Smooth Terrain for organic ground and MeshParts for cliffs/rocks to reduce the voxel count.
Collision Fidelity: Set all non-essential decorative meshes (grass, small rocks) to CanCollide = false and CanTouch = false.
LOD (Level of Detail): Use Roblox's "Automatic" Mesh LOD to ensure mobile performance.
2. The "Qi Node" Integration
Every region must be designed with "Node Pockets":
Hidden Spots: Place SpiritSpring nodes behind waterfalls or inside hollow trees to reward exploration.
Risk vs Reward: Place the highest-value QiCrystals in open, dangerous areas (future PvP zones).
3. Spatial Zoning
The world must be tagged using ZonePlus or a custom Region3 check:
Safe Zones: Sect interiors and starter villages (No PvP, 1.2x Qi Multiplier).
Danger Zones: Open world (PvP enabled, 1.5x Qi Multiplier).
Forbidden Zones: Boss arenas (No Meditation allowed).