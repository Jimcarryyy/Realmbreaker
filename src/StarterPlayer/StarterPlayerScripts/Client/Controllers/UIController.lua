--!strict
-- ============================================================================
-- Realmbreaker — Central UI Controller (Phase 1 / Task 1.5)
-- Description: Governs Bottom HUD, Shortcut hotbar, and modular menu panels.
--              Maintains strict HP scaling caps and uses smooth CanvasGroup
--              transitions with Xianxia-inspired aesthetics.
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local UIController = {}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui
local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local CultivationUpdatedRemote = Remotes:WaitForChild("CultivationUpdated") :: RemoteEvent

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local RealmsConfig = require(Config:WaitForChild("RealmsConfig") :: ModuleScript)

-- ============================================================================
-- DESIGN CONSTANTS & CONFIGURATIONS
-- ============================================================================
local CUSTOM_FONT = Font.fromEnum(Enum.Font.FredokaOne) -- Soft bloated game font [1]
local COLOR_OBSIDIAN_BG = Color3.fromRGB(10, 12, 18)   -- Dark charcoal ink [1]
local COLOR_BORDER = Color3.fromRGB(180, 140, 80)      -- Ethereal bronze/gold [1]
local COLOR_SLOT_BG = Color3.fromRGB(16, 20, 28)       -- Inner slot background
local COLOR_TEXT_GOLD = Color3.fromRGB(240, 190, 100)  -- Golden accent text
local COLOR_TEXT_WHITE = Color3.fromRGB(245, 248, 255)
local COLOR_HEALTH_FILL = Color3.fromRGB(46, 204, 113) -- Cohesive Green [1]
local COLOR_QI_FILL = Color3.fromRGB(52, 152, 219)     -- Cohesive Cyan [1]
local COLOR_BLACK = Color3.fromRGB(0, 0, 0)

-- UI Asset IDs provided by Studio setup
local ASSETS = {
	-- Shortcut Buttons
	InventoryButton = "rbxassetid://114080253228005",
	StanceButton = "rbxassetid://112528458902591",
	BreakthroughButton = "rbxassetid://109386248218895",
	SectButton = "rbxassetid://102856734720054",
	
	-- Panel Backgrounds
	InventoryPanel = "rbxassetid://137976326690852",
	StancePanel = "rbxassetid://113212623822372",
	BreakthroughPanel = "rbxassetid://137540405084927",
	SectPanel = "rbxassetid://127875100585483",
	
	-- Interactive Components
	BreakBtnAction = "rbxassetid://109386248218895"
}

-- Auditory cues (Standard MMORPG placeholder assets)
local SFX = {
	Click = "rbxassetid://9114223193",
	Hover = "rbxassetid://9114221160",
}

-- ============================================================================
-- STATE TRACKING
-- ============================================================================
local lastReceivedState: any = nil
local activeOpenPanel: string? = nil
local isTweening: boolean = false

-- HUD Trackers
local mainGui: ScreenGui
local statsContainer: ImageLabel
local realmLabel: TextLabel
local barFill: Frame
local qiText: TextLabel
local overheadTitleLabel: TextLabel

-- Health Trackers
local healthFill: Frame
local healthText: TextLabel
local healthBarFill: Frame
local mainHealthText: TextLabel

-- Modular UI Panel Trackers
local panelsContainer: Frame
local registeredPanels: { [string]: CanvasGroup } = {}

-- ============================================================================
-- AUXILIARY HELPER FUNCTIONS
-- ============================================================================

local function playLocalSFX(assetId: string)
	task.spawn(function()
		local success, err = pcall(function()
			local sound = Instance.new("Sound")
			sound.SoundId = assetId
			sound.Volume = 0.2
			sound.PlayOnRemove = true
			sound.Parent = SoundService
			sound:Play()
			sound:Destroy()
		end)
	end)
end

-- Helper to apply high-quality coated text outlines
local function applyOutline(label: TextLabel, thickness: number?)
	label.FontFace = CUSTOM_FONT
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = COLOR_BLACK -- Solid black outline [1]
	stroke.Thickness = thickness or 1.8 -- Thick "coated" outline
	stroke.Transparency = 0.05
	stroke.Parent = label
end

-- Safely clamps health in compliance with V1 maximum specs (370 HP cap) [1]
local function clampHP(value: number): number
	return math.clamp(value, 0, 370)
end

local function formatNumber(n: number): string
	if n < 1000 then return tostring(math.floor(n)) end
	local suffixes = { "K", "M", "B", "T" }
	local i = math.floor(math.log10(n) / 3)
	local formatted = n / (10 ^ (i * 3))
	return string.format("%.1f%s", formatted, suffixes[i] or "")
end

-- Synchronizes health updates across both the Overhead display and the Main HUD
local function updateHealth(humanoid: Humanoid)
	local rawHealth = clampHP(humanoid.Health)
	local rawMaxHealth = clampHP(humanoid.MaxHealth)
	
	local percent = math.clamp(rawHealth / math.max(1, rawMaxHealth), 0, 1)
	local hpString = string.format("%d / %d HP", math.floor(rawHealth), math.floor(rawMaxHealth))
	
	if healthText then healthText.Text = hpString end
	if mainHealthText then mainHealthText.Text = hpString end
	
	if healthFill then
		TweenService:Create(healthFill, TweenInfo.new(0.2, Enum.EasingStyle.Sine), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
	end
	if healthBarFill then
		TweenService:Create(healthBarFill, TweenInfo.new(0.2, Enum.EasingStyle.Sine), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
	end
end

-- ============================================================================
-- MODULAR PANEL BUILDERS & TRANSITIONS
-- ============================================================================

local function animatePanelTransition(panel: CanvasGroup, open: boolean, callback: (() -> ())?)
	isTweening = true
	
	if open then
		panel.Visible = true
		panel.GroupTransparency = 1
		panel.Size = UDim2.new(0.85, 0, 0.85, 0) -- Slide and expand outwards
		panel.Position = UDim2.new(0.075, 0, 0.075, 0)
		
		local tweenOpacity = TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			GroupTransparency = 0
		})
		local tweenSize = TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		})
		
		tweenOpacity:Play()
		tweenSize:Play()
		tweenSize.Completed:Connect(function()
			isTweening = false
			if callback then callback() end
		end)
	else
		local tweenOpacity = TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
			GroupTransparency = 1
		})
		local tweenSize = TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
			Size = UDim2.new(0.85, 0, 0.85, 0),
			Position = UDim2.new(0.075, 0, 0.075, 0)
		})
		
		tweenOpacity:Play()
		tweenSize:Play()
		tweenSize.Completed:Connect(function()
			panel.Visible = false
			isTweening = false
			if callback then callback() end
		end)
	end
end

local function buildCloseButton(parentPanel: GuiObject, panelKey: string)
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -38, 0, 15)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = COLOR_TEXT_GOLD
	closeBtn.TextSize = 18
	closeBtn.ZIndex = 5
	applyOutline(closeBtn, 1.5)
	
	closeBtn.MouseButton1Click:Connect(function()
		playLocalSFX(SFX.Click)
		UIController.TogglePanel(panelKey)
	end)
	
	closeBtn.Parent = parentPanel
end

local function buildInventoryContent(bg: ImageLabel, panelKey: string)
	-- 1. Left Equipment Column (Sits over the 2x4 pre-drawn grid)
	local equipContainer = Instance.new("Frame")
	equipContainer.Name = "EquipContainer"
	equipContainer.Size = UDim2.new(0.28, 0, 0.72, 0)
	equipContainer.Position = UDim2.new(0.04, 0, 0.18, 0)
	equipContainer.BackgroundTransparency = 1
	equipContainer.Parent = bg

	local equipGrid = Instance.new("UIGridLayout")
	equipGrid.CellSize = UDim2.new(0, 48, 0, 48) -- Aligns with left squares
	equipGrid.CellPadding = UDim2.new(0, 22, 0, 14)
	equipGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	equipGrid.Parent = equipContainer

	-- Place some placeholder items over the pre-drawn slots (Invisible backgrounds)
	for i = 1, 8 do
		local slot = Instance.new("Frame")
		slot.BackgroundTransparency = 1 -- Keep it transparent so gold outlines show!
		slot.Parent = equipContainer
		if i == 1 then
			local icon = Instance.new("TextLabel")
			icon.Size = UDim2.new(1, 0, 1, 0)
			icon.BackgroundTransparency = 1
			icon.Text = "🗡️"
			icon.TextSize = 24
			icon.Parent = slot
			applyOutline(icon, 1.2)
		end
	end

	-- 2. Middle Main Grid Container (Sits perfectly over the 6x6 grid)
	local mainGridContainer = Instance.new("Frame")
	mainGridContainer.Name = "MainGridContainer"
	mainGridContainer.Size = UDim2.new(0.42, 0, 0.72, 0)
	mainGridContainer.Position = UDim2.new(0.33, 0, 0.18, 0)
	mainGridContainer.BackgroundTransparency = 1
	mainGridContainer.Parent = bg

	local mainGrid = Instance.new("UIGridLayout")
	mainGrid.CellSize = UDim2.new(0, 32, 0, 32) -- Tiny slots to fit your 6x6 design
	mainGrid.CellPadding = UDim2.new(0, 6, 0, 6)
	mainGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	mainGrid.Parent = mainGridContainer

	for i = 1, 36 do -- Exactly 36 slots for the 6x6 grid
		local slot = Instance.new("Frame")
		slot.BackgroundTransparency = 1 -- Completely transparent so background art shows!
		slot.Parent = mainGridContainer
		
		if i == 5 then
			local icon = Instance.new("TextLabel")
			icon.Size = UDim2.new(1, 0, 1, 0)
			icon.BackgroundTransparency = 1
			icon.Text = "💊"
			icon.TextSize = 16
			icon.Parent = slot
			applyOutline(icon, 1)
		elseif i == 12 then
			local icon = Instance.new("TextLabel")
			icon.Size = UDim2.new(1, 0, 1, 0)
			icon.BackgroundTransparency = 1
			icon.Text = "🌿"
			icon.TextSize = 16
			icon.Parent = slot
			applyOutline(icon, 1)
		end
	end

	-- 3. Right Details Area (Sits over the description column)
	local descFrame = Instance.new("Frame")
	descFrame.Name = "DescriptionFrame"
	descFrame.Size = UDim2.new(0.2, 0, 0.72, 0)
	descFrame.Position = UDim2.new(0.77, 0, 0.18, 0)
	descFrame.BackgroundTransparency = 1
	descFrame.Parent = bg

	local descText = Instance.new("TextLabel")
	descText.Size = UDim2.new(1, 0, 1, 0)
	descText.BackgroundTransparency = 1
	descText.Text = "Spirit Pill\n\nTier: 1\nRarity: Common\n\nRestores 10% Spiritual Qi upon consumption."
	descText.TextColor3 = COLOR_TEXT_WHITE
	descText.TextSize = 11
	descText.TextWrapped = true
	descText.TextYAlignment = Enum.TextYAlignment.Top
	descText.Parent = descFrame
	applyOutline(descText, 1)
end

local function buildStanceContent(bg: ImageLabel, panelKey: string)
	-- Left Selection Column (Sits over the 10 left long vertical slots)
	local listFrame = Instance.new("Frame")
	listFrame.Size = UDim2.new(0.25, 0, 0.72, 0)
	listFrame.Position = UDim2.new(0.04, 0, 0.18, 0)
	listFrame.BackgroundTransparency = 1
	listFrame.Parent = bg

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = listFrame

	local stances = { "Water Sword", "Thunder Strike" }
	for _, sName in ipairs(stances) do
		local rowBtn = Instance.new("TextButton")
		rowBtn.Size = UDim2.new(1, 0, 0, 26) -- Sized perfectly to cover the drawn lines
		rowBtn.BackgroundTransparency = 1
		rowBtn.Text = sName
		rowBtn.TextColor3 = COLOR_TEXT_GOLD
		rowBtn.TextSize = 12
		rowBtn.Parent = listFrame
		applyOutline(rowBtn, 1.2)
	end

	-- Right Skill Node Column (Over the 4 right progress channels)
	local skillFrame = Instance.new("Frame")
	skillFrame.Size = UDim2.new(0.25, 0, 0.72, 0)
	skillFrame.Position = UDim2.new(0.71, 0, 0.18, 0)
	skillFrame.BackgroundTransparency = 1
	skillFrame.Parent = bg

	local skillLayout = Instance.new("UIListLayout")
	skillLayout.Padding = UDim.new(0, 16)
	skillLayout.Parent = skillFrame

	for i = 1, 4 do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 42)
		row.BackgroundTransparency = 1
		row.Parent = skillFrame

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(0.8, 0, 0, 6)
		bar.Position = UDim2.new(0.1, 0, 0.75, 0)
		bar.BackgroundColor3 = COLOR_QI_FILL
		bar.BorderSizePixel = 0
		bar.Parent = row
	end
end

local function buildBreakthroughContent(bg: ImageLabel, panelKey: string)
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(0.9, 0, 0.72, 0)
	contentFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = bg

	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, 0, 0, 80)
	infoLabel.Position = UDim2.new(0, 0, 0.1, 0)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = "Awaiting cultivation status synchronization...\nRequired Qi: -- / --"
	infoLabel.TextColor3 = COLOR_TEXT_WHITE
	infoLabel.TextSize = 14
	infoLabel.Parent = contentFrame
	applyOutline(infoLabel, 1.5)

	-- Cultivation Breakthrough Button trigger [1]
	local breakBtn = Instance.new("ImageButton")
	breakBtn.Size = UDim2.new(0.6, 0, 0, 42)
	breakBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
	breakBtn.Image = ASSETS.BreakBtnAction
	breakBtn.BackgroundTransparency = 1
	
	local btnLabel = Instance.new("TextLabel")
	btnLabel.Size = UDim2.new(1, 0, 1, 0)
	btnLabel.BackgroundTransparency = 1
	btnLabel.Text = "⚡ BREAKTHROUGH BOUNDS ⚡"
	btnLabel.TextColor3 = COLOR_TEXT_GOLD
	btnLabel.TextSize = 12
	btnLabel.Parent = breakBtn
	applyOutline(btnLabel, 1.5)

	breakBtn.MouseEnter:Connect(function()
		playLocalSFX(SFX.Hover)
		TweenService:Create(breakBtn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), { ImageColor3 = Color3.fromRGB(255, 230, 150) }):Play()
	end)

	breakBtn.MouseLeave:Connect(function()
		TweenService:Create(breakBtn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), { ImageColor3 = COLOR_TEXT_WHITE }):Play()
	end)

	breakBtn.MouseButton1Click:Connect(function()
		playLocalSFX(SFX.Click)
		local breakthroughRemote = Remotes:FindFirstChild("CultivationBreakthrough") or Remotes:FindFirstChild("Breakthrough")
		if breakthroughRemote and breakthroughRemote:IsA("RemoteEvent") then
			breakthroughRemote:FireServer()
		else
			warn("[UIController] CultivationBreakthrough RemoteEvent could not be found.")
		end
	end)

	breakBtn.Parent = contentFrame
end

local function buildSectContent(bg: ImageLabel, panelKey: string)
	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(0.9, 0, 0.72, 0)
	contentFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = bg

	local details = Instance.new("TextLabel")
	details.Size = UDim2.new(1, 0, 1, 0)
	details.BackgroundTransparency = 1
	details.TextColor3 = COLOR_TEXT_WHITE
	details.TextSize = 12
	details.TextXAlignment = Enum.TextXAlignment.Left
	details.TextYAlignment = Enum.TextYAlignment.Top
	details.Text = "Sect Affiliation: Nine Heavens Sword Sect\n" ..
		"Disciple Rank: Outer Sect Disciple\n" ..
		"Sect Merit: 150 Contribution Points (CP)\n\n" ..
		"Daily Missions:\n" ..
		"• Gather Spirit Herbs [0/5]\n" ..
		"• Meditate on Peak Stone [0/1] (Yields bonus Qi)\n" ..
		"• Purge Rogue Beasts [0/3]"
	details.Parent = contentFrame
	applyOutline(details, 1.2)
end

local function CreateModularPanels()
	panelsContainer = Instance.new("Frame")
	panelsContainer.Name = "PanelsContainer"
	panelsContainer.Size = UDim2.new(0, 600, 0, 340) -- Sets exact pixel dimensions of the artwork [1]
	panelsContainer.Position = UDim2.new(0.5, -300, 0.5, -170) -- Perfectly recentered [1]
	panelsContainer.BackgroundTransparency = 1
	panelsContainer.Visible = true
	panelsContainer.Parent = mainGui

	local configurations = {
		{ Key = "Inventory", Image = ASSETS.InventoryPanel, TitleText = "🎒 INVENTORY BAG", Builder = buildInventoryContent },
		{ Key = "Stance", Image = ASSETS.StancePanel, TitleText = "⚔️ STANCES & TECHNIQUE", Builder = buildStanceContent },
		{ Key = "Breakthrough", Image = ASSETS.BreakthroughPanel, TitleText = "⚡ MERIDIAN TRANSFORMATION", Builder = buildBreakthroughContent },
		{ Key = "Sect", Image = ASSETS.SectPanel, TitleText = "⛰️ SECT SANCTUARY", Builder = buildSectContent }
	}

	for _, config in ipairs(configurations) do
		local cg = Instance.new("CanvasGroup")
		cg.Name = config.Key
		cg.Size = UDim2.new(1, 0, 1, 0)
		cg.BackgroundTransparency = 1
		cg.GroupTransparency = 1
		cg.Visible = false
		cg.Parent = panelsContainer

		local bg = Instance.new("ImageLabel")
		bg.Name = "Background"
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Image = config.Image
		bg.BackgroundTransparency = 1
		bg.ScaleType = Enum.ScaleType.Stretch
		bg.Parent = cg

		local title = Instance.new("TextLabel")
		title.Name = "TitleText"
		title.Size = UDim2.new(1, -80, 0, 40)
		title.Position = UDim2.new(0, 24, 0, 8)
		title.BackgroundTransparency = 1
		title.Text = config.TitleText
		title.TextColor3 = COLOR_TEXT_GOLD
		title.TextSize = 15
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = bg
		applyOutline(title, 1.8)

		buildCloseButton(bg, config.Key)
		config.Builder(bg, config.Key)

		registeredPanels[config.Key] = cg
	end
end

-- local function CreateShortcutBar()
-- 	local shortcutBar = Instance.new("Frame")
-- 	shortcutBar.Name = "ShortcutBar"
-- 	shortcutBar.Size = UDim2.new(0, 260, 0, 50)
-- 	shortcutBar.Position = UDim2.new(1, -280, 0, 25) -- Placed nicely top-right [1]
-- 	shortcutBar.BackgroundTransparency = 1
-- 	shortcutBar.Parent = mainGui

-- 	local listLayout = Instance.new("UIListLayout")
-- 	listLayout.FillDirection = Enum.FillDirection.Horizontal
-- 	listLayout.Padding = UDim.new(0, 12)
-- 	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
-- 	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
-- 	listLayout.Parent = shortcutBar

-- 	local buttons = {
-- 		{ Key = "Sect", Image = ASSETS.SectButton, Tooltip = "Sect" },
-- 		{ Key = "Breakthrough", Image = ASSETS.BreakthroughButton, Tooltip = "Breakthrough" },
-- 		{ Key = "Stance", Image = ASSETS.StanceButton, Tooltip = "Stances" },
-- 		{ Key = "Inventory", Image = ASSETS.InventoryButton, Tooltip = "Bag" },
-- 	}

-- 	for _, btnInfo in ipairs(buttons) do
-- 		local btn = Instance.new("ImageButton")
-- 		btn.Name = btnInfo.Key .. "Button"
-- 		btn.Size = UDim2.new(0, 42, 0, 42) -- Balanced proportion [1]
-- 		btn.Image = btnInfo.Image
-- 		btn.BackgroundTransparency = 1
-- 		btn.Parent = shortcutBar

-- 		-- Responsive Juiciness Events [1]
-- 		btn.MouseEnter:Connect(function()
-- 			playLocalSFX(SFX.Hover)
-- 			TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
-- 				Size = UDim2.new(0, 46, 0, 46),
-- 				ImageColor3 = Color3.fromRGB(240, 210, 150)
-- 			}):Play()
-- 		end)

-- 		btn.MouseLeave:Connect(function()
-- 			TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
-- 				Size = UDim2.new(0, 42, 0, 42),
-- 				ImageColor3 = COLOR_TEXT_WHITE
-- 			}):Play()
-- 		end)

-- 		btn.MouseButton1Click:Connect(function()
-- 			playLocalSFX(SFX.Click)
-- 			UIController.TogglePanel(btnInfo.Key)
-- 		end)
-- 	end
-- end

local function CreateShortcutBar()
	-- 1. Locate the visual ShortcutBar inside your ScreenGui [1]
	local shortcutBar = mainGui:WaitForChild("ShortcutBar") :: Frame
	
	local buttons = {
		{ Key = "Sect", Button = shortcutBar:WaitForChild("SectButton") :: ImageButton },
		{ Key = "Breakthrough", Button = shortcutBar:WaitForChild("BreakthroughButton") :: ImageButton },
		{ Key = "Stance", Button = shortcutBar:WaitForChild("StanceButton") :: ImageButton },
		{ Key = "Inventory", Button = shortcutBar:WaitForChild("InventoryButton") :: ImageButton },
	}

	for _, btnInfo in ipairs(buttons) do
		local btn = btnInfo.Button

		-- Bind juicy hover scaling animations [1]
		btn.MouseEnter:Connect(function()
			playLocalSFX(SFX.Hover)
			TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
				Size = UDim2.new(0, 46, 0, 46),
				ImageColor3 = Color3.fromRGB(240, 210, 150)
			}):Play()
		end)

		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
				Size = UDim2.new(0, 42, 0, 42),
				ImageColor3 = COLOR_TEXT_WHITE
			}):Play()
		end)

		-- Bind Toggle events directly to your visual hotbar buttons [1]
		btn.MouseButton1Click:Connect(function()
			playLocalSFX(SFX.Click)
			UIController.TogglePanel(btnInfo.Key)
		end)
	end
end

-- ============================================================================
-- MAIN PUBLIC INTERFACE METHOD
-- ============================================================================

function UIController.TogglePanel(panelKey: string)
	if isTweening then return end
	
	local targetPanel = registeredPanels[panelKey]
	if not targetPanel then return end

	if activeOpenPanel then
		local currentPanel = registeredPanels[activeOpenPanel]
		if activeOpenPanel == panelKey then
			-- Close current open panel
			animatePanelTransition(currentPanel, false, function()
				activeOpenPanel = nil
			end)
		else
			-- Swap panels: Fade out current, then open new
			animatePanelTransition(currentPanel, false, function()
				activeOpenPanel = nil
				animatePanelTransition(targetPanel, true, function()
					activeOpenPanel = panelKey
				end)
			end)
		end
	else
		-- Open straight away
		animatePanelTransition(targetPanel, true, function()
			activeOpenPanel = panelKey
		end)
	end
end

-- ============================================================================
-- INITIALIZATION AND EVENT REGISTRATION
-- ============================================================================

function UIController.Init()
	UIController.CreateHUD()
	CreateShortcutBar()
	CreateModularPanels()

	-- local UI_TEST_MODE = true

	-- if UI_TEST_MODE then
	-- 	-- 1. Lock the camera 50,000 studs up in the sky where there are no meshes, terrain, or grass to render
	-- 	local camera = workspace.CurrentCamera
	-- 	if camera then
	-- 		camera.CameraType = Enum.CameraType.Scriptable
	-- 		camera.CFrame = CFrame.new(0, 50000, 0)
	-- 	end
		
	-- 	-- 2. Create a solid full-screen obsidian backdrop behind your HUD and panels
	-- 	local testBg = Instance.new("Frame")
	-- 	testBg.Name = "TestBackground"
	-- 	testBg.Size = UDim2.new(1, 0, 1, 0)
	-- 	testBg.BackgroundColor3 = Color3.fromRGB(10, 12, 18) -- Your theme's Obsidian Black [1]
	-- 	testBg.BorderSizePixel = 0
	-- 	testBg.ZIndex = -100 -- Sits completely behind your HUD and shortcut bar [1]
	-- 	testBg.Parent = mainGui
	-- end

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

		-- Update breakthrough panel requirements dynamically
		local breakPanel = registeredPanels["Breakthrough"]
		if breakPanel then
			local infoLabel = breakPanel:FindFirstChild("InfoLabel", true) :: TextLabel?
			if infoLabel then
				local reqQi = realmData and realmData.RequiredQi or 100
				local status = state.CurrentQi >= reqQi and "Status: Meridian Barrier Fracturing" or "Status: Accumulating Spiritual Qi"
				infoLabel.Text = string.format(
					"Current Realm: %s — %s\nQi Accumulation: %s / %s Spirit Qi\n\n%s",
					realmName, stageText, formatNumber(state.CurrentQi), formatNumber(reqQi), status
				)
			end
		end

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

-- function UIController.CreateHUD()
-- 	local oldGui = PlayerGui:FindFirstChild("AutoCultivationGui")
-- 	if oldGui then oldGui:Destroy() end

-- 	mainGui = Instance.new("ScreenGui")
-- 	mainGui.Name = "AutoCultivationGui"
-- 	mainGui.ResetOnSpawn = false
-- 	mainGui.IgnoreGuiInset = true
-- 	mainGui.Parent = PlayerGui

-- 	-- 1. Main Stats Container Panel (UPSCALED: Sized to 300px x 110px) [1]
-- 	statsContainer = Instance.new("ImageLabel")
-- 	statsContainer.Name = "StatsContainer"
-- 	statsContainer.Size = UDim2.new(0, 300, 0, 110)
-- 	statsContainer.Position = UDim2.new(0.5, -150, 1, -135) -- Centered and shifted slightly up [1]
-- 	statsContainer.BackgroundTransparency = 1
-- 	statsContainer.BorderSizePixel = 0
	
-- 	statsContainer.Image = "rbxassetid://92647755738342" -- Existing Asset ID preserved [1]
-- 	statsContainer.ScaleType = Enum.ScaleType.Stretch
-- 	statsContainer.Parent = mainGui

-- 	-- 2. Realm Label (Scaled up)
-- 	realmLabel = Instance.new("TextLabel")
-- 	realmLabel.Size = UDim2.new(1, -30, 0, 24)
-- 	realmLabel.Position = UDim2.new(0, 15, 0, 12)
-- 	realmLabel.BackgroundTransparency = 1
-- 	realmLabel.Text = "Mortal Body — Early"
-- 	realmLabel.TextColor3 = COLOR_TEXT_WHITE
-- 	realmLabel.TextSize = 15
-- 	realmLabel.Parent = statsContainer
-- 	applyOutline(realmLabel, 1.8)

-- 	-- 3. Health Bar (Scaled up with matching 6px squircle corners) [1]
-- 	local healthBg = Instance.new("Frame")
-- 	healthBg.Name = "HealthBarBG"
-- 	healthBg.Size = UDim2.new(1, -30, 0, 22) -- Expanded height to 22px [1]
-- 	healthBg.Position = UDim2.new(0, 15, 0, 42)
-- 	healthBg.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
-- 	healthBg.BorderSizePixel = 0
-- 	healthBg.ClipsDescendants = true
-- 	healthBg.Parent = statsContainer

-- 	local hpBgCorner = Instance.new("UICorner")
-- 	hpBgCorner.CornerRadius = UDim.new(0, 6)
-- 	hpBgCorner.Parent = healthBg

-- 	local hpBgStroke = Instance.new("UIStroke")
-- 	hpBgStroke.Color = Color3.fromRGB(245, 248, 255) -- Thick white coated outline [1]
-- 	hpBgStroke.Thickness = 1.6
-- 	hpBgStroke.Parent = healthBg

-- 	healthBarFill = Instance.new("Frame")
-- 	healthBarFill.Size = UDim2.new(0, 0, 1, 0)
-- 	healthBarFill.BackgroundColor3 = COLOR_HEALTH_FILL
-- 	healthBarFill.BorderSizePixel = 0
-- 	healthBarFill.Parent = healthBg

-- 	local hpFillCorner = Instance.new("UICorner")
-- 	hpFillCorner.CornerRadius = UDim.new(0, 6)
-- 	hpFillCorner.Parent = healthBarFill

-- 	mainHealthText = Instance.new("TextLabel")
-- 	mainHealthText.Size = UDim2.new(1, 0, 1, 0)
-- 	mainHealthText.BackgroundTransparency = 1
-- 	mainHealthText.Text = "100 / 100 HP"
-- 	mainHealthText.TextColor3 = COLOR_TEXT_WHITE
-- 	mainHealthText.TextSize = 12
-- 	mainHealthText.Parent = healthBg
-- 	applyOutline(mainHealthText, 1.5)

-- 	-- 4. Spirit Qi Bar (Scaled up with matching 6px squircle corners) [1]
-- 	local barBg = Instance.new("Frame")
-- 	barBg.Name = "QiBarBG"
-- 	barBg.Size = UDim2.new(1, -30, 0, 22) -- Expanded height to 22px [1]
-- 	barBg.Position = UDim2.new(0, 15, 0, 72)
-- 	barBg.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
-- 	barBg.BorderSizePixel = 0
-- 	barBg.ClipsDescendants = true
-- 	barBg.Parent = statsContainer

-- 	local barBgCorner = Instance.new("UICorner")
-- 	barBgCorner.CornerRadius = UDim.new(0, 6)
-- 	barBgCorner.Parent = barBg

-- 	local barBgStroke = Instance.new("UIStroke")
-- 	barBgStroke.Color = COLOR_BORDER -- Golden Outline [1]
-- 	barBgStroke.Thickness = 1.6
-- 	barBgStroke.Parent = barBg

-- 	barFill = Instance.new("Frame")
-- 	barFill.Size = UDim2.new(0, 0, 1, 0)
-- 	barFill.BackgroundColor3 = COLOR_QI_FILL
-- 	barFill.BorderSizePixel = 0
-- 	barFill.Parent = barBg

-- 	local barFillCorner = Instance.new("UICorner")
-- 	barFillCorner.CornerRadius = UDim.new(0, 6)
-- 	barFillCorner.Parent = barFill

-- 	qiText = Instance.new("TextLabel")
-- 	qiText.Size = UDim2.new(1, 0, 1, 0)
-- 	qiText.BackgroundTransparency = 1
-- 	qiText.Text = "0 / 100 Spirit Qi"
-- 	qiText.TextColor3 = COLOR_TEXT_WHITE
-- 	qiText.TextSize = 12
-- 	qiText.Parent = barBg
-- 	applyOutline(qiText, 1.5)

-- 	-- ========================================================================
-- 	-- RESET STATS TESTING BUTTON (MOVED TO BOTTOM RIGHT CORNER)
-- 	-- ========================================================================
-- 	local resetButton = Instance.new("TextButton")
-- 	resetButton.Name = "ResetButton"
-- 	resetButton.Size = UDim2.new(0, 95, 0, 26)
-- 	resetButton.Position = UDim2.new(1, -115, 1, -40) -- Placed in bottom-right corner
-- 	resetButton.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
-- 	resetButton.Text = "Reset Stats"
-- 	resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
-- 	resetButton.TextSize = 10
-- 	resetButton.Parent = mainGui

-- 	local resetCorner = Instance.new("UICorner")
-- 	resetCorner.CornerRadius = UDim.new(0, 5)
-- 	resetCorner.Parent = resetButton

-- 	local resetStroke = Instance.new("UIStroke")
-- 	resetStroke.Color = Color3.fromRGB(100, 20, 20)
-- 	resetStroke.Thickness = 1
-- 	resetStroke.Parent = resetButton

-- 	resetButton.MouseButton1Click:Connect(function()
-- 		local resetRemote = Remotes:FindFirstChild("ResetStats") :: RemoteEvent?
-- 		if resetRemote then
-- 			resetRemote:FireServer()
-- 		end
-- 	end)
-- end

function UIController.CreateHUD()
	-- 1. Grab the existing ScreenGui copied from StarterGui instead of deleting it! [1]
	mainGui = PlayerGui:WaitForChild("AutoCultivationGui") :: ScreenGui

	-- 2. Reference your visually edited StatsContainer and its children [1]
	statsContainer = mainGui:WaitForChild("StatsContainer") :: ImageLabel
	realmLabel = statsContainer:WaitForChild("RealmLabel") :: TextLabel

	local healthBg = statsContainer:WaitForChild("HealthBarBG") :: Frame
	healthBarFill = healthBg:WaitForChild("Fill") :: Frame
	mainHealthText = healthBg:WaitForChild("HPText") :: TextLabel

	local barBg = statsContainer:WaitForChild("QiBarBG") :: Frame
	barFill = barBg:WaitForChild("Fill") :: Frame
	qiText = barBg:WaitForChild("QiText") :: TextLabel

	-- 3. Connect Reset Button [1]
	local resetButton = mainGui:WaitForChild("ResetButton") :: TextButton
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
	healthCorner.CornerRadius = UDim.new(0, 6)
	healthCorner.Parent = healthBg

	local healthStroke = Instance.new("UIStroke")
	healthStroke.Color = Color3.fromRGB(245, 248, 255)
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