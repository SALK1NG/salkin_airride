Config = {}
Config.ItemName = "airride_kit"
Config.InstallTime = 5000 

Config.Controls = {
    Up = 172,
    Down = 173,
}

-- Whitelist: ['spawnname'] = { min, max, camber }
-- Geschwindigkeits-Einstellungen
Config.MaxSpeedLowered = 50.0 -- km/h
Config.SpeedLimitHeight = 0.04 -- Ab dieser Tiefe greift die Drosselung

-- Hier definierst du, welches Auto Airride haben darf und wie die Limits sind
Config.VehicleWhitelist = {
    -- === JDM / TUNER (Stance / Drift Style) ===
    ['sultan']      = { min = 0.0, max = 0.10 }, -- Subaru Style
    ['sultanrs']    = { min = 0.0, max = 0.11 },
    ['elegy']       = { min = 0.0, max = 0.10 }, -- Nissan GTR Style
    ['elegy2']      = { min = 0.0, max = 0.11 }, -- Elegy Retro
    ['futo']        = { min = 0.0, max = 0.12 }, -- AE86 Style
    ['jester']      = { min = 0.0, max = 0.09 }, -- Supra Style
    ['banshee']     = { min = 0.0, max = 0.09 }, -- Viper Style
    ['sentinel']    = { min = 0.0, max = 0.10 }, -- BMW Style
    ['penumbra']    = { min = 0.0, max = 0.10 },
    ['kuruma']      = { min = 0.0, max = 0.09 },
    ['comet2']      = { min = 0.0, max = 0.04 }, -- Porsche Style

    -- === LUXUS / VIP (Dezentes Absenken, "Slotted" Look) ===
    ['oracle']      = { min = 0.0, max = 0.11 }, -- BMW 7er
    ['oracle2']     = { min = 0.0, max = 0.11 },
    ['vorschlaghammer']   = { min = 0.0, max = 0.07 }, -- Mercedes E/S Klasse

    ['cognoscenti'] = { min = 0.0, max = 0.09 }, -- Bentley/Maybach Style
    ['tailgater']   = { min = 0.0, max = 0.10 }, -- Audi Style
    ['felon']       = { min = 0.0, max = 0.10 }, -- Jaguar Style
    ['exemplar']    = { min = 0.0, max = 0.09 },

    -- === SUVs (VIP / Urban Style) ===
    ['baller']      = { min = 0.0, max = 0.13 }, -- Range Rover Style
    ['baller2']     = { min = 0.0, max = 0.13 },
    ['huntley']     = { min = 0.0, max = 0.12 }, -- Bentley SUV Style
    ['cavalcade']   = { min = 0.0, max = 0.14 }, -- Escalade Style
    ['granger']     = { min = 0.0, max = 0.12 }, -- Chevy Suburban Style
    ['dubsta']      = { min = 0.0, max = 0.11 }, -- G-Klasse
    ['dubsta2']     = { min = 0.0, max = 0.11 },
    ['landstalker2'] = { min = 0.0, max = 0.13 },

    -- === KLEINWAGEN / SONSTIGE ===
    ['panto']       = { min = 0.0, max = 0.15 }, -- Extrem tiefer Smart
    ['bfinjection'] = { min = -0.10, max = 0.05 }, -- Offroad-Buggy (eher zum höher legen)
    ['sandking2'] = { min = -0.10, max = 0.05 },
}
-- Wie viel "Tiefe" pro Tuning-Stufe beim Mechaniker abgezogen wird
-- Verhindert das Versinken im Boden, wenn das Auto schon Tuning hat.
Config.TuningReductionFactor = 0.02

Config.ChangeSpeed = 0.001
Config.StiffSuspensionForce = 100.0 -- Wert für "keine Federung"
-- In datenbank:
-- ALTER TABLE owned_vehicles ADD COLUMN airride TINYINT(1) DEFAULT 0;

-- In OX_inventory:
--	['airride_kit'] = {
--		label = 'Airride Einbausatz',
--		weight = 5000,
--		stack = true,
--		close = true,
--		description = 'Ein komplettes Luftfahrwerk-Set zum Einbauen.',
--		client = {
--			export = 'salkin_airride.installAirride'
--		}
--	},