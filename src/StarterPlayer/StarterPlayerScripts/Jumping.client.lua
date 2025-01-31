local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Character
local Humanoid: Humanoid

local Gui = PlayerGui:WaitForChild("Jumps")
local JumpsLabel = Gui.Frame.Jumps

local DEFAULT_JUMP_POWER = 50
local DEFAULT_WALK_SPEED = 16
local JUMP_JUMP_POWER = 100
local JUMP_WALK_SPEED = 50


local UsedJumps = 0
local MaxJumps = 2
local CanJump = false

local JUMP_TEXT_TEMPLATE = "Double Jumps: AMOUNT/MAX"

local tween = TweenService:Create(JumpsLabel, TweenInfo.new(0.5), {TextTransparency = 1})

tween.Completed:Connect(function()
    Gui.Enabled = false
end)

local function Jump()
    if not CanJump then return end
    if UsedJumps >= MaxJumps then
        Gui.Enabled = true
        JumpsLabel.TextTransparency = 0
        JumpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        Humanoid.JumpPower = DEFAULT_JUMP_POWER
        Humanoid.WalkSpeed = DEFAULT_WALK_SPEED
        tween:Play()
        return
    end

    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    Humanoid.JumpPower = JUMP_JUMP_POWER
    Humanoid.WalkSpeed = JUMP_WALK_SPEED
    UsedJumps += 1
    CanJump = false

    tween:Cancel()
    Gui.Enabled = true
    JumpsLabel.TextTransparency = 0
    JumpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpsLabel.Text = JUMP_TEXT_TEMPLATE:gsub("AMOUNT", MaxJumps - UsedJumps):gsub("MAX", MaxJumps)

end

local function CharacterAdded(character)
    Character = character
    Humanoid = Character:WaitForChild("Humanoid")
    UsedJumps = 0
    CanJump = true

    Humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            UsedJumps = 0
            CanJump = true
            tween:Play()
        elseif newState == Enum.HumanoidStateType.Freefall then
            task.wait(0.2)
            CanJump = true
        end
    end)
end

if Player.Character then
    CharacterAdded(Player.Character)
end

Player.CharacterAdded:Connect(CharacterAdded)
UserInputService.JumpRequest:Connect(Jump)
Remotes.PurchaseJump.OnClientEvent:Connect(function(jump)
    MaxJumps = jump
end)