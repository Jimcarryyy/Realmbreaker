--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local ReplicaController = require(ReplicatedStorage:WaitForChild("ReplicaController"))

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
local MIN_RANGE_PERCENT = 0.25    -- Start range at 25% of timeline
local MAX_RANGE_PERCENT = 0.75    -- End range at 75% of timeline

-- TRANSITION EASING TIMINGS (Natural & Responsive)
local LIFT_DURATION = 0.35        -- Time to float up (seconds)
local DESCENT_DURATION = 0.28     -- Time to descend to ground (seconds)
local ANIM_FADE_TIME = 0.25       -- Animation blend fade time (seconds)
--------------------------------------------------------------------------------

local activeAnimTrack: AnimationTrack? = nil
local pingPongThread: thread? = nil
local activeTween: Tween? = nil
local isMeditatingState: boolean = false
local currentRealmLevel: number = 1
local activeMeditationSound: Sound? = nil
local isInitialized: boolean = false

-- RACE CONDITION & TWEEN CANCELLATION SAFEGUARDS
local lastInputTime: number = 0
local meditationSessionId: number = 0

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
	if isInitialized then return end
	isInitialized = true

	task.spawn(function()
		pcall(function()
			ContentProvider:PreloadAsync({ floatAnimation })
		end)
	end)

	print(">>> CULTIVATION CONTROLLER STARTED (Smooth Ethereal Easing Active) <<<")

	-- ADD: Listen to the player's replica to govern current progression stats
	ReplicaController.ReplicaOfClassCreated("PlayerReplica", function(replica)
		local function updateFromReplica()
			local cultivation = replica.Data.Cultivation
			if cultivation then
				currentRealmLevel = cultivation.RealmTier + 1
				print(string.format("[ReplicaSync] Updated currentRealmLevel to %d from Replica", currentRealmLevel))
			end
		end

		updateFromReplica()
		replica:ListenToChange({"Cultivation"}, updateFromReplica)
	end)

	-- Listen for Key 'M' with 0.3s Input Debounce
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.M then
			local now = os.clock()
			if (now - lastInputTime) < 0.3 then return end
			lastInputTime = now

			print("[CultivationController] 'M' Key Pressed -> Requesting Server Toggle...")
			task.spawn(function()
				ToggleMeditationRemote:InvokeServer()
			end)
		end
	end)

	-- Single Authority Listener: Visuals update strictly from Server State
	CultivationUpdatedRemote.OnClientEvent:Connect(CultivationController._onStateUpdated)
end

function CultivationController._setMeditationVisuals(isMeditating: boolean)
	if isMeditatingState == isMeditating then return end
	isMeditatingState = isMeditating

	-- Increment session token to cancel any running tweens/yields from previous state
	meditationSessionId += 1
	local currentSessionToken = meditationSessionId

	if activeTween then
		activeTween:Cancel()
		activeTween = nil
	end

	local character = LocalPlayer.Character
	if not character then return end

	local humanoid = character:WaitForChild("Humanoid", 5) :: Humanoid?
	local rootPart = character:WaitForChild("HumanoidRootPart", 5) :: BasePart?
	if not humanoid or not rootPart then return end

	local animator = humanoid:WaitForChild("Animator", 5) :: Animator?

	if isMeditating then
		print(string.format("🧘 [Session #%d] Smoothly Floating Up...", currentSessionToken))

		-- 1. Play Looped SFX
		if not activeMeditationSound then
			local sound = Instance.new("Sound")
			sound.Name = "ActiveMeditationSFX"
			sound.SoundId = "rbxassetid://124551555247426"
			sound.Volume = 0.4
			sound.PlaybackSpeed = 0.5
			sound.Looped = true
			sound.Parent = rootPart
			pcall(function() sound:Play() end)
			activeMeditationSound = sound
		end

		-- 2. Lock movement
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.JumpHeight = 0

		-- 3. Smooth Animation Blend (Fade in over 0.25s)
		if animator then
			activeAnimTrack = animator:LoadAnimation(floatAnimation)
			if activeAnimTrack then
				activeAnimTrack.Priority = Enum.AnimationPriority.Action4
				activeAnimTrack.Looped = false
				activeAnimTrack:Play(ANIM_FADE_TIME, 1.0, ANIMATION_SPEED)

				local elapsed = 0
				while activeAnimTrack.Length == 0 and elapsed < 1 do
					task.wait(0.05)
					elapsed += 0.05
					if currentSessionToken ~= meditationSessionId or not isMeditatingState then return end
				end

				if activeAnimTrack and activeAnimTrack.Length > 0 then
					activeAnimTrack.TimePosition = activeAnimTrack.Length * MIN_RANGE_PERCENT
				end
			end
		end

		-- 4. Ethereal Vertical Lift-Off (Smooth 0.35s Sine-Out Tween)
		rootPart.Anchored = true
		local targetCFrame = rootPart.CFrame * CFrame.new(0, FLOAT_HEIGHT, 0)
		activeTween = TweenService:Create(
			rootPart,
			TweenInfo.new(LIFT_DURATION, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ CFrame = targetCFrame }
		)
		activeTween:Play()

		-- 5. Enable Aura & Breathing Motion
		CultivationController._toggleAura(character, true)
		CultivationController._startPingPongLoop()

	else
		print(string.format("🚶 [Session #%d] Gently Descending to Ground...", currentSessionToken))

		-- 1. Stop ping-pong thread
		if pingPongThread then
			task.cancel(pingPongThread)
			pingPongThread = nil
		end

		-- 2. Smooth Animation Blend (Fade out over 0.25s)
		if activeAnimTrack then
			activeAnimTrack:Stop(ANIM_FADE_TIME)
			activeAnimTrack = nil
		end

		-- 3. Stop Sound
		if activeMeditationSound then
			pcall(function() activeMeditationSound:Stop() end)
			activeMeditationSound:Destroy()
			activeMeditationSound = nil
		end

		-- 4. Gentle Descent back to Ground (Smooth 0.28s Sine-In Tween)
		if rootPart.Anchored then
			local targetCFrame = rootPart.CFrame * CFrame.new(0, -FLOAT_HEIGHT, 0)
			activeTween = TweenService:Create(
				rootPart,
				TweenInfo.new(DESCENT_DURATION, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
				{ CFrame = targetCFrame }
			)
			activeTween:Play()

			-- Restore unanchored movement physics after descent finishes
			task.delay(DESCENT_DURATION, function()
				if currentSessionToken == meditationSessionId and not isMeditatingState then
					rootPart.Anchored = false
					humanoid.WalkSpeed = 16
					humanoid.JumpPower = 50
					humanoid.JumpHeight = 7.2
				end
			end)
		else
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
			humanoid.JumpHeight = 7.2
		end

		-- 5. Fade out Aura
		CultivationController._toggleAura(character, false)
	end
end

function CultivationController._startPingPongLoop()
	if pingPongThread then task.cancel(pingPongThread) end

	local currentSessionToken = meditationSessionId

	pingPongThread = task.spawn(function()
		local movingForward = true

		while isMeditatingState and activeAnimTrack and currentSessionToken == meditationSessionId do
			task.wait(0.03)
			if not activeAnimTrack or currentSessionToken ~= meditationSessionId then break end

			local trackLength = activeAnimTrack.Length
			if trackLength == 0 then continue end

			local currentPos = activeAnimTrack.TimePosition
			local minBound = trackLength * MIN_RANGE_PERCENT
			local maxBound = trackLength * MAX_RANGE_PERCENT

			if movingForward and currentPos >= maxBound then
				movingForward = false
				activeAnimTrack:AdjustSpeed(-ANIMATION_SPEED)
			elseif not movingForward and currentPos <= minBound then
				movingForward = true
				activeAnimTrack:AdjustSpeed(ANIMATION_SPEED)
			end
		end
	end)
end

function CultivationController._toggleAura(character: Model, enable: boolean)
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not rootPart then return end

	if enable then
		local auraColor = getAuraColor(currentRealmLevel)
		local realmFactor = math.clamp(currentRealmLevel / 12, 0, 1)
		local fillTrans = 0.85 - (realmFactor * 0.35)
		local particleRate = 15 + math.floor(realmFactor * 40)

		-- 1. Highlight Border (Fades in)
		local highlight = character:FindFirstChild("MeditationAuraBorder") :: Highlight?
		if not highlight then
			highlight = Instance.new("Highlight")
			highlight.Name = "MeditationAuraBorder"
			highlight.FillColor = auraColor
			highlight.FillTransparency = 1.0 -- Start transparent
			highlight.OutlineColor = auraColor
			highlight.OutlineTransparency = 1.0 -- Start transparent
			highlight.Parent = character

			-- Smooth fade-in tween for highlight
			TweenService:Create(highlight, TweenInfo.new(0.35), {
				FillTransparency = fillTrans,
				OutlineTransparency = 0.0
			}):Play()
		end

		-- 2. Aura Particles
		local attachment = rootPart:FindFirstChild("AuraAttachment") :: Attachment?
		if not attachment then
			attachment = Instance.new("Attachment")
			attachment.Name = "AuraAttachment"
			attachment.Parent = rootPart

			local particle = Instance.new("ParticleEmitter")
			particle.Name = "MeditationParticles"
			particle.Texture = "rbxassetid://243098098"
			particle.Color = ColorSequence.new(auraColor)
			particle.LightEmission = 0.7 + (realmFactor * 0.25)
			particle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 4) })
			particle.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4 - (realmFactor * 0.2)), NumberSequenceKeypoint.new(1, 1) })
			particle.Lifetime = NumberRange.new(1, 2)
			particle.Rate = particleRate
			particle.Speed = NumberRange.new(1, 3)
			particle.SpreadAngle = Vector2.new(180, 180)
			particle.RotSpeed = NumberRange.new(-50, 50)
			particle.Parent = attachment
		end
	else
		-- Smooth fade-out for Highlight before destroying
		local highlight = character:FindFirstChild("MeditationAuraBorder") :: Highlight?
		if highlight then
			local tween = TweenService:Create(highlight, TweenInfo.new(0.25), {
				FillTransparency = 1.0,
				OutlineTransparency = 1.0
			})
			tween:Play()
			tween.Completed:Connect(function()
				highlight:Destroy()
			end)
		end

		local attachment = rootPart:FindFirstChild("AuraAttachment")
		if attachment then attachment:Destroy() end
	end
end

function CultivationController._onStateUpdated(state: any)
	if not state then return end

	if state.RealmLevel then
		currentRealmLevel = state.RealmLevel
	end

	if state.IsMeditating ~= nil then
		CultivationController._setMeditationVisuals(state.IsMeditating)
	end
end

return CultivationController