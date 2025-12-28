local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

--||Character||--
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character

--||Folder||--
-- TODO: use sounds
-- local SFXFolder = SoundService:WaitForChild("SFX")

--||Modules||--

local FPS = require(ReplicatedStorage.Viewmodels.FPS)
--||Settings||--
local debounce = false

------------------------------------------------------------------------------------------------------------------
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
char:WaitForChild("Humanoid").Died:Connect(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local M1 = {}

function M1.Execute() --function for starting to block
	-- local attacking = char:GetAttribute("Attacking")
	-- local Stunned = char:GetAttribute("Stunned")
	-- local IsRagdoll = char:GetAttribute("IsRagdoll")
	-- local Blocking = char:GetAttribute("IsBlocking")
	-- if attacking or Stunned or IsRagdoll or Blocking then return end

	debounce = true
	
    FPS:animate("Shoot") -- this should be handled by the command

	task.delay(1, function() 
        debounce = false
    end)
end 


function M1.Check()
	return not debounce 
end

return M1