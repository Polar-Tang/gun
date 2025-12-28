local require = require(script.Parent.loader).load(script)

local ALL_ABILITIES = {
	["M1"] = require("M1"),
	["Sprint"] = require("Sprint"),
	["Heavy"] = require("Heavy"),
	["Blocking"] = require("Blocking"),
	["PowerDome"] = require("PowerDome"),
}

local AbilityBuilder = {}
AbilityBuilder.__index = AbilityBuilder

-- The pop drilling to service bag ends... HERE!
function AbilityBuilder.new(char, serviceBag)
	return setmetatable({
		character = char,
		_map = {},
		_serviceBag = serviceBag,
		OnDefended = nil,
	}, AbilityBuilder)
end

type WeaponStats = {
	_cooldown: number?,
	damage: number?,
	_serviceBag: any,
	type: string,
	character: Model,
	name: string,
	tool_name: string?,
	_max_combo: number,
}

function AbilityBuilder:Add(inputKey, abilityName, config: WeaponStats)
	local AbilityClass = ALL_ABILITIES[abilityName]
	-- Get the cooldown controller from service bag to every ability

	config._serviceBag = self._serviceBag
	config.character = self.character
	local newAbility = AbilityClass.new(config)
	self._map[inputKey] = newAbility
	if config.type == "Defense" then
		-- local ability = DefenseAbility.new
		function self.OnDefended()
			newAbility:OnDefended()
		end
	end

	return self
end

function AbilityBuilder:Build()
	return self._map
end

return AbilityBuilder
