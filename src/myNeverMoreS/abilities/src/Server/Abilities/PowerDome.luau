-- TODO: It would be call if this is described and not directly executed, so move this logic to the effect service domain

local require = require(script.Parent.loader).load(script)
local AttackBaseAbility = require("AttackBaseAbility")

local hitTouchTemplate = require("hitTouchTemplate")
local hitbox_start_stop = require("hitbox_start_stop")

local PowerDome = setmetatable({}, AttackBaseAbility)
PowerDome.__index = PowerDome

-- Config is the data created by the weapon through the builder
function PowerDome.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), PowerDome)
	-- TODO: move this to the weaponInfo domain
	self.maxRadius = 20

	return self
end

function PowerDome:Execute()
	-- check if can run
	if self._cooldownController:getCD() then
		return
	end

	self._cooldownController:init(self.cooldown)
	--Settin attr
	-- self:SetAttributes()

	self.hitBox = self:createHitBox({
		Puncher = self.dome,
		mode = "Default",
	})

	------------- Create the description -------------
	local data
	do
		local ragdoll = {
			duration = 1,
		}
		data = {
			serviceBag = self._serviceBag,
			ragdoll = ragdoll,
			damage = nil,
			hitBox = self.hitBox,
			stun_time = self.stun_time,
			["Explosion"] = {
				["Explosion"] = true,
			},
			["Attacker"] = {
				["Character"] = self.character,
				["HRP"] = self.character.PrimaryPart,
			},

			["kockback"] = math.huge,
			["strength"] = 4000,
			["HRP"] = self.HRP,
		}
	end
	---------------------------------------------------------------------------------

	--create the connection
	-- asumming the data is always the same, the connection should remain the same too

	self._maid:DoCleaning()
	local hitTask = self.hitBox.Touched:Connect(hitTouchTemplate(data))
	hitTask.Destroy = hitTask.Disconnect
	self._maid:GiveTask(hitTask)

	-- PLay an animation
	-- TODO: get a cool asimation that resembles goku henkidama
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")

	-- Start the damn box
	task.defer(function()
		hitbox_start_stop(self.character, self.hitBox)
	end)
end

return PowerDome
