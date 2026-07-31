# 🎨 Realmbreaker — UI/UX Specification & Layout Architecture

> **Master UI Specification** | Roblox Action Xianxia MMORPG  
> **Style Standard:** Modern, Soft, Clean Glassmorphism & Spirit Jade Aesthetics  
> **Target Audience:** All-Ages (Accessible, Intuitive, Clutter-Free)

---

## 📜 Table of Contents
1. [Visual Style & Design Tokens](#1-visual-style--design-tokens)
2. [Dynamic UI & Slicing Architecture](#2-dynamic-ui--slicing-architecture)
3. [In-World Overhead Status (BillboardGui)](#3-in-world-overhead-status-billboardgui)
4. [In-Game Screen HUD Layout](#4-in-game-screen-hud-layout)
5. [Center Navigation Modals](#5-center-navigation-modals)
6. [Roblox Studio Implementation Standard](#6-roblox-studio-implementation-standard)

---

## 1. Visual Style & Design Tokens

Realmbreaker combines **Frosted Obsidian Slate Glass** containers with **Spirit Jade Cloud Filigree Corners** (`#4AE3B5`) and **Imperial Gold Accents** (`#FFD700`). This bridges high-end Xianxia identity with modern Roblox standards.

### 🎨 Color Palette Tokens

| Token Name | Hex Code | Visual Use Case | Roblox Color3 |
| :--- | :--- | :--- | :--- |
| **Frosted Obsidian** | `#0D1117` | Main Panel Glass Backdrop (50–60% Opacity) | `Color3.fromRGB(13, 17, 23)` |
| **Spirit Jade** | `#4AE3B5` | Filigree corners, Health fills, Scrollbar handles | `Color3.fromRGB(74, 227, 181)` |
| **Imperial Gold** | `#FFD700` | Realm badges, rare borders, breakthrough highlights | `Color3.fromRGB(255, 215, 0)` |
| **Cyan Qi Energy** | `#38BDF8` | Spirit Qi bar fill, mana costs, realm progress | `Color3.fromRGB(56, 189, 248)` |
| **Amber Stamina** | `#F97316` | Stamina bar fill, dash/dodge indicators | `Color3.fromRGB(249, 115, 22)` |
| **Crimson Posture** | `#EF4444` | Posture poise bar fill, low health warnings | `Color3.fromRGB(239, 68, 68)` |

### 🔤 Typography Hierarchy

* **Headers & Realm Titles:** `Enum.Font.FredokaOne` (Soft, bold, engaging, highly readable on all screen sizes).
* **HUD Numbers & Stat Specs:** `Enum.Font.GothamBold` / `Enum.Font.GothamSSm` (Crisp legibility with 1.5px drop shadows).
* **Body / Descriptions:** `Enum.Font.GothamMedium` (Clean sans-serif text).

---

## 2. Dynamic UI & Slicing Architecture

> [!IMPORTANT]
> To ensure seamless Luau runtime execution, **all 2D background image assets are static templates**. Dynamic elements (item slots, scrollbars, health fills, button text) are rendered programmatically in Roblox Studio.

> [ 2D Asset Background Template ] ──┐  
>                                    ├──> Integrated at Runtime by Luau Engine  
> [ Dynamic Luau Script Instances ] ──┘  

1. **Hollow Track Grooves:** Status gauge tracks (Health, Stamina, Qi, Posture) and progress bars are hollow, dark empty grooves. Luau code dynamically animates inner fill `Frame` objects using `TweenService` with `ClipsDescendants = true`.
2. **Clean Canvas Panes:** Grid containers and scrolling canvas areas are kept as pure open dark glass panes. Luau populates item slots at runtime via `UIGridLayout` / `UIListLayout`.
3. **Native Scrolling Channels:** Canvas panes preserve a clean right margin (`20px`) allowing Roblox's native `ScrollingFrame` scrollbar handles to operate without visual overlap.
4. **Blank Container Slots:** Skill slots and navigation pills are generated as empty background frames. Keybind text badges (`[1]`, `[Q]`, `[F]`) and skill icons are mounted dynamically via `TextLabel` and `ImageLabel`.

---

## 3. In-World Overhead Status (`BillboardGui`)

Every character (Player and NPC) displays a floating `BillboardGui` anchored to `HumanoidRootPart` / `Head` with a `3.2` studs vertical offset (`220px x 65px` proportional scaling).

>           ┌──────────────────────────────────────────┐          
>           │  ✨ [ Core Formation - Early Stage ] ✨   │  <-- Realm Title Badge
>           ├──────────────────────────────────────────┤          
>           │             Cultivator Name              │  <-- Player Name text
>           │     ┌──────────────────────────────┐     │          
>           │  HP │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 302 │  <-- Hollow Track
>           │     └──────────────────────────────┘     │          
>           │  PO │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 100 │  <-- Hollow Track
>           └──────────────────────────────────────────┘          

* **Realm Title Badge:** Rounded Imperial Gold pill badge displaying current breakthrough stage (`Mortal Body`, `Qi Condensation`, `Foundation Establishment`, `Core Formation`).
* **Nameplate:** Clean sans-serif name rendering with 1.5px black contrast outline.
* **Dual Gauges:** Two hollow track grooves where Luau updates Health and Posture poise in real time.

---

## 4. In-Game Screen HUD Layout

> ┌────────────────────────────────────────────────────────────────────────────────────────┐  
> │                                                         In-World Overhead Status       │  
> │                                                       ┌────────────────────────┐       │  
> │                                                       │ ✨ [ Core Formation ]  │       │  
> │                                                       │    Player Nameplate    │       │  
> │                                                       │ [░░░░░░░░░░░░░░░░░░]   │       │  
> │                                                       └────────────────────────┘       │  
> │                                                                        TopRightNav     │  
> │                                                                   ┌──────────────────┐ │  
> │                                                                   │ ≡  👤 🎒 ⚔️ 🗺️ ⚙️│ │  
> │                                                                   └──────────────────┘ │  
> │                                                                                        │  
> │                                       [AVATAR]                                         │  
> │                                                                                        │  
> │                                                                                        │  
> ├────────────────────────────────────────────────────────────────────────────────────────┤  
> │  VitalityCluster (20px Padding)              Hotbar (15px Bottom Offset)               │  
> │  ┌─────────────────────────────┐   ┌────────────────────────────────────────────────┐  │  
> │  │ 🟢 HP  [░░░░░░░░░░░░░░░░░] │   │ [1]    [2]    [Q]    [E]    [F]    [V]        │  │  
> │  │ ⚡ ST  [░░░░░░░░░░░░░░░░░] │   │ ┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐  ┌───┐     │  │  
> │  │ 💧 QI  [░░░░░░░░░░░░░░░░░] │   │ │   │  │   │  │   │  │   │  │   │  │   │     │  │  
> │  └─────────────────────────────┘   └────────────────────────────────────────────────┘  │  
> │          (240px x 110px)                            (340px x 60px)                     │  
> └────────────────────────────────────────────────────────────────────────────────────────┘  

### HUD Component Breakdown

#### A. Vitality Stack (`VitalityCluster`)
* **Placement:** Bottom-Left corner with `20px` edge padding (`240px x 110px`).
* **Container:** Dark obsidian glass card with Spirit Jade cloud filigree corners (`UICorner: 12px`).
* **Tracks:** 3 stacked hollow gauge grooves:
  * **Health (HP):** Dynamic Green fill (`#10B981`)
  * **Stamina (ST):** Dynamic Amber fill (`#F97316`)
  * **Spirit Qi (QI):** Dynamic Cyan fill (`#38BDF8`)

#### B. Action Hotbar (`HotbarCluster`)
* **Placement:** Bottom-Center, floating `15px` above bottom screen edge (`340px x 60px`).
* **Container:** Dark glass horizontal ribbon with Spirit Jade corner flourishes.
* **Slots:** 6 empty square slot container frames (`[1]`, `[2]`, `[Q]`, `[E]`, `[F]` Parry, `[V]` Qi Sense). Keybind pill badges and skill icons are mounted dynamically.

#### C. Navigation Bar (`TopRightNav`)
* **Placement:** Top-Right corner with `20px` edge padding (`220px x 40px`).
* **Container:** Horizontal glass pill holding 6 circular icon button frames for modal toggles.

---

## 5. Center Navigation Modals

When a player opens a menu hotkey (`[C]`, `[I]`, `[K]`, `[L]`, `[M]`, `[O]`), the master modal window displays centered on screen (`920px x 520px`, `AspectRatio: 1.778`).

> ┌────────────────────────────────────────────────────────────────────────────────────────┐  
> │                        MAIN NAVIGATION & CENTER MODALS (920px x 520px)                  │  
> │ ┌───────────────────────┬───────────────────────────────────────────┬────────────────┐ │  
> │ │                       │  [ All ]  [ Weapons ]  [ Pills ]  [ Mats ]│                │ │  
> │ │                       ├───────────────────────────────────────────┤                │ │  
> │ │                       │                                         ▲ │                │ │  
> │ │     PAPERDOLL 3D      │                                         █ │  ITEM PREVIEW  │ │  
> │ │    AVATAR VIEWPORT    │               ITEM GRID                 █ │     FRAME      │ │  
> │ │                       │            SCROLLING CANVAS             █ │                │ │  
> │ │                       │                                         █ ├────────────────┤ │  
> │ │                       │                                         █ │ DESCRIPTION    │ │  
> │ │                       │                                         ▼ │ TEXT BOX       │ │  
> │ │     ┌───────────┐     │                                           ├────────────────┤ │  
> │ │     │ JADE BASE │     │                                           │ [EQUIP]  [USE] │ │  
> │ └─────┴───────────┴─────┴───────────────────────────────────────────┴────────────────┘ │  
> └────────────────────────────────────────────────────────────────────────────────────────┘  

### 3-Pane Modular Layout Breakdown

1. **Left Pane (Paperdoll Viewport — 280px):** Holds a 3D character avatar viewport positioned above a 2D Spirit Jade circular pedestal artwork.
2. **Center Pane (Main Canvas — 460px):**
   * Top horizontal filter tab bar frame (`All`, `Weapons`, `Pills`, `Materials`).
   * Large open dark scrolling canvas populated dynamically via `UIGridLayout`.
   * Native scrollbar track on right edge styled with a Spirit Jade handle (`#4AE3B5`).
3. **Right Pane (Item Inspector — 180px):**
   * Top square item icon preview frame.
   * Middle detail text box container.
   * Dual bottom action button containers (`Equip` / `Use`, `Discard`).

---

## 6. Roblox Studio Implementation Standard

1. **Responsive Scale Constraints:**
   * All screen UI elements use relative `Scale` positioning (`Size` and `Position`) paired with `UIAspectRatioConstraint` and `UISizeConstraint` to ensure seamless scaling across Mobile, Tablet, PC, and Console.
2. **Interactive Motion Polish:**
   * All interactive buttons utilize scale-bounce spring animations (`1.0x` baseline -> `1.05x` Hover -> `0.95x` Click) via `TweenService`.
3. **Zero Asset Loading Flicker:**
   * All UI textures, background frames, and icon assets are preloaded during the initial game loading screen using `ContentProvider:PreloadAsync()`.