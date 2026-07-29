--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local Server = ServerScriptService:WaitForChild("Server")
local Services = Server:WaitForChild("Services")

-- Require Services from Server/Services directory
local SaveService = require(Services:WaitForChild("SaveService") :: ModuleScript)
local WorldService = require(Services:WaitForChild("WorldService") :: ModuleScript)
local CultivationService = require(Services:WaitForChild("CultivationService") :: ModuleScript)
local WorldObjectService = require(Services:WaitForChild("WorldObjectService") :: ModuleScript)
local CombatService = require(Services:WaitForChild("CombatService") :: ModuleScript)

-- Initialize Services in Order
SaveService.Init()
WorldService.Init()
CultivationService.Init()
WorldObjectService.Init()
CombatService.Init()

print("========================================")
print(">>> REALMBREAKER SERVER INITIALIZED <<<")
print("========================================")