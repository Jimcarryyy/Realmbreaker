# Realmbreaker — Combat System Specification

> **Document Code:** 04_COMBAT.md  
> **Category:** Game Design / Combat & Systems Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 03_CULTIVATION.md, 23_NETWORK_ARCHITECTURE.md, 28_BALANCING_PHILOSOPHY.md

---

## 1. Executive Summary & Philosophy

In **Realmbreaker**, combat is designed to be visceral, responsive, and skill-driven. Raw cultivation stats provide advantages in utility, health pool, and mechanical abilities, but **timing, posture control, stance switching, and spatial awareness dictate victory**.

> **Design Axiom:**  
> *"Stats grant options; skill grants victory. A skilled Realm 1 Qi Condensation cultivator who perfectly reads animation telegraphs can defeat an arrogant Realm 2 cultivator."*

---

## 2. Core Mechanics & Control Specs

Combat relies on a deterministic frame-data model combining light combos, heavy guard breaks, active parries, directional dodges, and posture meters.

### 2.1 Basic Offensive Actions

* **Light Attack Chain (M1):**
  * 4-hit string with distinct animation telegraphs.
  * Hits 1-3 deal light damage and soft flinch.
  * Hit 4 (Combo Finisher) deals heavy knockback and 0.5s stun.
  * Can be canceled into Dodge [Q] before frame active window ends.

* **Heavy Attack / Guard Break (M2):**
  * Windup Time: 0.45 seconds.
  * Consumes 20 Stamina.
  * Cannot be blocked by basic Guard. Forces Guard Break if hit while blocking.
  * Fully parryable by precise timing.

### 2.2 Defensive Actions & Frame Data

* **Block / Guard [Hold F]:**
  * Reduces incoming physical/Qi damage by 70%.
  * Consumes Posture (Stamina) per blocked hit.
  * Vulnerable to M2 Guard Breaks.

* **Parry [Tap F]:**
  * Base Parry Window: 0.18 seconds (11 frames at 60 FPS).
  * Cooldown on Miss: 1.0 second (prevents parry spamming).
  * **Perfect Parry Success:** Completely negates damage, staggers attacker for 1.2s, refunds 100% stamina, and fills 15% Qi gauge.

* **Dodge Roll / Flash Step [Q + Direction]:**
  * Invulnerability Frames (I-Frames): 0.20 seconds.
  * Stamina Cost: 25.
  * Unlocks aerial Flash Step variant at Realm 2 (Foundation Establishment).

---

## 3. Posture & Poise System

Both players and enemies possess a **Posture Meter** alongside their Health Bar:

Total_Posture = Base_Posture + (Realm_Tier * 25)

* **Posture Depletion:** Blocking attacks, receiving heavy strikes, or getting hit by Qi Blasts reduces Posture.
* **Posture Break State:** When Posture reaches zero, the character enters **Posture Break** for 1.5 seconds.
  * During Posture Break, all damage taken is multiplied by 1.5x.
  * Dodging and blocking are completely disabled.

---

## 4. Launch Martial Disciplines (V1.0 Scope)

V1.0 launches with two distinct, deeply balanced martial disciplines:

### 4.1 Flowing Water Sword Stance
* **Archetype:** Defensive Counter / Precision Striker.
* **Passive Trait - Riposte:** Successful parries instantly empower the next M1 attack into an unblockable thrust.
* **Skill 1 - Tidal Sweep:** 360-degree sword slash that deflects light projectiles and sweeps enemy legs.
* **Skill 2 - Flowing Step:** Forward dash thrust that bypasses enemy armor.

### 4.2 Thunder-Palm Unarmed Stance
* **Archetype:** High Pressure / Posture Breaker.
* **Passive Trait - Overload:** Landing 3 consecutive palm strikes electrifies the target, disabling their dodge roll for 1.5 seconds.
* **Skill 1 - Thunder Palm Thrust:** Rapid forward palm strike dealing massive Posture damage to blocking targets.
* **Skill 2 - Shockwave Stomp:** AoE ground slam that launches nearby enemies into air combo height.

---

## 5. Integration of Cultivation Unlocks in Combat

As players advance their Realm in 03_CULTIVATION.md, combat fundamentally evolves:

* **Realm 0 (Mortal Body):** Pure physical M1/M2/Parry combat. Relies entirely on Stamina management.
* **Realm 1 (Qi Condensation):** Ranged Qi Blast introduced. Allows pressuring opponents from distance to stop stamina recovery.
* **Realm 2 (Foundation Establishment):** Unlocks Air Dash and Qi Shielding (extends parry window from 0.18s to 0.33s).
* **Realm 3 (Core Formation):** Unlocks Flight aerial combat and Domain Stances (15-stud AoE aura buff/debuff).

---

## 6. Technical Hit Registration & Server Validation

To ensure competitive integrity, prevent exploits, and eliminate ghost hits across Roblox clients:

1. **Client-Side Prediction:**
   * The client immediately plays swing animations, sound effects, and particle trails upon input.

2. **Server-Side Validation:**
   * Spatial Raycasting / Shapecasting is calculated exclusively on the server.
   * Server verifies attacker position, target position, player latency (ping buffer up to 150ms), and active invulnerability frames before applying damage.

3. **Anti-Exploit Safeguards:**
   * Attack frequency is validated against server timestamp tables.
   * Speed-hacking or frame-skipping attempts automatically trigger attack invalidation and log exploit alerts.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Realm progression dictates available combat mechanics, parry window buffers, and stamina/Qi limits.
* **Connections to 08_UI_UX.md:** Combat requires clean visual feedback for Posture bars, Parry flash indicators, and Stance cooldown icons.
* **Connections to 23_NETWORK_ARCHITECTURE.md:** Server-side hit validation relies on strict network replication rules.

---

> **Document Revision History**  
> *v1.0.0* — Initial combat engine specification approved by Lead Systems Designer.