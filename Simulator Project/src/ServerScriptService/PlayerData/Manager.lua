local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

local Manager = {}

Manager.Profiles = {}

function Manager.AdjustRebirths(player: Player, amount: number)
	local profile = Manager.Profiles[player]
	if not profile then return end
	profile.Data.Rebirths += amount
	player.leaderstats.Rebirths.Value = profile.Data.Rebirths
	Remotes.UpdateRebirths:FireClient(player, profile.Data.Rebirths)
end

function Manager.AdjustGems(player: Player, amount: number)
	local profile = Manager.Profiles[player]
	if not profile then return end
	profile.Data.Gems += amount
	player.leaderstats.Gems.Value = profile.Data.Gems
	Remotes.UpdateGems:FireClient(player, profile.Data.Gems)
end

function Manager.AdjustClicks(player: Player, amount: number)
	local profile = Manager.Profiles[player]
	if not profile then return end
	profile.Data.Clicks += amount
	player.leaderstats.Clicks.Value = profile.Data.Clicks
	Remotes.UpdateClicks:FireClient(player, profile.Data.Clicks)
end

local function GetData(player: Player, directory: string)
	local profile = Manager.Profiles[player]
	if not profile then return end
	return profile.Data[directory]
end

local function GetAutoClickMode(player: Player, buttonType: "Fast" | "Regular")
	local profile = Manager.Profiles[player]
	if not profile then return end
	return profile.Data.Auto[buttonType].Active
end


Remotes.GetData.OnServerInvoke = GetData

Remotes.GetAutoClickMode.OnServerInvoke = GetAutoClickMode

return Manager
