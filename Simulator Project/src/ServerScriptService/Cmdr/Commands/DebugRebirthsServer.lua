local ServerScriptService = game:GetService("ServerScriptService")

local Rebirth = require(ServerScriptService.Rebirth)

return function (context, amount: number?)
	amount = if amount then amount else 1
	
	local player = context.Executor
	return Rebirth.Rebirth(player, amount)
end