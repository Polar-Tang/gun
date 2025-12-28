--TODO: this script is only listeen for a single weapon, we need a weapon to listen to any weapon equipped by the player and fire Equipment remote event

--||Service||--
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BackpackCoreGui = Enum.CoreGuiType.Backpack
local FPS = require(ReplicatedStorage.Viewmodels.FPS)


--||Player||--
local player: Player = Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()

--||RemoteEvents||--
local remotes = RS.Events
local Equipment = remotes.Equipment
local tool = player.Backpack:WaitForChild("Fist")
------------------------------------------------------------------------------------------------------------------

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)


tool.Equipped:Connect(function()
	FPS:EquipGun("ViewmodelAnim")
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.delay(0.6, function()
		StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	end)

	Equipment:FireServer({
		tool = tool,
		has_to_equip = true,
	})
end)

tool.Unequipped:Connect(function()
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.delay(0.6, function()
		StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	end)
	Equipment:FireServer({
		has_to_equip = false,
	})
end)

-- local HitboxClass = require(ReplicatedStorage.HitboxClass)
-- Remotes events (i got the code smell to migrate this)
local Events = ReplicatedStorage.Events
local HitboxResponseRemote = Events.HitboxResponseRemote

-- This event is called in the server after it has Execute() the ability
-- HitboxResponseRemote.OnClientEvent:Connect(function(attackInfo)  
	
-- 	local Tool_sober: Tool = char:FindFirstChild("Fist")

-- 	if not Tool_sober then 
-- 		warn("Weapon don't found")
-- 		return 
-- 	end
-- 	-- Create a sword hitbox that follows the weapon
-- 	local hitbox = HitboxClass.new("Box", {
-- 		root = Tool_sober.BodyAttach,
-- 		size = Vector3.new(4, 1, 6),
-- 		duration = 2,
-- 		velocityPrediction = true,
-- 		dotProductFilter = {
-- 			dotProduct = 0.1,
-- 			referenceVector = char.PrimaryPart.CFrame.LookVector,
-- 			sourcePosition = char.PrimaryPart.Position,
-- 		},
-- 		hitboxId = "sword_" .. player.UserId,
-- 		HitMode = "Weak",
-- 		debug = true,
-- 	})
	
-- 	hitbox.OnHit:Connect(function(character, hitPart)
-- 		HitboxResponseRemote:FireServer(attackInfo.AttackID, character)
-- 	end)
	
-- 	hitbox:Start()
-- end)
