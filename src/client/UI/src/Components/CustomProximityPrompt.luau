local rs = game:GetService("ReplicatedStorage")
local Roact = require(rs.Roact)
local CustomProximityPrompt = Roact.Component:extend("CustomProximityPrompt")

function CustomProximityPrompt:render()
	local prompt = self.props.prompt
	--print("props ", self.props)
	if not prompt then
		return
	end
	if prompt.Style ~= Enum.ProximityPromptStyle.Custom then
		return
	end

	local head = prompt.Parent
	local imagePrompt = "" -- MUST SET IT IN

	return Roact.createElement("BillboardGui", {
		AlwaysOnTop = true,
		Size = UDim2.fromOffset(64, 64),
		StudsOffset = Vector3.new(0, -1, 0),
		Adornee = head,
		Active = true,
	}, {
		button = Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = imagePrompt,
			[Roact.Event.Activated] = function()
				-- USE STRATEGIES HERE --
			end,
		}),
	})
end

return CustomProximityPrompt
