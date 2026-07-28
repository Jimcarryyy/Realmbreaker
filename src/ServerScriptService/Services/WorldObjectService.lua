--!strict
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NodeData = require(ReplicatedStorage.Shared.Configs.NodeData) :: any
local CultivationService = require(script.Parent.CultivationService) :: any

local WorldObjectService = {}
local activeNodes: { [Instance]: boolean } = {}

function WorldObjectService.Init(): ()
	for _, node in CollectionService:GetTagged("QiNode") do
		WorldObjectService.SetupNode(node)
	end

	CollectionService:GetInstanceAddedSignal("QiNode"):Connect(function(node: Instance)
		WorldObjectService.SetupNode(node)
	end)
end

function WorldObjectService.SetupNode(node: Instance): ()
	if not (node:IsA("BasePart") or node:IsA("Model")) then return end

	local nodeType = node:GetAttribute("NodeType") :: string?
	if not nodeType or not NodeData[nodeType] then return end

	local config = NodeData[nodeType]

	local prompt = node:FindFirstChildOfClass("ProximityPrompt")
	if not prompt then
		prompt = Instance.new("ProximityPrompt")
		prompt.Name = "HarvestPrompt"
		prompt.ActionText = "Harvest"
		prompt.ObjectText = config.Name
		prompt.HoldDuration = config.HoldDuration
		prompt.MaxActivationDistance = 10
		prompt.RequiresLineOfSight = false
		prompt.Parent = node
	end

	activeNodes[node] = true

	prompt.Triggered:Connect(function(player: Player)
		WorldObjectService.HarvestNode(player, node, nodeType)
	end)
end

function WorldObjectService.HarvestNode(player: Player, node: Instance, nodeType: string): ()
	if not activeNodes[node] then return end

	local config = NodeData[nodeType]
	if not config then return end

	-- Validate Player Distance Server-Side
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
	local nodePart = node:IsA("BasePart") and node or node:FindFirstChildWhichIsA("BasePart")

	if not root or not nodePart or (root.Position - nodePart.Position).Magnitude > 15 then
		return
	end

	-- Lock node interaction state
	activeNodes[node] = false

	local prompt = node:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
		prompt.Enabled = false
	end

	WorldObjectService.SetNodeVisibility(node, false)

	-- Award Qi
	CultivationService.AddQi(player, config.QiReward)

	-- Handle Respawn Cooldown
	task.delay(config.RespawnTime, function()
		if not node:IsDescendantOf(workspace) then return end

		activeNodes[node] = true
		if prompt then
			prompt.Enabled = true
		end
		WorldObjectService.SetNodeVisibility(node, true)
	end)
end

function WorldObjectService.SetNodeVisibility(node: Instance, visible: boolean): ()
	local transparency = visible and 0 or 1
	if node:IsA("BasePart") then
		node.Transparency = transparency
	elseif node:IsA("Model") then
		for _, desc in node:GetDescendants() do
			if desc:IsA("BasePart") then
				desc.Transparency = transparency
			end
		end
	end
end

return WorldObjectService