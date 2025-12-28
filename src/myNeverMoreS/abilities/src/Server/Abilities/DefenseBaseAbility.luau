-- Abstract class for Defense abilities
local require = require(script.Parent.loader).load(script)
local BaseAbility = require("BaseAbility")

local DefenseAbility =  setmetatable({}, BaseAbility)
DefenseAbility.__index = DefenseAbility

function DefenseAbility.new(config)
    local self = setmetatable(BaseAbility.new(config), DefenseAbility)
    self.isActive = false
    return self
end

function DefenseAbility:Execute()
    error("This method should be override by child class")
end

-- link the handler to the chain, should be called in every :Execute()
function DefenseAbility:Activate()
    self.isActive = true
    
    self._weaponHandler:SetActiveDefense(self)
end

function DefenseAbility:Process(context)
    error("This method should be override by child class")
end



return DefenseAbility