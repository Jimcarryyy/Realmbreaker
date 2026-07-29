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

local CUSTOM_FONT = Font.fromEnum(Enum.Font.GothamMedium)
local COLOR_OBSIDIAN_BG = Color3.fromRGB(16, 20, 28)
local COLOR_BORDER = Color3.fromRGB(50, 65, 85)
local COLOR_TEXT_WHITE = Color3.fromRGB(245, 248, 255)
local COLOR_HEALTH_FILL = Color3.fromRGB(46, 204, 113)
local COLOR_QI_FILL = Color3.fromRGB(52, 152, 219)

local realmLabel: TextLabel
local barFill: Frame
local qiText: TextLabel
local overheadTitleLabel: TextLabel

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

	LocalPlayer.CharacterAdded:Connect(UIController.SetupOverheadTitle)
	if LocalPlayer.Character then UIController.SetupOverheadTitle(LocalPlayer.Character) end

	CultivationUpdatedRemote.OnClientEvent:Connect(function(state: any)
		if not state then return end

		local realmData = RealmsConfig.Realms[state.RealmLevel]
		local realmName = realmData and realmData.StageName or "Mortal Body"
		local stageNames = { "Early", "Mid", "Late", "Peak" }
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

	local container = Instance.new("Frame")
	container.Name = "HUDContainer"
	container.Size = UDim2.new(0, 360, 0, 75)
	container.Position = UDim2.new(0.5, -180, 1, -95)
	container.BackgroundColor3 = COLOR_OBSIDIAN_BG
	container.BackgroundTransparency = 0.15
	container.BorderSizePixel = 0
	container.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Color = COLOR_BORDER
	stroke.Transparency = 0.3
	stroke.Thickness = 1.5
	stroke.Parent = container

	realmLabel = Instance.new("TextLabel")
	realmLabel.Size = UDim2.new(1, -24, 0, 24)
	realmLabel.Position = UDim2.new(0, 12, 0, 8)
	realmLabel.BackgroundTransparency = 1
	realmLabel.FontFace = CUSTOM_FONT
	realmLabel.Text = "Mortal Body — Early"
	realmLabel.TextColor3 = COLOR_TEXT_WHITE
	realmLabel.TextSize = 14
	realmLabel.Parent = container

	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.new(1, -24, 0, 20)
	barBg.Position = UDim2.new(0, 12, 0, 42)
	barBg.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
	barBg.BorderSizePixel = 0
	barBg.ClipsDescendants = true
	barBg.Parent = container

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 6)
	barCorner.Parent = barBg

	barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = COLOR_QI_FILL
	barFill.BorderSizePixel = 0
	barFill.Parent = barBg

	qiText = Instance.new("TextLabel")
	qiText.Size = UDim2.new(1, 0, 1, 0)
	qiText.BackgroundTransparency = 1
	qiText.FontFace = CUSTOM_FONT
	qiText.Text = "0 / 100 Spirit Qi"
	qiText.TextColor3 = COLOR_TEXT_WHITE
	qiText.TextSize = 12
	qiText.Parent = barBg

	local resetButton = Instance.new("TextButton")
	resetButton.Name = "ResetButton"
	resetButton.Size = UDim2.new(0, 90, 0, 28)
	resetButton.Position = UDim2.new(1, -100, 1, -40)
	resetButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	resetButton.FontFace = CUSTOM_FONT
	resetButton.Text = "Reset Stats"
	resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	resetButton.TextSize = 11
	resetButton.Parent = gui

	local resetCorner = Instance.new("UICorner")
	resetCorner.CornerRadius = UDim.new(0, 6)
	resetCorner.Parent = resetButton

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
	overheadTitleLabel.FontFace = CUSTOM_FONT
	overheadTitleLabel.Text = "Mortal Body — Early"
	overheadTitleLabel.TextColor3 = COLOR_TEXT_WHITE
	overheadTitleLabel.TextSize = 13
	overheadTitleLabel.Parent = bb

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

	local healthFill = Instance.new("Frame")
	healthFill.Size = UDim2.new(math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), 0, 1, 0)
	healthFill.BackgroundColor3 = COLOR_HEALTH_FILL
	healthFill.BorderSizePixel = 0
	healthFill.Parent = healthBg

	local healthText = Instance.new("TextLabel")
	healthText.Size = UDim2.new(1, 0, 1, 0)
	healthText.BackgroundTransparency = 1
	healthText.FontFace = CUSTOM_FONT
	healthText.Text = string.format("%d / %d HP", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
	healthText.TextColor3 = COLOR_TEXT_WHITE
	healthText.TextSize = 11
	healthText.Parent = healthBg

	humanoid.HealthChanged:Connect(function(newHealth)
		local percent = math.clamp(newHealth / humanoid.MaxHealth, 0, 1)
		healthText.Text = string.format("%d / %d HP", math.floor(math.max(0, newHealth)), math.floor(humanoid.MaxHealth))
		TweenService:Create(healthFill, TweenInfo.new(0.2), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
	end)
end

UIController.Init()

return UIController