local dap_status, dap = pcall(require, "dap")
if not dap_status then
	print("dap not found")
	return
end

local dap_utils_status, dap_utils = pcall(require, "dap.utils")
if not dap_utils_status then
	print("dap_utils not found")
	return
end

local languages = { "typescript", "javascript", "typescriptreact" }

for _, language in ipairs(languages) do
	-- based on vscode launch configurations: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations
	dap.configurations[language] = {
		-- debug single node.js files
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		-- debug express applications
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = dap_utils.pick_process,
			cwd = "${workspaceFolder}",
		},
		-- debug web applications
		{
			type = "pwa-chrome",
			request = "launch",
			name = 'Start Chrome with "localhost"',
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
		},
		{
			name = "Debug Spotify LWC Tests",
			type = "pwa-node",
			request = "launch",
			trace = true,
			runtimeArgs = {
				"${workspaceFolder}/node_modules/.bin/lwc-jest",
				"--skipApiVersionCheck",
			},
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			port = 9229,
		},
	}
end
