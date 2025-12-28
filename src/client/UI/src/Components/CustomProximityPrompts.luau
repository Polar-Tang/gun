local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))
local CustomProximityPrompt = require(script.Parent.CustomProximityPrompt)
local CustomProximityPrompts = Roact.Component:extend("CustomProximityPrompts")
local Helpers = script.Parent.Parent.Parent.Helpers
local theWS = require(Helpers.TheWorstSolutionToCleanPrompt)

function CustomProximityPrompts:render()
	local context = script.Parent.Parent.Parent.Context
	local dropItemCtx = require(context.DropItemContext.DropItemContext)
	local PromptContext = require(context.PromptContext.PromptContext)
	local QuestContext = require(context.QuestContext.QuestContext)
	local useContext = require(context.useContext)

	local withCtx = useContext({ PromptContext = PromptContext, dropItemCtx = dropItemCtx })

	return withCtx(function(ctx)
		--print("ctx ", ctx)
		local dropCTX = ctx.dropItemCtx
		local prompCTX = ctx.PromptContext
		local customProxComponents = {}
		local prompts = prompCTX.prompts
		--print("prompCTX.prompts ", prompCTX.prompts)
		for id, prompt in pairs(prompCTX.prompts) do
			--print("prompCTX ", prompCTX)
			customProxComponents[id] = Roact.createElement(CustomProximityPrompt, {
				prompt = prompt,
				callClose = prompCTX.callClose,
				dropItems = dropCTX.dropItems,
				removerItem = dropCTX.removerItem,
			})
		end
		return Roact.createFragment(customProxComponents)
	end)
end

return CustomProximityPrompts
