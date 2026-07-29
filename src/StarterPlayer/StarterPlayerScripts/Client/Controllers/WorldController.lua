--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes") :: Folder
local ZoneChangedRemote = Remotes:WaitForChild("ZoneChanged") :: RemoteEvent

local WorldController = {}

-- Sound Setup
local ambientSound = Instance.new("Sound")
ambientSound.Name = "AmbientSound"
ambientSound.Looped = true
ambientSound.Volume = 0
ambientSound.Parent = Workspace

function WorldController.Init()
	ZoneChangedRemote.OnClientEvent:Connect(WorldController.OnZoneChanged)
end

function WorldController.OnZoneChanged(zoneId: string, zoneConfig: any)
	-- 1. Smoothly Tween Lighting
	local tweenInfo = TweenInfo.new(2.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local targetLighting = {
		ClockTime = zoneConfig.LightingSettings.ClockTime,
		Brightness = zoneConfig.LightingSettings.Brightness,
		OutdoorAmbient = zoneConfig.LightingSettings.OutdoorAmbient,
		FogEnd = zoneConfig.LightingSettings.FogEnd,
	}

	TweenService:Create(Lighting, tweenInfo, targetLighting):Play()

	-- 2. Transition Sound
	if zoneConfig.AmbientAudioId and zoneConfig.AmbientAudioId ~= "" then
		local soundTweenOut = TweenService:Create(ambientSound, TweenInfo.new(1.0), { Volume = 0 })
		soundTweenOut:Play()

		soundTweenOut.Completed:Connect(function()
			ambientSound.SoundId = zoneConfig.AmbientAudioId
			ambientSound:Play()
			TweenService:Create(ambientSound, TweenInfo.new(1.0), { Volume = 0.5 }):Play()
		end)
	end

	-- 3. Display Region Banner (HUD Notification trigger)
	WorldController._displayBanner(zoneConfig.DisplayName)
end

function WorldController._displayBanner(displayName: string)
	-- Placeholder for UI notification service trigger
	print("[WorldController] NOW ENTERING: " .. displayName)
end

return WorldController