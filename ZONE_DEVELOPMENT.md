Here is a detailed, non-technical **Level Design & Terrain Guide** specifically written for your brother to use directly in Roblox Studio. 

It is structured into actionable steps for sculpting, material painting, and asset placement for both **Zone 1 (The Starter Zone)** and **Zone 2 (The Mid-Game Progression Zone)**.

---

# 🌲 Realmbreaker — Level Design & Terrain Art Guide
*For the Roblox Studio Environment Designer*

This guide outlines the exact visual style, layout, and material settings for sculpting **Zone 1** and **Zone 2** directly in Roblox Studio.

---

## 🌸 ZONE 1: Bamboo Leaf Village & Serene Grove (The Starter Area)
* **Target Audience:** New players, Mortals (Realm 0) & Qi Condensation (Realm 1) [22_DATABASE_DESIGN.md].
* **Vibe:** Peaceful, bright, traditional Chinese fantasy (Xianxia) starter area.
* **Colors:** Soft daylight, lush greens, pink blossoms, and clear blue water.

### 1. Landscape & Sculpting Style
* **Terrain Shape:** Gentle, rolling hills. Avoid sharp, jagged cliffs here. Keep the terrain easy to walk on, with natural dirt paths winding through hills.
* **The River/Stream:** Sculpt a clear, winding river cutting through the landscape, ending in a scenic lake with a waterfall next to the village.
* **The Bamboo Forest:** Create dense groves of tall, green bamboo stalks. The trees should be grouped tightly together with patches of sunlight cutting through.

### 2. Terrain Material Painting (Roblox Terrain Editor)
* **Base:** Use the **Grass** material for the main ground. 
* **Paths:** Use **LeafyGrass** and **Mud** to paint natural, organic walking paths leading from the village out into the groves.
* **Riverbed:** Use a mix of **Sand** and **Pebbles** under the water.
* **Cliffs:** Use **Rock** or **Slate** *only* for the waterfall face and gentle hillside boundaries.

### 3. Key Landmarks to Place
* **Bamboo Leaf Village:** A small cluster of traditional Chinese starter homes (curved tiled roofs, wooden support pillars, paper lantern props) [WorldController:55].
* **The Central Plaza:** A flat stone area in the center of the village with training dummies, weapon racks, and meditation mats.
* **Peach Blossom Grove:** A secluded, beautiful clearing filled with pink cherry blossom trees, ideal for early meditation.
* **Tier 1 Resource Spawns:** Scatter basic **Green Herbs** (flora) and small **Iron/Copper Ore** clusters (rocks) along the paths and near riverbanks for players to gather [02_WORLD.md].

---

## 🌫️ ZONE 2: Mistveil Forest & Ancient Qi Caverns (The Contested Wilderness)
* **Target Audience:** Mid-game players, Foundation (Realm 2) & Core Formation (Realm 3) [22_DATABASE_DESIGN.md].
* **Vibe:** Mystical, dangerous, foggy, and highly vertical [02_WORLD.md].
* **Colors:** Dark greens, deep swampy grays, glowing cyan crystals, and toxic lime-green mists [02_WORLD.md].

### 1. Vertical Level Design Layout
Zone 2 must be sculpted in **three vertical layers** to reward players who unlock movement abilities:

```
                  [ LAYER 3: CELESTIAL SHRINES ] (Floating Islands above the Clouds)
                                ^
                                | (Requires Flight [Space x2] to reach)
                                v
                  [ LAYER 2: CHASM & STONE PILLARS ] (Isolated shortcuts)
                                ^
                                | (Requires Air Dash [Q] to jump across)
                                v
                  [ LAYER 1: SWAMP FLOOR & CAVERNS ] (Deep green fog & underground caves)
```

* **Layer 1: The Swamp Floor:** Sculpt a low-lying, flat, damp basin [02_WORLD.md]. Use the terrain "Add" tool to create large, twisted swamp tree roots that players have to jump over. 
* **Layer 1: The Caverns:** Use the terrain **Subtract** tool to carve out deep, winding underground tunnels beneath the swamp. Ensure there are wide "arena" chambers inside the caves for player group fights.
* **Layer 2: The Chasms:** Sculpt wide, bottomless canyons splitting the land. Place isolated stone pillars across the canyons, spaced just far enough apart that a player cannot jump normally—they must use their **Air Dash [Q]** to cross [02_WORLD.md].
* **Layer 3: Floating Islands:** Place floating stone islands in the sky, high above the main trees. These must be physically impossible to reach from the ground unless the player has unlocked **Flight** [02_WORLD.md].

### 2. Terrain Material Painting
* **Swamp Floor:** Use a heavy blend of **Mud**, **Ground**, and **Moss** to create a wet, decaying forest floor.
* **Cavern Interior:** Use **Slate** and **Basalt** for the cave walls. Paint glowing **Glacier** or glowing neon parts inside the wall seams to represent the **Qi Arteries** [02_WORLD.md].
* **Floating Islands:** Paint with **Rock** on the bottom edges, and **Moss** or **Grass** on the flat tops.

### 3. Key Landmarks & Details to Place
* **The Mystic Realm Gate:** Place a glowing, ancient portal ruins structure at the edge of the swamp (leading to the dungeon) [02_WORLD.md].
* **Contested Qi Arteries:** In the heart of the caverns, place massive, glowing cyan crystal structures. This is where players fight for meditation spots [02_WORLD.md].
* **Tier 2/3 Resource Spawns:** 
  * Scatter **Miasma Grass** (glowing green swamp weeds) on the low swamp floor [02_WORLD.md].
  * Scatter **Golden Core Lotuses** (rare glowing gold flowers) strictly on the high floating sky islands [02_WORLD.md].
  * Scatter **Spirit Crystal Ore** (blue glowing rocks) along the cavern walls [02_WORLD.md].

---

## 🎨 STUDIO LIGHTING & ATMOSPHERE CHEAT SHEET
To make these zones look incredibly cinematic, tell your brother to configure these settings under **`Lighting`** in Roblox Studio:

### For Zone 1 (Bright & Serene):
* **Technology:** Set to **Future** (for beautiful lighting and shadows).
* **ClockTime:** `14.5` (Mid-afternoon sun).
* **Atmosphere properties:**
  * `Density` = `0.1` (Very clear air).
  * `Haze` = `0.0`
  * `Color` = `Color3.fromRGB(255, 245, 230)` (Soft warm daylight).

### For Zone 2 (Foggy & Ethereal):
* **Atmosphere properties (Place inside Lighting):**
  * `Density` = `0.45` (Dense, thick fog) [02_WORLD.md].
  * `Haze` = `1.5`
  * `Color` = `Color3.fromRGB(120, 150, 130)` (Misty, swamp-green fog tint) [02_WORLD.md].
* **ColorCorrection (Add into Lighting):**
  * `Saturation` = `-0.15` (Slightly desaturated, grittier feel).
  * `Contrast` = `0.1`