local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local RebirthsConfig = require(ReplicatedStorage.Configs.Rebirths)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ButtonGui = PlayerGui:WaitForChild("Left")
local OpenButton = ButtonGui.Frame.Buttons.Rebirths

local Gui = PlayerGui:WaitForChild("Rebirth")
local Frame = Gui.Frame

local Rebirths = Frame.Rebirths
local ExitButton = Frame.Exit
local Container = Frame.Container

local Template = Container.Template

local REBIRTH_DISPLAY_TEMPLATE = "Rebirths: AMOUNT"
local REBIRTH_BUTTON_REBIRTHS_TEMPLATE = "AMOUNT rebirths"
local REBIRTH_BUTTON_COST_TEMPLATE = "cost: AMOUNT"

local function GenerateButton(rebirths: string)

local function UpdateRebirth(amount: number)
	Rebirths.Text = REBIRTH_DISPLAY_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(amount))
end
	
local Data = {
	Rebirths = 0, 
	RebirthButtons = {}		
}	

	

for rebirths, info in RebirthsConfig.Buttons do
	local isUnlocked = RebirthsConfig.HasButtonUnlocked(Data, tonumber(rebirths))
	local clone = Template:Clone()
	clone.Parent = Container
	clone.Name = rebirths
	clone.Visible = isUnlocked
	clone.LayoutOrder = tonumber(rebirths)
	clone.Rebirths.Text = REBIRTH_BUTTON_REBIRTHS_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(tonumber(rebirths)))
	
	clone.MouseButton1Click:Connect(function()
		Remotes.RequestRebirth:FireServer(rebirths)
	end)
end 	

UpdateRebirth(Remotes.GetData:InvokeServer("Rebirths"))
Remotes.UpdateRebirths.OnClientEvent:Connect(UpdateRebirth)

OpenButton.MouseButton1Click:Connect(function()
	Gui.Enabled = not Gui.Enabled
end)

ExitButton.MouseButton1Click:Connect(function()
	Gui.Enabled = false
end)