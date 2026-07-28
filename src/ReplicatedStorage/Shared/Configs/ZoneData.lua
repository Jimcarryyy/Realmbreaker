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

local ZoneData: { [string]: ZoneConfig } = {
	["MortalVillage"] = {
		DisplayName = "Greenleaf Village",
		MinRealmLevel = 1, -- Mortal Realm
		QiDensityMultiplier = 1.0,
		AmbientAudioId = "rbxassetid://1837877611",
		LightingSettings = {
			ClockTime = 14,
			Brightness = 2,
			OutdoorAmbient = Color3.fromRGB(128, 128, 128),
			FogEnd = 10000,
		},
	},
	["OuterSect"] = {
		DisplayName = "Azure Cloud Sect - Outer Grounds",
		MinRealmLevel = 2, -- Qi Condensation Realm
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
		DisplayName = "Dragon Vein Spirit Spring",
		MinRealmLevel = 3, -- Foundation Establishment Realm
		QiDensityMultiplier = 10.0,
		AmbientAudioId = "rbxassetid://1837878100",
		LightingSettings = {
			ClockTime = 0,
			Brightness = 1,
			OutdoorAmbient = Color3.fromRGB(50, 100, 150),
			FogEnd = 2000,
		},
	},
}

return ZoneData