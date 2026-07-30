--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer :: Player
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local ItemsConfig = require(Config:WaitForChild("ItemsConfig") :: ModuleScript)

local FONT_PRIMARY = Font.fromEnum(Enum.Font.FredokaOne)

-- Types
type InventorySlot = {
	ItemId: string,
	Amount: number,
}

local CurrentInventory: { InventorySlot } = {
	{ ItemId = "Pill_Vitality_Minor", Amount = 5 },
	{ ItemId = "Pill_Qi_Minor", Amount = 12 },
	{ ItemId = "Weapon_WaterSword", Amount = 1 },
	{ ItemId = "Herb_SpiritGrass", Amount = 34 },
}

local SelectedFilter: string = "All"
local SelectedSlotIndex: number? = nil

local InventoryController = {}

-- ============================================================================
-- INSPECTOR UPDATE
-- ============================================================================

local function updateInspector(inspectorFrame: Frame, itemId: string?, amount: number)
	local nameLabel = inspectorFrame:FindFirstChild("ItemName") :: TextLabel?
	local gradeLabel = inspectorFrame:FindFirstChild("ItemGrade") :: TextLabel?
	local descLabel = inspectorFrame:FindFirstChild("ItemDesc") :: TextLabel?
	local iconLabel = inspectorFrame:FindFirstChild("ItemIcon") :: ImageLabel?

	if not itemId or not ItemsConfig[itemId] then
		if nameLabel then nameLabel.Text = "Select an Item" end
		if gradeLabel then gradeLabel.Text = "" end
		if descLabel then descLabel.Text = "Click an item in your inventory to inspect its details." end
		return
	end

	local itemData = ItemsConfig[itemId]
	if nameLabel then nameLabel.Text = itemData.Name end
	if gradeLabel then gradeLabel.Text = string.format("%s Grade · %s", itemData.Grade, itemData.Category) end
	if descLabel then descLabel.Text = itemData.Description end
	if iconLabel then iconLabel.Image = itemData.Icon end
end

-- ============================================================================
-- DYNAMIC GRID RENDERER
-- ============================================================================

function InventoryController.RenderGrid(gridContainer: ScrollingFrame, inspectorFrame: Frame)
	-- Clear old item slots
	for _, child in ipairs(gridContainer:GetChildren()) do
		if child:IsA("ImageButton") then
			child:Destroy()
		end
	end

	for index, slotData in ipairs(CurrentInventory) do
		local itemData = ItemsConfig[slotData.ItemId]
		if not itemData then continue end

		-- Category Filtering
		if SelectedFilter ~= "All" and itemData.Category ~= SelectedFilter then
			continue
		end

		-- Create Item Slot Button
		local slotBtn = Instance.new("ImageButton")
		slotBtn.Name = "Slot_" .. index
		slotBtn.BackgroundColor3 = Color3.fromRGB(16, 20, 26)
		slotBtn.BorderSizePixel = 0

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = slotBtn

		local stroke = Instance.new("UIStroke")
		stroke.Color = (SelectedSlotIndex == index) and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(42, 58, 53)
		stroke.Thickness = (SelectedSlotIndex == index) and 1.8 or 1
		stroke.Parent = slotBtn

		-- Item Icon
		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.Size = UDim2.new(0.8, 0, 0.8, 0)
		icon.Position = UDim2.new(0.1, 0, 0.1, 0)
		icon.BackgroundTransparency = 1
		icon.Image = itemData.Icon
		icon.Parent = slotBtn

		-- Stack Amount Counter
		if slotData.Amount > 1 then
			local countLabel = Instance.new("TextLabel")
			countLabel.Name = "AmountLabel"
			countLabel.Size = UDim2.new(0, 20, 0, 14)
			countLabel.Position = UDim2.new(1, -22, 1, -16)
			countLabel.BackgroundTransparency = 1
			countLabel.FontFace = FONT_PRIMARY
			countLabel.Text = tostring(slotData.Amount)
			countLabel.TextColor3 = Color3.fromRGB(245, 248, 255)
			countLabel.TextSize = 10
			countLabel.Parent = slotBtn

			local strokeText = Instance.new("UIStroke")
			strokeText.Thickness = 1.2
			strokeText.Parent = countLabel
		end

		-- Click Event to Select / Inspect Item
		slotBtn.MouseButton1Click:Connect(function()
			SelectedSlotIndex = index
			InventoryController.RenderGrid(gridContainer, inspectorFrame)
			updateInspector(inspectorFrame, slotData.ItemId, slotData.Amount)
		end)

		slotBtn.Parent = gridContainer
	end
end

function InventoryController.Init()
	local mainGui = PlayerGui:WaitForChild("MainScreenGui", 5) :: ScreenGui?
	if not mainGui then return end

	local invPanel = mainGui:FindFirstChild("InventoryPanel") :: ImageLabel?
	if not invPanel then return end

	local gridContainer = invPanel:FindFirstChild("ItemGridContainer") :: ScrollingFrame?
	local inspectorFrame = invPanel:FindFirstChild("RightInspector") :: Frame?

	if gridContainer and inspectorFrame then
		InventoryController.RenderGrid(gridContainer, inspectorFrame)
	end

	print(">>> [Realmbreaker] DYNAMIC INVENTORY CONTROLLER INITIALIZED <<<")
end

InventoryController.Init()

return InventoryController