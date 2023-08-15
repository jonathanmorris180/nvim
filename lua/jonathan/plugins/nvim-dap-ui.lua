-- local dap_status, dap = pcall(require, "dap")
-- if not dap_status then
-- 	print("dap not found")
-- 	return
-- end

local dapui_status, dapui = pcall(require, "dapui")
if not dapui_status then
	print("dapui not found")
	return
end

-- automatically open and close the UI when a debugging session has been created
-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	dapui.open({})
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	dapui.close({})
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	dapui.close({})
-- end

dapui.setup()
