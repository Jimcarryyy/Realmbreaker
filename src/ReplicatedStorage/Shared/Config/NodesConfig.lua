--!strict
export type NodeConfig = {
	Name: string,
	QiReward: number,
	RespawnTime: number,
	RequiredRealm: number,
	HoldDuration: number,
}

local NodesConfig: { [string]: NodeConfig } = {
	SpiritHerb = {
		Name = "Spirit Qi Herb",
		QiReward = 20,
		RespawnTime = 15,
		RequiredRealm = 1,
		HoldDuration = 1.0,
	},
	SpiritSpring = {
		Name = "Spirit Qi Spring",
		QiReward = 50,
		RespawnTime = 20,
		RequiredRealm = 1,
		HoldDuration = 2.0,
	},
	QiCrystal = {
		Name = "Contested Qi Artery",
		QiReward = 200,
		RespawnTime = 40,
		RequiredRealm = 2,
		HoldDuration = 4.0,
	},
}

return NodesConfig