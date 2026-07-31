Here is the complete, production-ready **Level Design & Map Implementation README Guide** formatted in clean GitHub Markdown. 

You can copy this directly into your project repository as **`docs/LEVEL_DESIGN_GUIDE.md`** or **`README_MAP.md`**.

---

# 🗺️ Realmbreaker — Level Design & Map Implementation Guide (Milestone 1)

This guide provides step-by-step instructions for constructing, assembling, and placing **Zone 1 (Azure Cloud Sect)**, **Zone 2 (Miasma Bamboo Forest)**, and their **Skyward Border Bridge** inside Roblox Studio.

---

## 📸 Visual Concept Art References

Before placing models in Roblox Studio, use these 3D game engine concept renders as your spatial layout blueprints:

### 1️⃣ Zone 1: Azure Cloud Sect (Sect Sanctuary & Safe Hub)
![Zone 1 - Azure Cloud Sect](./docs/assets/concept_zone1_azure_cloud_sect.png)
> **Sub-Districts:** Upper Grand Pagoda Palace, Sect Plaza with dragon statues, Tiered Waterfall Meditation Garden with jade platforms, and Outdoor Alchemy Courtyard.

---

### 2️⃣ Zone 2: Miasma Bamboo Forest (Wilderness & Contested Qi Vein)
![Zone 2 - Miasma Bamboo Forest](./docs/assets/concept_zone2_miasma_bamboo_forest.png)
> **Sub-Areas:** Outer Bamboo Grove, Central Mossy Ruins with colossal glowing cyan Qi Artery crystal, Toxic Miasma Ravines, and Cliffside Cave Entrances.

---

### 3️⃣ Interconnected World View (Zone 1 & Zone 2 Linked)
![Interconnected Panoramic World View](./docs/assets/concept_panoramic_world_view.png)
> **Spatial Transition:** Zone 1 sits at high altitude (`Y = 250`), descending through the Skyward Border Bridge (`Y = 150`) into Zone 2 (`Y = 0`).

---

## 🏗️ Step 1: Roblox Studio Workspace Hierarchy Setup

Before dragging and dropping models, structure your **`Workspace`** in Roblox Studio to ensure clean organization and server-authoritative zone tracking.

1. In the **Explorer** window, right-click **`Workspace`** → **Insert Object** → **`Folder`**.
2. Rename the folder: **`World`**.
3. Create 3 sub-folders inside **`World`**:
   - `Zones`
   - `Interconnections`
   - `Triggers`

```text
Workspace/
└── World/
    ├── Zones/
    │   ├── Zone1_AzureCloudSect/
    │   │   ├── Terrain/
    │   │   ├── Buildings/
    │   │   ├── Foliage/
    │   │   └── Props/
    │   └── Zone2_MiasmaBambooForest/
    │       ├── Terrain/
    │       ├── Buildings/
    │       ├── Foliage/
    │       └── Props/
    ├── Interconnections/
    │   └── SkywardBorderBridge/
    └── Triggers/
        ├── Zone1_SafeZoneTrigger (Part)
        └── Zone2_MiasmaZoneTrigger (Part)
```

---

## ☁️ Step 2: Sky, Lighting, & Cloud Atmosphere Setup

To achieve the Xianxia sea-of-clouds environment seen in the concept art:

1. In **Explorer**, select **`Lighting`**. In the **Properties** panel, set:
   - `Technology` = **`Future`** (Enables realistic 3D volumetric shadows).
   - `ClockTime` = **`14.5`** (3:30 PM warm golden sunlight).
   - `Brightness` = **`3`**.
   - `OutdoorAmbient` = `Color3.fromRGB(120, 130, 150)`.
2. Right-click **`Lighting`** → **Insert Object** → **`Atmosphere`**:
   - `Density` = **`0.35`**
   - `Offset` = **`0.25`**
   - `Color` = `Color3.fromRGB(240, 220, 180)` (Warm golden light).
   - `Decay` = `Color3.fromRGB(150, 180, 210)`.
3. In **Explorer**, expand **`Workspace.Terrain`** → right-click → **Insert Object** → **`Clouds`**:
   - `Cover` = **`0.65`**
   - `Density` = **`0.7`**
   - Enables a dense volumetric sea of clouds below the floating sky islands!

---

## 🌸 Step 3: Building Zone 1 — Azure Cloud Sect (`Y = 250`)

### A. Base Island Assembly
1. Select `Workspace.World.Zones.Zone1_AzureCloudSect.Terrain`.
2. Open the **Terrain Editor** (`Home` tab → `Editor` → `Create` / `Add`).
3. Sculpt a large multi-tiered floating mountain mass centered at **Position `(0, 250, 0)`**.
4. Set material paint to **`Rock`** for cliffs and **`Grass`** for the flat top surface.

### B. Drag & Drop Building Placement
1. **Grand Pagoda Palace:** Place at the highest peak `(0, 280, -100)`.
2. **Sect Plaza:** Place a wide stone tile platform in front of the pagoda `(0, 250, 0)`.
3. **Meditation Pavilion:** On the left island `(-150, 240, 50)`, place 2 green jade slabs over a cyan neon water pool.
4. **Alchemy Courtyard:** On the right island `(150, 240, 50)`, place a large bronze cauldron asset with herb garden soil patches surrounding it.

---

## 🌲 Step 4: Building Zone 2 — Miasma Bamboo Forest (`Y = 0`)

### A. Wilderness Landscape
1. Select `Workspace.World.Zones.Zone2_MiasmaBambooForest.Terrain`.
2. Sculpt a sprawling lower mountain valley or floating plateau centered at **Position `(0, 0, 600)`**.
3. Paint the terrain with **`Mud`**, **`Moss`**, and **`Dark Rock`**.

### B. Contested Qi Artery Core & Foliage
1. **The Qi Crystal Centerpiece:** In the central ruins `(0, 10, 600)`, place a large cyan crystal MeshPart.
   - Insert a **`PointLight`** inside the crystal (`Color = Cyan`, `Brightness = 4`, `Range = 35`).
2. **Dense Bamboo Foliage:** Drag and drop dark bamboo tree models around the perimeter to form natural map boundaries.
3. **Miasma Hazard Fog:** Inside `Zone2_MiasmaBambooForest`, insert a **`ParticleEmitter`** on the ground:
   - `Color` = Green / Cyan
   - `Size` = `NumberSequence.new(5, 12)`
   - `Transparency` = `NumberSequence.new(0.7, 1)`
   - Creates low-lying toxic green Miasma fog rolling across the ground!

---

## 🌉 Step 5: Constructing the Skyward Border Bridge

1. Navigate to `Workspace.World.Interconnections.SkywardBorderBridge`.
2. Drag and drop stone archway bridge models connecting:
   - **Start:** Zone 1 Border Gate `(0, 250, 200)`
   - **End:** Zone 2 Forest Entrance `(0, 10, 400)`
3. Create a stepping mountain staircase that descends **240 studs vertically** through the cloud layer.

---

## 🛑 Step 6: Setting Up Zone Trigger Parts

Zone triggers tell the server when a player enters a Safe Zone versus a Danger Zone.

1. In `Workspace.World.Triggers`, insert a **`Part`** named **`Zone1_SafeZoneTrigger`**:
   - `Size` = **`(400, 200, 400)`** (Encloses Azure Cloud Sect).
   - `Position` = **`(0, 250, 0)`**.
   - `CanCollide` = **`False`**, `Anchored` = **`True`**, `Transparency` = **`1`**.
   - Add Attribute: `ZoneType` = **`SafeZone`** (Disables PvP, resets Miasma toxicity to 0%).

2. Insert a **`Part`** named **`Zone2_MiasmaZoneTrigger`**:
   - `Size` = **`(800, 300, 800)`** (Encloses Miasma Forest).
   - `Position` = **`(0, 0, 600)`**.
   - `CanCollide` = **`False`**, `Anchored` = **`True`**, `Transparency` = **`1`**.
   - Add Attribute: `ZoneType` = **`MiasmaHazard`** (Enables PvP in Qi Vein, activates HUD Miasma toxicity bar).

---

## ⚡ Step 7: Optimization & Performance Checklist

Before testing, verify these software engineering performance rules across all placed models:

- [x] **Anchored State:** Ensure **100% of static map parts/models are `Anchored = True`** to prevent physics lag.
- [x] **StreamingEnabled:** In `Workspace`, set `StreamingEnabled = True` (`TargetRadius = 256`, `MinRadius = 64`).
- [x] **CollisionFidelity:** Set complex foliage/bamboo mesh collisions to **`Box`** or **`Hull`** to optimize physics calculations.
- [x] **CastShadow:** Disable `CastShadow` on small grass tufts, pebbles, and decorative props.

---