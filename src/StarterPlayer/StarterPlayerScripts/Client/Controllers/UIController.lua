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

local FONT_PRIMARY = Font.fromEnum(Enum.Font.FredokaOne)
local COLOR_OBSIDIAN_BG = Color3.fromRGB(18, 22, 26)

local isInitialized = false
local ActivePanelName: string? = nil
local PanelMap: { [string]: ImageLabel } = {}

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

local function isTypingInChat(): boolean
	local focusedTextBox = UserInputService:GetFocusedTextBox()
	return focusedTextBox ~= nil
end

local UIController = {}

function UIController.TogglePanel(panelName: string)
	local targetPanel = PanelMap[panelName]

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
	if not HudRefs or not HudRefs.Qi or not state then return end

	local currentQi = state.CurrentQi or 0
	local maxQi = math.max(1, state.MaxQi or 100)
	local percent = math.clamp(currentQi / maxQi, 0, 1)

	HudRefs.Qi.TextLabel.Text = string.format("%d / %d Spirit Qi", math.floor(currentQi), math.floor(maxQi))

	TweenService:Create(HudRefs.Qi.Fill, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(percent, 0, 1, 0)
	}):Play()
end

function UIController.SetupKeybindings()
	UserInputService.InputBegan:Connect(function(input, _gameProcessed)
		if isTypingInChat() then return end

		-- B or I Key for Inventory
		if input.KeyCode == Enum.KeyCode.I or input.KeyCode == Enum.KeyCode.B then
			print("[UI Debug] Inventory Key Pressed (I/B)!")
			UIController.TogglePanel("Inventory")
		elseif input.KeyCode == Enum.KeyCode.C then
			print("[UI Debug] 'C' Key Pressed!")
			UIController.TogglePanel("Character")
		elseif input.KeyCode == Enum.KeyCode.K then
			print("[UI Debug] 'K' Key Pressed!")
			UIController.TogglePanel("Skills")
		elseif input.KeyCode == Enum.KeyCode.N then
			print("[UI Debug] 'N' Key Pressed!")
			UIController.TogglePanel("WorldMap")
		elseif input.KeyCode == Enum.KeyCode.O then
			print("[UI Debug] 'O' Key Pressed!")
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
		-- Register panels with Fuzzy Fallback Search
		local function registerPanel(keyName: string, defaultName: string)
			local found = mainGui:FindFirstChild(defaultName) :: ImageLabel?
			
			-- Fuzzy search if exact name wasn't found
			if not found then
				for _, child in ipairs(mainGui:GetChildren()) do
					if child:IsA("ImageLabel") and string.find(string.lower(child.Name), string.lower(keyName)) then
						found = child
						print(string.format("[UI Auto-Finder] Matched key '%s' to Explorer object '%s'", keyName, child.Name))
						break
					end
				end
			end

			if found then
				PanelMap[keyName] = found
			else
				warn(string.format("[UI Warning] Could NOT find panel for '%s' in MainScreenGui!", defaultName))
			end
		end

		registerPanel("Character", "CharacterPanel")
		registerPanel("Inventory", "InventoryPanel")
		registerPanel("Skills",    "SkillsPanel")
		registerPanel("Alchemy",   "AlchemyPanel")
		registerPanel("WorldMap",  "WorldMapPanel")
		registerPanel("Settings",  "SettingsPanel")

		-- Preload Textures
		local instancesToPreload: { Instance } = {}
		for panelKey, panelImage in pairs(PanelMap) do
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
	print(">>> [REALMBREAKER] UI CONTROLLER READY (INVENTORY B/I DUAL BIND ACTIVE) <<<")
end

UIController.Init()

return UIController