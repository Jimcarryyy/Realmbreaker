# Realmbreaker — Cultivation System Specification

> **Document Code:** 03_CULTIVATION.md  
> **Category:** Game Design / Progression Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 02_WORLD.md, 04_COMBAT.md, 09_ECONOMY.md, 24_SAVE_SYSTEM.md

---

## 1. System Purpose & Core Philosophy

In traditional Roblox cultivation games, realm advancement is purely numerical: HP increases by 10x, damage increases by 10x, and gameplay remains identical. 

**Realmbreaker fundamentally rejects this design.**

In **Realmbreaker**, raw stat increases are strictly moderated. Progression is defined by **Mechanical Unlocks**—new spatial movement options, tactical defensive mechanics, elemental interactions, environmental access, and combat stances.

> **Design Axiom:**  
> *"A Foundation Establishment cultivator does not defeat a Qi Condensation cultivator simply because they have 10,000 HP vs 1,000 HP. They win because they possess Air Dashing, Qi Shielding, and superior tactical positioning."*

---

## 2. V1.0 Launch Realms & Mechanical Unlocks

The Early Publish version features four deeply designed realms. Higher realms (Nascent Soul, Soul Formation, Void Refining) are reserved for V1.1+ Live Operations.

* **Realm 0: Mortal Body** (Sub-Stages: Early, Mid, Late, Peak)
  * Primary Unlock: Physical Foundations
  * Mechanics: Basic light/heavy sword combo, stamina-based dodge roll, physical block. No Qi usage.

* **Realm 1: Qi Condensation** (Sub-Stages: Early, Mid, Late, Peak)
  * Primary Unlock: Qi Gauge & Sensing
  * Mechanics: Unlocks Qi Pool, ranged Qi Projectiles, Qi Sensing HUD (locates herbs/veins).

* **Realm 2: Foundation Establishment** (Sub-Stages: Early, Mid, Late, Peak)
  * Primary Unlock: Spatial Mobility & Shielding
  * Mechanics: Unlocks Air Dash / Flash Step, Qi Shielding (extended parry buffer), Alchemy Crafting.

* **Realm 3: Core Formation [V1.0 Cap]** (Sub-Stages: Early, Mid, Late, Peak)
  * Primary Unlock: Flight & Territory Control
  * Mechanics: Unlocks Flight / Hovering, Domain Stance (AOE field buffs), Contested Qi Extraction.

---

## 3. Realm Deep-Dive Specifications

### 3.1 Realm 0: Mortal Body
* **Theme:** Physical martial arts mastery, stamina conservation, grounded combat.
* **Mechanics Unlocked:**
  * **Stamina Gauge:** Replaces Qi. Used for Dodge Rolls (Invulnerability Frames: 0.2s) and Heavy Attacks.
  * **Martial Stances:** Basic Sword Stance or Unarmed Fist Stance.
* **Breakthrough Condition:** Reaching 100% Physical Conditioning (achieved via basic training dummies, physical combat, and basic body-refining herbs). No tribulation required.

### 3.2 Realm 1: Qi Condensation
* **Theme:** Channeling ambient environmental energy into internal Meridian pathways.
* **Mechanics Unlocked:**
  * **Qi Energy Pool:** Unlocks a secondary resource bar (Qi) alongside Health and Stamina.
  * **Qi Blast (Ranged):** Spend 15 Qi to fire a linear projectile breaking enemy stance.
  * **Qi Sense HUD:** Toggling [V] activates aura vision, highlighting nearby gathering nodes and enemy realm levels within a 50-stud radius.
* **Environmental Interaction:** Able to absorb Qi from basic Qi Vein Nodes scattered throughout Zone 1.

### 3.3 Realm 2: Foundation Establishment
* **Theme:** Solidifying volatile Qi into an indestructible pillar, expanding physical spatial limits.
* **Mechanics Unlocked:**
  * **Air Dash / Flash Step [Q in air]:** Instant directional impulse in mid-air (Cooldown: 4s).
  * **Qi Shielding [F]:** Consumes Qi to form a directional barrier that negates projectile damage and widens the active parry window by +0.15s.
  * **Alchemy Crafting Access:** Unlocks the ability to brew tier-2 Breakthrough Elixirs and Combat Buff Potions.
* **World Access:** Resistance to environmental hazards in Zone 2 (Mistveil Forest toxic miasma).

### 3.4 Realm 3: Core Formation (V1.0 Cap)
* **Theme:** Condensing the liquid Foundation into a solid Golden Core. Reaching peak mortal mastery.
* **Mechanics Unlocked:**
  * **Flight & Levitation [Double Jump]:** Flight consumes 5 Qi per second. Enables aerial combat and rapid world traversal over Zone 2 mountains.
  * **Domain Stances [G]:** Deploy an elemental or martial domain field (15-stud radius) that buffs allies (+15% speed) and debuffs enemies (-20% stamina regen) for 12 seconds.
  * **Sect Leadership & Node Extraction:** Ability to claim Contested Qi Arteries for your Sect, generating passive resources for members.

---

## 4. Qi Accumulation & Meditation Mechanics

Players accumulate Qi to progress through sub-stages (Early -> Mid -> Late -> Peak) using three primary methods:

1. ACTIVE MEDITATION: Sit at High-Density Qi Nodes (+200% Rate)
2. ALCHEMY CONSUMABLES: Drink Elixirs / Pills (Instant Qi Boost)
3. COMBAT ABSORPTION: Defeat Spirit Beasts / Compete in PvP

### 4.1 Qi Purity & Density Factors
Total Qi gained per second is calculated using the following formula:

Total_Qi_Gain = Base_Meditation_Rate * Environment_Qi_Density * (1 + Pill_Buff) * Qi_Purity

* **Base Meditation Rate:** 1.0 Qi/sec.
* **Environment Qi Density:** Multiplier based on location (Safe Zone = 1.0x, Deep Forest = 2.5x, Contested Node = 5.0x).
* **Qi Purity (%):** Meditating in impure environments or using low-grade pills reduces purity, slowing down breakthrough success rates until cleansed via purity elixirs or pure spring water.

---

## 5. Breakthrough & Heavenly Tribulation System

Advancing between major realms (e.g., Qi Condensation Peak -> Foundation Establishment Early) requires a Breakthrough Event:

Reach 100% Peak Qi -> Consume Required Pill -> Trigger Event

- [SUCCESS] -> Unlock New Realm & Mechanics
- [FAILURE] -> Meridian Backfire (Qi Loss / Temp Debuff)

### 5.1 Heavenly Tribulation Mini-Game (Skill-Based)
Rather than a random RNG roll determining success, major breakthroughs spawn a Skill-Based Tribulation Event:

1. **Lightning Strikes:** 3 to 5 lightning strikes descend from the sky at accelerating intervals.
2. **Defensive Reaction:** The player must actively time their Parry [F] or Air Dash [Q] to deflect or dodge each bolt.
3. **Success Threshold:**
   * Deflecting 100% bolts = Flawless Breakthrough (+5% permanent Qi pool bonus).
   * Passing majority = Standard Breakthrough.
   * Failing majority = Meridian Backfire.

### 5.2 Failure Penalty & Safety Mechanics
* **Meridian Backfire:** Failure drains 30% of current realm sub-stage Qi and applies a 10-minute "Damaged Meridians" debuff (-20% movement speed).
* **Protection Pills (Monetization & Crafting Hook):** 
  * Craftable via high-tier Alchemy or purchasable via Robux/Sect Shop.
  * Consuming a Heart Protection Pill prevents Qi loss and debuffs upon breakthrough failure.

---

## 6. System Interconnections

* **Connections to 04_COMBAT.md:** Realm unlocks stances, movement skills (Air Dash, Flight), and Qi gauge capacity.
* **Connections to 02_WORLD.md:** High-tier Qi zones and hazardous areas require specific realm milestones to survive.
* **Connections to 09_ECONOMY.md:** Alchemy pill market drives trade value curves for breakthrough materials.

---

## 7. Technical Data Schemas

The cultivation state is stored on the server via ProfileService to prevent client-side manipulation:

- RealmTier: Number (0 = Mortal Body, 1 = Qi Condensation, 2 = Foundation, 3 = Core Formation)
- SubStage: Number (0 = Early, 1 = Mid, 2 = Late, 3 = Peak)
- CurrentQi: Float
- MaxQi: Float
- QiPurity: Float (0.50 to 1.00)
- UnlockedMechanics: Dictionary (QiGauge, AirDash, QiShield, Flight, DomainStance)
- BreakthroughHistory: Dictionary (FlawlessAttempts, FailedAttempts)

---

```markdown
## Overhead Displays & Onboarding Sequence

### 1. 3D Overhead World Display (`OverheadBillboardGui`)
Cultivation status renders in 3D space attached to `Character.Head`:
* Display Name & Sect Tag: `[Jade Cloud Sect] Aethelgard`
* Realm Title Glow: `[Qi Condensation - Stage 4]` (Cyan / Gold / Purple glow)
* Mini Combat Vitals: Fades in during combat; fades out 5s after exiting combat. (`MaxDistance = 80 studs`).

### 2. New Player Tutorial Onboarding (`[Quest: First Steps]`)
1. **Wake Up:** Banner (`92283672177848`) prompts `[PRESS C TO INSPECT REALM]`.
2. **Elder Lin:** Interact using **`DialogueFrame`** (`79576725327950`).
3. **Gathering:** Activate `[V] Qi Sense` (`128617837655590`) to locate 3 *Spirit Herbs*.
4. **Refining:** Use **`Panel1 AlchemyPanel`** (`84276737641585`) at the Cauldron to refine a *Qi Gathering Pill*.
5. **Breakthrough:** Consume the pill, Meditate to achieve **Qi Condensation Stage 1**, and test active skills against a Training Dummy using `[1] Flowing Water Slash`.
5️⃣ File: docs/Game Design/07_PVE.md
Path: docs/Game Design/07_PVE.md
📍 Action:
Open 07_PVE.md. Do NOT touch Section 6 (## 6. System Interconnections) or existing threat tables. Simply update or append under ## Target Health Bar Architecture:
code
Markdown
## Target Health Bar Architecture

### 1. Generic Mobs & Wild Beasts
* Rendered via a 3D Overhead `BillboardGui` floating directly above the mob's head (`MaxDistance = 60 studs`).
* Displays compact HP & Posture tracks. Fades out when out of combat aggro range.

### 2. Major & Sect Bosses (*Shadow Beast*)
* Triggers a widescreen top-center overlay using **`BossHealthBarShell`** (`rbxassetid://134065637826617`).
* Features dual-track gauges: **Boss Health** (Red) + **Posture Stun Rail** (Gold).
* Displays phase notch dividers (Phase 1, Phase 2, Phase 3).
* Top navigation banner (`rbxassetid://122415586898423`) slides up out of view during boss encounters.

> **Document Revision History**  
> *v1.0.0* — Document expanded for V1.0 Early Publish standard by Lead Systems Designer.