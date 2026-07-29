# Realmbreaker — UI/UX Architecture Specification

> **Document Code:** 08_UI_UX.md  
> **Category:** Game Design / UI & UX Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 03_CULTIVATION.md, 04_COMBAT.md, 06_PVP.md, 09_ECONOMY.md

---

## 1. Executive Summary & Design Philosophy

The user interface of **Realmbreaker** is designed to balance deep Xianxia thematic immersion with ultra-clean, modern competitive readability.

### Core UX Principles
1. **Uncluttered Combat Screen:** During active combat, non-essential UI elements automatically fade to 20% opacity to ensure zero visual obstruction of enemy attack telegraphs.
2. **Instant Visual Feedback ("Juice"):** Critical mechanics—such as Perfect Parries, Posture Breaks, and Breakthrough attempts—are paired with distinct micro-screen shakes, flash indicators, and spatial sound cues.
3. **Cross-Platform Equality:** The UI architecture uses responsive anchor scaling to ensure identical functional parity across PC, Mobile, and Console devices.

---

## 2. Main HUD Layout Architecture

The Heads-Up Display (HUD) is organized into four distinct screen zones:

+-----------------------------------------------------------------------+
|  [TOP-LEFT]                          [TOP-RIGHT]                      |
|  • Player Identity & Realm Badge     • Mini-Map & Zone Safety Status  |
|  • Health / Stamina / Qi Bars        • Quest Tracker & Ping/FPS       |
|                                                                       |
|                                                                       |
|                                      [CENTER-RIGHT]                   |
|                                      • Target Locking & Posture Meter |
|                                                                       |
|  [BOTTOM-LEFT]                       [BOTTOM-CENTER]                  |
|  • Chat & Combat Log                 • Ability Hotbar & Cooldowns     |
|                                      • Stance Indicator & M1 Combo    |
+-----------------------------------------------------------------------+

### 2.1 Player Vitals Cluster (Top-Left)
* **Realm Badge:** Displays current cultivation realm icon (e.g., Golden Core icon for Realm 3) and sub-stage text (Early, Mid, Late, Peak).
* **Health Bar (Red):** Displays current/max HP. Flashes white upon taking damage.
* **Stamina Bar (Green):** Displays current stamina used for Dodge Rolls [Q] and Heavy M2 attacks.
* **Qi Energy Bar (Cyan/Blue):** Unlocks at Realm 1. Displays current internal Qi reserved for skills and spatial movement.

### 2.2 Combat & Ability Hotbar (Bottom-Center)
* **Stance Indicator:** Displays active stance (Flowing Water Sword / Thunder-Palm) with quick-swap keybind indicator.
* **M1 Combo Counter:** 4-dot indicator showing active position in light combo sequence.
* **Skill Slots:** Displaying cooldown sweeps and Qi cost badges for Qi Blast, Air Dash, and Domain Stances.

---

## 3. Core Interface Panels

### 3.1 Cultivation & Breakthrough Panel `[C]`
* **Qi Wheel:** Radial progress indicator showing current Qi accumulation toward the next sub-stage.
* **Pill Slotting Modal:** Drag-and-drop slots for Breakthrough Elixirs and Heart Protection Pills.
* **Breakthrough Trigger Button:** Displays estimated tribulation risk and success factors based on Qi purity.

### 3.2 Inventory & Equipment Panel `[I]`
* **Grid Layout:** 5x6 inventory slot grid using full scale-based responsive constraints.
* **Category Tabs:** All Items, Alchemy Herbs, Crafting Ores, Consumables, Quest Items.
* **Item Tooltips:** Displays rarity color borders (Common, Rare, Legendary), tier requirements, and current trade tax values.

### 3.3 Qi Sensing HUD Overlay `[V]`
* Toggling `[V]` activates a full-screen spirit vision filter (desaturates environmental textures while highlighting energetic entities):
  * **Green Glow:** Tier 1-3 Alchemy Herbs & Root Nodes.
  * **Cyan Glow:** High-Density Qi Vein Arteries.
  * **Red Aura:** Hostile Cultivators (Wanted/Outlaw status).
  * **Gold Aura:** World Bosses & Rare Spirit Beasts.

---

## 4. Cross-Platform Input Mapping

The UI dynamically adapts input prompts based on the player's active device:

| Action / Feature | PC Keyboard / Mouse | Mobile Touch Screen | Console (Xbox / PlayStation) |
| :--- | :--- | :--- | :--- |
| **Light Combo (M1)** | Left Mouse Click | Large Right Thumb Button | Right Trigger (RT / R2) |
| **Heavy / Guard Break** | Right Mouse Click | M2 Sub-Button | Right Bumper (RB / R1) |
| **Parry / Block** | Tap / Hold `[F]` | Dedicated Shield Button | Left Bumper (LB / L1) |
| **Dodge Roll / Air Dash**| `[Q]` + Direction | Swipe / Jump Double Tap | `[A]` Button / Cross |
| **Toggle Qi Sensing** | `[V]` Key | Eye HUD Icon | D-Pad Up |
| **Open Menu / Inventory**| `[I]` / `[C]` Keys | Top Menu Drawer | View / Touchpad Button |

---

## 5. Visual & Audio Feedback Protocols ("Juice")

To provide clear feedback without overwhelming the player:

1. **Perfect Parry Feedback:**
   * **Visual:** Instant 0.05-second micro-freeze frame + circular gold spark particle burst at blade contact point.
   * **Audio:** Sharp metallic chime cue (high priority sound channel).

2. **Posture Break Feedback:**
   * **Visual:** Target posture bar flashes red and shatters; target plays heavy stagger animation.
   * **Audio:** Heavy glass cracking sound effect.

3. **Miasma Hazard Warning:**
   * **Visual:** Screen edge vignette turns toxic purple when taking miasma environmental damage in Zone 2.

---

## 6. Technical UI Implementation Standards

To maintain high UI frame rates and zero memory leaks across mobile and low-end devices:

1. **Scale-Based Responsive Layouts:**
   * All Frame elements use `Scale` coordinates instead of fixed `Offset` pixels.
   * All square icon containers enforce 1:1 ratios via `UIAspectRatioConstraint`.

2. **Event-Driven UI Updates:**
   * Health, Stamina, and Qi bars update strictly via state change events (e.g., `ProfileService` replica updates), NEVER running inside `RunService.RenderStepped` loops.

3. **Spatial Canvas Groups:**
   * Complex menu panels use `CanvasGroup` for smooth group alpha fade-in/out transitions without individual element opacity iteration.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Displays Qi accumulation progress, purity stats, and breakthrough mini-game indicators.
* **Connections to 04_COMBAT.md:** Communicates parry frame feedback, posture meters, and stance cooldown sweeps.
* **Connections to 06_PVP.md:** Displays hostility icons (Peaceful/Hostile) and Wanted/Outlaw bounty markers.

---

> **Document Revision History**  
> *v1.0.0* — UI/UX architecture and cross-platform mapping approved by Lead UI/UX Designer.