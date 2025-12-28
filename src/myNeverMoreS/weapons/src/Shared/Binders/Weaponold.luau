
-- local require = require(script.Parent.loader).load(script)
-- -- local Binder = require("Binder")
-- local WeaponController = require("WeaponController")

-- local Weapon = {}
-- Weapon.ServiceName = "Weapon"

-- function Weapon.new(char: Model, serviceBag)
-- 	local self = setmetatable(WeaponController.new(char, serviceBag), Weapon)
-- 	self._serviceBag = assert(serviceBag, "No serviceBag")
-- 	return self
-- end


-- -- something like this should be don in the binder provider
-- -- https://quenty.github.io/NevermoreEngine/docs/servicebag#dependency-injection-in-binders
-- -- Binder.new("Armed", require(constructor)) Binder.new("Ragdoll", require("RagdollClient"), serviceBag)
-- return Weapon
