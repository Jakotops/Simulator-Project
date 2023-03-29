local ServerScriptService = game:GetService("ServerScriptService")

local Rebirth = require(ServerScriptService.Rebirth)

return function (context, rebirthButton: number)
	local player = context.Executor
	return Rebirth.UnlockButton(player, tostring(rebirthButton))
end