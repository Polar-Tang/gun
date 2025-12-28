local require = require(script.Parent.loader).load(script)

-- Binders
--||Helpers||--

--classes
local BaseAbility = require("BaseAbility")

local Sprint = setmetatable({}, BaseAbility)
Sprint.__index = Sprint

-- Config is the data created by the weapon through the builder
function Sprint.new(config)
	local self = setmetatable(BaseAbility.new(config), Sprint)
	return self
end

function Sprint:Execute()
	local char = self.character

	if self._cooldownController:getCD() then
		return
	end
	self._cooldownController:init(self.cooldown)
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = self.walk_speed_normal
	self._animHandler:LoadAnimation(true, "Sprint")

	char:SetAttribute("Sprinting", true)
end

return Sprint
