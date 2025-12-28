
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

-- local DeathReportBinders = Nevermore("DeathReportBinders")
-- serviceBag:GetService(DeathReportBinders)
--------------------------- END Binders -----------------------------
--------------------------- others services -----------------------------



-------------------------START SERVICEBAG -----------------------------
serviceBag:Init()
serviceBag:Start()

_G.ServiceBag = serviceBag
-- _G.DeathReportBinders = DeathReportBinders
