--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer :: Player
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local CombatRemote = Remotes:WaitForChild("CombatRemote") :: RemoteEvent

local UIController = require(script.Parent:WaitForChild("UIController") :: ModuleScript)

local isTyping = false

local CombatController = {}

-- ============================================================================
-- DODGE MOVEMENT IMPULSE
-- ============================================================================

local function performDodgeImpulse()
	local character = LocalPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not rootPart or not humanoid then return end

	-- Calculate Dodge Direction based on MoveDirection or Facing Direction
	local moveDir = humanoid.MoveDirection
	if moveDir.Magnitude < 0.1 then
		moveDir = -rootPart.CFrame.LookVector -- Backwards dash if standing still
	end

	-- Apply physical velocity impulse
	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.MaxForce = 100000
	linearVelocity.VectorVelocity = moveDir.Unit * 60 -- Fast directional dash
	linearVelocity.Attachment0 = rootPart:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", rootPart)
	linearVelocity.Parent = rootPart

	task.delay(0.15, function()
		linearVelocity:Destroy()
	end)
end

-- ============================================================================
-- INPUT LISTENERS ([F] Parry, [Q] Dodge)
-- ============================================================================

function CombatController.SetupInputs()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or UserInputService:GetFocusedTextBox() then return end

		-- [F] KEY: PARRY / GUARD
		if input.KeyCode == Enum.KeyCode.F then
			CombatRemote:FireServer("ParryIntent")
		
		-- [Q] KEY: DODGE / FLASH STEP
		elseif input.KeyCode == Enum.KeyCode.Q then
			CombatRemote:FireServer("DodgeIntent")
		end
	end)

	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.F then
			CombatRemote:FireServer("ReleaseGuard")
		end
	end)
end

function CombatController.Init()
	CombatController.SetupInputs()

	-- Server Event Listener
	CombatRemote.OnClientEvent:Connect(function(action: string, data: any)
		if action == "SyncCombatState" and data then
			-- Update Posture Bar on HUD
			local combatGui = PlayerGui:FindFirstChild("CombatHUDGui")
			if combatGui then
				local vitality = combatGui:FindFirstChild("VitalityCluster")
				if vitality then
					local postureTrack = vitality:FindFirstChild("PostureTrack")
					if postureTrack then
						local fill = postureTrack:FindFirstChild("Fill") :: Frame?
						local textLabel = postureTrack:FindFirstChild("ValueText") :: TextLabel?
						if fill and textLabel then
							local percent = math.clamp(data.CurrentPosture / data.MaxPosture, 0, 1)
							textLabel.Text = string.format("%d / %d Posture", math.floor(data.CurrentPosture), math.floor(data.MaxPosture))
							TweenService:Create(fill, TweenInfo.new(0.15), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
						end
					end

					-- Update Stamina Bar on HUD
					local staminaTrack = vitality:FindFirstChild("StaminaTrack")
					if staminaTrack then
						local fill = staminaTrack:FindFirstChild("Fill") :: Frame?
						local textLabel = staminaTrack:FindFirstChild("ValueText") :: TextLabel?
						if fill and textLabel then
							local percent = math.clamp(data.CurrentStamina / data.MaxStamina, 0, 1)
							textLabel.Text = string.format("%d / %d Stamina", math.floor(data.CurrentStamina), math.floor(data.MaxStamina))
							TweenService:Create(fill, TweenInfo.new(0.15), { Size = UDim2.new(percent, 0, 1, 0) }):Play()
						end
					end
				end
			end

		elseif action == "DodgeSuccess" then
			performDodgeImpulse()

		elseif action == "ParrySuccess" then
			print("✨ [Parry Success] Blocked 100% Damage!")
		end
	end)

	print(">>> [REALMBREAKER] COMBAT CONTROLLER INITIALIZED ([F] PARRY / [Q] DODGE ACTIVE) <<<")
end

CombatController.Init()

return CombatController