--!strict
export type RealmStage = {
	StageName: string,
	RequiredQi: number,
	MinorStages: number,
}

export type CultivationConfig = {
	BaseMeditationInterval: number,
	BaseQiPerTick: number,
	Realms: { [number]: RealmStage },
}

local CultivationData: CultivationConfig = {
	BaseMeditationInterval = 2.0,
	BaseQiPerTick = 10,
	Realms = {
		[1]  = { StageName = "Mortal Realm",           RequiredQi = 100,      MinorStages = 9 },
		[2]  = { StageName = "Body Forging Realm",     RequiredQi = 500,      MinorStages = 9 },
		[3]  = { StageName = "Qi Gathering Realm",     RequiredQi = 2000,     MinorStages = 9 },
		[4]  = { StageName = "Spirit Foundation Realm", RequiredQi = 8000,     MinorStages = 9 },
		[5]  = { StageName = "Golden Core Realm",        RequiredQi = 30000,    MinorStages = 9 },
		[6]  = { StageName = "Nascent Soul Realm",       RequiredQi = 100000,   MinorStages = 9 },
		[7]  = { StageName = "Soul Ascendant Realm",     RequiredQi = 400000,   MinorStages = 9 },
		[8]  = { StageName = "Void Sovereign Realm",    RequiredQi = 1500000,  MinorStages = 9 },
		[9]  = { StageName = "Heavenly Dao Realm",      RequiredQi = 5000000,  MinorStages = 9 },
		[10] = { StageName = "Celestial Monarch Realm",RequiredQi = 20000000, MinorStages = 9 },
		[11] = { StageName = "Eternal Sovereign Realm",RequiredQi = 80000000, MinorStages = 9 },
		[12] = { StageName = "Realmbreaker Realm",     RequiredQi = 300000000,MinorStages = 9 },
	},
}

return CultivationData