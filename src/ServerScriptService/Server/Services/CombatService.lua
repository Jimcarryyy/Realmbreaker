--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local CombatRemote = Remotes:FindFirstChild("CombatRemote") :: RemoteEvent?
if not CombatRemote then
	CombatRemote = Instance.new("RemoteEvent")
	CombatRemote.Name = "CombatRemote"
	CombatRemote.Parent = Remotes
end

-- Constants matching Realmbreaker Specs
local BASE_PARRY_WINDOW  = 0.18  -- 0.18s frame-precise parry
local BASE_IFRAME_WINDOW = 0.20  -- 0.20s dodge i-frame
local STAMINA_DODGE_COST = 25    -- 25 Stamina per dodge
local STAGGER_DURATION   = 1.5   -- 1.5s posture break stun
local STAGGER_DAMAGE_MULT= 1.5   -- 1.5x damage during stagger
local POSTURE_REGEN_DELAY= 2.0   -- 2s delay before posture regen
local POSTURE_REGEN_RATE = 35    -- 35 posture/sec
local STAMINA_REGEN_RATE = 40    -- 40 stamina/sec

type CombatState = {
	CurrentPosture: number,
	MaxPosture: number,
	CurrentStamina: number,
	MaxStamina: number,
	ParryEndTime: number,
	IFrameEndTime: number,
	IsBlocking: boolean,
	IsStaggered: boolean,
	StaggerEndTime: number,
	LastDamageTime: number,
}

local CombatStates: { [Player]: CombatState } = {}

local CombatService = {}

-- ============================================================================
-- STATE MANAGEMENT
-- ============================================================================

local function getCombatState(player: Player): CombatState
	if not CombatStates[player] then
		CombatStates[player] = {
			CurrentPosture = 100,
			MaxPosture = 100,
			CurrentStamina = 100,
			MaxStamina = 100,
			ParryEndTime = 0,
			IFrameEndTime = 0,
			IsBlocking = false,
			IsStaggered = false,
			StaggerEndTime = 0,
			LastDamageTime = 0,
		}
	end
	return CombatStates[player]
end

local function syncClientHUD(player: Player)
	local state = getCombatState(player)
	CombatRemote:FireClient(player, "SyncCombatState", {
		CurrentPosture = state.CurrentPosture,
		MaxPosture = state.MaxPosture,
		CurrentStamina = state.CurrentStamina,
		MaxStamina = state.MaxStamina,
		IsStaggered = state.IsStaggered,
	})
end

-- ============================================================================
-- DAMAGE & PARRY VALIDATION ENGINE
-- ============================================================================

function CombatService.ApplyDamage(attacker: Player?, targetChar: Model, baseDamage: number, postureDamage: number): string
	local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
	local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
	if not targetHumanoid or targetHumanoid.Health <= 0 then return "None" end

	local now = os.clock()

	-- If target is a Player, run full CombatEngine checks
	if targetPlayer then
		local state = getCombatState(targetPlayer)

		-- 1. Check I-Frame Dodge (0.20s Invincibility)
		if now <= state.IFrameEndTime then
			print(string.format("[CombatEngine] %s DODGED damage via I-Frames!", targetPlayer.Name))
			return "Dodged"
		end

		-- 2. Check Frame-Precise Parry (0.18s Window)
		if now <= state.ParryEndTime then
			print(string.format("✨ [CombatEngine] PERFECT PARRY by %s!", targetPlayer.Name))
			
			-- Parry FX & Counter sound trigger
			CombatRemote:FireClient(targetPlayer, "ParrySuccess")
			if attacker then
				CombatRemote:FireClient(attacker, "ParriedByTarget")
				-- Inflict Posture damage to the attacker
				CombatService.InflictPostureDamage(attacker, 30)
			end
			return "Parried"
		end

		-- 3. Check Blocking (Holding Guard)
		if state.IsBlocking and not state.IsStaggered then
			print(string.format("[CombatEngine] %s Blocked attack!", targetPlayer.Name))
			state.LastDamageTime = now
			
			-- Block reduces physical damage by 60%, but drains Posture
			local reducedDamage = baseDamage * 0.4
			targetHumanoid:TakeDamage(reducedDamage)
			CombatService.InflictPostureDamage(targetPlayer, postureDamage)
			syncClientHUD(targetPlayer)
			return "Blocked"
		end

		-- 4. Check Stagger State (Takes 1.5x Critical Damage)
		local finalDamage = baseDamage
		if state.IsStaggered then
			finalDamage = baseDamage * STAGGER_DAMAGE_MULT
			print(string.format("💥 [CombatEngine] CRITICAL STAGGER HIT on %s!", targetPlayer.Name))
		end

		state.LastDamageTime = now
		targetHumanoid:TakeDamage(finalDamage)
		syncClientHUD(targetPlayer)
		return "Hit"
	else
		-- Target is an NPC / Dummy
		targetHumanoid:TakeDamage(baseDamage)
		return "Hit"
	end
end

function CombatService.InflictPostureDamage(player: Player, postureAmount: number)
	local state = getCombatState(player)
	if state.IsStaggered then return end

	state.CurrentPosture = math.clamp(state.CurrentPosture - postureAmount, 0, state.MaxPosture)
	state.LastDamageTime = os.clock()

	-- Check Posture Break Stagger
	if state.CurrentPosture <= 0 then
		state.IsStaggered = true
		state.StaggerEndTime = os.clock() + STAGGER_DURATION
		print(string.format("⚠️ [CombatEngine] POSTURE BROKEN! %s is STAGGERED for 1.5s!", player.Name))
		
		-- Disable movement during stagger
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 0 end
		end

		task.delay(STAGGER_DURATION, function()
			state.IsStaggered = false
			state.CurrentPosture = state.MaxPosture
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.WalkSpeed = 16 end
			end
			syncClientHUD(player)
		end)
	end

	syncClientHUD(player)
end

-- ============================================================================
-- INPUT INTENT LISTENERS
-- ============================================================================

local function handleCombatIntent(player: Player, action: string, data: any)
	local state = getCombatState(player)
	local now = os.clock()

	if state.IsStaggered then return end

	if action == "ParryIntent" then
		-- Trigger 0.18s Frame-Precise Parry Window
		state.ParryEndTime = now + BASE_PARRY_WINDOW
		state.IsBlocking = true
		print(string.format("[CombatEngine] %s initiated 0.18s Parry Window", player.Name))

	elseif action == "ReleaseGuard" then
		state.IsBlocking = false

	elseif action == "DodgeIntent" then
		-- Check Stamina Cost (25 Stamina)
		if state.CurrentStamina >= STAMINA_DODGE_COST then
			state.CurrentStamina = state.CurrentStamina - STAMINA_DODGE_COST
			state.IFrameEndTime = now + BASE_IFRAME_WINDOW
			state.LastDamageTime = now
			
			syncClientHUD(player)
			CombatRemote:FireClient(player, "DodgeSuccess")
			print(string.format("[CombatEngine] %s Dodged! (I-Frames Active for 0.20s)", player.Name))
		else
			print(string.format("[CombatEngine] %s - Not enough Stamina to Dodge!", player.Name))
		end
	end
end

-- ============================================================================
-- REGENERATION LOOP (POSTURE & STAMINA)
-- ============================================================================

task.spawn(function()
	while true do
		task.wait(0.2)
		local now = os.clock()

		for player, state in pairs(CombatStates) do
			if state.IsStaggered then continue end

			-- Regenerate Stamina
			if state.CurrentStamina < state.MaxStamina then
				state.CurrentStamina = math.clamp(state.CurrentStamina + (STAMINA_REGEN_RATE * 0.2), 0, state.MaxStamina)
				syncClientHUD(player)
			end

			-- Regenerate Posture after 2.0s delay
			if (now - state.LastDamageTime) >= POSTURE_REGEN_DELAY and state.CurrentPosture < state.MaxPosture then
				state.CurrentPosture = math.clamp(state.CurrentPosture + (POSTURE_REGEN_RATE * 0.2), 0, state.MaxPosture)
				syncClientHUD(player)
			end
		end
	end
end)

function CombatService.Init()
	CombatRemote.OnServerEvent:Connect(function(player: Player, action: string, data: any)
		handleCombatIntent(player, action, data)
	end)

	Players.PlayerRemoving:Connect(function(player)
		CombatStates[player] = nil
	end)

	print(">>> [REALMBREAKER] COMBAT SERVICE INITIALIZED (SERVER AUTHORITATIVE) <<<")
end

CombatService.Init()

return CombatService