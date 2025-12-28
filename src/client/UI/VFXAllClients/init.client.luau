--||Services||--
local RS = game:GetService("ReplicatedStorage")

--||Camera||--
local camera = game.Workspace.CurrentCamera

--||Camera Shake Module||--
local CameraShakeModule = require(RS.helpers.CameraShaker)
local camShake = CameraShakeModule.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)
camShake:Start()


--||VFX All Clients Function||--
RS.Events.VFX.OnClientEvent:Connect(function(action, ...)
	
end)
