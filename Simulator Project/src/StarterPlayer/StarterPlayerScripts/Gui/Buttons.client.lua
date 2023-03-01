local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gui = PlayerGui:WaitForChild("Left")
local Frame = Gui.Frame.Buttons

type ButtonInstance = typeof(Frame.Pets)

local HOVERED_ICON_COLOUR = Color3.fromRGB(58, 97, 108)
local DEFAULT_ICON_COLOUR = Color3.fromRGB(255, 255, 255)
local REWARD_TEXT_HOVER_COLOUR = Color3.fromRGB(249, 238, 48)

for _,child in Frame:GetChildren() do
	if not child:IsA("GuiButton") or child.Name == "Shop"  then continue end
	
	local button: ButtonInstance = child
	if button.Name == "Rewards" then
		button.MouseEnter:Connect(function()
			button.Title.TextColor3 = REWARD_TEXT_HOVER_COLOUR
		end)	
	else
		button.MouseEnter:Connect(function()
			button.Icon.ImageColor3 = HOVERED_ICON_COLOUR
			button.Title.TextColor3 = HOVERED_ICON_COLOUR
		end)
	end
	
	
	button.MouseLeave:Connect(function()
		button.Icon.ImageColor3 = DEFAULT_ICON_COLOUR
		button.Title.TextColor3 = DEFAULT_ICON_COLOUR
	end)
	
	
end