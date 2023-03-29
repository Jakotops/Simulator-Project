local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local PlayerData = require(ServerScriptService.PlayerData.Manager)
local RebirthConfig = require(ReplicatedStorage.Configs.Rebirths)
local Remotes = ReplicatedStorage.Remotes

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

function Rebirth.UnlockButton(player: Player, rebirthButton: string)
	local profile = PlayerData.Profiles[player]
	if not profile then return "No profile!" end

	local price = RebirthConfig.Buttons[rebirthButton].Price
	local canAfford = profile.Data.Gems >= price
	if not canAfford then return "Cannot afford "..price.."!"end

	local isUnlocked = RebirthConfig.HasButtonUnlocked(profile.Data, rebirthButton)
	if isUnlocked then return "Already unlocked!" end

	PlayerData.AdjustGems(player, -price)
	profile.Data.RebirthButtons[rebirthButton] = true
	Remotes.UpdateRebirthButton:FireClient(player, rebirthButton, true)
end


Remotes.RequestRebirth.OnServerEvent:Connect(function(player: Player, rebirth: string)
	rebirth = tonumber(rebirth)
	if not rebirth then return end
	Rebirth.Rebirth(player, rebirth)
end)
return Rebirth
