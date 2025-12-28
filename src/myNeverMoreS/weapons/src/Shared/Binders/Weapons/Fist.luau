local require = require(script.Parent.loader).load(script)
local WeaponBase = require("WeaponBase")
local AbilityBuilder = require("AbilityBuilder")
local Table = require("Table")

local WeaponInfo = Table.readonly(require("WeaponInfo"))
local WeaponStats = WeaponInfo.info.Fist

local Fist = setmetatable({}, WeaponBase)
Fist.__index = Fist

function Fist.new(char, serviceBag)
	local self = setmetatable(WeaponBase.new(char, serviceBag), Fist)
	self:_createAbilities()
	return self
end

function Fist:_createAbilities()
	local attackData = WeaponStats["attacks"]

	-- attacks of type Attack and maybe Movement in the future
	self.attacks, self.OnDefended = AbilityBuilder.new(self.char, self._serviceBag)
		:Add(Enum.UserInputType.MouseButton1, "M1", {
			name = "Basic",
			type = "Attack",
			_cooldown = attackData.Basic.cooldown,
			damage = attackData.Basic.damage,
			hitbox_size = attackData.Basic.hitbox_size,
			hitbox_offset = attackData.Basic.hitbox_offset,
			character = self.char,
			_max_combo = attackData.Basic.max_combo,
			stun_time = attackData.Basic.stun_time,
			tool_name = "Fist",
		})
		:Add(Enum.KeyCode.F, "Blocking", {
			name = "Blocking",
			type = "Defense",
			character = self.char,
			_cooldown = attackData.Basic.cooldown,
			damage = attackData.Basic.damage,
			hitbox_size = attackData.Basic.hitbox_size,
			hitbox_offset = attackData.Basic.hitbox_offset,
			_max_combo = attackData.Basic.max_combo,
			walk_speed_blocking = WeaponStats.walk_speed_blocking,
			parry_time = WeaponStats.parry_time,
			walk_speed_normal = WeaponStats.walk_speed_normal,
			tool_name = "Fist",
		})
		:Add(Enum.KeyCode.W, "Sprint", {
			name = "Sprint",
			type = "Movement",
			_cooldown = attackData.Sprint.cooldown,
			character = self.char,
			damage = attackData.Basic.damage,
			hitbox_size = attackData.Basic.hitbox_size,
			hitbox_offset = attackData.Basic.hitbox_offset,
			_max_combo = attackData.Basic.max_combo,
			tool_name = "Fist",
		})
		:Add(Enum.KeyCode.R, "Heavy", {
			name = "Heavy",
			type = "Attack",
			_cooldown = attackData.Heavy.cooldown,
			damage = attackData.Heavy.damage,
			hitbox_size = attackData.Heavy.hitbox_size,
			hitbox_offset = attackData.Heavy.hitbox_offset,
			character = self.char,
			stun_time = attackData.Heavy.stun_time,

			tool_name = "Fist",
		})
		:Add(Enum.KeyCode.T, "PowerDome", {
			name = "PowerDome",
			type = "Attack",
			_cooldown = attackData.PowerDome.cooldown,
			damage = attackData.PowerDome.damage,
			hitbox_size = attackData.PowerDome.hitbox_size,
			hitbox_offset = attackData.PowerDome.hitbox_offset,
			character = self.char,
			shape = attackData.PowerDome.shape,
			stun_time = attackData.PowerDome.stun_time,

			tool_name = "Fist",
		})
		:Build()

	if self.attacks then
		for _, ability in pairs(self.attacks) do
			self._maid:GiveTask(ability)
		end
	end

	-- This shit was intended to reduce the blocking atribute every second
	--[[
		self.char:GetAttributeChangedSignal("Blocking"):Connect(function()
			local isBlocking = character:GetAttribute("IsBlocking")
			-- IMPORTANT! LastStopTime do record the last blocking time... or something alike
			local lastStopTime = character:GetAttribute("LastStopTime") or 0
			local currentTime = tick()
	
			if not isBlocking and currentTime - lastStopTime >= block_reset_time then
				character:SetAttribute("Blocking", math.max(0, character:GetAttribute("Blocking") - 1.5))
			end
		end)
	]]
	return self
end

function Fist:Execute(action: string)
	if not self.attacks[action] then
		return
	end
	self.attacks[action]:Execute()
end

function Fist:GetAction(action: string)
	return self.attacks[action]
end

function Fist:UnEquip()
	self._maid:DoCleaning()
	return self:Destroy()
end

return Fist
