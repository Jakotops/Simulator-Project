local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

local Gui = script.Parent
local Frame = Gui.Frame

local Click = Frame.Click.Stroke
local FastAuto = Frame.Fast
local RegularAuto = Frame.Regular


local BUTTON_OFF_COLOUR = Color3.fromRGB(179, 36, 12) 
local BUTTON_ON_COLOUR = Color3.fromRGB(75, 179, 44)
local STROKE_OFF_COLOUR = Color3.fromRGB(100, 19, 6) 
local STROKE_ON_COLOUR = Color3.fromRGB(45, 106, 26)
local CLICK_TEXT_TEMPLATE = "TYPE Auto Clicker (MODE)"

local RegularMode = false
local FastMode = false

local function UpdateButton(buttonType: "Regular" | "Fast", mode: boolean)
	local button
	if buttonType == "Regular" then
		button = RegularAuto
		RegularMode = mode
	else
		button = FastAuto
		FastMode = mode
	end
	
	if mode then
		button.BackgroundColor3 = BUTTON_ON_COLOUR
		button.Label.Text = CLICK_TEXT_TEMPLATE:gsub("TYPE", buttonType):gsub("MODE", "ON")
		button.Label.TextColor3 = BUTTON_ON_COLOUR
		button.Stroke.UIStroke.Color = STROKE_ON_COLOUR
	else
		button.BackgroundColor3 = BUTTON_OFF_COLOUR
		button.Label.Text = CLICK_TEXT_TEMPLATE:gsub("TYPE", buttonType):gsub("MODE", "OFF")
		button.Label.TextColor3 = BUTTON_OFF_COLOUR
		button.Stroke.UIStroke.Color = STROKE_OFF_COLOUR
	end
end

FastAuto.Stroke.MouseButton1Click:Connect(function()
	Remotes.UpdateAutoClicker:FireServer("Fast")
end)

RegularAuto.Stroke.MouseButton1Click:Connect(function()
	Remotes.UpdateAutoClicker:FireServer("Regular")
end)

Click.MouseButton1Click:Connect(function()
	Remotes.Click:FireServer()
end)

Remotes.UpdateAutoClicker.OnClientEvent:Connect(UpdateButton)
UpdateButton("Regular", Remotes.GetAutoClickMode:InvokeServer("Regular"))
UpdateButton("Fast", Remotes.GetAutoClickMode:InvokeServer("Fast"))