--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer :: Player
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local FONT_PRIMARY = Font.fromEnum(Enum.Font.FredokaOne)

-- Color Tokens for Qi Sense Highlights
local COLOR_HERB_GLOW  = Color3.fromRGB(46, 204, 113)  -- Emerald Green
local COLOR_NODE_GLOW  = Color3.fromRGB(0, 240, 255)   -- Spirit Cyan
local COLOR_BEAST_GLOW = Color3.fromRGB(231, 76, 60)   -- Crimson Violet

local SCAN_RADIUS = 300 -- Studs radius
local isInitialized = false
local isQiSenseActive = false
local lastToggleTime = 0

local activeHighlights: { [Instance]: Highlight } = {}
local activeBillboards: { [Instance]: BillboardGui } = {}

-- Lighting Effects
local qiColorCorrection: ColorCorrectionEffect? = nil

local QiSenseController = {}

-- ============================================================================
-- ATMOSPHERIC LIGHTING SHADER TOGGLE
-- ============================================================================

local function setupLightingEffects()
	qiColorCorrection = Lighting:FindFirstChild("QiSenseColorCorrection") :: ColorCorrectionEffect?
	if not qiColorCorrection then
		qiColorCorrection = Instance.new("ColorCorrectionEffect")
		qiColorCorrection.Name = "QiSenseColorCorrection"
		qiColorCorrection.TintColor = Color3.fromRGB(130, 255, 230) -- Vibrant Spirit Cyan Tint
		qiColorCorrection.Saturation = 0.3
		qiColorCorrection.Contrast = 0.25
		qiColorCorrection.Enabled = false
		qiColorCorrection.Parent = Lighting
	end
end

-- ============================================================================
-- HIGHLIGHT & BILLBOARD CREATION
-- ============================================================================

local function applyQiHighlight(target: Instance, glowColor: Color3, labelText: string?)
	if activeHighlights[target] then return end

	-- 1. Create Ethereal Outline Highlight
	local highlight = Instance.new("Highlight")
	highlight.Name = "QiSenseHighlight"
	highlight.FillColor = glowColor
	highlight.FillTransparency = 0.6
	highlight.OutlineColor = glowColor
	highlight.OutlineTransparency = 0.05
	highlight.Adornee = target
	highlight.Parent = target

	activeHighlights[target] = highlight

	-- 2. Create Floating World Label
	local primaryPart: BasePart? = nil
	if target:IsA("Model") then
		primaryPart = target.PrimaryPart or target:FindFirstChildOfClass("BasePart") :: BasePart?
	elseif target:IsA("BasePart") then
		primaryPart = target
	end

	if labelText and primaryPart then
		local bb = Instance.new("BillboardGui")
		bb.Name = "QiSenseLabel"
		bb.Size = UDim2.new(0, 160, 0, 32)
		bb.StudsOffset = Vector3.new(0, 4, 0)
		bb.AlwaysOnTop = true
		bb.Adornee = primaryPart

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.FontFace = FONT_PRIMARY
		textLabel.Text = labelText
		textLabel.TextColor3 = glowColor
		textLabel.TextSize = 13
		textLabel.Parent = bb

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(0, 0, 0)
		stroke.Thickness = 1.6
		stroke.Parent = textLabel

		bb.Parent = primaryPart
		activeBillboards[target] = bb
	end
end

local function clearQiHighlights()
	for target, highlight in pairs(activeHighlights) do
		if highlight then highlight:Destroy() end
	end
	for target, billboard in pairs(activeBillboards) do
		if billboard then billboard:Destroy() end
	end
	table.clear(activeHighlights)
	table.clear(activeBillboards)
end

-- ============================================================================
-- SCANNER LOOP
-- ============================================================================

local function scanWorldForQiObjects()
	local character = LocalPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not rootPart then return end

	local playerPos = rootPart.Position

	-- Scan Tagged Herbs
	for _, herb in ipairs(CollectionService:GetTagged("AlchemyHerb")) do
		if herb:IsA("BasePart") or herb:IsA("Model") then
			local pos = herb:IsA("Model") and (herb.PrimaryPart and herb.PrimaryPart.Position or Vector3.zero) or (herb :: BasePart).Position
			if (pos - playerPos).Magnitude <= SCAN_RADIUS then
				applyQiHighlight(herb, COLOR_HERB_GLOW, "🌱 Spirit Herb")
			end
		end
	end

	-- Scan Tagged Qi Nodes / Spirit Springs
	for _, node in ipairs(CollectionService:GetTagged("QiNode")) do
		if node:IsA("BasePart") or node:IsA("Model") then
			local pos = node:IsA("Model") and (node.PrimaryPart and node.PrimaryPart.Position or Vector3.zero) or (node :: BasePart).Position
			if (pos - playerPos).Magnitude <= SCAN_RADIUS then
				applyQiHighlight(node, COLOR_NODE_GLOW, "🌊 Qi Artery (+3.0x)")
			end
		end
	end

	-- Scan Tagged Spirit Beasts
	for _, beast in ipairs(CollectionService:GetTagged("SpiritBeast")) do
		if beast:IsA("Model") then
			local pos = beast.PrimaryPart and beast.PrimaryPart.Position or Vector3.zero
			if (pos - playerPos).Magnitude <= SCAN_RADIUS then
				applyQiHighlight(beast, COLOR_BEAST_GLOW, "🐉 Corrupted Beast")
			end
		end
	end
end

-- ============================================================================
-- TOGGLE QI SENSE MODE
-- ============================================================================

function QiSenseController.ToggleQiSense()
	local now = os.clock()
	if (now - lastToggleTime) < 0.25 then return end -- Debounce guard
	lastToggleTime = now

	isQiSenseActive = not isQiSenseActive

	if qiColorCorrection then
		qiColorCorrection.Enabled = isQiSenseActive
	end

	if isQiSenseActive then
		print("👁️ [QiSense] ACTIVATED — Ethereal Vision Active")
		scanWorldForQiObjects()
	else
		print("👁️ [QiSense] DEACTIVATED")
		clearQiHighlights()
	end
end

function QiSenseController.SetupKeybindings()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or UserInputService:GetFocusedTextBox() then return end

		if input.KeyCode == Enum.KeyCode.V then
			QiSenseController.ToggleQiSense()
		end
	end)
end

function QiSenseController.Init()
	if isInitialized then return end
	isInitialized = true

	setupLightingEffects()
	QiSenseController.SetupKeybindings()

	task.spawn(function()
		while true do
			task.wait(1.0)
			if isQiSenseActive then
				scanWorldForQiObjects()
			end
		end
	end)

	print(">>> [REALMBREAKER] QI SENSE CONTROLLER READY ([V] KEY FIXED) <<<")
end

QiSenseController.Init()

return QiSenseController