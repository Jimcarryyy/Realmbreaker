--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui
local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local CultivationUpdatedRemote = Remotes:WaitForChild("CultivationUpdated") :: RemoteEvent

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local RealmsConfig = require(Config:WaitForChild("RealmsConfig") :: ModuleScript)

-- Visual Configs
local CUSTOM_FONT = Font.fromEnum(Enum.Font.FredokaOne) -- Soft bloated game font
local COLOR_OBSIDIAN_BG = Color3.fromRGB(10, 12, 18)   -- Dark charcoal ink
local COLOR_BORDER = Color3.fromRGB(180, 140, 80)      -- Ethereal bronze/gold
local COLOR_SLOT_BG = Color3.fromRGB(16, 20, 28)      -- Inner slot background
local COLOR_TEXT_GOLD = Color3.fromRGB(240, 190, 100)   -- Golden accent text
local COLOR_TEXT_WHITE = Color3.fromRGB(245, 248, 255)
local COLOR_HEALTH_FILL = Color3.fromRGB(46, 204, 113)
local COLOR_QI_FILL = Color3.fromRGB(52, 152, 219)

-- UI Reference Trackers
local realmLabel: TextLabel
local barFill: Frame
local qiText: TextLabel
local overheadTitleLabel: TextLabel

-- Main HUD & Overhead health trackers
local healthFill: Frame
local healthText: TextLabel
local healthBarFill: Frame
local mainHealthText: TextLabel

local lastReceivedState: any = nil

-- ============================================================================
-- HELPER FUNCTIONS (ORDERED FOR SCOPE COMPLIANCE)
-- ============================================================================

-- Helper to apply high-quality coated text outlines
local function applyOutline(label: TextLabel, thickness: number?)
	label.FontFace = CUSTOM_FONT
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0) -- Solid black outline
	stroke.Thickness = thickness or 1.8    -- Thick "coated" outline
	stroke.Transparency = 0.05
	stroke.Parent = label
end

-- Helper to quickly build beautifully styled hotbar slots
local function createHotbarSlot(parent: Instance, name: string, keybind: string, iconText: string, size: UDim2, position: UDim2, isGolden: boolean)
	local slot = Instance.new("Frame")
	slot.Name = name
	slot.Size = size
	slot.Position = position
	slot.BackgroundColor3 = COLOR_SLOT_BG
	slot.BorderSizePixel = 0
	slot.Parent = parent

	local slotCorner = Instance.new("UICorner")
	slotCorner.CornerRadius = UDim.new(0, 6) -- Matching clean squircle corners
	slotCorner.Parent = slot

	local slotStroke = Instance.new("UIStroke")
	slotStroke.Color = isGolden and COLOR_BORDER or Color3.fromRGB(45, 55, 70)
	slotStroke.Thickness = isGolden and 1.2 or 1
	slotStroke.Parent = slot

	-- Slot Name/Icon placeholder text
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = iconText
	label.TextColor3 = isGolden and COLOR_TEXT_GOLD or COLOR_TEXT_WHITE
	label.TextSize = 10
	label.Parent = slot
	applyOutline(label, 1)

	-- Floating Keybind Label
	local bindLabel = Instance.new("TextLabel")
	bindLabel.Size = UDim2.new(0, 16, 0, 12)
	bindLabel.Position = UDim2.new(1, -12, 1, -10)
	bindLabel.BackgroundColor3 = COLOR_OBSIDIAN_BG
	bindLabel.Text = keybind
	bindLabel.TextColor3 = COLOR_TEXT_GOLD
	bindLabel.TextSize = 8
	bindLabel.Parent = slot

	local bindCorner = Instance.new("UICorner")
	bindCorner.CornerRadius = UDim.new(0, 3)
	bindCorner.Parent = bindLabel

	local bindStroke = Instance.new("UIStroke")
	bindStroke.Color = COLOR_BORDER
	bindStroke.Thickness = 0.8
	bindStroke.Parent = bindLabel
end

-- Synchronizes health updates across both the Overhead display and the Main HUD
local function updateHealth(humanoid: Humanoid)
	local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
	local hpString = string.format("%d / %d HP", math.floor(math.max(0, humanoid.Health)), math.floor(humanoid.MaxHealth))
	
	if healthText then healthText.Text = hpString end
	if mainHealthText then mainHealthText.Text = hpString end
	
	if healthFill then
		TweenService:Create(healthFill, TweenInfo.new(0.2), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
	end
	if healthBarFill then
		TweenService:Create(healthBarFill, TweenInfo.new(0.2), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
	end
end

local function formatNumber(n: number): string
	if n < 1000 then return tostring(math.floor(n)) end
	local suffixes = { "K", "M", "B", "T" }
	local i = math.floor(math.log10(n) / 3)
	local formatted = n / (10 ^ (i * 3))
	return string.format("%.1f%s", formatted, suffixes[i] or "")
end

local UIController = {}

function UIController.Init()
	UIController.CreateHUD()

	LocalPlayer.CharacterAdded:Connect(function(character)
		UIController.SetupOverheadTitle(character)
		
		local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
		if humanoid then
			humanoid.HealthChanged:Connect(function() updateHealth(humanoid) end)
			updateHealth(humanoid)
		end
	end)
	
	if LocalPlayer.Character then 
		UIController.SetupOverheadTitle(LocalPlayer.Character)
		local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid") :: Humanoid?
		if humanoid then
			humanoid.HealthChanged:Connect(function() updateHealth(humanoid) end)
			updateHealth(humanoid)
		end
	end

	CultivationUpdatedRemote.OnClientEvent:Connect(function(state: any)
		if not state then return end
        lastReceivedState = state
		local realmData = RealmsConfig.Realms[state.RealmLevel]
		local realmName = realmData and realmData.StageName or "Mortal Body"
		local stageNames = { "First Order", "Second Order", "Third Order", "Fourth Order", "Fifth Order", "Sixth Order", "Seventh Order", "Eighth Order", "Ninth Order" }
		local stageText = stageNames[state.MinorStage] or string.format("Stage %d", state.MinorStage)

		local titleText = string.format("%s — %s", realmName, stageText)

		if realmLabel then realmLabel.Text = titleText end
		if overheadTitleLabel then overheadTitleLabel.Text = titleText end

		if qiText then
			qiText.Text = string.format("%s / %s Spirit Qi", formatNumber(state.CurrentQi), formatNumber(state.MaxQi))
		end

		local percent = math.clamp(state.CurrentQi / state.MaxQi, 0, 1)
		if barFill then
			TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(percent, 0, 1, 0)
			}):Play()
		end
	end)

	print(">>> UI CONTROLLER INITIALIZED <<<")
end

function UIController.CreateHUD()
	local oldGui = PlayerGui:FindFirstChild("AutoCultivationGui")
	if oldGui then oldGui:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoCultivationGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = PlayerGui

	-- 1. Main Stats Container Panel (UPSCALED: Sized to 300px x 110px)
	local statsContainer = Instance.new("ImageLabel")
	statsContainer.Name = "StatsContainer"
	statsContainer.Size = UDim2.new(0, 300, 0, 110)
	statsContainer.Position = UDim2.new(0.5, -150, 1, -135) -- Centered and shifted slightly up
	statsContainer.BackgroundTransparency = 1
	statsContainer.BorderSizePixel = 0
	
	-- REPLACE WITH YOUR UPLOADED ROBLOX ASSET ID:
	statsContainer.Image = "rbxassetid://92647755738342"
	statsContainer.ScaleType = Enum.ScaleType.Stretch
	statsContainer.Parent = gui

	-- 2. Realm Label (Scaled up)
	realmLabel = Instance.new("TextLabel")
	realmLabel.Size = UDim2.new(1, -30, 0, 24)
	realmLabel.Position = UDim2.new(0, 15, 0, 12)
	realmLabel.BackgroundTransparency = 1
	realmLabel.Text = "Mortal Body — Early"
	realmLabel.TextColor3 = COLOR_TEXT_WHITE
	realmLabel.TextSize = 15 -- Increased font size
	realmLabel.Parent = statsContainer
	applyOutline(realmLabel, 1.8)

	-- 3. Health Bar (Scaled up with matching 6px squircle corners)
	local healthBg = Instance.new("Frame")
	healthBg.Name = "HealthBarBG"
	healthBg.Size = UDim2.new(1, -30, 0, 22) -- Expanded height to 22px
	healthBg.Position = UDim2.new(0, 15, 0, 42)
	healthBg.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
	healthBg.BorderSizePixel = 0
	healthBg.ClipsDescendants = true
	healthBg.Parent = statsContainer

	local hpBgCorner = Instance.new("UICorner")
	hpBgCorner.CornerRadius = UDim.new(0, 6)
	hpBgCorner.Parent = healthBg

	local hpBgStroke = Instance.new("UIStroke")
	hpBgStroke.Color = Color3.fromRGB(245, 248, 255) -- Thick white coated outline
	hpBgStroke.Thickness = 1.6
	hpBgStroke.Parent = healthBg

	healthBarFill = Instance.new("Frame")
	healthBarFill.Size = UDim2.new(0, 0, 1, 0)
	healthBarFill.BackgroundColor3 = COLOR_HEALTH_FILL
	healthBarFill.BorderSizePixel = 0
	healthBarFill.Parent = healthBg

	local hpFillCorner = Instance.new("UICorner")
	hpFillCorner.CornerRadius = UDim.new(0, 6)
	hpFillCorner.Parent = healthBarFill

	mainHealthText = Instance.new("TextLabel")
	mainHealthText.Size = UDim2.new(1, 0, 1, 0)
	mainHealthText.BackgroundTransparency = 1
	mainHealthText.Text = "100 / 100 HP"
	mainHealthText.TextColor3 = COLOR_TEXT_WHITE
	mainHealthText.TextSize = 12 -- Increased font size
	mainHealthText.Parent = healthBg
	applyOutline(mainHealthText, 1.5)

	-- 4. Spirit Qi Bar (Scaled up with matching 6px squircle corners)
	local barBg = Instance.new("Frame")
	barBg.Name = "QiBarBG"
	barBg.Size = UDim2.new(1, -30, 0, 22) -- Expanded height to 22px
	barBg.Position = UDim2.new(0, 15, 0, 72)
	barBg.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
	barBg.BorderSizePixel = 0
	barBg.ClipsDescendants = true
	barBg.Parent = statsContainer

	local barBgCorner = Instance.new("UICorner")
	barBgCorner.CornerRadius = UDim.new(0, 6)
	barBgCorner.Parent = barBg

	local barBgStroke = Instance.new("UIStroke")
	barBgStroke.Color = COLOR_BORDER -- Golden Outline
	barBgStroke.Thickness = 1.6
	barBgStroke.Parent = barBg

	barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = COLOR_QI_FILL
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg

	local barFillCorner = Instance.new("UICorner")
	barFillCorner.CornerRadius = UDim.new(0, 6)
	barFillCorner.Parent = barFill

	qiText = Instance.new("TextLabel")
	qiText.Size = UDim2.new(1, 0, 1, 0)
	qiText.BackgroundTransparency = 1
	qiText.Text = "0 / 100 Spirit Qi"
	qiText.TextColor3 = COLOR_TEXT_WHITE
	qiText.TextSize = 12 -- Increased font size
	qiText.Parent = barBg
	applyOutline(qiText, 1.5)

	-- ========================================================================
	-- RESET STATS TESTING BUTTON (MOVED TO BOTTOM RIGHT CORNER)
	-- ========================================================================
	local resetButton = Instance.new("TextButton")
	resetButton.Name = "ResetButton"
	resetButton.Size = UDim2.new(0, 95, 0, 26)
	resetButton.Position = UDim2.new(1, -115, 1, -40) -- Moved safely to the bottom-right corner!
	resetButton.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
	resetButton.Text = "Reset Stats"
	resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	resetButton.TextSize = 10
	resetButton.Parent = gui

	local resetCorner = Instance.new("UICorner")
	resetCorner.CornerRadius = UDim.new(0, 5)
	resetCorner.Parent = resetButton

	local resetStroke = Instance.new("UIStroke")
	resetStroke.Color = Color3.fromRGB(100, 20, 20)
	resetStroke.Thickness = 1
	resetStroke.Parent = resetButton

	resetButton.MouseButton1Click:Connect(function()
		local resetRemote = Remotes:FindFirstChild("ResetStats") :: RemoteEvent?
		if resetRemote then
			resetRemote:FireServer()
		end
	end)
end

function UIController.SetupOverheadTitle(character: Model)
	local head = character:WaitForChild("Head", 5) :: BasePart?
	local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
	if not head or not humanoid then return end

	local oldBb = head:FindFirstChild("OverheadTitleGui")
	if oldBb then oldBb:Destroy() end

	local bb = Instance.new("BillboardGui")
	bb.Name = "OverheadTitleGui"
	bb.Size = UDim2.new(0, 220, 0, 60)
	bb.StudsOffset = Vector3.new(0, 2.6, 0)
	bb.AlwaysOnTop = true
	bb.Parent = head

    overheadTitleLabel = Instance.new("TextLabel")
	overheadTitleLabel.Size = UDim2.new(1, 0, 0, 22)
	overheadTitleLabel.BackgroundTransparency = 1

	-- 1. Declare and calculate the title text FIRST
	local titleText = "Mortal Realm — First Order"
	if lastReceivedState then
		local realmData = RealmsConfig.Realms[lastReceivedState.RealmLevel]
		local realmName = realmData and realmData.StageName or "Mortal Realm"
		local stageNames = { 
			"First Order", "Second Order", "Third Order", 
			"Fourth Order", "Fifth Order", "Sixth Order", 
			"Seventh Order", "Eighth Order", "Ninth Order" 
		}
		local stageText = stageNames[lastReceivedState.MinorStage] or string.format("Order %d", lastReceivedState.MinorStage)
		titleText = string.format("%s — %s", realmName, stageText)
	end

	-- 2. Create the label, assign the text, and apply outline ONCE
	overheadTitleLabel.Text = titleText
	overheadTitleLabel.TextColor3 = COLOR_TEXT_WHITE
	overheadTitleLabel.TextSize = 14
	overheadTitleLabel.Parent = bb
	applyOutline(overheadTitleLabel, 1.8)

	local healthBg = Instance.new("Frame")
	healthBg.Size = UDim2.new(0, 180, 0, 18)
	healthBg.Position = UDim2.new(0.5, -90, 0, 26)
	healthBg.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
	healthBg.BorderSizePixel = 0
	healthBg.ClipsDescendants = true
	healthBg.Parent = bb

	local healthCorner = Instance.new("UICorner")
	healthCorner.CornerRadius = UDim.new(0, 6) -- Matching soft-rounded squircle!
	healthCorner.Parent = healthBg

	local healthStroke = Instance.new("UIStroke")
	healthStroke.Color = Color3.fromRGB(245, 248, 255) -- Thick white coated outline
	healthStroke.Thickness = 1.4
	healthStroke.Parent = healthBg

	healthFill = Instance.new("Frame")
	healthFill.Size = UDim2.new(math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), 0, 1, 0)
	healthFill.BackgroundColor3 = COLOR_HEALTH_FILL
	healthFill.BorderSizePixel = 0
	healthFill.Parent = healthBg

	local hpFillCorner = Instance.new("UICorner")
	hpFillCorner.CornerRadius = UDim.new(0, 6)
	hpFillCorner.Parent = healthFill

	healthText = Instance.new("TextLabel")
	healthText.Size = UDim2.new(1, 0, 1, 0)
	healthText.BackgroundTransparency = 1
	healthText.Text = string.format("%d / %d HP", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
	healthText.TextColor3 = COLOR_TEXT_WHITE
	healthText.TextSize = 11
	healthText.Parent = healthBg
	applyOutline(healthText, 1.5)

	humanoid.HealthChanged:Connect(function()
		updateHealth(humanoid)
	end)
end

UIController.Init()

return UIController