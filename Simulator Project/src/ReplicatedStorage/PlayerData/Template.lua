local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthConfig = require(ReplicatedStorage.Configs.Rebirths)


local DEFAULT_AUTO_INFO = {
	Active = false,
	Duration = 0
}

local DEFAULT_REBIRTH_BUTTONS = {}
for rebirth, info in RebirthConfig.Buttons do
	DEFAULT_REBIRTH_BUTTONS[rebirth] = info.Price == 0
end

local Template = {
	Clicks = 0,
	Gems = 0,
	Rebirths = 0,
	Auto = {
		Fast = DEFAULT_AUTO_INFO,
		Regular = DEFAULT_AUTO_INFO
	},
	RebirthButtons = DEFAULT_REBIRTH_BUTTONS
}

export type PlayerData = typeof(Template)

return Template
