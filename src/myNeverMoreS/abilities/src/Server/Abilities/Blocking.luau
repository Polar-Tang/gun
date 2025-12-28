--||services||----
local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local SFXFolder = SoundService.SFX

local require = require(script.Parent.loader).load(script)

--||Modules||--

local stunt_client = require("stunt_client")
local DefenseBaseAbility = require("DefenseBaseAbility")
local CombatConstants = require("AbilityConstants")

-- SETTING CHARACTER ATTRIBUTES TO THE CHARACTER, REDUCES ITS VELOCITY
------------------------------------------------------------------------------------------------------------------

local Blocking = setmetatable({}, DefenseBaseAbility)
Blocking.__index = Blocking
Blocking.Type = "Defense"

function Blocking.new(config)
	local self = setmetatable(DefenseBaseAbility.new(config), Blocking)
	self.priority = CombatConstants.DefensePriority["PERFECT_BLOCK"]
	return self
end

function Blocking:Execute()
	--||Settings||--
	local character = self.character

	local parry_time = self.parry_time
	-- local walk_speed_normal = self.walk_speed_normal
	local walk_speed_blocking = self.walk_speed_blocking
	local isBlocking = character:GetAttribute("IsBlocking")
	-- local currentTime = tick()
	-- print("IsBlocking", character:GetAttribute("IsBlocking"))
	-- Blocking:Stop()
	local AnimationHandler = self._animHandler

	if not isBlocking then
		character:SetAttribute("IsBlocking", true)
		character:SetAttribute("LastStopTime", 0)
		character.Humanoid.WalkSpeed = walk_speed_blocking

		AnimationHandler:LoadAnimation(true, "Blocking")

		task.spawn(function()
			character:SetAttribute("Parrying", true)
			task.wait(parry_time)
			character:SetAttribute("Parrying", false)
		end)
		self:Activate()
	elseif isBlocking then
		self:Stop()
	end
end

function Blocking:_GuardBreak(): boolean?
	local char = self.character
	-- print("enemyChar:GetAttribute('Blocking')  ", char:GetAttribute("Blocking"))
	-- client effects
	RS.Events.VFX:FireAllClients("GuardBreak", char)

	local toolName = self.tool_name
	--stopAnims(char.Humanoid)

	-- PLAY GUARDBREAK SOUND
	do
		local BlockSound = SFXFolder.Weapons[toolName].BlockBreak:Clone()
		BlockSound.Parent = char:WaitForChild("HumanoidRootPart")
		BlockSound:Play()
		Debris:AddItem(BlockSound, 2)
	end

	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "GuardBreak")

	-- CHANGE THE PLAYER UI
	local enemyPlr = game:GetService("Players"):GetPlayerFromCharacter(char)
	if enemyPlr then
		RS.Events.VFX:FireClient(enemyPlr, "GuardBreakCamera")
		enemyPlr.PlayerGui.BlockingUi.MainFrame.Visible = false
		enemyPlr.PlayerGui.BlockingUi.MainFrame.Bar.Size = UDim2.new(0, 0, 1, 0)
	end

	local enemyH = char:WaitForChild("Humanoid")
	-- print("enemyH ", enemyH)
	stunt_client(enemyH, 3)

	self:Stop()
	return true
end

function Blocking:Process(context)
	local char = self.character
	local toolName = self.tool_name

	if not char:GetAttribute("Blocking") then
		return
	end

	RS.Events.VFX:FireAllClients("BlockingHit", char)

	local attValue = char:GetAttribute("Blocking")
	--char:SetAttribute("Blocking", attValue + damage * 2.75)
	char:SetAttribute("Blocking", attValue + 20)

	if char:GetAttribute("Blocking") >= 100 then
		self:_GuardBreak()
	end
	
	-- Play blocked sound
	do
		local BlockSound = SFXFolder.Weapons[toolName].Blocked:Clone()
		BlockSound.Parent = char:WaitForChild("HumanoidRootPart")
		BlockSound:Play()
		Debris:AddItem(BlockSound, 2)
	end
	context.blocked = true
	return context
end

function Blocking:Stop()
	local char = self.character
	local walk_speed_normal = self.walk_speed_normal
	local hum: Humanoid = self.humanoid
	hum.WalkSpeed = walk_speed_normal

	--ATT
	char:SetAttribute("IsBlocking", false)
	char:SetAttribute("Parrying", false)
	char:SetAttribute("LastStopTime", tick())
	char:SetAttribute("Blocking", 0)
	self._animHandler:LoadAnimation(false, "Blocking")
	self:Deactivate()
end
-- TODO: test enum types as keys
function Blocking:Deactivate()
    self.isActive = false
    self._weaponHandler:ClearActiveDefense(self.priority)
    -- Stop animation, etc.
end
--[[for i,v in pairs(workspace.Npcs:GetChildren()) do
	v:GetAttributeChangedSignal("Blocking"):Connect(function()
		onBlockingChanged(v)
	end)
end
]]

return Blocking
