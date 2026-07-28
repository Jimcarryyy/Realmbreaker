--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Configs = Shared:WaitForChild("Configs")

local SkillData = require(Configs:WaitForChild("SkillData")) :: any

local Services = ServerScriptService:WaitForChild("Services")
local CultivationService = require(Services:WaitForChild("CultivationService"))

local SkillExecutors = require(Services:WaitForChild("SkillExecutors"))

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local CastSkillRemote = Remotes:FindFirstChild("CastSkill") :: RemoteEvent
if not CastSkillRemote then
	CastSkillRemote = Instance.new("RemoteEvent")
	CastSkillRemote.Name = "CastSkill"
	CastSkillRemote.Parent = Remotes
end

type CooldownTable = {
	[string]: number
}

local SkillService = {}

local playerCooldowns: { [Player]: CooldownTable } = {}

function SkillService.Init()
	print(">>> SKILL SERVICE MODULE LOADED <<<")

	CastSkillRemote.OnServerEvent:Connect(function(player: Player, skillId: string)
		SkillService.CastSkill(player, skillId)
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

function SkillService.CastSkill(player: Player, skillId: string)
	local state = CultivationService.GetPlayerState(player)
	if not state then
		return
	end

	local skill = SkillData[skillId]
	if not skill then
		return
	end

	if state.RealmLevel < skill.RequiredRealm then
		return
	end

	if isOnCooldown(player, skillId, skill.Cooldown) then
		return
	end

	if not CultivationService.SpendQi(player, skill.QiCost) then
		return
	end

	SkillExecutors.Execute(player, skill.SkillId)
end

return SkillService