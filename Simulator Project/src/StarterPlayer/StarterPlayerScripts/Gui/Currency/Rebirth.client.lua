local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gui = PlayerGui:WaitForChild("Left")
local Frame = Gui.Frame.Rebirths

local Rebirths = Frame.Amount
local REBIRTH_TEXT_TEMPLATE = "Rebirth: AMOUNT"


local function UpdateRebirths(amount: number)
	Rebirths.Text = REBIRTH_TEXT_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(amount))
end
	
	
UpdateRebirths(Remotes.GetData:InvokeServer("Rebirths"))

Remotes.UpdateRebirths.OnClientEvent:Connect(UpdateRebirths)