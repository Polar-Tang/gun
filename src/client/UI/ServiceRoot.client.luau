--||Services||--
local RS = game:GetService("ReplicatedStorage")

--||Nevermore Shit||--
---------------------------getting servicebag and loader -----------------------------

local NeverMorePackages = RS.Nevermore
local loader = NeverMorePackages:FindFirstChild("LoaderUtils", true).Parent
local Nevermore = require(loader).bootstrapGame(NeverMorePackages)

local ServiceBag = Nevermore("ServiceBag")
local serviceBag = ServiceBag.new()

--------------------------- Binders -----------------------------

-- local BinderProvider = Nevermore("BinderProvider")

local DeathReportBindersClient = Nevermore("DeathReportBindersClient")
serviceBag:GetService(DeathReportBindersClient)
--------------------------- END Binders -----------------------------
--------------------------- others services -----------------------------

local PlayerBrio = Nevermore("PlayerBrio")


-------------------------START SERVICEBAG -----------------------------
serviceBag:Init()
serviceBag:Start()

_G.PlayerBrio = PlayerBrio.new() -- use the same instance for everything
_G.ServiceBagClient = serviceBag
_G.DeathReportBindersClient = DeathReportBindersClient

-- Ensures Roact App start after intializing service bag
require(script.Parent.App)
