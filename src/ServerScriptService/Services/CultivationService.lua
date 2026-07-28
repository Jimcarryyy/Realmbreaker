--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- 1. Ensure Remotes Folder Exists FIRST
local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder

local ToggleMeditationRemote = Remotes:FindFirstChild("ToggleMeditation") :: RemoteFunction
if not ToggleMeditationRemote then
	ToggleMeditationRemote = Instance.new("RemoteFunction")
	ToggleMeditationRemote.Name = "ToggleMeditation"
	ToggleMeditationRemote.Parent = Remotes
end

local CultivationUpdatedRemote = Remotes:FindFirstChild("CultivationUpdated") :: RemoteEvent
if not CultivationUpdatedRemote then
	CultivationUpdatedRemote = Instance.new("RemoteEvent")
	CultivationUpdatedRemote.Name = "CultivationUpdated"
	CultivationUpdatedRemote.Parent = Remotes
end

local BreakthroughTriggeredRemote = Remotes:FindFirstChild("BreakthroughTriggered") :: RemoteEvent
if not BreakthroughTriggeredRemote then
	BreakthroughTriggeredRemote = Instance.new("RemoteEvent")
	BreakthroughTriggeredRemote.Name = "BreakthroughTriggered"
	BreakthroughTriggeredRemote.Parent = Remotes
end

-- 2. Require Configs & Services
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Configs = Shared:WaitForChild("Configs")
local CultivationData = require(Configs:WaitForChild("CultivationData") :: ModuleScript)

local Services = ServerScriptService:WaitForChild("Services")
local WorldService = require(Services:WaitForChild("WorldService") :: ModuleScript)
local DataService = require(Services:WaitForChild("DataService") :: ModuleScript)

export type PlayerCultivationState = {
	RealmLevel: number,
	MinorStage: number,
	CurrentQi: number,
	MaxQi: number,
	IsMeditating: boolean,
}

local CultivationService = {}
local playerStates: { [Player]: PlayerCultivationState } = {}

function CultivationService.Init()
	print(">>> CULTIVATION SERVICE MODULE LOADED <<<")

	Players.PlayerAdded:Connect(CultivationService._onPlayerAdded)
	Players.PlayerRemoving:Connect(CultivationService._onPlayerRemoving)

	for _, player in Players:GetPlayers() do
		CultivationService._onPlayerAdded(player)
	end
	
	-- Reset Stats Remote for Testing
	local ResetStatsRemote = Remotes:FindFirstChild("ResetStats") :: RemoteEvent
	if not ResetStatsRemote then
		ResetStatsRemote = Instance.new("RemoteEvent")
		ResetStatsRemote.Name = "ResetStats"
		ResetStatsRemote.Parent = Remotes
	end

	ResetStatsRemote.OnServerEvent:Connect(function(player: Player)
		local state = playerStates[player]
		if state then
			state.RealmLevel = 1
			state.MinorStage = 1
			state.CurrentQi = 0
			state.MaxQi = 100

			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.MaxHealth = 100
				player.Character.Humanoid.Health = 100
			end

			DataService.SaveData(player, { RealmLevel = 1, MinorStage = 1, CurrentQi = 0 })
			CultivationUpdatedRemote:FireClient(player, state)
			print(string.format("🔄 [Data Reset] Reset all cultivation stats for %s", player.Name))
		end
	end)

	ToggleMeditationRemote.OnServerInvoke = function(player: Player)
		return CultivationService.ToggleMeditation(player)
	end

	task.spawn(function()
		while true do
			task.wait(CultivationData.BaseMeditationInterval)
			CultivationService._processMeditationTick()
		end
	end)
end

-- Test Remote Setup (Instant Breakthrough Trigger)
local TestBreakthroughRemote = Remotes:FindFirstChild("TestBreakthrough") :: RemoteEvent
if not TestBreakthroughRemote then
	TestBreakthroughRemote = Instance.new("RemoteEvent")
	TestBreakthroughRemote.Name = "TestBreakthrough"
	TestBreakthroughRemote.Parent = Remotes
end

-- Update Test Remote Connection:
TestBreakthroughRemote.OnServerEvent:Connect(function(player: Player)
	local state = playerStates[player]
	-- Only allow test breakthrough if player is meditating
	if state and state.IsMeditating then
		state.CurrentQi = state.MaxQi
		CultivationService._attemptBreakthrough(player, state)
		CultivationUpdatedRemote:FireClient(player, state)
	else
		print(string.format("[CultivationService] %s tried to break through while standing! (Rejected)", player.Name))
	end
end)

-- Exponential Health Calculation Formula (Up to Trillions)
local function calculateMaxHealth(realmLevel: number, minorStage: number): number
	local baseHp = 100
	local realmMultiplier = 10 ^ (realmLevel - 1)
	local orderMultiplier = 1 + ((minorStage - 1) * 0.2)
	return math.floor(baseHp * realmMultiplier * orderMultiplier)
end

function CultivationService._onPlayerAdded(player: Player)
	local savedData = DataService.LoadData(player)
	local realmLvl = savedData and savedData.RealmLevel or 1
	local minorStg = savedData and savedData.MinorStage or 1
	local initialRealm = CultivationData.Realms[realmLvl]

	playerStates[player] = {
		RealmLevel = realmLvl,
		MinorStage = minorStg,
		CurrentQi  = savedData and savedData.CurrentQi or 0,
		MaxQi      = initialRealm and initialRealm.RequiredQi or 100,
		IsMeditating = false,
	}

	-- Apply Dynamic Max Health to Character
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid") :: Humanoid
		local maxHp = calculateMaxHealth(realmLvl, minorStg)
		humanoid.MaxHealth = maxHp
		humanoid.Health = maxHp
	end)

	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		local maxHp = calculateMaxHealth(realmLvl, minorStg)
		humanoid.MaxHealth = maxHp
		humanoid.Health = maxHp
	end

	task.defer(function()
		CultivationUpdatedRemote:FireClient(player, playerStates[player])
	end)
end

function CultivationService._onPlayerRemoving(player: Player)
	local state = playerStates[player]
	if state then
		DataService.SaveData(player, {
			RealmLevel = state.RealmLevel,
			MinorStage = state.MinorStage,
			CurrentQi  = state.CurrentQi,
		})
		playerStates[player] = nil
	end
end

function CultivationService.ToggleMeditation(player: Player): boolean
	local state = playerStates[player]
	if not state then return false end

	state.IsMeditating = not state.IsMeditating
	CultivationUpdatedRemote:FireClient(player, state)

	print(string.format("[CultivationService] %s meditation state: %s", player.Name, tostring(state.IsMeditating)))
	return state.IsMeditating
end

function CultivationService.AddQi(player: Player, amount: number): ()
	local state = playerStates[player]
	if not state then return end

	-- Max realm check: do not add Qi if at Realm 12 Order 9
	if state.RealmLevel >= 12 and state.MinorStage >= 9 then
		state.CurrentQi = state.MaxQi
		CultivationUpdatedRemote:FireClient(player, state)
		return
	end

	-- Add Qi capped at MaxQi
	state.CurrentQi = math.min(state.CurrentQi + amount, state.MaxQi)

	-- Trigger breakthrough if condition is met and meditating
	if state.CurrentQi >= state.MaxQi and state.IsMeditating then
		CultivationService._attemptBreakthrough(player, state)
	end

	-- Notify client HUD of update
	CultivationUpdatedRemote:FireClient(player, state)
end

function CultivationService._processMeditationTick()
	for player, state in playerStates do
		if not state.IsMeditating then continue end
		if not player.Character or not player.Character:FindFirstChild("Humanoid") then continue end

		-- MAX REALM CHECK: Stop accumulating if at Realm 12, Order 9
		if state.RealmLevel >= 12 and state.MinorStage >= 9 then
			state.CurrentQi = state.MaxQi
			CultivationUpdatedRemote:FireClient(player, state)
			continue
		end

		local zoneMultiplier = WorldService.GetPlayerQiMultiplier(player)
		local qiGained = math.floor(CultivationData.BaseQiPerTick * zoneMultiplier)

		state.CurrentQi = math.min(state.CurrentQi + qiGained, state.MaxQi)

		if state.CurrentQi >= state.MaxQi then
			CultivationService._attemptBreakthrough(player, state)
		end

		CultivationUpdatedRemote:FireClient(player, state)
	end
end

function CultivationService._attemptBreakthrough(player: Player, state: PlayerCultivationState)
	if not state.IsMeditating then return end

	-- MAX REALM CHECK: Stop breakthroughs if already at max realm
	if state.RealmLevel >= 12 and state.MinorStage >= 9 then
		state.CurrentQi = state.MaxQi
		return
	end

	local currentRealmData = CultivationData.Realms[state.RealmLevel]
	if not currentRealmData then return end

	local isMajor = false

	if state.MinorStage < currentRealmData.MinorStages then
		state.MinorStage += 1
		state.CurrentQi = 0
	else
		local nextRealmIndex = state.RealmLevel + 1
		local nextRealmData = CultivationData.Realms[nextRealmIndex]

		if nextRealmData then
			state.RealmLevel = nextRealmIndex
			state.MinorStage = 1
			state.CurrentQi = 0
			state.MaxQi = nextRealmData.RequiredQi
			isMajor = true
		end
	end

	-- Update Dynamic Character Max Health
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		local newMaxHp = calculateMaxHealth(state.RealmLevel, state.MinorStage)
		humanoid.MaxHealth = newMaxHp
		humanoid.Health = newMaxHp
	end

	BreakthroughTriggeredRemote:FireAllClients(player, isMajor, state.RealmLevel, state.MinorStage)
end

function CultivationService.SpendQi(player: Player, amount: number): boolean
	local state = playerStates[player]
	if not state then
		return false
	end

	if state.CurrentQi < amount then
		return false
	end

	state.CurrentQi -= amount

	CultivationUpdatedRemote:FireClient(player, state)

	return true
end

function CultivationService.GetPlayerState(player: Player): PlayerCultivationState?
	return playerStates[player]
end

return CultivationService