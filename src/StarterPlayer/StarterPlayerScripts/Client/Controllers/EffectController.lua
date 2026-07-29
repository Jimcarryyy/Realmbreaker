--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Assets = Shared:WaitForChild("Assets")

-- NEW CODE (Correct Path):
local AssetsConfig = require(ReplicatedStorage.Shared.Assets:WaitForChild("AssetsConfig"))
local Animations = AssetsConfig.Animations

local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local BreakthroughTriggeredRemote = Remotes:WaitForChild("BreakthroughTriggered") :: RemoteEvent

local function getAuraColor(realmLevel: number): Color3
	if realmLevel <= 3 then return Color3.fromRGB(100, 200, 255)
	elseif realmLevel <= 6 then return Color3.fromRGB(170, 50, 255)
	elseif realmLevel <= 9 then return Color3.fromRGB(255, 50, 80)
	else return Color3.fromRGB(255, 215, 0) end
end

local EffectController = {}

local SkillExecutedRemote =
	Remotes:WaitForChild("SkillExecuted") :: RemoteEvent

function EffectController.Init()
	BreakthroughTriggeredRemote.OnClientEvent:Connect(EffectController._onBreakthrough)
	SkillExecutedRemote.OnClientEvent:Connect(
		EffectController._onSkillExecuted
	)
end

function EffectController._onBreakthrough(targetPlayer: Player, isMajor: boolean, realmLevel: number, minorStage: number)
	local character = targetPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not rootPart then return end

	local auraColor = getAuraColor(realmLevel)

	-- SINGLE PHASE: Void Ring Expanding at Base Only
	local voidRing = Instance.new("Part")
	voidRing.Name = "VoidBreakthroughRing"
	voidRing.Shape = Enum.PartType.Cylinder
	voidRing.Size = Vector3.new(0.1, 3, 3)
	voidRing.CFrame = rootPart.CFrame * CFrame.new(0, -2.1, 0) * CFrame.Angles(0, 0, math.rad(90))
	voidRing.Material = Enum.Material.ForceField
	voidRing.Color = auraColor
	voidRing.Transparency = 0.1
	voidRing.CanCollide = false
	voidRing.Anchored = true
	voidRing.Parent = Workspace

	TweenService:Create(voidRing, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = isMajor and Vector3.new(0.1, 22, 22) or Vector3.new(0.1, 15, 18),
		Transparency = 1.0
	}):Play()

	task.delay(0.6, function() voidRing:Destroy() end)
end

function EffectController._onSkillExecuted(
	player: Player,
	skillId: string
)
	if skillId ~= "QiPalm" then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local humanoid =
		character:FindFirstChildOfClass("Humanoid")

	local root =
		character:FindFirstChild("HumanoidRootPart") :: BasePart?

	if not humanoid or not root then
		return
	end

	------------------------------------------------
	-- Play Animation
	------------------------------------------------

	local animator =
		humanoid:FindFirstChildOfClass("Animator")

	if animator then

		local animation = Instance.new("Animation")
		animation.AnimationId =
			Animations.Skills.QiPalm.Cast

		local track =
			animator:LoadAnimation(animation)

		track:Play()

	end

	------------------------------------------------
	-- Temporary Shockwave
	------------------------------------------------

	local wave = Instance.new("Part")
	wave.Shape = Enum.PartType.Ball
	wave.Material = Enum.Material.ForceField
	wave.Color = Color3.fromRGB(80,180,255)

	wave.Anchored = true
	wave.CanCollide = false

	wave.Size = Vector3.new(1,1,1)

	wave.CFrame =
		root.CFrame * CFrame.new(0,0,-4)

	wave.Parent = workspace

	TweenService:Create(
		wave,
		TweenInfo.new(0.45),
		{
			Size = Vector3.new(8,8,8),
			Transparency = 1
		}
	):Play()

	task.delay(0.45,function()
		wave:Destroy()
	end)
end

EffectController.Init()

return EffectController