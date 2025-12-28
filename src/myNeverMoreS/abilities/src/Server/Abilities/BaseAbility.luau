local Debris = game:GetService("Debris")

local SoundService = game:GetService("SoundService")
local SoundFolder = SoundService.SFX
local WeaponSoundFolder = SoundFolder.Weapons

local require = require(script.Parent.loader).load(script)
local CooldownController = require("CooldownController")
local Maid = require("Maid")

local BaseAbility = {}
BaseAbility.__index = BaseAbility

function BaseAbility.new(config)
	local self = setmetatable(config, BaseAbility)
	self.character = config.character
	self.humanoid = config.character:WaitForChild("Humanoid")

	self.sound_folder = WeaponSoundFolder[config.tool_name]

	self.walk_speed_blocking = config.walk_speed_blocking
	self._serviceBag = config._serviceBag
	self._cooldownController = CooldownController.new(config.character, config._serviceBag, config)

	self.RagdollService = self._serviceBag:GetService(require("Ragdoll"))

	self._maid = Maid.new()
	-- BINDERS
	assert(_G.BinderProvider, "Binder Provider not initialized")
	-- Get the animation binder
	local BinderProvider = self._serviceBag:GetService(_G.BinderProvider)
	-- weapon Binder
	local WeaponBinder = BinderProvider:Get("Armed")
	self._weaponHandler = WeaponBinder:Get(self.character)

	-- Animation Binder
	local AnimationBinder = BinderProvider:Get("AnimationHandler")
	self._animHandler = AnimationBinder:Get(self.character)

	return self
end

function BaseAbility:PlaySound(nameSound: string, lifeTime: number?)
	local dur = lifeTime or 2
	local Sound = self.sound_folder[nameSound]:Clone()
	Sound.Parent = self.character:WaitForChild("HumanoidRootPart")
	Sound:Play()
	Debris:AddItem(Sound, dur)
end

function BaseAbility:Execute(char)
	error("Execute must be overridden in subclass")
end

function BaseAbility:Destroy()
	setmetatable(self, nil)
	self._maid:DoCleaning()
	self = nil
end

return BaseAbility
