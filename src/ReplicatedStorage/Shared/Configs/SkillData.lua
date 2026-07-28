--!strict

export type SkillConfig = {
	SkillId: string,
	DisplayName: string,
	RequiredRealm: number,
	QiCost: number,
	Cooldown: number,
}

local SkillData: { [string]: SkillConfig } = {

	QiPalm = {
		SkillId = "QiPalm",
		DisplayName = "Qi Palm",
		RequiredRealm = 1,
		QiCost = 25,
		Cooldown = 3,
	},

}

return SkillData