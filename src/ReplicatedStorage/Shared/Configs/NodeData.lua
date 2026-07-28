--!strict
export type NodeConfig = {
	Name: string,
	QiReward: number,
	RespawnTime: number,
	RequiredRealm: number,
	HoldDuration: number,
}

local NodeData: { [string]: NodeConfig } = {
	SpiritHerb = {
		Name = "Spirit Qi Spring",
		QiReward = 200,
		RespawnTime = 20,
		RequiredRealm = 1,
		HoldDuration = 1.5,
	},
	SpiritSpring = {
		Name = "Spirit Qi Spring",
		QiReward = 200,
		RespawnTime = 20,
		RequiredRealm = 1,
		HoldDuration = 2.0,
	},
	QiCrystal = {
		Name = "Qi Crystal Array",
		QiReward = 1000,
		RespawnTime = 40,
		RequiredRealm = 2,
		HoldDuration = 4.0,
	},
}

return NodeData