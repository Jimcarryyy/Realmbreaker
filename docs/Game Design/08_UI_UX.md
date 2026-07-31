
---

# 🎨 Realmbreaker — UI/UX Specification & Layout Architecture

> **Master UI/UX Specification** | Roblox Action Xianxia MMORPG  
> **Style Standard:** Soft 2D Vector Handcrafted Sect Artifact System  
> **Target Audience:** All-Ages (Accessible, Intuitive, Clutter-Free, Cross-Platform)

---

## 📜 Table of Contents
1. [Design Philosophy, Core Principles & Project Mantra](#1-design-philosophy-core-principles--project-mantra)
2. [The 3-Tier UI Functional Framework](#2-the-3-tier-ui-functional-framework)
3. [Visual Style & Design Tokens](#3-visual-style--design-tokens)
4. [Dynamic Shell & Slicing Architecture](#4-dynamic-shell--slicing-architecture)
5. [Master Approved UI Asset Kit Registry](#5-master-approved-ui-asset-kit-registry)
6. [In-World Overhead Status (BillboardGui)](#6-in-world-overhead-status-billboardgui)
7. [In-Game Screen HUD Layout](#7-in-game-screen-hud-layout)
8. [Center Navigation Modals & 3-Pane Layouts](#8-center-navigation-modals--3-pane-layouts)
9. [UX Interaction Models & Input Ergonomics](#9-ux-interaction-models--input-ergonomics)
10. [Roblox Studio Implementation Standard & Luau Code](#10-roblox-studio-implementation-standard--luau-code)
11. [AI Generator Reference Prompts](#11-ai-generator-reference-prompts)

---

---
```markdown
## 1. Master 37-Asset Registry (Populated Roblox Asset IDs)

```text
ReplicatedStorage/Shared/Assets/UI/
├── 📁 Panels/ (7 Widescreen Modal Shells)
│   ├── Panel1_AlchemyPanelShell.png         (rbxassetid://84276737641585)
│   ├── Panel2_InventoryPanelShell.png       (rbxassetid://123841032076360)
│   ├── Panel3_CharacterPanelShell.png       (rbxassetid://86012045244236)
│   ├── Panel4_SkillsPanelShell.png          (rbxassetid://107226547729026)
│   ├── Panel5_MapQuestPanelShell.png        (rbxassetid://131488945229260)
│   ├── SettingsPanel_SettingsShell.png      (rbxassetid://127613233097676)
│   └── DialogueFrame_DialogueShell.png      (rbxassetid://79576725327950)
│
├── 📁 HUD/ (6 On-Screen Overlays & Banners)
│   ├── Panel6_CombatHUDOverlayShell.png     (rbxassetid://110381792485649)
│   ├── TopNavigationFrame_TopNavShell.png   (rbxassetid://122415586898423)
│   ├── BossHealthBarShell_BossBarShell.png  (rbxassetid://134065637826617)
│   ├── TargetFrame_TargetFrameShell.png     (rbxassetid://112564321533982)
│   ├── QuestTrackerWidget_QuestTrackerShell.png (rbxassetid://131670772422654)
│   └── TutorialHintBanner_TutorialBannerShell.png (rbxassetid://92283672177848)
│
├── 📁 Templates/ (3 Reusable Controls & Buttons)
│   ├── Panel7_ModularSlotTemplate.png       (rbxassetid://78377208477701)
│   ├── AssetA_CloseButton.png               (rbxassetid://113605743209527)
│   └── AssetB_PrimaryActionButton.png       (rbxassetid://139131406784954)
│
├── 📁 Items/ (11 Inventory Items, Pills, Herbs & Currencies)
│   ├── Item_JadeSpiritBlade.png             (rbxassetid://102309054006524)
│   ├── Item_InitiateRobe.png                (rbxassetid://110436079253993)
│   ├── Item_QiGatheringRing.png             (rbxassetid://138394758283116)
│   ├── Item_SpiritHerb.png                  (rbxassetid://90866060513740)
│   ├── Item_DragonBloodFlower.png           (rbxassetid://122623665914573)
│   ├── Item_FrostLotus.png                  (rbxassetid://76826036711416)
│   ├── Item_QiGatheringPill.png             (rbxassetid://87497192233934)
│   ├── Item_VitalityPill.png                (rbxassetid://112990324747062)
│   ├── Item_SkillManualScroll.png           (rbxassetid://78648040440784)
│   ├── Currency_SpiritStones.png            (rbxassetid://79573528943998)
│   └── Currency_SectTokens.png              (rbxassetid://75450655299271)
│
├── 📁 Skills/ (6 Action Hotbar Ability Icons)
│   ├── Skill_QiDash.png                     (rbxassetid://137358656097564)
│   ├── Skill_Parry.png                      (rbxassetid://129890118103154)
│   ├── Skill_QiSense.png                    (rbxassetid://128617837655590)
│   ├── Skill_FlowingWaterSlash.png          (rbxassetid://95178149840421)
│   ├── Skill_ThunderPalmStrike.png          (rbxassetid://139060977395032)
│   └── Skill_SpiritBlast.png                (rbxassetid://71547589196383)
│
└── 📁 Icons/ (4 Individual Map Pins)
    ├── MapPin_PlayerArrow.png               (rbxassetid://113587700256481)
    ├── MapPin_SectTemple.png                (rbxassetid://106421270342595)
    ├── MapPin_QiNodeCrystal.png             (rbxassetid://115576917375343)
    └── MapPin_QuestExclamation.png          (rbxassetid://120838027568021)

---

## 2. The 3-Tier UI Functional Framework

To eliminate UI fatigue and ensure combat clarity, the interface is divided into three functional categories:

```text
+----------------------------------------------------------------------------------------------------+
| TIER 1: PERSISTENT HUD (Combat & Real-Time Navigation)                                             |
| • Philosophy: "Invisible, Modern & Unobtrusive"                                                    |
| • Materials: Floating dark translucent overlays (#0D1117) with soft Spirit Jade cyan strokes.      |
| • Key Goal: Maximum readability during fast-paced 0.18s parry / 0.20s dodge combat.                |
+----------------------------------------------------------------------------------------------------+
                                                  │
                                                  ▼
+----------------------------------------------------------------------------------------------------+
| TIER 2: INTERACTIVE SYSTEMS (Management & Crafting)                                                |
| • Philosophy: "Handcrafted Sect Tools & Artifacts"                                                 |
| • Materials: Dark slate-blue vector satin (#161B26), muted jade, brushed gold line-art filigree.   |
| • Key Goal: Tactile, rewarding, structured interaction for inventory, alchemy, and character stats.|
+----------------------------------------------------------------------------------------------------+
                                                  │
                                                  ▼
+----------------------------------------------------------------------------------------------------+
| TIER 3: NARRATIVE & LORE (Story, Quests & World Techniques)                                        |
| • Philosophy: "Ancient Parchment & Silk Scrolls"                                                   |
| • Materials: Aged paper parchment, unfurled silk canvas, dark bamboo rods, ink-wash brush borders.|
| • Key Goal: Deep immersion for technique manuals, quest logs, sect records, and world maps.       |
+----------------------------------------------------------------------------------------------------+
```

---

## 3. Visual Style & Design Tokens

### 🎨 Color Palette Tokens

| Token Name | Hex Code | Visual Use Case | Roblox Color3 |
| :--- | :--- | :--- | :--- |
| **Dark Slate Satin (Base)** | `#161B26` | Main Panel Shell Container Backdrop | `Color3.fromRGB(22, 27, 38)` |
| **Dark Inset Canvas** | `#0D1117` | Recessed Slot Backings & Inner Cards | `Color3.fromRGB(13, 17, 23)` |
| **Spirit Jade Cyan** | `#38E5B6` | Tier 1 HUD Strokes, Active Selection, Qi Sense | `Color3.fromRGB(56, 229, 182)` |
| **Muted Jade Accent** | `#36997B` | Herb Bowls, Slot Borders, Secondary Frames | `Color3.fromRGB(54, 153, 123)` |
| **Brushed Gold Line-Art** | `#D4AF37` | Cloud Filigree, Panel Borders, Active Tabs | `Color3.fromRGB(212, 175, 55)` |
| **Amber Stamina** | `#F97316` | Stamina Gauge Fill, Dodge Indicators | `Color3.fromRGB(249, 115, 22)` |
| **Crimson Posture** | `#EF4444` | Posture Gauge Fill, Danger Warnings | `Color3.fromRGB(239, 68, 68)` |
| **Pure Black Margin** | `#000000` | Crop Isolation Backdrop | `Color3.fromRGB(0, 0, 0)` |

### 📐 Geometry & Border Rules
* **Sharp 90° Outer Corners (0px Radius):** All main panel shell frames have **sharp 90-degree outer corners** with zero border radius. This guarantees pixel-perfect cropping and 9-slice tiling (`SliceScale`) in Roblox Studio without transparent corner gaps.
* **Internal Corner Radius (8px–10px):** Inner cards, buttons, and item slots use soft 8px–10px rounded corners (`UICorner`) for an approachable, tactile feel.
* **Contained Filigree:** All cloud corner decorations are drawn **strictly inside** the inner padding of the frame. Zero edge clipping or outer boundary overflow.

### 🔤 Typography Hierarchy
* **Headers & Realm Titles:** `Enum.Font.FredokaOne` (Soft, bold, engaging, highly readable on all screen sizes).
* **HUD Numbers & Stat Specs:** `Enum.Font.GothamBold` / `Enum.Font.GothamSSm` (Crisp legibility with 1.5px drop shadows).
* **Body / Descriptions:** `Enum.Font.GothamMedium` (Clean sans-serif text).

---

## 4. Dynamic Shell & Slicing Architecture

> [!IMPORTANT]
> To ensure seamless Luau runtime execution, **all 2D background image assets are pure empty shell templates**. Dynamic elements (item slots, scrollbars, health fills, button text, 3D viewport models) are rendered programmatically in Roblox Studio.

```text
> [ 2D Asset Background Shell ] ──┐  
>                                 ├──> Integrated at Runtime by Luau Engine  
> [ Dynamic Luau Instances ]   ──┘  
```

1. **Hollow Track Grooves:** Status gauge tracks (Health, Stamina, Qi, Posture) and progress bars are hollow, dark empty grooves. Luau code dynamically animates inner fill `Frame` objects using `TweenService` with `ClipsDescendants = true`.
2. **Clean Canvas Panes:** Grid containers and scrolling canvas areas are kept as pure open dark slate panes. Luau populates item slots at runtime via `UIGridLayout` / `UIListLayout`.
3. **Native Scrolling Channels:** Canvas panes preserve a clean right margin (`20px`) allowing Roblox's native `ScrollingFrame` scrollbar handles to operate without visual overlap.
4. **Blank Container Slots:** Skill slots and navigation pills are generated as empty background frames. Keybind text badges (`[1]`, `[Q]`, `[F]`) and skill icons are mounted dynamically via `TextLabel` and `ImageLabel`.

---

```markdown
### Master 37-Asset Directory Mapping
All 2D UI graphic assets are categorized across 6 subfolders under `ReplicatedStorage.Shared.Assets.UI`:

* **`Panels/` (7 Shells):** `Panel1_AlchemyPanelShell` (`84276737641585`), `Panel2_InventoryPanelShell` (`123841032076360`), `Panel3_CharacterPanelShell` (`86012045244236`), `Panel4_SkillsPanelShell` (`107226547729026`), `Panel5_MapQuestPanelShell` (`131488945229260`), `SettingsPanel_SettingsShell` (`127613233097676`), `DialogueFrame_DialogueShell` (`79576725327950`).
* **`HUD/` (6 Overlays):** `Panel6_CombatHUDOverlayShell` (`110381792485649`), `TopNavigationFrame_TopNavShell` (`122415586898423`), `BossHealthBarShell_BossBarShell` (`134065637826617`), `TargetFrame_TargetFrameShell` (`112564321533982`), `QuestTrackerWidget_QuestTrackerShell` (`131670772422654`), `TutorialHintBanner_TutorialBannerShell` (`92283672177848`).
* **`Templates/` (3 Controls):** `Panel7_ModularSlotTemplate` (`78377208477701`), `AssetA_CloseButton` (`113605743209527`), `AssetB_PrimaryActionButton` (`139131406784954`).
* **`Items/` (11 Items & Currencies):** `Item_JadeSpiritBlade` (`102309054006524`), `Item_InitiateRobe` (`110436079253993`), `Item_QiGatheringRing` (`138394758283116`), `Item_SpiritHerb` (`90866060513740`), `Item_DragonBloodFlower` (`122623665914573`), `Item_FrostLotus` (`76826036711416`), `Item_QiGatheringPill` (`87497192233934`), `Item_VitalityPill` (`112990324747062`), `Item_SkillManualScroll` (`78648040440784`), `Currency_SpiritStones` (`79573528943998`), `Currency_SectTokens` (`75450655299271`).
* **`Skills/` (6 Abilities):** `Skill_QiDash` (`137358656097564`), `Skill_Parry` (`129890118103154`), `Skill_QiSense` (`128617837655590`), `Skill_FlowingWaterSlash` (`95178149840421`), `Skill_ThunderPalmStrike` (`139060977395032`), `Skill_SpiritBlast` (`71547589196383`).
* **`Icons/` (4 Pins):** `MapPin_PlayerArrow` (`113587700256481`), `MapPin_SectTemple` (`106421270342595`), `MapPin_QiNodeCrystal` (`115576917375343`), `MapPin_QuestExclamation` (`120838027568021`).

---

## 6. In-World Overhead Status (`BillboardGui`)

Every character (Player and NPC) displays a floating `BillboardGui` anchored to `HumanoidRootPart` / `Head` with a `3.2` studs vertical offset (`220px x 65px` proportional scaling).

```text
          ┌──────────────────────────────────────────┐          
          │  ✨ [ Core Formation - Early Stage ] ✨   │  <-- Realm Title Badge
          ├──────────────────────────────────────────┤          
          │             Cultivator Name              │  <-- Player Name text
          │     ┌──────────────────────────────┐     │          
          │  HP │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 302 │  <-- Hollow Track
          │     └──────────────────────────────┘     │          
          │  PO │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 100 │  <-- Hollow Track
          └──────────────────────────────────────────┘          
```

* **Realm Title Badge:** Rounded Brushed Gold pill badge displaying current breakthrough stage (`Mortal Body`, `Qi Condensation`, `Foundation Establishment`, `Core Formation`).
* **Nameplate:** Clean sans-serif name rendering with 1.5px black contrast outline.
* **Dual Gauges:** Two hollow track grooves where Luau updates Health and Posture poise in real time.

---

## 7. In-Game Screen HUD Layout

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐  
│                                                         In-World Overhead Status       │  
│                                                       ┌────────────────────────┐       │  
│                                                       │ ✨ [ Core Formation ]  │       │  
│                                                       │    Player Nameplate    │       │  
│                                                       │ [░░░░░░░░░░░░░░░░░░]   │       │  
│                                                       └────────────────────────┘       │  
│                                                                        TopRightNav     │  
│                                                                   ┌──────────────────┐ │  
│                                                                   │ ≡  👤 🎒 ⚔️ 🗺️ ⚙️│ │  
│                                                                   └──────────────────┘ │  
│                                                                                        │  
│                                       [AVATAR]                                         │  
│                                                                                        │  
│                                                                                        │  
├────────────────────────────────────────────────────────────────────────────────────────┤  
│  VitalityCluster (20px Padding)              Hotbar (15px Bottom Offset)               │  
│  ┌─────────────────────────────┐   ┌────────────────────────────────────────────────┐  │  
│  │ 🟢 HP  [░░░░░░░░░░░░░░░░░] │   │ [1]    [2]    [3]    [Q]    [F]    [V]        │  │  
│  │ ⚡ ST  [░░░░░░░░░░░░░░░░░] │   │ ┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐     │  │  
│  │ 💧 QI  [░░░░░░░░░░░░░░░░░] │   │ │   │  │   │  │   │  │   │  │   │  │   │     │  │  
│  │ 🛡️ PO  [░░░░░░░░░░░░░░░░░] │   │ └───┘  └───┘  └───┘  └───┘  └───┘  └───┘     │  │  
│  └─────────────────────────────┘   └────────────────────────────────────────────────┘  │  
│          (240px x 130px)                            (340px x 60px)                     │  
└────────────────────────────────────────────────────────────────────────────────────────┘  
```

### HUD Component Breakdown

#### A. Vitality Stack (`VitalityCluster`)
* **Placement:** Bottom-Left corner with `20px` edge padding (`240px x 130px`).
* **Container:** Dark slate-blue ribbon card with gold filigree corners.
* **Tracks:** 4 stacked hollow gauge grooves:
  * **Health (HP):** Dynamic Crimson fill (`#EF4444`)
  * **Stamina (ST):** Dynamic Amber fill (`#F97316`)
  * **Spirit Qi (QI):** Dynamic Cyan fill (`#38E5B6`)
  * **Posture (PO):** Dynamic Gold fill (`#D4AF37`)

#### B. Action Hotbar (`HotbarCluster`)
* **Placement:** Bottom-Center, floating `15px` above bottom screen edge (`340px x 60px`).
* **Container:** Dark slate horizontal ribbon with gold filigree corner flourishes.
* **Slots:** 6 empty square slot container frames (`[1]`, `[2]`, `[3]`, `[Q]` Air Dash, `[F]` Parry/Shield, `[V]` Qi Sense). Keybind pill badges and skill icons are mounted dynamically.

#### C. Navigation Bar (`TopRightNav`)
* **Placement:** Top-Right corner with `20px` edge padding (`220px x 40px`).
* **Container:** Horizontal dark slate pill holding 6 circular icon button frames for modal toggles (`[C]`, `[B]`, `[K]`, `[L]`, `[M]`, `[O]`).

---

## 8. Center Navigation Modals & 3-Pane Layouts

When a player opens a menu hotkey (`[C]`, `[B]`, `[K]`, `[L]`, `[M]`, `[O]`), the master modal window displays centered on screen (`920px x 520px`, `AspectRatio: 1.778`).

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐  
│                        MAIN NAVIGATION & CENTER MODALS (920px x 520px)                  │  
│ ┌───────────────────────┬───────────────────────────────────────────┬────────────────┐ │  
│ │                       │  [ All ]  [ Weapons ]  [ Pills ]  [ Mats ]│                │ │  
│ │                       ├───────────────────────────────────────────┤                │ │  
│ │                       │                                         ▲ │                │ │  
│ │     PAPERDOLL 3D      │                                         █ │  ITEM PREVIEW  │ │  
│ │    AVATAR VIEWPORT    │               ITEM GRID                 █ │     FRAME      │ │  
│ │                       │            SCROLLING CANVAS             █ │                │ │  
│ │                       │                                         █ ├────────────────┤ │  
│ │                       │                                         █ │ DESCRIPTION    │ │  
│ │                       │                                         ▼ │ TEXT BOX       │ │  
│ │     ┌───────────┐     │                                           ├────────────────┤ │  
│ │     │ JADE BASE │     │                                           │ [EQUIP]  [USE] │ │  
│ └─────┴───────────┴─────┴───────────────────────────────────────────┴────────────────┘ │  
└────────────────────────────────────────────────────────────────────────────────────────┘  
```

### 3-Pane Modular Layout Breakdown

1. **Left Pane (Paperdoll Viewport — 280px):** Holds a 3D character avatar viewport positioned above a 2D Spirit Jade circular pedestal artwork (`Panel2_InventoryPanelShell`).
2. **Center Pane (Main Canvas — 460px):**
   * Top horizontal filter tab bar frame (`All`, `Weapons`, `Pills`, `Materials`).
   * Large open dark scrolling canvas populated dynamically via `UIGridLayout` using `Panel7_ModularSlotTemplate`.
   * Native scrollbar track on right edge styled with a Muted Jade handle (`#36997B`).
3. **Right Pane (Item Inspector — 180px):**
   * Top square item icon preview frame (`Panel1_AlchemyPanelShell` or inspector card).
   * Middle detail text box container.
   * Dual bottom action button containers (`[EQUIP]`, `[USE]`, `[DISCARD]`).

---

## 9. UX Interaction Models & Input Ergonomics

### 9.1 Ingredient & Item Selection UX
To support PC (Mouse), Mobile (Touch), and Console (Gamepad), item interactions support dual input workflows:

1. **Tap-to-Assign (Drawer UX - Best for Mobile & Gamepad):**
   * Tapping an empty slot opens a filtered **Mini-Inventory Drawer**.
   * Tapping an item in the drawer assigns it to the slot and updates the stack count (`x3`).
2. **Drag-and-Drop (PC & Touch):**
   * Holding an item card creates a floating `DragIcon` following the cursor.
   * Dropping the icon over a valid target slot snaps it into place with a subtle click sound.
3. **Auto-Fill Recipe Shortcut:**
   * Clicking a known recipe name automatically pulls required herbs from inventory into slots with 1 click.

### 9.2 Keybindings & Core Access
* `[C]` — Character Sheet & Heavenly Tribulation Breakthrough
* `[B]` / `[I]` — Inventory Grid & Paperdoll Equipment
* `[K]` — Martial Skill Tree Canvas
* `[L]` — Alchemy Cauldron & Pill Brewing Workstation
* `[M]` / `[N]` — World Map & Qi Artery Heatmap
* `[O]` — Settings & Keybind Remapping
* `[V]` — Qi Sense Spiritual Vision Overlay
* `[1]`, `[2]`, `[3]`, `[Q]`, `[F]`, `[V]` — Action Hotbar Quickslots

### 9.3 Roblox Safe Area & Ergonomics
* **TopBar Inset:** Top HUD elements adjust dynamically for device cutouts using `GuiService:GetGuiInset()`.
* **Touch Targets:** Minimum interactive touch target size of **44×44 DP** on mobile devices.
* **Gamepad Focus:** Full D-Pad/Thumbstick UI selection groups supported via `GuiService.SelectedObject`.

---

## 10. Roblox Studio Implementation Standard & Luau Code

1. **Responsive Scale Constraints:**
   * All screen UI elements use relative `Scale` positioning (`Size` and `Position`) paired with `UIAspectRatioConstraint` and `UISizeConstraint` to ensure seamless scaling across Mobile, Tablet, PC, and Console.
2. **Interactive Motion Polish:**
   * All interactive buttons utilize scale-bounce spring animations (`1.0x` baseline -> `1.05x` Hover -> `0.95x` Click) via `TweenService`.
3. **Zero Asset Loading Flicker:**
   * All UI textures, background frames, and icon assets are preloaded during the initial game loading screen using `ContentProvider:PreloadAsync()`.

### 10.1 StarterGui Hierarchy
```text
StarterGui.MainGui
 ├── HUDFrame (ScreenGui)
 │    ├── VitalsCluster (Frame -> Panel6 Overlay Left)
 │    └── ActionHotbar (Frame -> Panel6 Overlay Right)
 └── ModalContainer (ScreenGui - Center Display)
      ├── Panel1_Alchemy (ImageLabel -> Panel1 Shell)
      ├── Panel2_Inventory (ImageLabel -> Panel2 Shell)
      │    └── ItemGridScroll (ScrollingFrame + UIGridLayout)
      ├── Panel3_Character (ImageLabel -> Panel3 Shell)
      ├── Panel4_SkillTree (ImageLabel -> Panel4 Shell)
      └── Panel5_WorldMap (ImageLabel -> Panel5 Shell)
```

### 10.2 Dynamic Luau Population Code Example
```lua
--!strict
-- Dynamic Slot Instantiation inside InventoryController.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemSlotTemplate = ReplicatedStorage.Assets.UI.Panel7_ModularSlotTemplate

local function PopulateInventoryGrid(containerFrame: ScrollingFrame, inventoryData: {any})
    -- Clear existing slots
    for _, child in ipairs(containerFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy()
        end
    end

    -- Dynamically instantiate slot components
    for _, item in ipairs(inventoryData) do
        local slot = ItemSlotTemplate:Clone() :: ImageButton
        slot.Name = "Slot_" .. item.Id
        
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Image = item.IconId
        iconLabel.Size = UDim2.fromScale(0.8, 0.8)
        iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        iconLabel.Position = UDim2.fromScale(0.5, 0.5)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Parent = slot
        
        local quantityLabel = Instance.new("TextLabel")
        quantityLabel.Text = "x" .. item.Quantity
        quantityLabel.Font = Enum.Font.FredokaOne
        quantityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        quantityLabel.TextSize = 14
        quantityLabel.Position = UDim2.new(1, -5, 1, -5)
        quantityLabel.AnchorPoint = Vector2.new(1, 1)
        quantityLabel.Parent = slot
        
        slot.Parent = containerFrame
    end
end
```

---

## 11. AI Generator Reference Prompts

If any panel shell ever needs to be regenerated in Midjourney / Flux / Nano Banana, use these exact prompt formulas:

```text
-- AI Prompt Formula for Background Shells:
A flat 2D vector game UI asset background shell template of [PANEL_NAME] for a Xianxia Roblox game, 16:9 layout. Stylized soft game-like UI panel with a smooth dark slate-blue vector satin background, sharp 90-degree outer corners with zero border radius, perfectly rectangular outer frame for easy cropping, thin gold border line, and elegant gold vector cloud line-art strictly inside the four frame corners, centered in the image with wide pure-black outer padding margins on all four sides. [SPECIFIC_CONTAINER_OUTLINES]. PURE EMPTY SHELL ONLY: zero drawn items, zero text, zero icons. Clean dark canvas ready for dynamic Roblox UI coding. Soft-painted 2D vector UI style, clean solid black margins, ready for easy crop --ar 16:9 --style raw
```