-- Weapon.lua
local require = require(script.Parent.loader).load(script)
local get_trail = require("get_trail")
local Maid = require("Maid")

local WeaponBase = {}
WeaponBase.__index = WeaponBase

type weaponBaseAbilities = {
	["M1"]: EnumItem,
	["Sprint"]: EnumItem,
	["Heavy"]: EnumItem,
	["Blocking"]: EnumItem,
}

type WeaponBase = {
	char: Model,
	-- attacks : weaponAbilities,
}

type weaponStats = {
	damage: number,
	heavy_damage: number,
	block_reset_time: number,
	parry_time: number,
	walk_speed_normal: number,
	walk_speed_blocking: number,
	stun_time: number,
	run_speed: number,
}

function WeaponBase.new(char: Model, serviceBag): WeaponBase
	local damn_data = {}
	damn_data.char = char
	damn_data._serviceBag = serviceBag
	local self = setmetatable(damn_data, WeaponBase)
	self._maid = Maid.new()
	-- enable the trail for the hitbox
	local trail = get_trail(char)
	if trail then
		trail.Enabled = true
	end

	return self
end
function WeaponBase:_createAbilities()
	error("Overwrite this method in child class")
end

function WeaponBase:GetAction()
	error("Overwrite this method in child class")
end

function WeaponBase:Execute()
	error("Overwrite this method in child class")
end

function WeaponBase:Start()
	self:_createAbilities()
end


function WeaponBase:Destroy()
	self._maid:DoCleaning()
	setmetatable(self, nil)
end
-- This will loop abilities, setting new ones based on the weapon type
--[[function Weapon:Start(weaponAbilities: {[string]})
	for keyCode, abilityName in pairs(weaponAbilities) do
		local abilityClass = assert(ALL_ABILITIES[abilityName], "Ability "..abilityName.." not found")
		self[keyCode] = abilityClass.new({
			name = abilityName,
		})
	end
end
]]
return WeaponBase
