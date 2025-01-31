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

local Data = {
	Rebirths = 0, 
	RebirthButtons = {}
}

local function unlockButtons()
	for _, child in Container:GetChildren() do
		if not child:isA("TextButton") or child.Name == "Template" or child.Name == "Unlimited" then continue end
		local clone: typeof(Template) = child
		clone.Visible = Data.RebirthButtons[clone.Name]
	end
end


-- Updates the cost of the rebirth buttons in the rebirth menu.
-- The rebirth button cost is calculated using the rebirth price config.
-- @param rebirths The number of rebirths the player has.
-- @param rebirths The rebirth the player is trying to buy.
-- @returns The cost of the rebirth in coins.

local function updateButtonCosts()
	for _, child in Container:GetChildren() do
		if not child:isA("TextButton") or child.Name == "Template" or child.Name == "Unlimited" then continue end
		local clone: typeof(Template) = child
		local rebirths = tonumber(clone.Name)
		local cost = RebirthsConfig.CalculatePrice(Data.Rebirths, rebirths)
		clone.Cost.Text = REBIRTH_BUTTON_COST_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(cost))
	end
end

-- This function is responsible for updating the color of the rebirth button based on the amount of currency the player has.
-- It will change the color of the button to green if the player can afford the rebirth, and gray if they can't.
-- The rebirth button is identified by its name, which is the number of rebirths the player will gain from purchasing it.
-- The cost of the rebirth is calculated by the RebirthsConfig.CalculatePrice function.

local function updateButtonBuyable(amount: number)
	for _, child in Container:GetChildren() do
		if not child:isA("TextButton") or child.Name == "Template" or child.Name == "Unlimited" then continue end
		local clone: typeof(Template) = child
		local rebirths = tonumber(clone.Name)
		local cost = RebirthsConfig.CalculatePrice(Data.Rebirths, rebirths)
		local canAfford = amount >= cost
		clone.BackgroundColor3 = if canAfford then Color3.fromRGB(142, 255, 101) else Color3.fromRGB(111, 111, 111)
	end
end

local function GenerateButton(rebirths: string)
	local isUnlocked = RebirthsConfig.HasButtonUnlocked(Data, rebirths)
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

local function UpdateRebirth(amount: number)
	Rebirths.Text = REBIRTH_DISPLAY_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(amount))
	Data.Rebirths = amount
	updateButtonCosts()
end

Data.RebirthButtons = Remotes.GetData:InvokeServer("RebirthButtons")
for rebirths, info in RebirthsConfig.Buttons do
	GenerateButton(rebirths)
end 	

updateButtonCosts()

Remotes.UpdateClicks.OnClientEvent:Connect(updateButtonBuyable)

UpdateRebirth(Remotes.GetData:InvokeServer("Rebirths"))
Remotes.UpdateRebirths.OnClientEvent:Connect(UpdateRebirth)
Remotes.UpdateRebirthButton.OnClientEvent:Connect(function(rebirth: string, isUnlocked: boolean)
	Data.RebirthButtons[rebirth] = isUnlocked
	unlockButtons()
end)

OpenButton.MouseButton1Click:Connect(function()
	Gui.Enabled = not Gui.Enabled
end)

ExitButton.MouseButton1Click:Connect(function()
	Gui.Enabled = false
end)


updateButtonBuyable(Remotes.GetData:InvokeServer("Clicks"))
unlockButtons()