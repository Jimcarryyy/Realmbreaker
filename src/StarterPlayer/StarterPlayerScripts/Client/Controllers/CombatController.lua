--!strict

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CastSkillRemote = Remotes:WaitForChild("CastSkill") :: RemoteEvent

local CombatController = {}

function CombatController.Init()

	UserInputService.InputBegan:Connect(function(input, processed)

		if processed then
			return
		end

		if input.KeyCode == Enum.KeyCode.One then
			CastSkillRemote:FireServer("QiPalm")
		end

	end)

	print(">>> COMBAT CONTROLLER INITIALIZED <<<")
end

CombatController.Init()

return CombatController