--!strict
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Configs = Shared:WaitForChild("Configs")
local ZoneData = require(Configs:WaitForChild("ZoneData") :: ModuleScript)

local WorldService = {}

local playerCurrentZone: { [Player]: string } = {}

local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local ZoneChangedRemote = Remotes:FindFirstChild("ZoneChanged") :: RemoteEvent
if not ZoneChangedRemote then
	ZoneChangedRemote = Instance.new("RemoteEvent")
	ZoneChangedRemote.Name = "ZoneChanged"
	ZoneChangedRemote.Parent = Remotes
end

function WorldService.Init()
	print(">>> WORLD SERVICE MODULE LOADED <<<")

	task.spawn(function()
		while true do
			task.wait(1.0)
			WorldService._updatePlayerZones()
		end
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		playerCurrentZone[player] = nil
	end)
end

function WorldService._updatePlayerZones()
	for _, player in Players:GetPlayers() do
		local character = player.Character
		if not character then continue end

		local primaryPart = character.PrimaryPart
		if not primaryPart then continue end

		local currentPosition = primaryPart.Position
		local detectedZoneId: string = "MortalVillage"

		local zoneParts = CollectionService:GetTagged("WorldZone")
		for _, zonePart in zoneParts do
			if typeof(zonePart) == "Instance" and zonePart:IsA("BasePart") then
				local zoneId = zonePart:GetAttribute("ZoneId") :: string?
				if zoneId and WorldService._isPointInPart(currentPosition, zonePart) then
					detectedZoneId = zoneId
					break
				end
			end
		end

		if playerCurrentZone[player] ~= detectedZoneId then
			local oldZone = playerCurrentZone[player]
			playerCurrentZone[player] = detectedZoneId
			WorldService._onPlayerZoneChanged(player, detectedZoneId, oldZone)
		end
	end
end

function WorldService._isPointInPart(point: Vector3, part: BasePart): boolean
	local localPoint = part.CFrame:PointToObjectSpace(point)
	local halfSize = part.Size / 2
	return math.abs(localPoint.X) <= halfSize.X
		and math.abs(localPoint.Y) <= halfSize.Y
		and math.abs(localPoint.Z) <= halfSize.Z
end

function WorldService._onPlayerZoneChanged(player: Player, newZoneId: string, oldZoneId: string?)
	local zoneConfig = ZoneData[newZoneId]
	if not zoneConfig then return end

	ZoneChangedRemote:FireClient(player, newZoneId, zoneConfig)

	print(string.format("[WorldService] %s entered zone: %s (Qi Multiplier: %.1fx)", 
		player.Name, zoneConfig.DisplayName, zoneConfig.QiDensityMultiplier))
end

function WorldService.GetPlayerQiMultiplier(player: Player): number
	local zoneId = playerCurrentZone[player] or "MortalVillage"
	local config = ZoneData[zoneId]
	return config and config.QiDensityMultiplier or 1.0
end

return WorldService