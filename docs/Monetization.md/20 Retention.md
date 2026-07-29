# Realmbreaker — Retention Engine & Lifecycle Specification

> **Document Code:** 20_RETENTION.md  
> **Category:** Monetization & Live Operations / Retention Architecture  
> **Status:** Active Standard — Version 1.0 (Early Publish Baseline)  
> **Dependencies:** 00_PROJECT_OVERVIEW.md, 03_CULTIVATION.md, 05_PROGRESSION.md, 17_MONETIZATION.md, 33_PLAYER_PSYCHOLOGY.md

---

## 1. Executive Summary & Retention Philosophy

In **Realmbreaker**, long-term player retention is built around the psychological **Hook Model** (Trigger -> Action -> Variable Reward -> Investment).

Unlike traditional Roblox clicker games that rely on infinite passive grinding (which causes sharp player churn after Day 3), **Realmbreaker** anchors player retention to **Meaningful Mechanical Milestones**, **Social Sect Reciprocity**, and **Scheduled World Events**.

> **Retention Axiom:**  
> *"A player returns tomorrow not because they want a bigger arbitrary number, but because they are 200 Qi away from unlocking Air Dashing, their Sect needs them to defend a Qi Artery at 8 PM, and their offline meditation pool is full."*

---

## 2. Target Retention KPIs & Funnel Architecture

For V1.0 Early Publish, retention mechanics are engineered to hit the following target conversion milestones:

```
+-----------------------------------------------------------------------+
|                       PLAYER RETENTION FUNNEL                         |
+-----------------------------------------------------------------------+
|  DAY 0 (Onboarding)  : >35% Retention (First Breakthrough in 15 mins) |
|  DAY 1 (Habit Stage) : >25% Retention (Offline Meditate & Daily Tasks)|
|  DAY 7 (Social Stage): >12% Retention (Dungeon Clears & Sect PvP)     |
|  DAY 30 (Mastery)    : >5% Retention (Core Formation & Market Empire) |
+-----------------------------------------------------------------------+
```

---

## 3. The 4-Stage Player Lifecycle Blueprint

### 3.1 Stage 1: Day 0 — The First 15 Minutes (Onboarding Hook)
* **Goal:** Deliver an immediate "Aha!" moment and reach **Qi Condensation (Realm 1)**.
* **Mechanic:** Fast-tracked initial breakthrough sequence. Within 15 minutes, the player learns M1/Parry controls, collects their first herb, and experiences the visual brilliance of unlocking the Qi Gauge and Qi Sensing HUD [V].
* **Retention Friction Prevention:** No long, unskippable wall-of-text dialogues; tutorial is 100% action-driven.

### 3.2 Stage 2: Day 1 to Day 3 — Habit Formation
* **Goal:** Establish a predictable daily play rhythm.
* **Mechanic:** **Resting Qi / Offline Meditation**. Players accumulate 25% Qi while offline (capped at 12 hours of offline storage; 24 hours for VIP Pass holders).
* **Return Trigger:** Logging in immediately awards accumulated offline Qi, granting a satisfying burst of progress at the start of every session.

### 3.3 Stage 3: Day 7 — Social & Competitive Lock-In
* **Goal:** Embed the player within a social community (Sect) and group activities.
* **Mechanic:** **Contested Qi Arteries & Dungeon Parties**. Players join Sects to run `Ancient Sword Mystic Realm` (Dungeon 1) and participate in scheduled 30-minute Qi Artery wars in Zone 2.
* **Social Reciprocity:** Higher-realm disciples who help lower-realm disciples clear dungeons receive **Sect Mentor Tokens** redeemable for cosmetic titles.

### 3.4 Stage 4: Day 30+ — Mastery, Prestige & Economy
* **Goal:** Drive long-term endgame investment.
* **Mechanic:** Reaching **Core Formation (Realm 3 - V1.0 Cap)**, unlocking Flight, mastering alchemy crafting market chains, and competing on Sect Leaderboards.

---

## 4. Daily & Weekly Loop Architecture

To maintain high Average Revenue Per User (ARPU) and steady Daily Active Users (DAU):

```
+-----------------------------------------------------------------------+
|                       DAILY & WEEKLY ENGAGEMENT                       |
+-----------------------------------------------------------------------+
|  DAILY TRIBUTES   : 3 Short Quests (10-15 min play session)          |
|  HOURLY SPONSORS  : Contested Qi Node Spawns in Zone 2                |
|  WEEKLY SECTS     : Sect Leaderboard Rewards & Token Distributions    |
+-----------------------------------------------------------------------+
```

### 4.1 Daily Sect Tributes (Daily Quests)
Every 24 hours, players receive 3 quick daily tasks (e.g., *Harvest 5 herbs*, *Execute 3 perfect parries*, *Meditate at a Spirit Spring*):
* **Completion Time:** 10 – 15 minutes.
* **Rewards:** Daily Spirit Stones, Alchemy Pills, and a **Streak Multiplier** (completing 7 days in a row awards a free Heart Protection Pill).

### 4.2 Scheduled Contested Qi Events
* Every hour, a **Major Qi Artery** activates in the Zone 2 Ancient Caverns.
* The event is broadcast server-wide, drawing active players into open-world PvP for 15 minutes of 5.0x Qi meditation rate.

---

## 5. Session Length Optimization & Anti-Burnout

To build a healthy, long-term player base without causing session fatigue:

1. **Focused High-Yield Sessions:** Active meditation at high-density nodes is **5x faster** than idle meditation. This encourages players to log in for intense 30- to 60-minute active sessions rather than leaving their devices running overnight.
2. **Breakthrough Safeguard (Pity Stacking):** If a player fails a skill-based Heavenly Tribulation breakthrough, they receive a stacking **+10% success buffer** on their next attempt. This eliminates rage-quitting caused by unrewarding progress wipes.

---

## 6. External Triggers & Notification Loop

To re-engage churned or offline players ethically:

* **Roblox Platform Notifications:** Sent when offline meditation storage hits maximum capacity (12 hrs / 24 hrs).
* **Discord Community Webhooks:** Automated alerts sent to the official Discord server when Zone 2 World Bosses spawn or weekly Sect Leaderboards reset.

---

## 7. System Interconnections

* **Connections to 03_CULTIVATION.md:** Offline meditation and sub-stage Qi scaling form the core daily return trigger.
* **Connections to 05_PROGRESSION.md:** Maps the 0 to 50+ hour milestone timeline across the player lifecycle.
* **Connections to 17_MONETIZATION.md:** VIP Sect Passes extend offline meditation storage from 12 to 24 hours.
* **Connections to 33_PLAYER_PSYCHOLOGY.md:** Implements habit loops, social reciprocity, and anti-ragequit safety nets.

---

> **Document Revision History**  
> *v1.0.0* — Retention engine and player lifecycle specifications approved by Lead Live Operations Planner.