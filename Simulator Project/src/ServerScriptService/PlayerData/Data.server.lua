local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Template = require(ReplicatedStorage.PlayerData.Template)
local Manager = require(ServerScriptService.PlayerData.Manager)
local ProfileService = require(ServerScriptService.Libs.ProfileService)

local ProfileStore = ProfileService.GetProfileStore("Production", Template)

local KICK_MESSAGE = "Data issue, try again shortly. If issue persists, contact us"

local function CreateLeaderStats(player: Players)
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	local clicks = Instance.new("NumberValue", leaderstats)
	clicks.Name = "Clicks"
	clicks.Value = profile.Data.Clicks
	
	local gems = Instance.new("NumberValue", leaderstats)
	gems.Name = "Gems"
	gems.Value = profile.Data.Gems 
	
	local rebiths = Instance.new("NumberValue", leaderstats)
	rebiths.Name = "Rebirths"
	rebiths.Value = profile.Data.Rebirths 
	
end

local function LoadProfile(player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)
	if not profile then
		player:Kick(KICK_MESSAGE)
		return
	end
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		Manager.Profiles	[player] = nil
		player:Kick(KICK_MESSAGE)
	end)
	
	if player:IsDescendantOf(Players) == true then
		Manager.Profiles	[player] = profile
		CreateLeaderStats(player)
	else
		profile:Release()
	end 
end

for _, player in Players:GetPlayers() do 
	task.spawn(LoadProfile, player)
end

Players.PlayerAdded:Connect(LoadProfile)
Players.PlayerRemoving:Connect(function(player)
	local profile = Manager.Profiles[player]
	if profile then
		profile:Release()
	end
end)