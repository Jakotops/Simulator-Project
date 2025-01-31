local ServerScriptService = game:GetService("ServerScriptService")

local JumpsShop = require(ServerScriptService.JumpsShop)

return function (context)
	local player = context.Executor

	return JumpsShop.PurchaseJump(player)
end

