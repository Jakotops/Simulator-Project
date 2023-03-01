local RebirthsConfig = {}

RebirthsConfig.BasePrice = 800
RebirthsConfig.IncreasePerRebirth = 175

function	 RebirthsConfig.CalculatePrice(currentRebirth: number, amountOfRebirths: number?)
	amountOfRebirths = if amountOfRebirths then amountOfRebirths else 1
	
	local price = 0 
	local rebirths = 0
	while (rebirths < amountOfRebirths) do
		price += RebirthsConfig.BasePrice + ((rebirths + currentRebirth) * RebirthsConfig.IncreasePerRebirth)
		rebirths += 1
	end
	
	return price
end

RebirthsConfig.Buttons = {
	["1"]  = {
		Price = 0
	},
	["5"]  = {
		Price = 0
	},
	["10"]  = {
		Price = 0
	},
	["50"]  = {
		Price = 500
	},
	["250"]  = {
		Price = 2_500
	},
	
}

function RebirthsConfig.HasButtonUnlocked(playerData, rebirthButton: number)
	local buttonConfig = RebirthsConfig.Buttons[rebirthButton]
	if not buttonConfig then return false end
	
	return playerData.RebirthButtons[rebirthButton] 
end
return RebirthsConfig