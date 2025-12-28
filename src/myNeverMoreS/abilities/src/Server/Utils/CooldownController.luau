local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PromiseUtils = require(ReplicatedStorage.Nevermore.promise.Shared.PromiseUtils)
-- CooldownController.lua
-- local SSS = game:GetService("ServerScriptService")

-------------- TESTING ZONE --------------
-- local RS = game:GetService("ReplicatedStorage")
local require = require(script.Parent.loader).load(script)

local Cooldown = require("Cooldown")

local CooldownController = {}
CooldownController.__index = CooldownController

function CooldownController.new(char: Model, serviceBag)
	-- Binder constructor
	local self = setmetatable({}, CooldownController)
	self._serviceBag = serviceBag
	self.char = char
	local coolDown = serviceBag:GetService(Cooldown)
	self._cooldown = coolDown
	self:_createCD()
	return self
end
-- local require = require(RS.Nevermore.loader).load(script)
-- Service bag injection
--[[
function CooldownController:Start(serviceBag) end
function CooldownController:getCD()
	return Cooldown:Get(self._inst)
end
]]

function CooldownController:_createCD(cd: number?)
	local cooldownd = cd or 1
	local char = self.char

	self._inst = Instance.new("NumberValue")
	self._inst.Name = "AttackCooldown"
	self._inst.Value = cooldownd
	self._inst.Parent = char
	self._inst:AddTag("Cooldown")
end

--
function CooldownController:init(cd)
	self:_createCD(cd)
	task.defer(function()
		-- test with self._cooldown and getting directly by the service bag
		self._cooldown:Get(self._inst)
	end)
	--[[
		task.defer(function()
			local cd = Cooldown:Get(self._inst)
			print("Cooldown:", cd)
			print("self._inst.Parent ", self._inst.Parent)
		end)
	]]
end

function CooldownController:getCD()
	local controller = self._cooldown:Get(self._inst)
	return controller
end

function CooldownController:canAttack()
	local controller = self._cooldown:Get(self._inst)

	return controller:GetTimePassed() - controller.Value >= 0
end

function CooldownController:IsReady(): boolean
	assert(self._inst, "Do CooldownController:init(currentCD: number) first")
	local CD = self:getCD()
	return self.currentCD - CD:GetTimePassed() >= 0
end

function CooldownController:Destroy()
	print("AAAAAAAAAAAAAAAAh!")
end

return CooldownController
