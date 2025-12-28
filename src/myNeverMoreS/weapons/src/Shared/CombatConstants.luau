local SSS = game:GetService("ServerScriptService")
local AttacksFodler = SSS.Combat.Attacks

local require = require(script.Parent.loader).load(script)

local constants = {}

constants.ALL_ABILITIES = {
	["M1"] = require("Basic"),
	["Sprint"] = require("Sprint"),
	["Heavy"] = require("Heavy"),
	["Blocking"] = require("Blocking"),
}

return constants
