local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Template = require(ReplicatedStorage.PlayerData.Template)

local directories = {}

for directory, value in Template do
	table.insert(directories,directory)
end

return function (registery)
	registery:RegisterType("dataDirectory", registery.Cmdr.Util.MakeEnumType("dataDirectory", directories))
end