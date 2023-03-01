local UserInputSerivce = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

UserInputSerivce.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 
		or input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.KeyCode.ButtonR2 then
		Remotes.Click:FireServer()
	end
end)
