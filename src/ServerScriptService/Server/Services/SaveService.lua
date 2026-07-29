--!strict
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local CultivationDataStore = DataStoreService:GetDataStore("Realmbreaker_Cultivation_v1")

local SaveService = {}
local sessionData: { [Player]: any } = {}

function SaveService.Init()
	print(">>> SAVE SERVICE MODULE LOADED <<<")

	-- Auto-save on server shutdown
	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			SaveService.SaveData(player, sessionData[player])
		end
	end)
end

function SaveService.LoadData(player: Player): any?
	local key = "Player_" .. player.UserId
	local success, result = pcall(function()
		return CultivationDataStore:GetAsync(key)
	end)

	if success and result then
		sessionData[player] = result
		print(string.format("[SaveService] Successfully loaded data for %s", player.Name))
		return result
	else
		print(string.format("[SaveService] New player or data load fallback for %s", player.Name))
		return nil
	end
end

function SaveService.SaveData(player: Player, data: any)
	if not data then return end
	sessionData[player] = data

	local key = "Player_" .. player.UserId
	local success, err = pcall(function()
		CultivationDataStore:SetAsync(key, data)
	end)

	if success then
		print(string.format("[SaveService] Successfully saved data for %s", player.Name))
	else
		warn(string.format("[SaveService] Failed to save data for %s: %s", player.Name, tostring(err)))
	end
end

return SaveService