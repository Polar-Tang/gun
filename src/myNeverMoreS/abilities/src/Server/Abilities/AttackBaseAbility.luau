local Players = game:GetService("Players")
-- The attacks abilities does not deal damage instantly, they rather describe intentes and derive that to the weapon's enemy
local require = require(script.Parent.loader).load(script)
local useClient = require("useClient")
local HitboxModule = require("MuchachoHitbox")
local get_trail = require("get_trail")
local BaseAbility = require("BaseAbility")
local Maid = require("Maid")
local Promise = require("Promise")

-- local BadDummy = game:GetService("ServerStorage"):FindFirstChild("BadDummy")
-- local npcs = game:GetService("Workspace").Npcs
local AttackBaseAbility = setmetatable({}, BaseAbility)
AttackBaseAbility.__index = AttackBaseAbility

type AttackBaseAbilityConfig = {
	name: string,
	cooldown: number?,
	damage: number,
	_max_combo: number?,
	_serviceBag: any,
	character: Model,
	hitbox_size: Vector3,
	hitbox_offset: CFrame,
}

function AttackBaseAbility.new(config)
	local self = setmetatable(BaseAbility.new(config), AttackBaseAbility)
	self._attacks = {} :: { typeof(Promise.new()) }
	self._lastAttackID = 0
	self.player = Players:GetPlayerFromCharacter(self.character)

	return self
end
function AttackBaseAbility:createHitBox(config)
	local CHAR = self.character
	local hitbox_offset = self.hitbox_offset
	local hitbox_size = self.hitbox_size

	local HRP = CHAR:WaitForChild("HumanoidRootPart")
	local trail = get_trail(CHAR)
	local tool = CHAR:FindFirstChildWhichIsA("Tool")
	if tool and trail then
		trail.Enabled = false
	end
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { CHAR }

	local newHitbox = HitboxModule.CreateHitbox()
	newHitbox.Size = hitbox_size
	newHitbox.CFrame = HRP
	newHitbox.Offset = hitbox_offset
	newHitbox.OverlapParams = params
	newHitbox.AutoDestroy = false
	newHitbox.Puncher = (config and config.Puncher) or CHAR
	newHitbox.DetectionMode = "HitOnce" or config.mode
	newHitbox.Shape = Enum.PartType.Block or config.shape
	-- newHitbox:Start()
	return newHitbox
end

function AttackBaseAbility:SetAttributes()
	local CHAR = self.character
	local HUM = CHAR:WaitForChild("Humanoid")

	CHAR:SetAttribute("Attacking", true)
	CHAR:SetAttribute("Swing", true)

	HUM.WalkSpeed = 7
	HUM.JumpHeight = 0
end

-- Create a promise with a csoped maid for the useClient function
function AttackBaseAbility:CreateScopedPromise(detectionInfo)
	local scopeMaid = Maid.new()

	local PromiseTask = Promise.new(function(resolve, reject)
		useClient(resolve, reject, scopeMaid, detectionInfo)
	end)
	--[[
	:Finally(function()
		-- always clean, on resolve, reject, or by expiring
		scopeMaid:DoCleaning()
	end)
	]]

	return PromiseTask
end
function AttackBaseAbility:_countAttack()
	self._lastAttackID += 1
end

function AttackBaseAbility:_GenerateAttackID()
	-- Simple incrementing ID or use HttpService:GenerateGUID()

	return self.player.UserId .. "_" .. self._lastAttackID
end

return AttackBaseAbility
