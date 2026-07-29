--!strict
local Client = script.Parent.Parent :: Instance
local Controllers = Client:WaitForChild("Controllers") :: Instance

for _, module in Controllers:GetChildren() do
	if module:IsA("ModuleScript") then
		local success, controller = pcall(function()
			return require(module)
		end)

		if not success then
			warn(string.format("[ClientLoader] Failed to require '%s': %s", module.Name, tostring(controller)))
			continue
		end

		if type(controller) == "table" and type(controller.Init) == "function" then
			task.spawn(function()
				controller.Init()
			end)
		end
	end
end

print("========================================")
print(">>> REALMBREAKER CLIENT INITIALIZED <<<")
print("========================================")