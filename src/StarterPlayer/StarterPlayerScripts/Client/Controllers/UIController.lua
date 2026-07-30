--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer :: Player
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local RealmsConfig = require(Config:WaitForChild("RealmsConfig") :: ModuleScript)

local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local CultivationUpdatedRemote = Remotes:WaitForChild("CultivationUpdated") :: RemoteEvent

-- Typography & Palette
local FONT_PRIMARY   = Font.fromEnum(Enum.Font.FredokaOne)
local FONT_SECONDARY = Font.fromEnum(Enum.Font.GothamMedium)

local COLOR_TEXT_WHITE = Color3.fromRGB(245, 248, 255)
local COLOR_TEXT_GOLD  = Color3.fromRGB(212, 175, 55)
local COLOR_TEXT_MUTED = Color3.fromRGB(138, 154, 146)
local COLOR_OBSIDIAN_BG= Color3.fromRGB(18, 22, 26)

local isInitialized = false
local ActivePanelName: string? = nil
local PanelMap: { [string]: ImageLabel } = {}

-- Top Nav References
type NavTabButton = {
	Button: TextButton,
	Label: TextLabel,
	Key: string,
}

type TopNavReferences = {
	Frame: ImageLabel,
	AvatarImage: ImageLabel,
	NameLabel: TextLabel,
	RankLabel: TextLabel,
	SpiritStonesLabel: TextLabel,
	SectTokensLabel: TextLabel,
	Tabs: { NavTabButton },
}

type GaugeReferences = {
	Container: Frame,
	Fill: Frame,
	TextLabel: TextLabel,
}

type HUDReferences = {
	VitalityCluster: ImageLabel,
	Health: GaugeReferences?,
	Posture: GaugeReferences?,
	Stamina: GaugeReferences?,
	Qi: GaugeReferences?,
}

local HudRefs: HUDReferences? = nil
local TopNavRefs: TopNavReferences? = nil

-- Currencies
local PlayerSpiritStones = 1250
local PlayerSectTokens = 45

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

local function applyStroke(label: TextLabel, thickness: number?, color: Color3?)
	local stroke = label:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(0, 0, 0)
	stroke.Thickness = thickness or 1.4
	stroke.Transparency = 0.05
	stroke.Parent = label
end

local function formatCommas(amount: number): string
	local formatted = tostring(amount)
	while true do
		local k
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then break end
	end
	return formatted
end

local function isTypingInChat(): boolean
	local focusedTextBox = UserInputService:GetFocusedTextBox()
	return focusedTextBox ~= nil
end

local function getTrackRefs(parent: Instance, trackName: string): GaugeReferences?
	local container = parent:FindFirstChild(trackName) :: Frame?
	if not container then return nil end

	local fill = container:FindFirstChild("Fill") :: Frame?
	local textLabel = container:FindFirstChild("ValueText") :: TextLabel?

	if fill and textLabel then
		textLabel.FontFace = FONT_PRIMARY
		return {
			Container = container,
			Fill = fill,
			TextLabel = textLabel,
		}
	end
	return nil
end

-- ============================================================================
-- TASK A: TOP NAVIGATION BAR BUILDER
-- ============================================================================

local function setupTopNavigationBar(navFrame: ImageLabel): TopNavReferences
	-- 1. Left Avatar Image (Circle Mask)
	local avatarImg = navFrame:FindFirstChild("AvatarImage") :: ImageLabel?
	if not avatarImg then
		avatarImg = Instance.new("ImageLabel")
		avatarImg.Name = "AvatarImage"
		avatarImg.Size = UDim2.new(0, 44, 0, 44)
		avatarImg.Position = UDim2.new(0, 10, 0.5, -22)
		avatarImg.BackgroundTransparency = 1
		avatarImg.Parent = navFrame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = avatarImg
	end

	-- Fetch Headshot
	task.spawn(function()
		local content, isLoaded = Players:GetUserThumbnailAsync(
			LocalPlayer.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size100x100
		)
		if isLoaded and avatarImg then
			avatarImg.Image = content
		end
	end)

	-- 2. Player Name & Realm Rank Labels (Next to Avatar)
	local nameLabel = navFrame:FindFirstChild("PlayerNameLabel") :: TextLabel?
	if not nameLabel then
		nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "PlayerNameLabel"
		nameLabel.Size = UDim2.new(0, 110, 0, 16)
		nameLabel.Position = UDim2.new(0, 60, 0, 12)
		nameLabel.BackgroundTransparency = 1
		nameLabel.FontFace = FONT_PRIMARY
		nameLabel.Text = LocalPlayer.DisplayName
		nameLabel.TextColor3 = COLOR_TEXT_WHITE
		nameLabel.TextSize = 12
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = navFrame
		applyStroke(nameLabel, 1.2)
	end

	local rankLabel = navFrame:FindFirstChild("RealmRankLabel") :: TextLabel?
	if not rankLabel then
		rankLabel = Instance.new("TextLabel")
		rankLabel.Name = "RealmRankLabel"
		rankLabel.Size = UDim2.new(0, 120, 0, 14)
		rankLabel.Position = UDim2.new(0, 60, 0, 30)
		rankLabel.BackgroundTransparency = 1
		rankLabel.FontFace = FONT_SECONDARY
		rankLabel.Text = "Qi Condensation · 1st"
		rankLabel.TextColor3 = COLOR_TEXT_GOLD
		rankLabel.TextSize = 10
		rankLabel.TextXAlignment = Enum.TextXAlignment.Left
		rankLabel.Parent = navFrame
		applyStroke(rankLabel, 1.2)
	end

	-- 3. Center Navigation Tabs (6 Tabs)
	local tabConfigs = {
		{ Key = "Character", Text = "Character [C]", PosX = 0.28, Width = 0.09 },
		{ Key = "Inventory", Text = "Inventory [B]", PosX = 0.38, Width = 0.09 },
		{ Key = "Skills",    Text = "Skills [K]",    PosX = 0.48, Width = 0.08 },
		{ Key = "WorldMap",  Text = "Map [N]",       PosX = 0.57, Width = 0.07 },
		{ Key = "Alchemy",   Text = "Alchemy",       PosX = 0.65, Width = 0.08 },
		{ Key = "Settings",  Text = "Settings [O]",  PosX = 0.74, Width = 0.08 },
	}

	local navTabs: { NavTabButton } = {}

	for _, config in ipairs(tabConfigs) do
		local btnName = "NavButton_" .. config.Key
		local btn = navFrame:FindFirstChild(btnName) :: TextButton?
		if not btn then
			btn = Instance.new("TextButton")
			btn.Name = btnName
			btn.Size = UDim2.new(config.Width, 0, 0.6, 0)
			btn.Position = UDim2.new(config.PosX, 0, 0.2, 0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.Parent = navFrame
		end

		local txtLabel = btn:FindFirstChild("TabLabel") :: TextLabel?
		if not txtLabel then
			txtLabel = Instance.new("TextLabel")
			txtLabel.Name = "TabLabel"
			txtLabel.Size = UDim2.new(1, 0, 1, 0)
			txtLabel.BackgroundTransparency = 1
			txtLabel.FontFace = FONT_PRIMARY
			txtLabel.Text = config.Text
			txtLabel.TextColor3 = COLOR_TEXT_MUTED
			txtLabel.TextSize = 11
			txtLabel.Parent = btn
			applyStroke(txtLabel, 1.2)
		end

		-- Hover Effects
		btn.MouseEnter:Connect(function()
			if ActivePanelName ~= config.Key then
				TweenService:Create(txtLabel, TweenInfo.new(0.15), { TextColor3 = COLOR_TEXT_WHITE }):Play()
			end
		end)

		btn.MouseLeave:Connect(function()
			if ActivePanelName ~= config.Key then
				TweenService:Create(txtLabel, TweenInfo.new(0.15), { TextColor3 = COLOR_TEXT_MUTED }):Play()
			end
		end)

		btn.MouseButton1Click:Connect(function()
			UIController.TogglePanel(config.Key)
		end)

		table.insert(navTabs, {
			Button = btn,
			Label = txtLabel,
			Key = config.Key,
		})
	end

	-- 4. Right Currencies (Spirit Stones & Sect Tokens)
	local stonesLabel = navFrame:FindFirstChild("SpiritStonesLabel") :: TextLabel?
	if not stonesLabel then
		stonesLabel = Instance.new("TextLabel")
		stonesLabel.Name = "SpiritStonesLabel"
		stonesLabel.Size = UDim2.new(0, 120, 0, 16)
		stonesLabel.Position = UDim2.new(1, -135, 0, 12)
		stonesLabel.BackgroundTransparency = 1
		stonesLabel.FontFace = FONT_PRIMARY
		stonesLabel.Text = string.format("%s Stones", formatCommas(PlayerSpiritStones))
		stonesLabel.TextColor3 = COLOR_TEXT_WHITE
		stonesLabel.TextSize = 10
		stonesLabel.TextXAlignment = Enum.TextXAlignment.Right
		stonesLabel.Parent = navFrame
		applyStroke(stonesLabel, 1.2)
	end

	local tokensLabel = navFrame:FindFirstChild("SectTokensLabel") :: TextLabel?
	if not tokensLabel then
		tokensLabel = Instance.new("TextLabel")
		tokensLabel.Name = "SectTokensLabel"
		tokensLabel.Size = UDim2.new(0, 120, 0, 16)
		tokensLabel.Position = UDim2.new(1, -135, 0, 32)
		tokensLabel.BackgroundTransparency = 1
		tokensLabel.FontFace = FONT_PRIMARY
		tokensLabel.Text = string.format("%s Tokens", formatCommas(PlayerSectTokens))
		tokensLabel.TextColor3 = COLOR_TEXT_GOLD
		tokensLabel.TextSize = 10
		tokensLabel.TextXAlignment = Enum.TextXAlignment.Right
		tokensLabel.Parent = navFrame
		applyStroke(tokensLabel, 1.2)
	end

	return {
		Frame = navFrame,
		AvatarImage = avatarImg,
		NameLabel = nameLabel,
		RankLabel = rankLabel,
		SpiritStonesLabel = stonesLabel,
		SectTokensLabel = tokensLabel,
		Tabs = navTabs,
	}
end

-- Update Tab Highlight States
local function updateTabHighlights()
	if not TopNavRefs then return end
	for _, tabData in ipairs(TopNavRefs.Tabs) do
		if tabData.Key == ActivePanelName then
			-- Glowing Gold for Active Tab
			TweenService:Create(tabData.Label, TweenInfo.new(0.2), { TextColor3 = COLOR_TEXT_GOLD }):Play()
		else
			TweenService:Create(tabData.Label, TweenInfo.new(0.2), { TextColor3 = COLOR_TEXT_MUTED }):Play()
		end
	end
end

-- ============================================================================
-- CONTROLLER MODULE API
-- ============================================================================

local UIController = {}

function UIController.TogglePanel(panelName: string)
	local targetPanel = PanelMap[panelName]

	if not targetPanel then
		local mainGui = PlayerGui:FindFirstChild("MainScreenGui")
		if mainGui then
			local found = mainGui:FindFirstChild(panelName .. "Panel") :: ImageLabel?
			if found then
				PanelMap[panelName] = found
				targetPanel = found
			end
		end
	end

	if not targetPanel then
		warn("[UI Error] Panel NOT FOUND in PanelMap for:", panelName)
		return
	end

	if ActivePanelName == panelName then
		UIController.CloseCurrentPanel()
		return
	end

	UIController.CloseCurrentPanel()

	ActivePanelName = panelName
	targetPanel.Visible = true
	updateTabHighlights()
	print("[UI Debug] SUCCESS: Opened panel ->", panelName)
end

function UIController.CloseCurrentPanel()
	if not ActivePanelName then return end
	local currentPanel = PanelMap[ActivePanelName]
	if currentPanel then
		currentPanel.Visible = false
		print("[UI Debug] Closed panel ->", ActivePanelName)
	end
	ActivePanelName = nil
	updateTabHighlights()
end

function UIController.UpdateCurrencies(stones: number, tokens: number)
	PlayerSpiritStones = stones
	PlayerSectTokens = tokens

	if TopNavRefs then
		TopNavRefs.SpiritStonesLabel.Text = string.format("%s Stones", formatCommas(stones))
		TopNavRefs.SectTokensLabel.Text = string.format("%s Tokens", formatCommas(tokens))
	end
end

function UIController.UpdateHealth(currentHp: number, maxHp: number)
	if not HudRefs or not HudRefs.Health then return end

	local safeMax = math.max(1, maxHp)
	local percent = math.clamp(currentHp / safeMax, 0, 1)

	HudRefs.Health.TextLabel.Text = string.format("%d / %d HP", math.floor(math.max(0, currentHp)), math.floor(safeMax))

	TweenService:Create(HudRefs.Health.Fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(percent, 0, 1, 0)
	}):Play()
end

function UIController.UpdateCultivationState(state: any)
	if not state then return end

	local currentQi = state.CurrentQi or 0
	local maxQi = math.max(1, state.MaxQi or 100)

	if HudRefs and HudRefs.Qi then
		local percent = math.clamp(currentQi / maxQi, 0, 1)
		HudRefs.Qi.TextLabel.Text = string.format("%d / %d Spirit Qi", math.floor(currentQi), math.floor(maxQi))

		TweenService:Create(HudRefs.Qi.Fill, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(percent, 0, 1, 0)
		}):Play()
	end

	-- Update Rank Label on Top Navigation Header
	if TopNavRefs and state.RealmLevel then
		local realmData = RealmsConfig.Realms[state.RealmLevel]
		local realmName = realmData and realmData.StageName or "Mortal Body"
		local stageNames = { "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th" }
		local stageText = stageNames[state.MinorStage] or string.format("%d", state.MinorStage)

		TopNavRefs.RankLabel.Text = string.format("%s · %s Order", realmName, stageText)
	end
end

function UIController.SetupKeybindings()
	UserInputService.InputBegan:Connect(function(input, _gameProcessed)
		if isTypingInChat() then return end

		if input.KeyCode == Enum.KeyCode.I or input.KeyCode == Enum.KeyCode.B then
			UIController.TogglePanel("Inventory")
		elseif input.KeyCode == Enum.KeyCode.C then
			UIController.TogglePanel("Character")
		elseif input.KeyCode == Enum.KeyCode.K then
			UIController.TogglePanel("Skills")
		elseif input.KeyCode == Enum.KeyCode.N then
			UIController.TogglePanel("WorldMap")
		elseif input.KeyCode == Enum.KeyCode.O then
			UIController.TogglePanel("Settings")
		elseif input.KeyCode == Enum.KeyCode.Escape then
			UIController.CloseCurrentPanel()
		end
	end)
end

function UIController.Init()
	if isInitialized then return end
	isInitialized = true

	local combatGui = PlayerGui:WaitForChild("CombatHUDGui", 5) :: ScreenGui?
	local mainGui   = PlayerGui:WaitForChild("MainScreenGui", 5) :: ScreenGui?

	if combatGui then
		local vitality = combatGui:FindFirstChild("VitalityCluster") :: ImageLabel?
		if vitality then
			HudRefs = {
				VitalityCluster = vitality,
				Health  = getTrackRefs(vitality, "HealthTrack"),
				Posture = getTrackRefs(vitality, "PostureTrack"),
				Stamina = getTrackRefs(vitality, "StaminaTrack"),
				Qi      = getTrackRefs(vitality, "QiTrack"),
			}
		end
	end

	if mainGui then
		local navFrame = mainGui:FindFirstChild("TopNavigationFrame") :: ImageLabel?
		if navFrame then
			TopNavRefs = setupTopNavigationBar(navFrame)
		end

		local function registerPanel(keyName: string, defaultName: string)
			local found = mainGui:FindFirstChild(defaultName) :: ImageLabel?
			if not found then
				for _, child in ipairs(mainGui:GetChildren()) do
					if child:IsA("ImageLabel") and string.find(string.lower(child.Name), string.lower(keyName)) then
						found = child
						break
					end
				end
			end
			if found then
				PanelMap[keyName] = found
			end
		end

		registerPanel("Character", "CharacterPanel")
		registerPanel("Inventory", "InventoryPanel")
		registerPanel("Skills",    "SkillsPanel")
		registerPanel("Alchemy",   "AlchemyPanel")
		registerPanel("WorldMap",  "WorldMapPanel")
		registerPanel("Settings",  "SettingsPanel")

		local instancesToPreload: { Instance } = {}
		for _, panelImage in pairs(PanelMap) do
			if panelImage then
				panelImage.BackgroundTransparency = 1
				panelImage.BackgroundColor3 = COLOR_OBSIDIAN_BG
				table.insert(instancesToPreload, panelImage)
			end
		end

		task.spawn(function()
			ContentProvider:PreloadAsync(instancesToPreload)
		end)
	end

	local function bindCharacter(character: Model)
		local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
		if humanoid then
			humanoid.HealthChanged:Connect(function()
				UIController.UpdateHealth(humanoid.Health, humanoid.MaxHealth)
			end)
			UIController.UpdateHealth(humanoid.Health, humanoid.MaxHealth)
		end
	end

	LocalPlayer.CharacterAdded:Connect(bindCharacter)
	if LocalPlayer.Character then
		bindCharacter(LocalPlayer.Character)
	end

	CultivationUpdatedRemote.OnClientEvent:Connect(function(state: any)
		UIController.UpdateCultivationState(state)
	end)

	UIController.SetupKeybindings()
	print(">>> [REALMBREAKER] TASK A: TOP NAVIGATION & CURRENCIES LIVE <<<")
end

UIController.Init()

return UIController