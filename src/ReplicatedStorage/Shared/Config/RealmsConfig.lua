--!strict
export type RealmStage = {
	StageName: string,
	RequiredQi: number,
	MinorStages: number,
	BaseMaxHp: number,
}

export type CultivationConfig = {
	BaseMeditationInterval: number,
	BaseQiPerTick: number,
	Realms: { [number]: RealmStage },
}

local RealmsConfig: CultivationConfig = {
	BaseMeditationInterval = 2.0,
	BaseQiPerTick = 10,
	Realms = {
		[1] = { StageName = "Mortal Realm", RequiredQi = 100, MinorStages = 9, BaseMaxHp = 100 },
		[2] = { StageName = "Body Forging Realm", RequiredQi = 250, MinorStages = 9, BaseMaxHp = 145 },
		[3] = { StageName = "Qi Gathering Realm", RequiredQi = 500, MinorStages = 9, BaseMaxHp = 190 },
		[4] = { StageName = "Spirit Foundation Realm", RequiredQi = 1000, MinorStages = 9, BaseMaxHp = 235 },
		[5] = { StageName = "Golden Core Realm", RequiredQi = 2500, MinorStages = 9, BaseMaxHp = 280 }, -- V1 CAP: Total HP hits 370 here
		
		-- Realms 6-12 (Future Content / Unlocked in Post-V1)
		[6] = { StageName = "Nascent Soul Realm", RequiredQi = 5000, MinorStages = 9, BaseMaxHp = 350 },
		[7] = { StageName = "Soul Ascendant Realm", RequiredQi = 10000, MinorStages = 9, BaseMaxHp = 450 },
		[8] = { StageName = "Void Sovereign Realm", RequiredQi = 25000, MinorStages = 9, BaseMaxHp = 580 },
		[9] = { StageName = "Heavenly Dao Realm", RequiredQi = 50000, MinorStages = 9, BaseMaxHp = 750 },
		[10] = { StageName = "Celestial Monarch Realm", RequiredQi = 100000, MinorStages = 9, BaseMaxHp = 1000 },
		[11] = { StageName = "Eternal Sovereign Realm", RequiredQi = 250000, MinorStages = 9, BaseMaxHp = 1500 },
		[12] = { StageName = "Realmbreaker Realm", RequiredQi = 1000000, MinorStages = 9, BaseMaxHp = 2500 },
	},
}

return RealmsConfig