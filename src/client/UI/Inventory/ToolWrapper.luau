local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FPS = require(ReplicatedStorage.Viewmodels.FPS)
local Maid = require(ReplicatedStorage.Nevermore.Quenty.maid.Shared.Maid)

local ToolWrapper = {}
ToolWrapper.__index = ToolWrapper

function ToolWrapper.new(tool, player)
	local self = setmetatable({}, ToolWrapper)
	
	self.tool = tool
	self.player = player
	self.FPS = FPS
	self.StarterGui = StarterGui
	self.RS = ReplicatedStorage
	self.BackpackCoreGui = Enum.CoreGuiType.Backpack
	self.maid = Maid.new()
	
	self:_initialize()
	
	return self
end

function ToolWrapper:_initialize()
	if not self.tool or not self.tool:IsA("Tool") then
		warn("Invalid tool provided to ToolWrapper")
		return
	end
	
	-- Connect Equipped event
	self.maid:GiveTask(self.tool.Equipped:Connect(function()
		self:_onEquipped()
	end))
	
	-- Connect Unequipped event
	self.maid:GiveTask(self.tool.Unequipped:Connect(function()
		self:_onUnequipped()
	end))
	
	-- Connect AncestryChanged for cleanup
	self.maid:GiveTask(self.tool.AncestryChanged:Connect(function()
		if not self.tool.Parent then
			self:Destroy()
		end
	end))
end

function ToolWrapper:_onEquipped()
	self.FPS:EquipGun("ViewmodelAnim")
	self.StarterGui:SetCoreGuiEnabled(self.BackpackCoreGui, false)
	
	task.delay(0.6, function()
		self.StarterGui:SetCoreGuiEnabled(self.BackpackCoreGui, true)
	end)
	
	self.RS.Events.Equipment:FireServer({
		tool = self.tool,
		has_to_equip = true,
	})
end

function ToolWrapper:_onUnequipped()
	self.StarterGui:SetCoreGuiEnabled(self.BackpackCoreGui, false)
	
	task.delay(0.6, function()
		self.StarterGui:SetCoreGuiEnabled(self.BackpackCoreGui, true)
	end)
	
	self.RS.Events.Equipment:FireServer({ has_to_equip = false })
end

function ToolWrapper:Destroy()
	self.maid:DoCleaning()
	setmetatable(self, nil)
end

return ToolWrapper