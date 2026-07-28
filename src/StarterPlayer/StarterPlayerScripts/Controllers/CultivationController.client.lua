--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local LocalPlayer = Players.LocalPlayer

-- Safe Remotes Setup
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10) :: Folder
local ToggleMeditationRemote = Remotes:WaitForChild("ToggleMeditation", 10) :: RemoteFunction
local CultivationUpdatedRemote = Remotes:WaitForChild("CultivationUpdated", 10) :: RemoteEvent

-- CUSTOM FLOATING MEDITATION ANIMATION ID
local FLOATING_ANIM_ID = "rbxassetid://116333173300889"
local floatAnimation = Instance.new("Animation")
floatAnimation.AnimationId = FLOATING_ANIM_ID

--------------------------------------------------------------------------------
-- ⚙️ FLOATING & ANIMATION TUNING CONFIGURATION
--------------------------------------------------------------------------------
local FLOAT_HEIGHT = 0.8          -- Hover distance above floor (0.8 studs)
local ANIMATION_SPEED = 0.08      -- Ultra-slow breathing float speed (8%)

-- Keeps movement in a small, tight range (prevents big swings)
local MIN_RANGE_PERCENT = 0.25    -- Start range at 25% of timeline
local MAX_RANGE_PERCENT = 0.75    -- End range at 75% of timeline
--------------------------------------------------------------------------------

local activeAnimTrack: AnimationTrack? = nil
local pingPongThread: thread? = nil
local isMeditatingState: boolean = false
local currentRealmLevel: number = 1

-- Dynamic Aura Color per 3 Realms
local function getAuraColor(realmLevel: number): Color3
	if realmLevel <= 3 then
		return Color3.fromRGB(100, 200, 255)  -- Realms 1-3: Light Blue / Cyan
	elseif realmLevel <= 6 then
		return Color3.fromRGB(170, 50, 255)  -- Realms 4-6: Royal Purple / Violet
	elseif realmLevel <= 9 then
		return Color3.fromRGB(255, 50, 80)   -- Realms 7-9: Crimson Red
	else
		return Color3.fromRGB(255, 215, 0)   -- Realms 10-12: Divine Celestial Gold
	end
end

local CultivationController = {}

function CultivationController.Init()
	-- Preload animation in background to eliminate first-press lag
	task.spawn(function()
		ContentProvider:PreloadAsync({ floatAnimation })
		print(">>> MEDITATION ANIMATION PRELOADED <<<")
	end)

	print(">>> CULTIVATION CONTROLLER STARTED (Subtle Gentle Float Active) <<<")

	-- Listen for Key 'M'
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.M then
			print("[CultivationController] 'M' Key Pressed! Toggling subtle floating meditation...")

			local isMeditating = ToggleMeditationRemote:InvokeServer()
			CultivationController._setMeditationVisuals(isMeditating)
		end

		--This is a temporary code for aura testing (N key)
		if input.KeyCode == Enum.KeyCode.N then
			currentRealmLevel += 3
			if currentRealmLevel > 12 then currentRealmLevel = 1 end

			print(string.format("🧪 [Aura Test] Switched to Realm Level: %d", currentRealmLevel))

			local character = LocalPlayer.Character
			if character and isMeditatingState then
				CultivationController._toggleAura(character, false) -- Refresh aura
				CultivationController._toggleAura(character, true)
			end
		end
		
		-- Test Key 'B': Instantly Fills Spirit Qi & Triggers Breakthrough
		if input.KeyCode == Enum.KeyCode.B then
			print("🧪 [Test] 'B' Key Pressed! Triggering instant breakthrough...")
			local testRemote = Remotes:FindFirstChild("TestBreakthrough") :: RemoteEvent?
			if testRemote then
				testRemote:FireServer()
			end
		end

	end)

	-- Sync state from server
	CultivationUpdatedRemote.OnClientEvent:Connect(CultivationController._onStateUpdated)
end

local activeMeditationSound: Sound? = nil

function CultivationController._setMeditationVisuals(isMeditating: boolean)
	isMeditatingState = isMeditating
	local character = LocalPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not humanoid or not rootPart then return end

	local animator = humanoid:FindFirstChildOfClass("Animator")

	if isMeditating then
		print("[CultivationController] 🧘 Entering Subtle Gentle Float...")

		-- 1. Play Looped Meditation SFX on Character RootPart
		if not activeMeditationSound then
			activeMeditationSound = Instance.new("Sound")
			activeMeditationSound.Name = "ActiveMeditationSFX"
			activeMeditationSound.SoundId = "rbxassetid://124551555247426"
			activeMeditationSound.Volume = 0.4
			activeMeditationSound.PlaybackSpeed = 0.5 -- Deep low energy hum
			activeMeditationSound.Looped = true
			activeMeditationSound.Parent = rootPart
			activeMeditationSound:Play()
		end

		-- 2. Stop default running/idle animation tracks
		if animator then
			for _, track in animator:GetPlayingAnimationTracks() do
				track:Stop(0.1)
			end
		end

		-- 3. Lock controls & disable freefall physics
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.JumpHeight = 0
		humanoid.PlatformStand = true
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

		-- 4. Play animation FIRST so character adopts meditation pose
		if animator then
			activeAnimTrack = animator:LoadAnimation(floatAnimation)
			if activeAnimTrack then
				activeAnimTrack.Priority = Enum.AnimationPriority.Action4
				activeAnimTrack.Looped = false
				activeAnimTrack:Play(0.1, 1.0, ANIMATION_SPEED)
				activeAnimTrack.TimePosition = activeAnimTrack.Length * MIN_RANGE_PERCENT
			end
		end

		-- 5. Brief wait (0.05s) for pose to apply, then lift & anchor
		task.wait(0.05)
		if isMeditatingState then
			rootPart.CFrame = rootPart.CFrame * CFrame.new(0, FLOAT_HEIGHT, 0)
			rootPart.Anchored = true
			CultivationController._startPingPongLoop()
			CultivationController._toggleAura(character, true)
		end
	else
		print("[CultivationController] 🚶 Exiting Floating Meditation...")

		-- 1. Stop & Destroy Meditation SFX
		if activeMeditationSound then
			activeMeditationSound:Stop()
			activeMeditationSound:Destroy()
			activeMeditationSound = nil
		end

		-- 2. Immediately Unanchor & Re-enable Normal Character Physics
		rootPart.Anchored = false
		humanoid.PlatformStand = false
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

		-- 3. Cancel Ping-Pong & Stop Animation
		if pingPongThread then
			task.cancel(pingPongThread)
			pingPongThread = nil
		end

		if activeAnimTrack then
			activeAnimTrack:Stop(0.2)
			activeAnimTrack = nil
		end

		-- 4. Turn off Aura & Restore Movement
		CultivationController._toggleAura(character, false)
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
		humanoid.JumpHeight = 7.2
	end
end

-- Clamps keyframe playback between 25% and 75% for a subtle, tight motion range
function CultivationController._startPingPongLoop()
	if pingPongThread then
		task.cancel(pingPongThread)
	end

	pingPongThread = task.spawn(function()
		local movingForward = true

		while isMeditatingState and activeAnimTrack do
			task.wait(0.03)
			if not activeAnimTrack then break end

			local trackLength = activeAnimTrack.Length
			local currentPos = activeAnimTrack.TimePosition

			local minBound = trackLength * MIN_RANGE_PERCENT
			local maxBound = trackLength * MAX_RANGE_PERCENT

			-- Reverse direction at max bound (clips large swing)
			if movingForward and currentPos >= maxBound then
				movingForward = false
				activeAnimTrack:AdjustSpeed(-ANIMATION_SPEED)
				-- Forward direction at min bound
			elseif not movingForward and currentPos <= minBound then
				movingForward = true
				activeAnimTrack:AdjustSpeed(ANIMATION_SPEED)
			end
		end
	end)
end

-- Your exact body aura structure with density scaling per realm level
function CultivationController._toggleAura(character: Model, enable: boolean)
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not rootPart then return end

	if enable then
		local auraColor = getAuraColor(currentRealmLevel)

		-- Density Calculation (Higher Realms = Denser Fill & More Particles)
		local realmFactor = math.clamp(currentRealmLevel / 12, 0, 1)
		local fillTrans = 0.85 - (realmFactor * 0.35) -- Fill gets denser (0.85 -> 0.50)
		local particleRate = 15 + math.floor(realmFactor * 40) -- Density scaling (15 -> 55)

		-- 1. Defined Body Border Line & Density Highlight
		local highlight = character:FindFirstChild("MeditationAuraBorder") :: Highlight
		if not highlight then
			highlight = Instance.new("Highlight")
			highlight.Name = "MeditationAuraBorder"
			highlight.FillColor = auraColor
			highlight.FillTransparency = fillTrans -- Progressively denser
			highlight.OutlineColor = auraColor
			highlight.OutlineTransparency = 0.0 -- Sharp defined line on player body
			highlight.Parent = character
		end

		-- 2. Dynamic Moving Body Aura Particles (Progressive Density)
		local attachment = rootPart:FindFirstChild("AuraAttachment") :: Attachment
		if not attachment then
			attachment = Instance.new("Attachment")
			attachment.Name = "AuraAttachment"
			attachment.Parent = rootPart

			local particle = Instance.new("ParticleEmitter")
			particle.Name = "MeditationParticles"
			particle.Texture = "rbxassetid://243098098" -- Your aura texture
			particle.Color = ColorSequence.new(auraColor)
			particle.LightEmission = 0.7 + (realmFactor * 0.25)
			particle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 4) })
			particle.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4 - (realmFactor * 0.2)), NumberSequenceKeypoint.new(1, 1) })
			particle.Lifetime = NumberRange.new(1, 2)
			particle.Rate = particleRate -- Denser rate per level
			particle.Speed = NumberRange.new(1, 3)
			particle.SpreadAngle = Vector2.new(180, 180)
			particle.RotSpeed = NumberRange.new(-50, 50)
			particle.Parent = attachment
		end
	else
		-- Turn Off & Clean Up Aura
		local highlight = character:FindFirstChild("MeditationAuraBorder")
		if highlight then highlight:Destroy() end

		local attachment = rootPart:FindFirstChild("AuraAttachment")
		if attachment then attachment:Destroy() end
	end
end

function CultivationController._onStateUpdated(state: any)
	if state and state.RealmLevel then
		currentRealmLevel = state.RealmLevel
	end
end

-- Initialize Controller
CultivationController.Init()

return CultivationController