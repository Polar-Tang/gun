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
	Explosion: any,
	serviceBag: any,
	HRP: BasePart,
}

return function(parentClass, hitTarget)
	local BinderProvider = parentClass.serviceBag:GetService(_G.BinderProvider)
	-- weapon Binder
	local WeaponBinder = BinderProvider:Get("Armed")
	local NPCBinder = BinderProvider:Get("NPC")
	--newHitbox.Touched:Connect
	----------------------------------------------------
	local context = {
		Defender = {},
		Attacker = {},
		groundSmash = {},
		ragdoll = {},
		Explosion = {},
	} :: effectHitCtx
	local ENEMY_CHAR: Model = hitTarget
	context.Defender.Character = ENEMY_CHAR
	
	context.Defender.Humanoid = ENEMY_CHAR:WaitForChild("Humanoid")
	
	context.strength = parentClass.strength
	
	local ENEMYHRP = ENEMY_CHAR:WaitForChild("HumanoidRootPart")
	context.Defender.HRP = ENEMYHRP
	local CHAR = parentClass.attacker
	context.Attacker.Character = CHAR
	local HRP = CHAR:FindFirstChild("HumanoidRootPart") or parentClass.HRP

	local DIRECTION = (ENEMYHRP.Position - HRP.Position).Unit
	local knockback = DIRECTION * parentClass.strength

	context.kockback = knockback
	----------------------------------------------------
	-- LAST BUT NOT LEAST, IMPORTANT DATA FROM THE PARENT
	-- Overwrites groundSMash, if it exists it lacks the hit position, only know by this module
	context.id = parentClass.AttackID

	if parentClass.groundSmash then
		parentClass.groundSmash.position = ENEMYHRP.Position
	end
	context.hit_position = ENEMYHRP.Position
	context.groundSmash = parentClass.groundSmash
	context.damage = parentClass.damage
	context.stunt_time = parentClass.stun_time
	context.serviceBag = parentClass.serviceBag
	context.ragdoll = parentClass.ragdoll
	-- THIS IS NOT ELEGANT BUT WE NEED A WAY FOR STOPING ALL THE ANIMATION CONTROLLER AFTER RAGDOLL
	if context.ragdoll then
		local stateMachine = NPCBinder:Get(ENEMY_CHAR)
		if stateMachine and stateMachine.state and stateMachine.state.MovementController then
			stateMachine.state.MovementController:Stop()
		end
	end

	context.Explosion = parentClass.Explosion

	local weaponEnemy = WeaponBinder:Get(ENEMY_CHAR)
	weaponEnemy:OnIncomingAttack(context)
	----------------------------------------------------
	-- Handling the hit blocking
	-- Heavy will be an attribute set by the heavy attack, execute()
	-- CheckInfront will be an utility directly by the weapon
	-- CombatUtils.Blocking could be a weapon method too, self._weapon[strategy].blockig
	--[[
		
		do
			if ENEMY_CHAR:GetAttribute("Parrying") and not Heavy and CombatUtils.CheckInfront(CHAR, ENEMY_CHAR) then
				CombatUtils.Parrying(CHAR, ENEMY_CHAR)
				return
			end
			if ENEMY_CHAR:GetAttribute("IsBlocking") and not Heavy and CombatUtils.CheckInfront(CHAR, ENEMY_CHAR) then
				CombatUtils.Blocking(ENEMY_CHAR, Damage)
				return
			end
			if ENEMY_CHAR:GetAttribute("IsRagdoll") or ENEMY_CHAR:GetAttribute("Iframes") or enemyHum.Health <= 0 then
				return
			end

			if Heavy then
				CHAR:SetAttribute("Combo", 4)
			end
		end
		]]
	------------ CONSTANTS ------------

	--local STRENGTH = 10

	---------------------- HIT: ANIM, DAMAGA ----------------------
	--enemyHrp.CFrame = CFrame.lookAt(enemyHrp.Position, hrp.Position)--makes the enemy look at you, disabled it cuz it doesnt look good lol

	-- PLAY THE HIT FROM THE COMBO
	--print("Stop animation playing feint")
	--print("NPCAnimBinder ", NPCAnimBinder)
end

--[[
		if ragdoll then
			task.spawn(function()		
				ENEMYCHAR:SetAttribute("IsRagdoll", false)
				ENEMYCHAR:SetAttribute("IsRagdoll", true)
				task.wait(ragdollDuration)
				ENEMYCHAR:SetAttribute("IsRagdoll", false)
				ENEMYCHAR:SetAttribute("Iframes", true)
				if enemyHum.Health > 0 then
					RS.Events.VFX:FireAllClients("Iframes",ENEMYHRP,.4)
					task.delay(.4, function() ENEMYCHAR:SetAttribute("Iframes", false) end)
				end
			end)
		end
		]]
