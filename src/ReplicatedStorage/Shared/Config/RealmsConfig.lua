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
		[1] = { StageName = "Mortal Body", RequiredQi = 100, MinorStages = 4, BaseMaxHp = 100 },
		[2] = { StageName = "Qi Condensation", RequiredQi = 500, MinorStages = 4, BaseMaxHp = 175 },
		[3] = { StageName = "Foundation Establishment", RequiredQi = 2000, MinorStages = 4, BaseMaxHp = 250 },
		[4] = { StageName = "Core Formation", RequiredQi = 8000, MinorStages = 4, BaseMaxHp = 325 },
	},
}

return RealmsConfig