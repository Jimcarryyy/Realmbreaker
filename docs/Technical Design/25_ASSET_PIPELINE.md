# Realmbreaker — Asset Pipeline & Production Specifications

> **Document Code:** 25_ASSET_PIPELINE.md  
> **Category:** Technical Design / Asset Production Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 11_ART_DIRECTION.md, 21_FOLDER_STRUCTURE.md, 26_CODING_STANDARD.md

---

## 1. Executive Summary & Pipeline Philosophy

The asset pipeline of **Realmbreaker** is designed to maintain high aesthetic standards while strictly enforcing performance budgets for Roblox cross-platform compatibility (PC, Mobile, Console).

To prevent high-memory crashes, long loading times, and erratic collision physics:
1. **Strict Polycount & Texture Limits:** All 3D models and PBR textures are optimized before import into Roblox Studio.
2. **Animation Marker Standard:** Combat animations embed frame-accurate Keyframe Markers (`HitStart`, `ParryWindow`, `AudioTrigger`) directly inside AnimationTracks, driving deterministic hit detection.
3. **Centralized Asset Management:** Asset IDs (meshes, animations, sound IDs) are never hardcoded inside individual scripts; they are managed centrally in `src/Shared/Config/AssetsConfig.lua`.

---

## 2. 3D Modeling & Mesh Import Pipeline

All 3D models are authored in Blender following standardized spatial unit scales and pivot point rules:

```
+-----------------------------------------------------------------------+
|                       3D MESH PRODUCTION PIPELINE                     |
+-----------------------------------------------------------------------+
|  BLENDER (1 Unit = 1 Stud)  ---> OPTIMIZE MESH & UV ATLAS MAPPING    |
|                                                   |                   |
|  ROBLOX STUDIO IMPORT       <--- EXPORT AS .FBX   <--- SET PIVOT POINT|
+-----------------------------------------------------------------------+
```

### 2.1 Spatial Scale & Pivot Point Rules
* **Scale Metric:** 1 Blender Unit = 1 Roblox Stud (0.28 meters).
* **Weapon Pivots:** Weapon mesh pivot points MUST be aligned exactly at the primary grip handle center to ensure seamless Motor6D attachment to character hands.
* **Collision Fidelity:** Complex environmental meshes use simplified custom collision proxy parts (`CanCollide = True`, invisible) while setting the detailed visual MeshPart to `CanCollide = False`.

### 2.2 Polycount Budgets Matrix

| Asset Category | Max Polycount (Triangles) | Collision Settings | Format |
| :--- | :---: | :--- | :---: |
| **Character Robes / Layered Clothing**| 4,000 Tris | `CanCollide = False` | `.FBX` |
| **Primary Weapon Meshes (Jian / Dao)** | 1,500 Tris | `CanCollide = False` | `.FBX` |
| **Environment Props (Trees / Rocks)**| 2,000 Tris | `Box` or `Hull` | `.FBX` |
| **Interactive Props (Cauldron / Node)**| 2,500 Tris | Custom Collision Proxy | `.FBX` |

---

## 3. Texture & PBR Material Pipeline

Textures utilize Roblox `SurfaceAppearance` PBR workflow (ColorMap, NormalMap, RoughnessMap, MetalnessMap):

* **Resolution Standards:**
  * Character Models & Key Weapons: **1024x1024** maximum resolution.
  * Environment Props & Ores: **512x512** resolution.
  * Particle Textures & UI Icons: **256x256** resolution.
* **Format:** PNG format with transparency channels preserved for particle maps and alpha-blended fabrics.

---

## 4. Animation Engine & Keyframe Marker Standard

Combat animations must follow strict timing protocols to synchronize client prediction with server-side hit detection:

```
+-----------------------------------------------------------------------+
|                    ANIMATION KEYFRAME MARKER TIMELINE                 |
+-----------------------------------------------------------------------+
|  [START] ---> Marker: HitStart  ---> Marker: HitEnd  ---> [FINISH]    |
|                   (Active Damage Window Enabled)                      |
+-----------------------------------------------------------------------+
```

### 4.1 Standardized Animation Keyframe Markers
Animators must insert named markers inside Blender / Moon Animator before exporting:

* **`HitStart`:** Indicates the exact frame where weapon damage hitboxes activate.
* **`HitEnd`:** Indicates the frame where active damage hitboxes deactivate.
* **`ParryWindowStart` / `ParryWindowEnd`:** Indicates the active parry buffer for defensive animations.
* **`AudioTrigger`:** Parameterized marker triggering spatial sword swoosh or impact sound effects.

### 4.2 Rigging & Rig Standards
* All humanoid animations must target the standard **R15 Avatar Rig**.
* Weapon attachments utilize standard `RightHand` / `LeftHand` `RightGrip` attachment points.

---

## 5. Audio Pipeline & Sound Architecture

Audio assets are categorized and balanced across dedicated Roblox `SoundGroups` to maintain clear sound prioritization:

```
+-----------------------------------------------------------------------+
|                        SOUNDGROUP HIERARCHY                           |
+-----------------------------------------------------------------------+
|  MASTER SOUND GROUP                                                   |
|  ├── COMBAT_SFX   (Highest Priority: Blade Clashes, Parry Chimes)     |
|  ├── ENVIRONMENT  (Ambient Wind, River Streams, Forest Sounds)        |
|  ├── MUSIC        (Background Guzheng & Battle Drums)                 |
|  └── UI_SOUNDS    (Button Clicks, Menu Swishes)                       |
+-----------------------------------------------------------------------+
```

* **File Format:** `.MP3` (compressed) or `.OGG` (lossless), 44.1kHz sampling rate.
* **Spatial 3D Audio:** All combat impact and skill sound instances use 3D spatial roll-off (`RollOffMinDistance = 5`, `RollOffMaxDistance = 100`).

---

## 6. Centralized Asset Management (`AssetsConfig.lua`)

To avoid hardcoded asset IDs throughout the codebase, all imported Asset IDs must be registered in the central shared config file:

```lua
-- Shared Config: src/Shared/Config/AssetsConfig.lua
local AssetsConfig = {
    Animations = {
        SwordStance = {
            M1_Combo1 = "rbxassetid://1234567890",
            M1_Combo2 = "rbxassetid://1234567891",
            ParryExecute = "rbxassetid://1234567892",
            AirDash = "rbxassetid://1234567893"
        }
    },
    Audio = {
        Combat = {
            PerfectParryChime = "rbxassetid://9876543210",
            PostureBreakCrack = "rbxassetid://9876543211"
        }
    },
    Meshes = {
        Weapons = {
            FlowingWaterJian = "rbxassetid://5555555555"
        }
    }
}

return AssetsConfig
```

---

## 7. System Interconnections

* **Connections to 11_ART_DIRECTION.md:** Enforces the visual quality, color palettes, and particle emission limits defined by art direction.
* **Connections to 21_FOLDER_STRUCTURE.md:** Maps raw asset models to `src/Assets/` and script config to `src/Shared/Config/`.
* **Connections to 26_CODING_STANDARD.md:** Mandates centralized configuration registration instead of hardcoding Asset IDs.

---

> **Document Revision History**  
> *v1.0.0* — Asset pipeline, polycount budgets, animation markers, and audio hierarchy approved by Technical Art Lead.