--||Service||--
local Players = game:GetService("Players")

local PlayerBrio = _G.PlayerBrio

--||Helpers||--
local ToolWrapper = require(script.Parent.ToolWrapper)

--||Player||--
local player: Player = Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()

local toolControllers = {}

local connectTool = function(tool)
	if not tool or not tool:IsA("Tool") then
		return
	end

	local wrapper = ToolWrapper.new(tool, player)
	toolControllers[tool] = wrapper
end

-- Listen for tools added to the backpack
player.Backpack.ChildAdded:Connect(connectTool)

-- initial backpack tools
for _, t in ipairs(player.Backpack:GetChildren()) do
	connectTool(t)
end



-- Wrap it to the player brio to clean up on death
PlayerBrio:Subscribe(function(characterBrio)
	local character = characterBrio:GetValue()
	local maid = characterBrio:ToMaid()
	
	maid:GiveTask(player.CharacterAdded:Connect(function(newChar)
		char = newChar
		for _, t in ipairs(char:GetChildren()) do
			connectTool(t)
		end
		char.ChildAdded:Connect(connectTool)
	end))
	
	maid:GiveTask(character.Humanoid.Died:Connect(function()
		-- Clean up tool wrappers on death
		for _, wrapper in pairs(toolControllers) do
			wrapper:Destroy()
		end
		toolControllers = {}
	end))
	-- TODO: Handle character (respawn) and tools parented to character
end)
