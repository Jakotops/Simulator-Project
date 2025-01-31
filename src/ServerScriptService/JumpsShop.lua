local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage.Remotes
local PlayerDataManager = require(ServerScriptService.PlayerData.Manager)
local JumpsConfig = require(ReplicatedStorage.Configs.Jumps)


local JumpsShop = {}

function JumpsShop.PurchaseJump(player: Player)
    local profile = PlayerDataManager.Profiles[player]
    if not profile then return "profile not found!" end
    
    
    local nextJump = profile.Data.Jumps + 1
    local nextJumpPrice = JumpsConfig.Config[nextJump]
    if not nextJumpPrice then return "Max jumps purchased!" end
    local canAfford = profile.Data.Clicks >= nextJumpPrice
    if not canAfford then return "Cannot afford: " .. nextJumpPrice.."!" end
    
    print(nextJump)
    PlayerDataManager.AdjustClicks(player, -nextJumpPrice)
    profile.Data.Jumps = nextJump
    Remotes.PurchaseJump:FireClient(player, profile.Data.Jumps)
    return "Purchased jump!"

end

Remotes.PurchaseJump.OnServerEvent:Connect(JumpsShop.PurchaseJump)

return JumpsShop