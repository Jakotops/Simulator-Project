local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataTemplate = require(ReplicatedStorage.PlayerData.Template)

local Stats = {}

function Stats.ClickMultiplier(player: Player, playerData: PlayerDataTemplate.PlayerData)
	local multiplier = 1
	
	local rebirths = playerData.Rebirths
	multiplier += rebirths
	return multiplier
end

return Stats
