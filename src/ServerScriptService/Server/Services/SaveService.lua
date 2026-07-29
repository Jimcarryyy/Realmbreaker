--!strict
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileServiceModule = ServerScriptService:WaitForChild("Server"):WaitForChild("Modules"):WaitForChild("ProfileService")
local ProfileService = require(ProfileServiceModule)

local ReplicaService = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Modules"):WaitForChild("ReplicaService"))
local PlayerReplicaToken = ReplicaService.NewClassToken("PlayerReplica")
local sessionReplicas: { [Player]: any } = {}

-- Configurations
local LATEST_SCHEMA_VERSION = 1
local DISCORD_WEBHOOK_URL = "" -- Add webhook URL for emergency logs

-- DataStore Definitions
local PROFILE_STORE_NAME = "PlayerData_v1.0"
local BACKUP_STORE_NAME = "PlayerBackups_v1.0"

local BackupDataStore = DataStoreService:GetDataStore(BACKUP_STORE_NAME)

-- Luau Types for Database Schema
export type CultivationData = {
	RealmTier: number, -- 0 = Mortal, 1 = Qi Condensation, 2 = Foundation, 3 = Core
	SubStage: number,  -- 0 = Early, 1 = Mid, 2 = Late, 3 = Peak
	CurrentQi: number,
	MaxQi: number,
	QiPurity: number,  -- 0.50 to 1.00
	UnlockedMechanics: {
		QiGauge: boolean,
		AirDash: boolean,
		QiShield: boolean,
		Flight: boolean,
		DomainStance: boolean,
	}
}

export type EconomyData = {
	SpiritStones: number,
	SectTokens: number,
	PremiumGems: number,
}

export type InventoryItem = {
	SlotID: number,
	ItemID: string,
	Quantity: number,
	Durability: number,
	ItemTier: number,
	IsBound: boolean,
}

export type InventoryData = {
	MaxSlots: number,
	Items: { InventoryItem },
}

export type StanceProficiency = {
	Level: number,
	XP: number,
}

export type StanceMasteryData = {
	ActiveStance: string,
	Proficiencies: { [string]: StanceProficiency },
}

export type SocialData = {
	SectID: string,
	SectRank: number, -- 1 = Member, 2 = Elder, 3 = Leader
	InfamyPoints: number,
	BountyAmount: number,
}

export type SettingsData = {
	QiSenseColor: string,
	Keybinds: { [string]: any },
	AudioVolume: { [string]: any },
}

export type PlayerProfileData = {
	SchemaVersion: number,
	MetaData: {
		FirstJoined: number,
		LastOnline: number,
		PlayTimeTotal: number,
	},
	Cultivation: CultivationData,
	Economy: EconomyData,
	Inventory: InventoryData,
	StanceMastery: StanceMasteryData,
	Social: SocialData,
	Settings: SettingsData,
}

-- Type representing the Profile object returned by ProfileService
export type Profile = {
	Data: PlayerProfileData,
	MetaData: {
		ProfileBegins: number,
		SessionPublishTime: number,
		SaveCount: number,
		ActiveSession: { [number]: number }?,
		ForceLoadEnd: boolean,
	},
	MetaTags: { [string]: any },
	KeyInfo: DataStoreKeyInfo,
	KeyName: string,
	IsActive: (self: any) -> boolean,
	GetMetaTag: (self: any, tag_name: string) -> any,
	Save: (self: any) -> (),
	Release: (self: any) -> (),
	ListenToRelease: (self: any, listener: (place_id: number, game_job_id: string) -> ()) -> any,
	ListenToHopReady: (self: any, listener: () -> ()) -> any,
	AddUserId: (self: any, user_id: number) -> (),
	RemoveUserId: (self: any, user_id: number) -> (),
	Reconcile: (self: any) -> (),
}

-- Default Template defined in 22_DATABASE_DESIGN.md
local DefaultTemplate: PlayerProfileData = {
	SchemaVersion = LATEST_SCHEMA_VERSION,
	MetaData = {
		FirstJoined = 0,
		LastOnline = 0,
		PlayTimeTotal = 0,
	},
	Cultivation = {
		RealmTier = 0,
		SubStage = 0,
		CurrentQi = 0,
		MaxQi = 100,
		QiPurity = 1.0,
		UnlockedMechanics = {
			QiGauge = false,
			AirDash = false,
			QiShield = false,
			Flight = false,
			DomainStance = false,
		},
	},
	Economy = {
		SpiritStones = 0,
		SectTokens = 0,
		PremiumGems = 0,
	},
	Inventory = {
		MaxSlots = 30,
		Items = {},
	},
	StanceMastery = {
		ActiveStance = "FlowingWaterSword",
		Proficiencies = {
			FlowingWaterSword = { Level = 1, XP = 0 },
			ThunderPalm = { Level = 1, XP = 0 },
		},
	},
	Social = {
		SectID = "",
		SectRank = 1,
		InfamyPoints = 0,
		BountyAmount = 0,
	},
	Settings = {
		QiSenseColor = "Cyan",
		Keybinds = {},
		AudioVolume = {},
	},
}

-- Service Initialization
local ProfileStore = ProfileService.GetProfileStore(PROFILE_STORE_NAME, DefaultTemplate)
local SaveService = {}
local sessionProfiles: { [Player]: Profile } = {}
local playerJoinTimes: { [Player]: number } = {}
local retryCounts: { [string]: number } = {}

-- Schema migrations dictionary for future backward-compatibility scaling
local Migrations: { [number]: (data: PlayerProfileData) -> () } = {
	-- Version increments will run functions here sequentially
	-- [2] = function(data) ... end
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Safely posts critical errors to developer Discord logs
function SaveService.LogEmergencyAlert(message: string)
	warn(string.format("[SaveService EMER] %s", message))

	if DISCORD_WEBHOOK_URL == "" then
		return
	end

	local payload = {
		content = string.format("⚠️ **[Realmbreaker SaveService Alert]** ⚠️\n%s", message),
	}

	task.spawn(function()
		local success, err = pcall(function()
			HttpService:PostAsync(
				DISCORD_WEBHOOK_URL,
				HttpService:JSONEncode(payload),
				Enum.HttpContentType.ApplicationJson
			)
		end)
		if not success then
			warn("[SaveService] Webhook alert post failed: " .. tostring(err))
		end
	end)
end

-- Fallback mechanism: attempts to restore the player's profile from the latest Milestone backup snapshot
local function attemptBackupRecovery(player: Player): PlayerProfileData?
	local userId = player.UserId
	local prefix = string.format("Snap_%d_", userId)

	local listSuccess, pages = pcall(function()
		return BackupDataStore:ListKeysAsync(prefix, 5, nil, true)
	end)

	if listSuccess and pages then
		local currentPage = pages:GetCurrentPage()
		if #currentPage > 0 then
			local newestKey = nil
			local highestTimestamp = 0

			for _, keyObject in ipairs(currentPage) do
				local timestampStr = string.match(keyObject.KeyName, "Snap_%d+_(%d+)")
				if timestampStr then
					local ts = tonumber(timestampStr) or 0
					if ts > highestTimestamp then
						highestTimestamp = ts
						newestKey = keyObject.KeyName
					end
				end
			end

			if newestKey then
				local readSuccess, backupData = pcall(function()
					return BackupDataStore:GetAsync(newestKey)
				end)

				if readSuccess and backupData then
					SaveService.LogEmergencyAlert(string.format("Disaster recovery success: Loaded profile snapshot %s for %s", newestKey, player.Name))
					return backupData
				end
			end
		end
	end

	return nil
end

-- Processes the pipeline of progressive schema version updates
local function runMigrations(data: PlayerProfileData)
	local currentVersion = data.SchemaVersion or 0
	if currentVersion < LATEST_SCHEMA_VERSION then
		print(string.format("[SaveService] Upgrading profile schema version from %d to %d...", currentVersion, LATEST_SCHEMA_VERSION))
		for version = currentVersion + 1, LATEST_SCHEMA_VERSION do
			local migration = Migrations[version]
			if migration then
				local success, err = pcall(migration, data)
				if not success then
					SaveService.LogEmergencyAlert(string.format("Migration to version %d failed for loaded profile: %s", version, tostring(err)))
				end
			end
		end
		data.SchemaVersion = LATEST_SCHEMA_VERSION
	end
end

-- ============================================================================
-- CORE PUBLIC METHODS
-- ============================================================================

function SaveService.Init()
	print(">>> SAVE SERVICE MODULE LOADED <<<")

	-- Handle existing players (useful during studio testing fast loads)
	for _, player in Players:GetPlayers() do
		task.spawn(SaveService.LoadProfile, player)
	end

	-- Connect player connection lifetimes
	Players.PlayerAdded:Connect(SaveService.LoadProfile)
	Players.PlayerRemoving:Connect(SaveService.ReleaseProfile)

	-- Handle server shutdowns
	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			SaveService.ReleaseProfile(player)
		end
	end)

	-- Register globally caught profile service corruption signals
	ProfileService.CorruptionSignal:Connect(function(storeName, key)
		SaveService.LogEmergencyAlert(string.format("CRITICAL: Corrupted Profile detected in Store %s (Key: %s)", tostring(storeName), tostring(key)))
	end)
end

-- Loads the profile using ProfileService and manages session tracking
function SaveService.LoadProfile(player: Player): Profile?
	local key = "Player_" .. player.UserId
	if sessionProfiles[player] then
		return sessionProfiles[player]
	end

	sessionProfiles[player] = profile
			playerJoinTimes[player] = os.time()

	retryCounts[key] = 0

	-- Load profile with custom retry callback logic
	local profile: any = ProfileStore:LoadProfileAsync(key, function(placeId: number, gameJobId: string)
		local count = (retryCounts[key] or 0) + 1
		retryCounts[key] = count

		warn(string.format("[SaveService] Key %s held on another server (Place: %s, Job: %s). Attempting retry %d/5...", key, tostring(placeId), gameJobId, count))

		if count >= 5 then
			return "Cancel"
		end
		return "Repeat"
	end)

	retryCounts[key] = nil

	if profile ~= nil then
		-- Lock established
		profile:AddUserId(player.UserId) -- Enforce GDPR compliance
		profile:Reconcile() -- Merges any missing keys introduced in game updates

		-- Schema validations & migrations
		local success, err = pcall(function()
			runMigrations(profile.Data)
		end)

		if not success then
			-- Automated Backup Restoration Trigger
			SaveService.LogEmergencyAlert(string.format("Data corruption or migration failure for player %s. Initiating disaster recovery...", player.Name))
			local recoveredData = attemptBackupRecovery(player)
			if recoveredData then
				profile.Data = recoveredData
			else
				player:Kick("Your save profile is corrupted and disaster recovery was unable to resolve it. Please contact support.")
				profile:Release()
				return nil
			end
		end

		-- Session Release Callback
		profile:ListenToRelease(function()
			sessionProfiles[player] = nil
			player:Kick("Your profile session has been released on another server. Please rejoin to protect your progression.")
		end)

		if player:IsDescendantOf(Players) then
			sessionProfiles[player] = profile
			playerJoinTimes[player] = os.time()

			local replica = ReplicaService.NewReplica({
				ClassToken = PlayerReplicaToken,
				Tags = { Player = player },
				Data = profile.Data,
				Replication = player,
			})
			sessionReplicas[player] = replica

			-- Setup initial login statistics
			if profile.Data.MetaData.FirstJoined == 0 then
				profile.Data.MetaData.FirstJoined = os.time()
			end
			profile.Data.MetaData.LastOnline = os.time()

			print(string.format("[SaveService] Established session-locked profile for %s", player.Name))
			return profile
		else
			profile:Release()
		end
	else
		-- Kicked if lock could not be released within retry parameters
		player:Kick("Profile locked by another server. Please wait 30 seconds.")
	end

	return nil
end

-- Releases session lock and completes final write sequence
function SaveService.ReleaseProfile(player: Player)
	local profile = sessionProfiles[player]
	if profile then
		local joinTime = playerJoinTimes[player]
		if joinTime then
			local totalSessionTime = os.time() - joinTime
			profile.Data.MetaData.PlayTimeTotal += totalSessionTime
			playerJoinTimes[player] = nil
		end

		profile.Data.MetaData.LastOnline = os.time()

		-- ProfileService automatically performs a final save to the DataStore on release
		profile:Release()
		sessionProfiles[player] = nil

	    local replica = sessionReplicas[player]
		if replica then
			replica:Destroy()
			sessionReplicas[player] = nil
		end

		print(string.format("[SaveService] Session lock released for player %s", player.Name))
	end
end

-- Creates a breakthrough milestone backup snapshot inside PlayerBackups_v1.0
function SaveService.CreateMilestoneSnapshot(player: Player, milestoneName: string): boolean
	local profile = sessionProfiles[player]
	if not profile then
		return false
	end

	local userId = player.UserId
	local timestamp = os.time()
	local backupKey = string.format("Snap_%d_%d", userId, timestamp)

	-- Create a hard-copy deep clone of the current profile data
	local successCopy, clonedData = pcall(function()
		return HttpService:JSONDecode(HttpService:JSONEncode(profile.Data))
	end)

	if not successCopy then
		warn("[SaveService] Failed to serialize deep copy of profile for backup snapshot.")
		return false
	end

	local success, err = pcall(function()
		BackupDataStore:SetAsync(backupKey, clonedData)
	end)

	if success then
		print(string.format("[SaveService] Created milestone snapshot backup (%s) for player %s under key %s", milestoneName, player.Name, backupKey))
		return true
	else
		SaveService.LogEmergencyAlert(string.format("Failed to write milestone snapshot (%s) for player %s: %s", milestoneName, player.Name, tostring(err)))
		return false
	end
end

-- ============================================================================
-- BACKWARD COMPATIBILITY / ACCESSOR WRAPPERS
-- ============================================================================

function SaveService.LoadData(player: Player): PlayerProfileData?
	local profile = sessionProfiles[player]
	if not profile then
		-- Yield wait wrapper up to 10 seconds to handle initial join loading speeds
		local start = tick()
		while not sessionProfiles[player] and tick() - start < 10 do
			task.wait(0.1)
		end
		profile = sessionProfiles[player]
	end

	return profile and profile.Data or nil
end

function SaveService.SaveData(player: Player, data: PlayerProfileData)
	local profile = sessionProfiles[player]
	if profile then
		profile.Data = data
	end
end

-- Provides access to raw profile handles (helpful for modules handling item trades / locks)
function SaveService.GetProfile(player: Player): Profile?
	return sessionProfiles[player]
end

function SaveService.UpdateReplica(player: Player, path: {any}, value: any)
	local replica = sessionReplicas[player]
	if replica then
		replica:SetValue(path, value)
	end
end

return SaveService