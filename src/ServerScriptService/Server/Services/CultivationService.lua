--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- 1. Ensure Remotes Folder Exists
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

-- 2. Require Configs & Services from updated directories
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local RealmsConfig = require(Config:WaitForChild("RealmsConfig") :: ModuleScript)

local Services = ServerScriptService:WaitForChild("Server"):WaitForChild("Services")
local WorldService = require(Services:WaitForChild("WorldService") :: ModuleScript)
local SaveService = require(Services:WaitForChild("SaveService") :: ModuleScript)

export type PlayerCultivationState = {
	RealmLevel: number,
	MinorStage: number,
	CurrentQi: number,
	MaxQi: number,
	IsMeditating: boolean,
}

local CultivationService = {}
local playerStates: { [Player]: PlayerCultivationState } = {}

-- Grounded Health Calculation Formula (Max 370 HP at Realm 4)
local function calculateMaxHealth(realmLevel: number, minorStage: number): number
	local realmData = RealmsConfig.Realms[realmLevel]
	local baseHp = realmData and realmData.BaseMaxHp or 100
	return baseHp + ((minorStage - 1) * 15)
end

local function syncToProfile(player: Player)
	local state = playerStates[player]
	if not state then return end
	local data = SaveService.LoadData(player)
	if data and data.Cultivation then
		data.Cultivation.RealmTier = state.RealmLevel - 1
		data.Cultivation.SubStage = state.MinorStage - 1
		data.Cultivation.CurrentQi = state.CurrentQi
		
		-- ADD: Automatically replicate the updated Cultivation stats to the client
		SaveService.UpdateReplica(player, {"Cultivation"}, data.Cultivation)
	end
end

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

			syncToProfile(player) -- CHANGED
			CultivationUpdatedRemote:FireClient(player, state)
			print(string.format("🔄 [Data Reset] Reset stats for %s", player.Name))
		end
	end)

	ToggleMeditationRemote.OnServerInvoke = function(player: Player)
		return CultivationService.ToggleMeditation(player)
	end

	task.spawn(function()
		while true do
			task.wait(RealmsConfig.BaseMeditationInterval)
			CultivationService._processMeditationTick()
		end
	end)
end

function CultivationService._onPlayerAdded(player: Player)
	local savedData = SaveService.LoadData(player)
	local cultivation = savedData and savedData.Cultivation
	
	local realmLvl = cultivation and (cultivation.RealmTier + 1) or 1
	local minorStg = cultivation and (cultivation.SubStage + 1) or 1
	local initialRealm = RealmsConfig.Realms[realmLvl]

	playerStates[player] = {
		RealmLevel = realmLvl,
		MinorStage = minorStg,
		CurrentQi = cultivation and cultivation.CurrentQi or 0,
		MaxQi = initialRealm and initialRealm.RequiredQi or 100,
		IsMeditating = false,
	}

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
	syncToProfile(player)
	playerStates[player] = nil
end

function CultivationService.ToggleMeditation(player: Player): boolean
	local state = playerStates[player]
	if not state then return false end

	state.IsMeditating = not state.IsMeditating
	CultivationUpdatedRemote:FireClient(player, state)
	return state.IsMeditating
end

function CultivationService.AddQi(player: Player, amount: number): ()
	local state = playerStates[player]
	if not state then return end

	if state.RealmLevel >= 4 and state.MinorStage >= 4 then
		state.CurrentQi = state.MaxQi
		CultivationUpdatedRemote:FireClient(player, state)
		return
	end

	state.CurrentQi = math.min(state.CurrentQi + amount, state.MaxQi)

	if state.CurrentQi >= state.MaxQi and state.IsMeditating then
		CultivationService._attemptBreakthrough(player, state)
	end

    syncToProfile(player)
	CultivationUpdatedRemote:FireClient(player, state)
end

function CultivationService._processMeditationTick()
	for player, state in playerStates do
		if not state.IsMeditating then continue end
		if not player.Character or not player.Character:FindFirstChild("Humanoid") then continue end

		if state.RealmLevel >= 4 and state.MinorStage >= 4 then
			state.CurrentQi = state.MaxQi
			CultivationUpdatedRemote:FireClient(player, state)
			continue
		end

		local zoneMultiplier = WorldService.GetPlayerQiMultiplier(player)
		local qiGained = math.floor(RealmsConfig.BaseQiPerTick * zoneMultiplier)

		state.CurrentQi = math.min(state.CurrentQi + qiGained, state.MaxQi)

		if state.CurrentQi >= state.MaxQi then
			CultivationService._attemptBreakthrough(player, state)
		end

		syncToProfile(player)
		CultivationUpdatedRemote:FireClient(player, state)
	end
end

function CultivationService._attemptBreakthrough(player: Player, state: PlayerCultivationState)
	if not state.IsMeditating then return end

	if state.RealmLevel >= 4 and state.MinorStage >= 4 then
		state.CurrentQi = state.MaxQi
		return
	end

	local currentRealmData = RealmsConfig.Realms[state.RealmLevel]
	if not currentRealmData then return end

	local isMajor = false

	if state.MinorStage < currentRealmData.MinorStages then
		state.MinorStage += 1
		state.CurrentQi = 0
	else
		local nextRealmIndex = state.RealmLevel + 1
		local nextRealmData = RealmsConfig.Realms[nextRealmIndex]

		if nextRealmData then
			state.RealmLevel = nextRealmIndex
			state.MinorStage = 1
			state.CurrentQi = 0
			state.MaxQi = nextRealmData.RequiredQi
			isMajor = true
		end
	end

	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		local newMaxHp = calculateMaxHealth(state.RealmLevel, state.MinorStage)
		humanoid.MaxHealth = newMaxHp
		humanoid.Health = newMaxHp
	end
    syncToProfile(player)
	BreakthroughTriggeredRemote:FireAllClients(player, isMajor, state.RealmLevel, state.MinorStage)
end

function CultivationService.SpendQi(player: Player, amount: number): boolean
	local state = playerStates[player]
	if not state or state.CurrentQi < amount then
		return false
	end

	state.CurrentQi -= amount
	syncToProfile(player)
	CultivationUpdatedRemote:FireClient(player, state)
	return true
end

function CultivationService.GetPlayerState(player: Player): PlayerCultivationState?
	return playerStates[player]
end

return CultivationService