--!strict
export type SkillConfig = {
	SkillId: string,
	DisplayName: string,
	RequiredRealm: number,
	QiCost: number,
	Cooldown: number,
}

local StancesConfig: { [string]: SkillConfig } = {
	QiPalm = {
		SkillId = "QiPalm",
		DisplayName = "Thunder-Palm Strike",
		RequiredRealm = 1,
		QiCost = 15,
		Cooldown = 3.0,
	},
}

return StancesConfig