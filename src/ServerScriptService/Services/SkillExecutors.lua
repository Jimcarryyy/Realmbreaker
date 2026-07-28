--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local SkillExecutedRemote =
	Remotes:FindFirstChild("SkillExecuted") :: RemoteEvent

if not SkillExecutedRemote then
	SkillExecutedRemote = Instance.new("RemoteEvent")
	SkillExecutedRemote.Name = "SkillExecuted"
	SkillExecutedRemote.Parent = Remotes
end

local SkillExecutors = {}

function SkillExecutors.Execute(player: Player, skillId: string)
	if skillId == "QiPalm" then
		SkillExecutors.QiPalm(player)
		return
	end

	warn(string.format("[SkillExecutors] No executor found for '%s'.", skillId))
end

function SkillExecutors.QiPalm(player: Player)
	SkillExecutedRemote:FireAllClients(
		player,
		"QiPalm"
	)
end

return SkillExecutors