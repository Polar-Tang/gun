local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local head = script.Parent.Parent:WaitForChild("Head")
local subject = Instance.new("Part")
subject.Size = Vector3.new(0.5,0.5,0.5)
subject.Transparency = 1
subject.CanTouch = false
subject.CanQuery = false
subject.CanCollide = false
subject.Anchored = true
subject.Shape = Enum.PartType.Ball
subject.Parent = camera

subject.Position = head.Position
camera.CameraSubject = subject

local WEIGHT_XZ = 4
local WEIGHT_Y = 4

local function updateSubject()
	local subPos = subject.Position
	local headPos = head.Position

	local xzPos = Vector3.new(subPos.X,0,subPos.Z):Lerp(Vector3.new(headPos.X,0,headPos.Z),1/WEIGHT_XZ)
	local yPos = Vector3.new(0,subPos.Y,0):Lerp(Vector3.new(0,headPos.Y,0),1/WEIGHT_Y)

	subject.Position = xzPos + yPos
end

RunService:BindToRenderStep("UpdateSubject", Enum.RenderPriority.Camera.Value, updateSubject)