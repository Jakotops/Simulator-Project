local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gui = PlayerGui:WaitForChild("Left")
local Frame = Gui.Frame.Currency

local Clicks = Frame.Clicks.Amount
local ClicksPerSecond = Frame.Clicks.CPS
local BuyClicks = Frame.Clicks.Buy
local Gems = Frame.Gems.Amount

local ClicksDuringSecond = 0 
local PreviousClicksAmount = 0

local CLICKS_PER_SECOND_STRING_TEMPLATE = "(+AMOUNT/sec)"

local function UpdateClicksPerSecond(amount: number)
	local amountOfClicks = amount - PreviousClicksAmount
	PreviousClicksAmount = amount
	if amountOfClicks <= 0 then return end
	
	ClicksDuringSecond += amountOfClicks
	ClicksPerSecond.Text = CLICKS_PER_SECOND_STRING_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(ClicksDuringSecond))
	
	task.delay(1, function()
		ClicksDuringSecond -= amountOfClicks
		ClicksPerSecond.Text = CLICKS_PER_SECOND_STRING_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(ClicksDuringSecond))
		ClicksPerSecond.Visible = ClicksDuringSecond > 0		
	end)
end	
	
local function UpdateCurrency(currency: "Clicks" | "Gems", amount: number)
	if currency == "Clicks" then
		UpdateClicksPerSecond(amount)
		Clicks.Text = FormatNumber.FormatCompact(amount)
	elseif currency == "Gems" then
		Gems.Text = FormatNumber.FormatCompact(amount)
	end 
end

UpdateCurrency("Clicks", Remotes.GetData:InvokeServer("Clicks"))
UpdateCurrency("Gems", Remotes.GetData:InvokeServer("Gems"))

Remotes.UpdateClicks.OnClientEvent:Connect(function(amount)
	UpdateCurrency("Clicks", amount)
end)

Remotes.UpdateGems.OnClientEvent:Connect(function(amount)
	UpdateCurrency("Gems", amount)
end)