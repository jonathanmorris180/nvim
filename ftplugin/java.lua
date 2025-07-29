local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

local function get_config_dir()
	---@diagnostic disable-next-line: undefined-field
	local arch = vim.uv.os_uname().machine
	if arch == "x86_64" then
		return "/config_mac"
	end
	return "/config_mac_arm"
end

local config_dir = jdtls_dir .. get_config_dir()

-- Dynamically find jar so it doesn't break on updates to jdtls
local function find_jar()
	local plugins_dir = jdtls_dir .. "/plugins/"
	for file in vim.fs.dir(plugins_dir) do
		if file:find("org.eclipse.equinox.launcher_") then
			return plugins_dir .. file
		end
	end
end

local function find_highest_temurin()
	local java_candidates = vim.fn.expand("$HOME/.sdkman/candidates/java")
	local versions = {}

	-- Iterate over the installed Java versions
	for file in vim.fs.dir(java_candidates) do
		local version = file:match("^(%d+%.%d+%.%d+%-tem)$") -- Match Temurin versions like 23.0.2-tem
		if version then
			table.insert(versions, version)
		end
	end

	-- Sort versions in descending order
	table.sort(versions, function(a, b)
		local function parse_version(v)
			local major, minor, patch = v:match("(%d+)%.(%d+)%.(%d+)")
			return tonumber(major), tonumber(minor), tonumber(patch)
		end
		local a1, a2, a3 = parse_version(a)
		local b1, b2, b3 = parse_version(b)
		if a1 ~= b1 then
			return a1 > b1
		end
		if a2 ~= b2 then
			return a2 > b2
		end
		return a3 > b3
	end)

	-- Return the highest version found
	return versions[1] or nil
end

local path_to_jar = find_jar()
local path_to_lombok = jdtls_dir .. "/lombok.jar"
-- see https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
local path_to_java_dap = vim.fn.expand("$HOME/java-debug-0.48.0/com.microsoft.java.debug.plugin/target")
-- The JDK to run jdtls itself should be the latest Temurin (Adoptium) since Eclipse makes both JDTLS and Temurin (https://adoptium.net/)
local highest_temurin = find_highest_temurin()

if not highest_temurin then
	vim.notify("Temurin SDK not found - please install the latest Temurin SDK with sdkman", vim.log.levels.ERROR)
end
local java_home = vim.fn.expand("$HOME/.sdkman/candidates/java/" .. find_highest_temurin())

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" } -- these tell the lsp that we are in a java project
local bazel_root_markers = { "BUILD.bazel" }
local kotlin_root_markers = { "kls_database.db" }
local status, jdtls_setup = pcall(require, "jdtls.setup")
if not status then
	vim.notify("Could not load jdtls.setup", vim.log.levels.ERROR)
	return
end
local root_dir = jdtls_setup.find_root(root_markers)
local bazel_root_dir = jdtls_setup.find_root(bazel_root_markers)
if bazel_root_dir ~= nil or kotlin_root_markers ~= nil then
	-- Don't activate in monorepo
	return
end
if root_dir == "" then
	vim.notify("Could not find root dir for jdtls")
	return
end

local maven_module = require("jonathan.core.utils").get_maven_module()

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:h:t")
	.. "_"
	.. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t") -- fixes issue where root dir isn't unique
if maven_module then
	project_name = project_name .. "_" .. maven_module
end

-- if the server fails to start, try deleting vim.fn.stdpath("data") .. "/site" (see https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#troubleshooting)
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name -- this is where jdtls saves the cache files
os.execute("mkdir -p " .. workspace_dir) -- create the workspace dir if it doesn't exist

-- Main Config
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		java_home .. "/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. path_to_lombok,
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		path_to_jar,
		"-configuration",
		config_dir,
		"-data",
		workspace_dir,
	},

	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = root_dir,

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			home = java_home, -- java home
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						path = java_home,
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = true, -- format on save (this doesn't seem to work consistently) see https://github.com/mfussenegger/nvim-jdtls/issues/533 for a potential solution
				settings = {
					url = vim.fn.stdpath("config") .. "/java/intellij-java-google-style.xml",
					profile = "GoogleStyle",
				},
			},
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
			importOrder = {
				"java",
				"javax",
				"com",
				"org",
			},
		},
		extendedClientCapabilities = {
			classFileContentsSupport = true,
		},
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},

	flags = {
		allow_incremental_sync = true,
	},
	init_options = {
		bundles = {
			vim.fn.glob(path_to_java_dap .. "/com.microsoft.java.debug.plugin-0.48.0.jar", true),
		},
	},
}

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	vim.notify("Could not load cmp_nvim_lsp", vim.log.levels.ERROR)
	return
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

local jdtls_status, jdtls = pcall(require, "jdtls")
if not jdtls_status then
	vim.notify("Could not load jdtls", vim.log.levels.ERROR)
	return
end

local keymap = vim.keymap -- for conciseness
local on_attach = function(_, bufnr)
	-- keybind options
	local opts = function(desc)
		return { desc = "Lspsaga: " .. desc, buffer = bufnr, noremap = true, silent = true }
	end

	---------------
	-- Debugging --
	---------------
	local function get_test_runner(test_name, debug)
		if debug then
			return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
		end
		return 'mvn test -Dtest="' .. test_name .. '"'
	end

	local function tmux_execute_in_next_window(command)
		os.execute(string.format('tmux next-window && tmux send-keys "%s" C-m', command))
	end

	local function run_java_test_method(debug)
		local utils = require("jonathan.core.utils")
		local method_name = utils.get_current_full_method_name("#")
		tmux_execute_in_next_window(get_test_runner(method_name, debug))
	end

	local function run_java_test_class(debug)
		local utils = require("jonathan.core.utils")
		local class_name = utils.get_current_full_class_name()
		tmux_execute_in_next_window(get_test_runner(class_name, debug))
	end

	keymap.set("n", "<leader>tm", function()
		run_java_test_method()
	end, { desc = "Run Java test method" })
	keymap.set("n", "<leader>TM", function()
		run_java_test_method(true)
	end, { desc = "Run Java test method with maven.surefire.debug enabled" })
	keymap.set("n", "<leader>tc", function()
		run_java_test_class()
	end, { desc = "Run Java test class" })
	keymap.set("n", "<leader>TC", function()
		run_java_test_class(true)
	end, { desc = "Run Java test class with maven.surefire.debug enabled" })

	local function get_spring_boot_runner(profile, debug)
		local debug_param = ""
		local profile_param = ""

		if profile then
			profile_param = " -Dspring-boot.run.profiles=" .. profile
		end

		if debug then
			debug_param =
				' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"'
		end

		return "mvn spring-boot:run " .. profile_param .. debug_param
	end

	local function run_spring_boot(debug)
		tmux_execute_in_next_window(get_spring_boot_runner("local", debug))
	end

	vim.api.nvim_create_user_command("JavaAttachToDebugger", function()
		local dap = require("dap")
		dap.configurations.java = {
			{
				type = "java",
				request = "attach",
				name = "Java debug",
				hostName = "localhost",
				port = "5005",
			},
		}
		dap.continue()
	end, {})

	keymap.set("n", "<leader>sb", function()
		run_spring_boot()
	end, { desc = "Run Spring Boot program" })
	keymap.set("n", "<leader>sd", function()
		run_spring_boot(true)
	end, {
		desc = 'Run Spring Boot with -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"',
	})
	keymap.set("n", "<leader>da", ":JavaAttachToDebugger<CR>", { desc = "Attach Java debugger" })

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts("(Lspsaga) Show definition/references"))
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts("Go to declaration"))
	keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts("Go to definition")) -- remove <cmd>Lspsaga peek_definition<CR> as this fails with "Cursor position outside buffer" error
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts("Go to implementation"))
	keymap.set("n", "<leader>ga", "<cmd>Lspsaga code_action<CR>", opts("(Lspsaga) Show available code actions"))
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts("(Lspsaga) Smart rename"))
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts("(Lspsaga) Show diagnostics for line"))
	keymap.set(
		"n",
		"<leader>d",
		"<cmd>Lspsaga show_cursor_diagnostics<CR>",
		opts("(Lspsaga) Show diagnostics for cursor")
	)
	keymap.set(
		"n",
		"[d",
		"<cmd>Lspsaga diagnostic_jump_prev<CR>",
		opts("(Lspsaga) Jump to previous diagnostic in buffer")
	)
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts("(Lspsaga) Jump to next diagnostic in buffer"))
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts("(Lspsaga) Show documentation for what is under cursor"))

	jdtls.setup_dap({ hotcodereplace = "auto" })
end

config["on_attach"] = on_attach
config["capabilities"] = capabilities
jdtls.start_or_attach(config)
