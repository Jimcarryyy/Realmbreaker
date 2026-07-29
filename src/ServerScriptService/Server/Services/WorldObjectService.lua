--!strict
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local NodesConfig = require(Config:WaitForChild("NodesConfig") :: ModuleScript)

local CultivationService = require(script.Parent:WaitForChild("CultivationService")) :: any

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
	if not nodeType or not NodesConfig[nodeType] then return end

	local config = NodesConfig[nodeType]

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

	local config = NodesConfig[nodeType]
	if not config then return end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart?
	local nodePart = node:IsA("BasePart") and node or node:FindFirstChildWhichIsA("BasePart")

	if not root or not nodePart or (root.Position - nodePart.Position).Magnitude > 15 then
		return
	end

	activeNodes[node] = false

	local prompt = node:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
		prompt.Enabled = false
	end

	WorldObjectService.SetNodeVisibility(node, false)
	CultivationService.AddQi(player, config.QiReward)

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