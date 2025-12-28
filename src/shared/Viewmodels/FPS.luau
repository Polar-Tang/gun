local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local Viewmodels = ReplicatedStorage:WaitForChild("Viewmodels")
local viewModel: Model

function module:animate(type)
	if viewModel then
		viewModel.AnimationController:LoadAnimation(viewModel.AnimationController[type]):Play()
	end
end

-- TODO: this should be handled by the weapon equip system
function module:EquipGun(Name)
	viewModel = Viewmodels:WaitForChild(Name):Clone()
	viewModel.Parent = workspace.CurrentCamera
	module:animate("Idle")
end

RS.RenderStepped:Connect(function()
	if viewModel then
		viewModel:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame)
	end
end)

return module
