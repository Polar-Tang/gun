local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotes = RS.Events
local VFX_Event: RemoteEvent = remotes.VFX

-- CUstom helpers/services
local require = require(script.Parent.loader).load(script)
local DebrisFX = require("DebrisFX")
local stunt_client = require("stunt_client")

local EffectService = {}

function EffectService.SetAttHit(hited)
	hited:SetAttribute("IsBlocking", false)
	hited:SetAttribute("Attacking", false)
	hited:SetAttribute("Swing", false)
	hited:SetAttribute("Parrying", false)
	hited:SetAttribute("IsBlocking", false)
end

export type effectHitCtx = {
	Defender: {
		Character: Model,
		Humanoid: Humanoid,
		HRP: BasePart,
	},
	Attacker: {
		Character: Model,
		Humanoid: Humanoid,
		HRP: BasePart,
	},
	groundSmash: {
		position: Vector3,
		amount: number,
		velocity: number,
		material: EnumItem,
		dust: boolean,
		shockwave: boolean,
		sizeRange: Vector2,
		lifetime: number,
	},
	strength: number,
	damage: number,
	kockback: Vector3,
	stunt_time: number,
	ragdoll: {
		isRag: boolean,
		duration: number,
	},
	serviceBag: any,
	hit_position: Vector3,
	Explosion: {},
	HitPart: BasePart,
}

--[[
force calculation:
local DIRECTION = (ENEMYHRP.Position - HRP.Position).Unit
local knockback = DIRECTION * parentClass.strength
]]

local function flyBack(enemy: BasePart, force)
	-- local bv = Instance.new("BodyVelocity")
	-- bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
	-- bv.P = 50000
	-- bv.Velocity = force
	-- bv.Parent = enemy
	-- Debris:AddItem(bv, 0.2)
	enemy:ApplyImpulse(force)
end

function EffectService:Apply(context: effectHitCtx)
	local serviceBag = context.serviceBag
	local RagdollService = serviceBag:GetService(require("Ragdoll"))

	local defender_char = context.Defender.Character :: Model
	local defender_humanoid = context.Defender.Humanoid
	local defender_hrp = context.Defender.HRP

	if context.ragdoll then
		RagdollService:Tag(defender_humanoid)

		--local impulse = context.kockback * Torso.AssemblyMass
		-- Torso:ApplyImpulse(impulse)

		-- local bv = Instance.new("BodyVelocity")
		-- bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
		-- bv.P = 50000
		-- bv.Velocity = context.kockback
		-- bv.Parent = Torso

		-- Debris:AddItem(bv, 0.2)

		--

		task.delay(context.ragdoll.duration, function()
			RagdollService:Untag(defender_humanoid)
		end)
	end

	if context.kockback and context.strength >= 35 then
		local force = context.kockback
		flyBack(context.HitPart, force)
	end

	-- Bug: it looks if the parent is self character to not make it damage and apply impulse. THis means that if there's a nested part force will be applyed on it
	if context.Explosion then
		local npcs = workspace:WaitForChild("Npcs")

		for _, character in ipairs(npcs:GetChildren()) do
			if not character:IsA("Model") then
				continue
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local root = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")

			if not humanoid or not root then
				continue
			end
			task.defer(function()
				flyBack(root, context.kockback)
				task.delay(0.3, function()
					humanoid:TakeDamage(100)
				end)
			end)
		end
		VFX_Event:FireAllClients("domeEffect")
		--
	end

	if context.groundSmash then
		local GConfig = context.groundSmash
		DebrisFX:GroundSmash({
			position = GConfig.position,
			amount = GConfig.amount,
			velocity = GConfig.velocity,
			material = GConfig.material,
			dust = GConfig.dust,
			shockwave = GConfig.shockwave,
			sizeRange = GConfig.sizeRange,
			lifetime = GConfig.lifetime,
		})
	end
	-- Decide what to do with strength
	-- local ragdollBinder = serviceBag:GetService(RagdollBindersServer).Ragdoll

	-- local ragdoll = ragdollBinder:Get(humanoid)
	-- if ragdoll then
	-- 	print("Is ragdolled")
	-- 	ragdollBinder:Unbind(humanoid)
	-- else
	-- 	print("Not ragdolled")
	-- 	ragdollBinder:Bind(humanoid)
	-- end

	if context.damage then
		defender_humanoid:TakeDamage(context.damage)
		defender_hrp.Anchored = false
	end

	stunt_client(defender_humanoid, context.stunt_time)

	self.SetAttHit(defender_char)
	--
	VFX_Event:FireAllClients("SwordHit", defender_char)
	local Player = Players:GetPlayerFromCharacter(defender_char)
	if Player then
		VFX_Event:FireClient(Player, "SwordHitShake")
	end
end

return EffectService
