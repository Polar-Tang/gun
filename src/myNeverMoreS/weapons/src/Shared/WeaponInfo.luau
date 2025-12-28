local module = {}

local basic_fist = {
	damage = 4,
	heavy_damage = 8,
	cooldown = 0.5,
	max_combo = 5,
	hitbox_size = Vector3.new(5, 5, 4.5),
	hitbox_offset = CFrame.new(0, 0, -2.5),
	stun_time = 1.7,
}

local heavy_Fist = {
	damage = 8,
	hitbox_size = Vector3.new(5.5, 5.5, 5),
	hitbox_offset = CFrame.new(0, 0, -2.5),
	stun_time = 1.7,

	cooldown = 10,
}

local power_dome = {
	damage = 100,
	hitbox_size = Vector3.new(50, 25, 50),
	hitbox_offset = CFrame.new(0, 0, -2.5),
	stun_time = 3,
	shape = Enum.PartType.Ball,
	cooldown = 120,
}

local sprint = {
	cooldown = 5,
}

local info = {
	["Blocking_General"] = {
		Block_Reset_Time = 3, --the time it takes for the blocking value to go down after you last blocked
		Parry_Time = 0.25, --How long the parry last when you start blocking
	},

	["Fist"] = { --If you wan't to make a new weapon just copy and paste one of the already existing tables and change the name  to your weapons name!
		stun_time = 1.2, -- How Long The Enemy Is Stunned
		max_combo = 5,
		attacks = {
			Basic = basic_fist,
			Heavy = heavy_Fist,
			Sprint = sprint,
			PowerDome = power_dome,
		},
		block_reset_time = 3, --the time it takes for the blocking value to go down after you last blocked
		parry_time = 0.25, --How long the parry last when you start blocking
		walk_speed_normal = 14,
		walk_speed_blocking = 6,
		run_speed = 18,
	},
	["Dagger"] = {
		damage = 5,
		heavy_damage = 5, -- dagger has 2 hit events in his animation, so 5 x 2
		swing_reset = 0.1,
		stun_time = 1.75,
		hitbox_size = Vector3.new(5, 5, 5),
		heavy_hitbox_size = Vector3.new(5, 5, 5.5),
		hitbox_offset = CFrame.new(0, 0, -2.5),
		max_combo = 4,
	},
	["Katana"] = {
		damage = 6,
		heavy_damage = 10,
		swing_reset = 0.15,
		stun_time = 1.8,
		hitbox_size = Vector3.new(6, 6, 6),
		heavy_hitbox_size = Vector3.new(6.5, 6.5, 6.5),
		hitbox_offset = CFrame.new(0, 0, -2.5),
		max_combo = 4,
	},
	["Naginata"] = {
		damage = 7,
		heavy_damage = 11,
		swing_reset = 0.35,
		stun_time = 1.85,
		hitbox_size = Vector3.new(6, 6, 8),
		heavy_hitbox_size = Vector3.new(6, 6, 9),
		hitbox_offset = CFrame.new(0, 0, -3),
		max_combo = 4,
	},
}

module.info = info

function module:getweapon(WeaponName: string)
	return info[WeaponName]
end

return module
