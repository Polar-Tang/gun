local RS = game:GetService("ReplicatedStorage")
local Roact = require(RS.Roact)

local src = script.Parent.src
local MainAppUI = require(src.MainApp)
local ctx = src.Context
local PromptProvider = require(ctx.PromptContext.PromptProvider)

local Players = game:GetService("Players")

local App = Roact.Component:extend("App")

function App:render()
	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = false,
	}, {
		PromptProvider = Roact.createElement(PromptProvider, {}, {
			AppUI = Roact.createElement(MainAppUI),
		}),
	})
end

local PlayerGui = Players.LocalPlayer.PlayerGui
Roact.mount(Roact.createElement(App), PlayerGui, "UI")

return App
