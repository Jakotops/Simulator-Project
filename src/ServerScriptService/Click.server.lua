local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)
local Stats = require(ReplicatedStorage.Utils.Stats)

local CLICK_COOLDOWN = 1

local Cooldown = {}

local function Click(player: Player)
	if table.find(Cooldown, player) then return end
	
	local profile = PlayerData.Profiles[player]
	if not profile then return end
	
	table.insert(Cooldown, player)
	task.delay(CLICK_COOLDOWN, function()
		local foundPlayer = table.find(Cooldown, player)
		if foundPlayer then
			table.remove(Cooldown, foundPlayer)
		end
	end)
	
	local clickMultiplier = Stats.ClickMultiplier(player, profile.Data)
	local reward = clickMultiplier
	PlayerData.AdjustClicks(player, reward)
end


Remotes.Click.OnServerEvent:Connect(Click)
