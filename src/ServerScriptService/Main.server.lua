--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local Services = ServerScriptService:WaitForChild("Services")
local WorldObjectService = require(ServerScriptService.Services.WorldObjectService)


-- Require Services
local DataService = require(Services:WaitForChild("DataService") :: ModuleScript)
local WorldService = require(Services:WaitForChild("WorldService") :: ModuleScript)
local CultivationService = require(Services:WaitForChild("CultivationService") :: ModuleScript)
local SkillService = require(Services:WaitForChild("SkillService") :: ModuleScript)


-- Initialize Services in Order
DataService.Init()
WorldService.Init()
CultivationService.Init()
WorldObjectService.Init()
SkillService.Init()

print("========================================")
print(">>> REALMBREAKER SERVER INITIALIZED <<<")
print("========================================")