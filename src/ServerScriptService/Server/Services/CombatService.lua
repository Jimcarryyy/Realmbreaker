--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local StancesConfig = require(Config:WaitForChild("StancesConfig") :: ModuleScript)

local Services = ServerScriptService:WaitForChild("Server"):WaitForChild("Services")
local CultivationService = require(Services:WaitForChild("CultivationService") :: ModuleScript)

local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder

local CastSkillRemote = Remotes:FindFirstChild("CastSkill") :: RemoteEvent
if not CastSkillRemote then
	CastSkillRemote = Instance.new("RemoteEvent")
	CastSkillRemote.Name = "CastSkill"
	CastSkillRemote.Parent = Remotes
end

local SkillExecutedRemote = Remotes:FindFirstChild("SkillExecuted") :: RemoteEvent
if not SkillExecutedRemote then
	SkillExecutedRemote = Instance.new("RemoteEvent")
	SkillExecutedRemote.Name = "SkillExecuted"
	SkillExecutedRemote.Parent = Remotes
end

type CooldownTable = { [string]: number }

local CombatService = {}
local playerCooldowns: { [Player]: CooldownTable } = {}

function CombatService.Init()
	print(">>> COMBAT SERVICE MODULE LOADED <<<")

	CastSkillRemote.OnServerEvent:Connect(function(player: Player, skillId: string)
		CombatService.CastSkill(player, skillId)
	end)
end

local function isOnCooldown(player: Player, skillId: string, cooldown: number): boolean
	local playerTable = playerCooldowns[player]
	if not playerTable then
		playerTable = {}
		playerCooldowns[player] = playerTable
	end

	local lastCast = playerTable[skillId]
	if lastCast and (os.clock() - lastCast) < cooldown then
		return true
	end

	playerTable[skillId] = os.clock()
	return false
end

function CombatService.CastSkill(player: Player, skillId: string)
	local state = CultivationService.GetPlayerState(player)
	if not state then return end

	local skill = StancesConfig[skillId]
	if not skill then return end

	if state.RealmLevel < skill.RequiredRealm then return end
	if isOnCooldown(player, skillId, skill.Cooldown) then return end
	if not CultivationService.SpendQi(player, skill.QiCost) then return end

	CombatService.ExecuteSkill(player, skill.SkillId)
end

function CombatService.ExecuteSkill(player: Player, skillId: string)
	if skillId == "QiPalm" then
		SkillExecutedRemote:FireAllClients(player, "QiPalm")
		return
	end

	warn(string.format("[CombatService] No executor found for '%s'.", skillId))
end

return CombatService