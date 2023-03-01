local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local PlayerData = require(ServerScriptService.PlayerData.Manager)
local RebirthConfig = require(ReplicatedStorage.Configs.Rebirths)

local Rebirth = {}

function Rebirth.Rebirth(player: Player, amount: number?)
	amount = if amount then amount else 1
	
	local profile = PlayerData.Profiles[player]
	if not profile then return "No profile!" end
	
	local currentRebirth = profile.Data.Rebirths
	local price = RebirthConfig.CalculatePrice(currentRebirth, amount)
	
	local canAfford  = profile.Data.Clicks >= price
	if not canAfford then return "Cannot afford "..price.."!"end
	
	
	PlayerData.AdjustRebirths(player, amount)
	PlayerData.AdjustClicks(player, -profile.Data.Clicks)
	PlayerData.AdjustGems(player, 10 * amount)
	return "Your Rebirthed "..amount.." times!"
end

return Rebirth
