--Services
-- The weapon context strategy
local SoundService = game:GetService("SoundService")
local SoundFolder = SoundService.SFX
local WeaponSoundFolder = SoundFolder.Weapons
local Debris = game:GetService("Debris")
local require = require(script.Parent.loader).load(script)
local EffectService = require("EffectService")

local BaseObject = require("BaseObject")
local Weapon = {}
Weapon.__index = Weapon

local Strategies = {
	Fist = require("Fist"),
}

function Weapon.new(char: Model, serviceBag)
	local self = setmetatable(BaseObject.new(char), Weapon)
	self.Char = char
	self._weapon = nil
	self._serviceBag = serviceBag
	self.Humanoid = char:WaitForChild("Humanoid")

	self._defenseChain = {}

	if self.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		self.armName = "RightLowerArm"
		self.torso = self.Char:FindFirstChild("UpperTorso") 
	else
		self.armName = "Right Arm"
		self.torso = self.Char:FindFirstChild("Torso")
	end
	return self
end

function Weapon:Execute(action)
	self._weapon:Execute(action)
end
function Weapon:TakeHit(context)
	EffectService:Apply(context)
end

function Weapon:OnIncomingAttack(context)
	-- Context should be modified through the chain, and the last in the change is TakeHit
	task.defer(function()
		self:OnDefend(context)
	end)
end

function Weapon:OnDefend(context)
	-- Chain of Responsibility pattern
	local modifiedContext = context
	-- For the moment, the hit part always will be a torso
	context.HitPart =  self.torso

	for _, description in ipairs(self._defenseChain) do
		local modifier = description.modifier
		modifiedContext = modifier:Process(modifiedContext)

		-- If a modifier blocks completely, stop the chain
		if modifiedContext.blocked then
			return
		end
	end
	self:TakeHit(modifiedContext)
end

function Weapon:SetActiveDefense(class)
	table.insert(self._defenseChain, {
        modifier = class,
        priority = class.priority
    })
	
	table.sort(self._defenseChain, function(a, b)
        return a.priority < b.priority
    end)
end

function Weapon:ClearActiveDefense(priority)
	for index, desc in ipairs(self._defenseChain) do 
		if desc.priority == priority then
			table.remove(self._defenseChain, index)
		end
	end
end

function Weapon:OnDefended()
	self._weapon:OnDefended()
end

function Weapon:EquiTool(tool)
	local toolName = tool.Name
	if not Strategies[toolName] then
		warn("Weapon not found")
		return
	end
	self._weapon = Strategies[toolName].new(self.Char, self._serviceBag)
	self.tool = tool

	local arm = self.Char:FindFirstChild(self.armName)
	if not arm then
		warn(string.format("The %s should has a %s", self.Char.Name, self.armName))
		return
	end

	local M6D = Instance.new("Motor6D")
	M6D.Name = "ToolGrip"
	M6D.Parent = arm

	arm.ToolGrip.Part0 = arm
	arm.ToolGrip.Part1 = self.Char[toolName].BodyAttach
end

function Weapon:UnequiTool()
	if not self.tool then
		warn("No tool equiped")
		return
	end
	self.tool.BodyAttach.Trail.Enabled = false

	local arm = self.Char:FindFirstChild(self.armName)
	arm:FindFirstChild("ToolGrip"):Destroy()
	
	local UnEquipSound = self.Folder:WaitForChild("UnEquip"):Clone()
	UnEquipSound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	UnEquipSound:Play()
	Debris:AddItem(UnEquipSound, 1)
	self._weapon:UnEquip()
end

function Weapon:GetAction(action)
	return self._weapon:GetAction(action)
end

function Weapon:registryTool(toolName)
	local f = WeaponSoundFolder:FindFirstChild(toolName)
	if not f then
		warn("Weapon not found")
		return
	end

	self.Folder = f
	self.tool_name = toolName
end



-- If the sound thing causes issue we move it to a facade
function Weapon:PlaySound(lifeTime: number?, nameSound: string)
	local dur = lifeTime or 2
	local Sound = self.Folder[nameSound]:Clone()
	Sound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	Sound:Play()
	Debris:AddItem(Sound, dur)
end

function Weapon:PlaySwingSound(lifeTime: number?)
	print("Do you meant to use PlaySound ", debug.traceback())
	local dur = lifeTime or 1
	local SwordSwingSound = self.Folder:WaitForChild("Swing"):Clone()
	SwordSwingSound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	SwordSwingSound:Play()
	Debris:AddItem(SwordSwingSound, dur)
end

function Weapon:PlayHeavySound(lifeTime: number?)
	print("Do you meant to use PlaySound ", debug.traceback())

	local dur = lifeTime or 4
	local HeavySound = WeaponSoundFolder:WaitForChild(self.tool_name):WaitForChild("Heavy"):Clone() -- the sound is very important
	HeavySound.Parent = self.Char.HumanoidRootPart
	HeavySound:Play()
	Debris:AddItem(HeavySound, dur)
end

return Weapon
