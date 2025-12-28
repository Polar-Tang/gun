local ReplicatedStorage = game:GetService("ReplicatedStorage")
local hitTouchTemplate = require(ReplicatedStorage.Nevermore.Custom.abilities.src.Server.Utils.hitTouchTemplate)
local require = require(script.Parent.loader).load(script)

-- Binders
--||Helpers||--
local CooldownController = require("CooldownController")

local hitbox_start_stop = require("hitbox_start_stop")
--utils
-- local hitTouchTemplate = require("hitTouchTemplate")

--classes
local AttackBaseAbility = require("AttackBaseAbility")

local Basic = setmetatable({}, AttackBaseAbility)
Basic.__index = Basic

-- Config is the data created by the weapon through the builder
function Basic.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), Basic)
	self._comboController = CooldownController.new(config.character, config._serviceBag, config)

	return self
end

-- RETURN THE WEAPON ANIMATION FOR THE NEXT COMBO
function Basic:getSwingAnimation(): string
	local char = self.character
	local combo = char:GetAttribute("Combo")

	return "Swing" .. combo
end

--[[
function for changing the players combo
set the current combo as an attribute
and stores the cooldown
]]
function Basic:_ChangeCombo()
	-- SET THE COMBO ATT
	local char = self.character
	local Max_Combo = self._max_combo

	-- If the last hit was after 3 seconds, reset the combo
	if not self._comboController:getCD() then
		-- print("current combo ", char:GetAttribute("Combo"))
		char:SetAttribute("Combo", 1)
		self._comboController:init(3)
		return
	end

	self._comboController:init(3)

	local combo = char:GetAttribute("Combo")

	if combo >= Max_Combo then
		char:SetAttribute("Combo", 1)
	else
		char:SetAttribute("Combo", combo + 1)
	end

	-- Cooldown handler goes here
	-- sets the Tick for cc
	-- self._cooldownController:init(self.cooldown)s
end

function Basic:Execute()
	if self._cooldownController:getCD() then
		return
	end

	self._cooldownController:init(self.cooldown)
	local CHAR = self.character

	local HUM = CHAR:WaitForChild("Humanoid")
	self:_ChangeCombo()

	local swingName: string = self:getSwingAnimation()

	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, swingName)

	--Settin attr
	self:SetAttributes()
	self:_countAttack()
	-------------

	local current_combo = CHAR:GetAttribute("Combo")

	local max_combo = self._max_combo
	local hitFx = function()
		CHAR:SetAttribute("Attacking", false)
		hitbox_start_stop(self.character, self.hitBox)
		self:PlaySound("Swing", 2)
		CHAR:SetAttribute("Swing", false)
	end
	animHandler:OnSignal({
		callback = hitFx,
		animationName = swingName,
		animationEventName = "Hit",
	})
	local hitEnd = function(track: AnimationTrack)
		-- Ithink this is handled by autodestroy
		--newHitbox:Stop()

		if not CHAR:GetAttribute("IsBlocking") then
			HUM.WalkSpeed = 14
			HUM.JumpHeight = 6.5
		end
	end

	animHandler:OnSignal({
		callback = hitEnd,
		animationName = swingName,
		animationEventName = "EndedCon",
	})

	local data = {
		serviceBag = self._serviceBag,
		damage = self.damage,
		attacker = self.character,
		stun_time = self.stun_time,
	}
	if current_combo == max_combo then
		data.strength = 4000
		data.groundSmash = {
			position = nil,
			amount = 14,
			velocity = 70,
			material = Enum.Material.Slate,
			dust = true,
			shockwave = true,
			sizeRange = Vector2.new(1, 2.5),
			lifetime = 2.5,
		}
		data.ragdoll = {
			duration = 1.2,
		}
	else
		data.strength = 1000
	end

	-- describe more data used fot the effect
	local attackId = self:_GenerateAttackID()
	--[[
	self._maid:DoCleaning()
	local hitTask = self.hitBox.Touched:Connect(hitTouchTemplate(data))
	hitTask.Destroy = hitTask.Disconnect
	
	self._maid:GiveTask(hitTask)
	]]

	-- Create promise for client detection
	local detectionInfo = {
		Time = 2,
		Size = self.hitbox_size,
		CFrame = self.hitbox_offset,
		AttackID = attackId,
		Attacker = self.character,
	}

	self:CreateScopedPromise(detectionInfo):Then(function(hitTarget)
		hitTouchTemplate(data, hitTarget)
	end)
end

return Basic
