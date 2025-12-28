local require = require(script.Parent.loader).load(script)
local AttackBaseAbility = require("AttackBaseAbility")

local hitTouchTemplate = require("hitTouchTemplate")
local hitbox_start_stop = require("hitbox_start_stop")

local Heavy = setmetatable({}, AttackBaseAbility)
Heavy.__index = Heavy

Heavy.Type = "Attack"

function Heavy.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), Heavy)
	self.hitBox = self:createHitBox()

	return self
end
function Heavy:Execute()
	if self._cooldownController:getCD() then
		return
	end
	
	self._cooldownController:init(self.cooldown)
	local CHAR = self.character
	local newHitbox = self.hitBox

	--Settin attr
	self:SetAttributes()
	-------------
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")

	local hitFx = function()
		self:PlaySound("Heavy")
		CHAR:SetAttribute("Attacking", false)
		hitbox_start_stop(CHAR, newHitbox)
		CHAR:SetAttribute("Swing", false)
	end
	animHandler:OnSignal({
		callback = hitFx,
		animationName = "Heavy",
		animationEventName = "Hit",
	})
	local hitEnd = function(track: AnimationTrack)
		-- Ithink this is handled by autodestroy
		--newHitbox:Stop()

		if not CHAR:GetAttribute("IsBlocking") then
			self.humanoid.WalkSpeed = 14
			self.humanoid.JumpHeight = 6.5
		end
	end
	animHandler:OnSignal({
		callback = hitEnd,
		animationName = "Heavy",
		animationEventName = "EndedCon",
	})

	-- HITBOX SHIT

	local groundSmash = {
		position = nil,
		amount = 14,
		velocity = 70,
		material = Enum.Material.Slate,
		dust = true,
		shockwave = true,
		sizeRange = Vector2.new(1, 2.5),
		lifetime = 2.5,
	}

	local ragdoll = {
		duration = 1
	}
	local data = {
		serviceBag = self._serviceBag,
		strength = 50,
		ragdoll = ragdoll,
		groundSmash = groundSmash,
		damage = self.damage,
		hitBox = newHitbox,
		stun_time = self.stun_time
	}
	-- asumming the data is always the same, the connection should remain the same too
	if self._maid["Heavy"] then
			return
		end
	local hitTask = self.hitBox.Touched:Connect(hitTouchTemplate(data))
	self._maid:__newindex("Heavy", hitTask)
end

function Heavy:test()
	print("test me")
end

return Heavy
