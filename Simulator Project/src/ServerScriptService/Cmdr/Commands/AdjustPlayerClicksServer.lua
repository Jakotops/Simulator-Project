local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService.PlayerData.Manager)

return function (context, player: Player, amount: number)
	PlayerData.AdjustClicks(player, amount)
	return "Adjusted"
end