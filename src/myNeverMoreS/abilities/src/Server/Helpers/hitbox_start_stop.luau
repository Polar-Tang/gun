return function(char, newHitbox)
	if not newHitbox then
		return
	end
	
	task.spawn(function()
		newHitbox:Start()
		task.delay(0.5, function()
			newHitbox:Stop()
		end)
	end)
end
