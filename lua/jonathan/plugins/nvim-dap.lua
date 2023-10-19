return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		local dap_utils = require("dap.utils")
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
				-- LWC jest
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
	end,
}
