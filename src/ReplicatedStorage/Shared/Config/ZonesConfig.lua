--!strict
export type ZoneConfig = {
	DisplayName: string,
	MinRealmLevel: number,
	QiDensityMultiplier: number,
	AmbientAudioId: string,
	LightingSettings: {
		ClockTime: number,
		Brightness: number,
		OutdoorAmbient: Color3,
		FogEnd: number,
	},
}

local ZonesConfig: { [string]: ZoneConfig } = {
	["MortalVillage"] = {
		DisplayName = "Bamboo Leaf Village",
		MinRealmLevel = 1, -- Mortal Body
		QiDensityMultiplier = 1.0,
		AmbientAudioId = "",
		LightingSettings = {
			ClockTime = 14,
			Brightness = 2,
			OutdoorAmbient = Color3.fromRGB(128, 128, 128),
			FogEnd = 10000,
		},
	},
	["OuterSect"] = {
		DisplayName = "Outer Sect Grounds",
		MinRealmLevel = 2, -- Qi Condensation
		QiDensityMultiplier = 2.5,
		AmbientAudioId = "rbxassetid://1837877888",
		LightingSettings = {
			ClockTime = 12,
			Brightness = 3,
			OutdoorAmbient = Color3.fromRGB(150, 180, 200),
			FogEnd = 5000,
		},
	},
	["SpiritQiDen"] = {
		DisplayName = "Mistveil Caverns (Contested)",
		MinRealmLevel = 3, -- Foundation Establishment
		QiDensityMultiplier = 5.0,
		AmbientAudioId = "rbxassetid://1837878100",
		LightingSettings = {
			ClockTime = 0,
			Brightness = 1,
			OutdoorAmbient = Color3.fromRGB(50, 100, 150),
			FogEnd = 2000,
		},
	},
}

return ZonesConfig