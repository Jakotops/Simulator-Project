local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)
local Stats = require(ReplicatedStorage.Utils.Stats)


local function UpdateAutoClicker(player: Player, buttonType: "Fast" | "Regular")
	local profile = PlayerData.Profiles[player]
	if not profile then return end
	
	local isActive = profile.Data.Auto[buttonType].Active
	local duration = profile.Data.Auto[buttonType].Duration
	
	if isActive then
		profile.Data.Auto[buttonType].Active = false
		Remotes.UpdateAutoClicker:FireClient(player, buttonType, false)
	elseif not isActive and duration > 0  then
		profile.Data.Auto[buttonType].Active = true
		Remotes.UpdateAutoClicker:FireClient(player, buttonType, true)
	end
end

Remotes.UpdateAutoClicker.OnServerEvent:Connect(UpdateAutoClicker)

local isSecond = false
while true do
	isSecond = not isSecond
	for _,player in Players:GetPlayers() do
		local profile = PlayerData.Profiles[player]
		if not profile then continue end
		
		local isRegularActive = profile.Data.Auto.Regular.Active
		local regularDuration = profile.Data.Auto.Regular.Duration
		local isFastActive = profile.Data.Auto.Fast.Active
		local FastDuration = profile.Data.Auto.Fast.Duration
		if isFastActive then
			local clickMultiplier = Stats.ClickMultiplier(player, profile.Data)
			local reward = clickMultiplier
			PlayerData.AdjustClicks(player, reward)
			if isSecond then
				profile.Data.Auto.Fast.Duration -= 1
			end
			
			if profile.Data.Auto.Fast.Duration <= 0 then
				profile.Data.Auto.Fast.Active = false
				Remotes.UpdateAutoClicker:FireClient(player, "Fast", false)
			end
		end
		
		if isSecond and isRegularActive then
			local clickMultiplier = Stats.ClickMultiplier(player, profile.Data)
			local reward = clickMultiplier
			PlayerData.AdjustClicks(player, reward)
			profile.Data.Auto.Regular.Duration -= 1
			
			if profile.Data.Auto.Regular.Duration <= 0 then
				profile.Data.Auto.Regular.Active = false
				Remotes.UpdateAutoClicker:FireClient(player, "Regular", false)
			end
		end
				
	end
	
	task.wait(.5)
end