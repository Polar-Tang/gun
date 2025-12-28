local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remotes events (i got the code smell to migrate this)
local Events = ReplicatedStorage.Events
local HitboxResponseRemote = Events.HitboxResponseRemote

return function(resolve, reject, scopeMaid, detectionInfo)
	-- Listen to client on hit parts
	local character = detectionInfo.Attacker
	local attacker_player = Players:GetPlayerFromCharacter(character)

	local connection = HitboxResponseRemote.OnServerEvent:Connect(function(player, attackID, hitTargets)
		if player == attacker_player and attackID == detectionInfo.AttackID then
			resolve(hitTargets) -- Promise resolves with hit targets
			-- targets
		end
	end)

	-- Add connection to scoped maid so it cleans up
	scopeMaid:GiveTask(connection)

	-- Fire to client to start detection
	HitboxResponseRemote:FireClient(attacker_player, detectionInfo)
	
	-- scopeMaid:GiveTask(task.delay(detectionInfo.Time + 0.2, function()
	-- 	reject("Client detection timeout")
	-- end))
	-- while hitTargets
end -- :: useClient: (any, any, typeof(Maid.new()), any) -> ()
