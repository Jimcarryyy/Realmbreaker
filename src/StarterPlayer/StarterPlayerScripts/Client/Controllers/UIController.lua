--!strict
-- Location: StarterPlayer/StarterPlayerScripts/Client/Controllers/UIController.lua
-- Purpose: Central client-side UI state controller for Realmbreaker

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local UIController = {}
UIController.__index = UIController

local isInitialized = false
local currentOpenModal: ImageLabel? = nil

-- References to ScreenGuis
local mainHUDGui: ScreenGui
local modalsGui: ScreenGui
local modalBackdrop: Frame

-- Keybindings map to Modal Panel Names
local KEY_MAP: { [Enum.KeyCode]: string } = {
	[Enum.KeyCode.C] = "CharacterPanel",
	[Enum.KeyCode.B] = "InventoryPanel",
	[Enum.KeyCode.K] = "SkillsPanel",
	[Enum.KeyCode.M] = "WorldMapPanel",
	[Enum.KeyCode.N] = "WorldMapPanel",
	[Enum.KeyCode.O] = "SettingsPanel",
}

local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

--------------------------------------------------------------------------------
-- PRIVATE HELPER FUNCTIONS
--------------------------------------------------------------------------------

local function isTypingInChat(): boolean
	return UserInputService:GetFocusedTextBox() ~= nil
end

local function setBackdropState(visible: boolean)
	if visible then
		modalBackdrop.Visible = true
		TweenService:Create(modalBackdrop, TWEEN_INFO, { BackgroundTransparency = 0.4 }):Play()
	else
		local tween = TweenService:Create(modalBackdrop, TWEEN_INFO, { BackgroundTransparency = 1 })
		tween:Play()
		tween.Completed:Connect(function()
			if not currentOpenModal then
				modalBackdrop.Visible = false
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- PUBLIC CONTROLLER API
--------------------------------------------------------------------------------

function UIController.ToggleModal(modalName: string)
	if not modalsGui then
		return
	end

	local targetModal = modalsGui:FindFirstChild(modalName) :: ImageLabel?
	if not targetModal then
		warn("[UIController]: Target modal frame missing ->", modalName)
		return
	end

	-- If clicking the currently open modal, close it
	if currentOpenModal == targetModal then
		UIController.CloseAllModals()
		return
	end

	-- If another modal is open, close it first
	if currentOpenModal and currentOpenModal ~= targetModal then
		currentOpenModal.Visible = false
	end

	-- Open target modal
	currentOpenModal = targetModal
	targetModal.Visible = true
	setBackdropState(true)
end

function UIController.CloseAllModals()
	if currentOpenModal then
		currentOpenModal.Visible = false
		currentOpenModal = nil
	end
	setBackdropState(false)
end

function UIController.PreloadAssets()
	-- List of critical asset IDs to preload into GPU memory
	local assetList: { string } = {
		"rbxassetid://84276737641585", -- AlchemyPanel
		"rbxassetid://123841032076360", -- InventoryPanel
		"rbxassetid://86012045244236", -- CharacterPanel
		"rbxassetid://107226547729026", -- SkillsPanel
		"rbxassetid://131488945229260", -- WorldMapPanel
		"rbxassetid://127613233097676", -- SettingsPanel
		"rbxassetid://79576725327950", -- DialogueFrame
		"rbxassetid://110381792485649", -- CombatHUDOverlay
		"rbxassetid://122415586898423", -- TopNavigationFrame
		"rbxassetid://134065637826617", -- BossHealthBar
		"rbxassetid://112564321533982", -- TargetFrame
		"rbxassetid://131670772422654", -- QuestTrackerWidget
		"rbxassetid://92283672177848", -- TutorialHintBanner
		"rbxassetid://137701990579121", -- ModularSlot
		"rbxassetid://113117552011909", -- CloseButton
		"rbxassetid://90057641384840", -- PrimaryActionButton
	}

	task.spawn(function()
		local startTime = os.clock()
		ContentProvider:PreloadAsync(assetList)
		local elapsed = os.clock() - startTime
		print(string.format("[UIController]: Preloaded %d UI assets in %.2f seconds.", #assetList, elapsed))
	end)
end

function UIController.Init()
	if isInitialized then
		return
	end
	isInitialized = true

	-- Acquire ScreenGuis from PlayerGui
	mainHUDGui = PlayerGui:WaitForChild("MainHUDGui") :: ScreenGui
	modalsGui = PlayerGui:WaitForChild("ModalsGui") :: ScreenGui
	modalBackdrop = modalsGui:WaitForChild("ModalBackdrop") :: Frame

	-- Preload asset textures to prevent white loading flashes
	UIController.PreloadAssets()

	-- Automatically bind CloseButtons inside all modal frames
	for _, child in ipairs(modalsGui:GetChildren()) do
		if child:IsA("ImageLabel") then
			local closeButton = child:FindFirstChild("CloseButton") :: ImageButton?
			if closeButton then
				closeButton.MouseButton1Click:Connect(function()
					UIController.CloseAllModals()
				end)
			end
		end
	end

	-- Connect Global Input Handling
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed or isTypingInChat() then
			return
		end

		if input.KeyCode == Enum.KeyCode.Escape then
			if currentOpenModal then
				UIController.CloseAllModals()
			end
			return
		end

		local mappedModal = KEY_MAP[input.KeyCode]
		if mappedModal then
			UIController.ToggleModal(mappedModal)
		end
	end)

	print("[UIController]: Initialized successfully.")
end

return UIController