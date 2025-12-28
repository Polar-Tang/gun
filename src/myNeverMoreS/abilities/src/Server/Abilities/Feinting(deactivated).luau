
--||Feint||--
--[[
local function Feinting(char,hum,action,toolName)
	if action == "Feint" then --the feint stuff is really bad lol
		print("Stop animation playing feint") 
		local animHandler = NPCAnimBinder:Get(char)
		print("animHandler ", animHandler)

		animHandler:LoadAnimation( true, "Feint")
		task.spawn(function()
			if char:GetAttribute("Combo") ~= 4 then 
				task.wait(.3)
				char:SetAttribute("Attacking", false)
				char:SetAttribute("Swing", false)
			else
				task.wait(1.6)
				char:SetAttribute("Attacking", false)
				char:SetAttribute("Swing", false)
			end
		end)
		local FeintSound = WeaponSoundFolder:WaitForChild(toolName):WaitForChild("Feint"):Clone()
		FeintSound.Parent = char:WaitForChild("HumanoidRootPart")
		FeintSound:Play()
		Debris:AddItem(FeintSound,1)
	end
end
]]