# Realmbreaker — Art Direction & Visual Identity Specification

> **Document Code:** 11_ART_DIRECTION.md  
> **Category:** Game Design / Art & Visual Direction  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 02_WORLD.md, 04_COMBAT.md, 08_UI_UX.md, 25_ASSET_PIPELINE.md

---

## 1. Executive Summary & Visual Philosophy

The art direction of **Realmbreaker** is defined as **Stylized Xianxia Elegance**. 

Rather than chasing hyper-realism (which degrades Roblox performance) or generic low-poly minimalism (which lacks Xianxia grandeur), **Realmbreaker** combines clean anime-style character models, flowing traditional robes, painterly environmental textures, and high-contrast elemental Qi particle effects.

> **Visual Axiom:**  
> *"The world should feel like a living ink painting brought to life. Soft natural tones in the environment make vibrant, glowing Qi visual effects pop instantly during combat."*

---

## 2. Palette & Environmental Lighting

Lighting and color palettes establish clear emotional shifts between safe exploration zones, contested wild areas, and high-altitude celestial shrines.

```
+-----------------------------------------------------------------------+
|                    ENVIRONMENTAL ART & LIGHTING MAP                   |
+-----------------------------------------------------------------------+
|  ZONE 1: Bamboo Village    ---> Sunlit Jade, Warm Wood, Clear Springs  |
|  ZONE 2: Mistveil Swamps   ---> Toxic Violet Fog, Bioluminescent Blue |
|  CELESTIAL SHRINES         ---> Sun-Gold Clouds, Marble, Radiant White|
+-----------------------------------------------------------------------+
```

### 2.1 Zone Visual Specifications

* **Zone 1: Bamboo Leaf Village & Outer Sect**
  * **Color Palette:** Jade Green, Warm Timber, Soft Sunrise Gold, Clean River Blue.
  * **Atmosphere:** Low fog density, warm directional sunlight, swaying bamboo stalks, floating cherry blossom petals.
  * **Roblox Lighting Setup:** Future Lighting Technology, ShadowSoftness: 0.2, Atmosphere Density: 0.25.

* **Zone 2: Mistveil Forest & Ancient Caverns**
  * **Color Palette:** Deep Indigo, Miasma Violet, Bioluminescent Cyan, Obsidian Stone.
  * **Atmosphere:** High fog density (creates visual mystery and hides contested Qi node surprises), glowing swamp mushrooms, dark subterranean caverns.
  * **Roblox Lighting Setup:** Future Lighting Technology, Atmosphere Density: 0.65, Haze: 0.4.

---

## 3. Visual FX (VFX) & Qi Progression Hierarchy

VFX scale in visual magnitude and complexity alongside player cultivation realm advancement, serving as an instant visual indicator of power in open-world encounters:

```
+-----------------------------------------------------------------------+
|                       QI VFX EVOLUTION MATRIX                         |
+-----------------------------------------------------------------------+
|  REALM 0: Mortal Body        ---> Physical Dust & Steel Impact Sparks |
|  REALM 1: Qi Condensation    ---> Pale Cyan Ribbon Trails & Qi Blast  |
|  REALM 2: Foundation Est.    ---> Electric Blue Impulse & Spatial Ring|
|  REALM 3: Core Formation     ---> Radiant Golden Aura & Flying Sword  |
+-----------------------------------------------------------------------+
```

### 3.1 Visual FX Guidelines

* **Mortal Body (Realm 0):** Pure physical feedback—slashing wind trails, ground dust kickups, sharp metal spark bursts on blade parries.
* **Qi Condensation (Realm 1):** Subtle flowing energy ribbons wrapping around weapon blades and palms during M1 combos.
* **Foundation Establishment (Realm 2):** High-velocity distortion rings on Air Dash [Q] and semi-transparent energy shields on Qi Shielding [F].
* **Core Formation (Realm 3):** Full-body passive golden aura flare during flight, glowing elemental ground circles for Domain Stances [G], glowing sword trails.

---

## 4. Character & Weapon Aesthetic Standards

### 4.1 Character & Clothing Design
* **Silhouettes:** Layered flowing Xianxia robes, broad rice hats, floating silk sashes, high-collared Sect coats.
* **Cloth Dynamics:** Robes and sashes utilize optimized weight painting to react dynamically to player movement, dashing, and flight without clipping into body meshes.
* **Proportions:** Stylized semi-realistic human proportions (R15 avatar compatibility with custom layered clothing bounds).

### 4.2 Weapon Aesthetics
* **Jian (Straight Double-Edged Sword):** Slender, elegant steel blades decorated with traditional brass guards and silk tassels.
* **Dao (Sabre):** Broad, single-edged curved blades built for aggressive posture-breaking animations.
* **Unarmed Fist Wraps:** Traditional cloth hand wraps imbued with glowing elemental rune engravings at higher realm tiers.

---

## 5. Audio Direction & Soundscape Architecture

Sound design is divided into ambient environmental soundscapes, dynamic musical scores, and punchy combat foley.

### 5.1 Music Direction
* **Exploration Music:** Traditional Chinese instrumentation (Guzheng zither, Erhu two-string violin, Dizi bamboo flute) layered over atmospheric ambient pads.
* **Combat Music:** Fast-paced Taiko drums, energetic string riffs, and booming brass horns that dynamically trigger upon entering combat.

### 5.2 Combat Foley & Sound Effects
* **Blade Clashes:** Crisp, high-frequency metallic rings for standard blocks; deep reverberating gong chime for a **Perfect Parry**.
* **Posture Break:** Heavy glass cracking sound effect combined with a low sub-bass impact.
* **Tribulation Lightning:** Sudden, sharp thunder cracks followed by ambient electrical hums.

---

## 6. Performance & Asset Optimization Budgets

To ensure high visual quality while maintaining 60 FPS performance on mobile devices and low-end hardware:

| Asset Category | Max Polygon / Triangle Budget | Texture Resolution Limit | Max Active Particles |
| :--- | :---: | :---: | :---: |
| **Character Mesh / Robes** | 4,000 Triangles | 1024x1024 Diffuse / Normal | N/A |
| **Weapon Meshes** | 1,500 Triangles | 512x512 SurfaceMap | N/A |
| **Environment Props (Trees/Rocks)**| 2,000 Triangles | 512x512 Atlas | N/A |
| **Active Spell VFX Emitter** | N/A | N/A | 30 Particles / Sec |

---

## 7. System Interconnections

* **Connections to 02_WORLD.md:** Environmental lighting, fog density, and ambient palettes dictate zone mood and visual readability.
* **Connections to 03_CULTIVATION.md:** Visual FX scale in brilliance and color palette according to player realm tier.
* **Connections to 08_UI_UX.md:** UI aesthetic mirrors Xianxia calligraphy, jade accents, and gold borders.

---

> **Document Revision History**  
> *v1.0.0* — Art direction, lighting, VFX hierarchy, and audio specifications approved by Creative Director.