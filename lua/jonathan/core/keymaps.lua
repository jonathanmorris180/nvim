vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<Esc>")
keymap.set("n", "<leader>j", ":nohl<CR>") -- clears search highlights

-- allow line movement when highlighted
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- format xml
keymap.set("n", "<leader>fx", ":%!xmllint '%' --format<CR>")

-- duplicate selection below (above can easily be done without keymap)
keymap.set("v", "P", "y'>p")

-- Q to exit visual line mode
keymap.set("v", "q", "<Esc>")

-- keep cursor in position
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "J", "mzJ`z")

-- disable Q
keymap.set("n", "Q", "<nop>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("n", "<leader>on", ":vnew<CR>") -- open a new split window

-- tabs
keymap.set("n", "<leader>tn", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tl", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>th", ":tabp<CR>") --  go to previous tab

-- allow copy to clipboard
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>yy", '"+yy')

-- enable/disable diagnostics
keymap.set("n", "<leader>dd", ":DisableDiagnostics<CR>")
keymap.set("n", "<leader>de", ":EnableDiagnostics<CR>")

vim.api.nvim_create_user_command("DisableDiagnostics", function()
	vim.diagnostic.disable()
end, {})
vim.api.nvim_create_user_command("EnableDiagnostics", function()
	vim.diagnostic.enable()
end, {})

-- quickfix
keymap.set("n", "<leader>qo", "<CMD>copen<CR>") -- open the quickfix list
keymap.set("n", "<leader>qx", "<CMD>cclose<CR>") -- close the quickfix list
keymap.set("n", "<leader>qc", "<CMD>cexpr []<CR>") -- clear the quickfix list

-------------
-- Buffers --
-------------
keymap.set("n", "<leader>yp", ":Cppath<CR>") -- copy relative path of current buffer
keymap.set("n", "<leader>bd", ":%bd|e#<CR>") -- close all buffers except current
keymap.set("n", "<leader>n", ":bn<CR>") -- go to next buffer (in order of when they were opened)
keymap.set("n", "<leader>p", ":bp<CR>") -- go to previous buffer (in order of when they were opened)
keymap.set("n", "<leader>w", ":update<CR>") -- save (:update only saves if there are changes)
-- :wa actually uses :update according to this: https://vi.stackexchange.com/questions/42066/updateall-command-to-update-all-files
keymap.set("n", "<leader>sa", ":wa<CR>") -- save all buffers
keymap.set("n", "<leader>qq", ":qa!<CR>") -- quit all buffers
keymap.set("n", "<leader>c", ":q!<CR>") -- quit the current buffer
keymap.set("n", "<leader>r", ":e!<CR>") -- refresh buffer
keymap.set("n", "<Up>", "10<C-w>>") -- increase window width
keymap.set("n", "<Down>", "10<C-w><") -- decrease window width

---------------------
-- Plugin Keybinds --
---------------------
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Git
keymap.set("n", "<leader>gb", ":Git<Space>blame<CR>")
keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>")
keymap.set("n", "<leader>do", ":DiffviewOpen<CR>")
keymap.set("n", "<leader>dc", ":DiffviewClose<CR>")

-- yanky keymaps
keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
keymap.set("n", "H", "<Plug>(YankyCycleForward)")
keymap.set("n", "L", "<Plug>(YankyCycleBackward)")
keymap.set("n", "<leader>yh", "<CMD>YankyRingHistory<CR>")

-- toggle undo tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

---------------
-- Debugging --
---------------

keymap.set("n", "<leader>dt", ':lua require("dapui").toggle()<CR>')
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
keymap.set("n", "<leader>dr", ":lua require('dap').repl.open()<CR>")

local function get_test_runner(test_name, debug)
	if debug then
		return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
	end
	return 'mvn test -Dtest="' .. test_name .. '"'
end

local function run_java_test_method(debug)
	local utils = require("jonathan.core.utils")
	local method_name = utils.get_current_full_method_name("#")
	local tmux = require("harpoon.tmux")
	tmux.sendCommand("{next}", get_test_runner(method_name, debug))
	tmux.gotoTerminal("{next}")
end

local function run_java_test_class(debug)
	local utils = require("jonathan.core.utils")
	local class_name = utils.get_current_full_class_name()
	local tmux = require("harpoon.tmux")
	tmux.sendCommand("{next}", get_test_runner(class_name, debug))
	tmux.gotoTerminal("{next}")
end

keymap.set("n", "<leader>tm", function()
	run_java_test_method()
end)
keymap.set("n", "<leader>TM", function()
	run_java_test_method(true)
end)
keymap.set("n", "<leader>tc", function()
	run_java_test_class()
end)
keymap.set("n", "<leader>TC", function()
	print("running test class in debug")
	run_java_test_class(true)
end)

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
	local tmux = require("harpoon.tmux")
	tmux.sendCommand("{next}", get_spring_boot_runner("local", debug))
	tmux.gotoTerminal("{next}")
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
end)
keymap.set("n", "<leader>sd", function()
	run_spring_boot(true)
end)
keymap.set("n", "<leader>da", ":JavaAttachToDebugger<CR>")

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

local ScratchBufferCreator = {}

function ScratchBufferCreator:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ScratchBufferCreator:create_scratch()
	if self.bufnr == nil or not vim.api.nvim_buf_is_valid(self.bufnr) then
		if self.bufnr == nil or not vim.api.nvim_buf_is_valid(self.bufnr) then
			self.bufnr = vim.api.nvim_create_buf(false, true)
		end

		-- check if the buffer is already displayed in a window
		local win_found = false
		for _, win_id in pairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win_id) == self.bufnr then
				win_found = true
				break
			end
		end

		-- if not displayed, open it in a vertical split
		if not win_found then
			vim.cmd("vsplit")
			vim.api.nvim_win_set_buf(0, self.bufnr)
		end
	end
end

function ScratchBufferCreator:write_to_scratch(data)
	if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) then
		-- split data into lines if it's a single string with newlines
		if type(data) == "string" then
			data = vim.split(data, "\n")
		end
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, data)
	end
end

function ScratchBufferCreator:clear_scratch()
	if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) then
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {})
	end
end

function ScratchBufferCreator:close_scratch()
	if self.bufnr and vim.api.nvim_buf_is_valid(self.bufnr) then
		vim.api.nvim_buf_delete(self.bufnr, { force = true })
		self.bufnr = nil
	end
end

local scratchBuffer = ScratchBufferCreator:new()

vim.api.nvim_create_user_command("SfdxExecuteFile", function()
	local path = vim.fn.expand("%:p")
	local file_type = vim.fn.expand("%:e")

	if file_type ~= "apex" then
		vim.notify("Not an Apex script file.", vim.log.levels.ERROR)
		return
	end

	local command = "sf apex run -f " .. path
	vim.notify("Running " .. command .. "...")
	local output = vim.fn.system(command)
	vim.notify("Adding output to scratch buffer...")
	scratchBuffer:create_scratch() -- this ensures the same buffer is reused
	scratchBuffer:write_to_scratch(output)
end, {})

-- recursively search for the file
local function find_file(path, target)
	local scanner = vim.loop.fs_scandir(path)
	-- if scanner is nil, then path is not a valid dir
	if scanner then
		local file, type = vim.loop.fs_scandir_next(scanner)
		while file do
			if type == "directory" then
				local found = find_file(path .. "/" .. file, target)
				if found then
					return found
				end
			elseif file == target then
				return path .. "/" .. file
			end
			-- get the next file and type
			file, type = vim.loop.fs_scandir_next(scanner)
		end
	end
end

local metadata_type_map = {
	["lwc"] = "LightningComponentBundle",
	["aura"] = "AuraDefinitionBundle",
	["classes"] = "ApexClass",
	["triggers"] = "ApexTrigger",
	["pages"] = "ApexPage",
	["components"] = "ApexComponent",
	["flows"] = "Flow",
	["objects"] = "CustomObject",
	["layouts"] = "Layout",
	["permissionsets"] = "PermissionSet",
	["profiles"] = "Profile",
	["labels"] = "CustomLabels",
	["staticresources"] = "StaticResource",
	["sites"] = "CustomSite",
	["applications"] = "CustomApplication",
	["roles"] = "UserRole",
	["groups"] = "Group",
	["queues"] = "Queue",
}

local function get_metadata_type(filePath)
	for key, metadataType in pairs(metadata_type_map) do
		if filePath:find(key) then
			return metadataType
		end
	end
	return nil
end

local function get_file_name_without_extension(fileName)
	-- (.-) makes the match non-greedy
	-- see https://www.lua.org/manual/5.3/manual.html#6.4.1
	return fileName:match("(.-)%.%w+%-meta%.xml$") or fileName:match("(.-)%.[^%.]+$")
end

local function diff_with_org()
	local path = vim.fn.expand("%:p")
	local file_name = vim.fn.expand("%:t")
	local file_name_no_ext = get_file_name_without_extension(file_name)
	local metadataType = get_metadata_type(path)

	if metadataType == nil then
		vim.notify("Not a supported metadata type.", vim.log.levels.ERROR)
		return
	end

	vim.notify("Retrieving " .. file_name .. " from the org...")
	local temp_dir = vim.fn.tempname()
	local temp_dir_with_suffix = string.format("%s/main/default", temp_dir)
	vim.fn.mkdir(temp_dir_with_suffix, "p")
	vim.notify("temp_dir_with_suffix: " .. temp_dir_with_suffix)

	local command =
		string.format("sf project retrieve start -m %s:%s -r %s --json", metadataType, file_name_no_ext, temp_dir)
	vim.notify("Running " .. command .. "...")
	local sfdx_output = vim.fn.system(command)
	local json_start = sfdx_output:find("{")
	local json_part = json_start and sfdx_output:sub(json_start) or ""

	-- parse the JSON
	local json_ok, sfdx_response = pcall(vim.json.decode, json_part)
	if not json_ok or not sfdx_response then
		vim.notify("Failed to parse the SFDX command output.", vim.log.levels.ERROR)
		return
	end

	-- check for messages and notify if present
	if sfdx_response.result and sfdx_response.result.messages and #sfdx_response.result.messages > 0 then
		for _, message in ipairs(sfdx_response.result.messages) do
			vim.notify(message.problem, vim.log.levels.ERROR)
		end
		return
	end

	local retrieved_file_path = find_file(temp_dir, file_name)
	vim.notify("Temp file path: " .. (retrieved_file_path or "Not found"))

	if not retrieved_file_path or not vim.fn.filereadable(retrieved_file_path) then
		vim.notify("Failed to retrieve the file from the org.", vim.log.levels.ERROR)
		return
	end

	vim.notify("Diffing " .. file_name .. " with the retrieved file...")
	vim.cmd("vert diffsplit " .. retrieved_file_path)
	vim.fn.delete(temp_dir, "rf")
end

local function push_to_org()
	local path = vim.fn.expand("%:p")
	local file_name = vim.fn.expand("%:t")

	vim.notify("Pushing " .. file_name .. " to the org...")
	local command = string.format("sfdx force:source:deploy -p %s --json", path)
	vim.notify("Running " .. command .. "...")
	local sfdx_output = vim.fn.system(command)

	local json_start = sfdx_output:find("{")
	local json_part = json_start and sfdx_output:sub(json_start) or ""

	local json_ok, sfdx_response = pcall(vim.json.decode, json_part)
	if not json_ok or not sfdx_response then
		vim.notify("Failed to parse the SFDX command output.", vim.log.levels.ERROR)
		return
	end

	if sfdx_response.result and sfdx_response.result.deployedSource and #sfdx_response.result.deployedSource > 0 then
		for _, source in ipairs(sfdx_response.result.deployedSource) do
			if source.error then
				vim.notify(source.error, vim.log.levels.ERROR)
				return
			end
		end
	elseif sfdx_response.code and sfdx_response.code == 1 then
		vim.notify(sfdx_response.message, vim.log.levels.ERROR)
		return
	end
	vim.notify("Pushed " .. file_name .. " successfully!")
end

vim.api.nvim_create_user_command("DiffWithOrg", diff_with_org, {})
vim.api.nvim_create_user_command("SfdxPush", push_to_org, {})

-- Sfdx
keymap.set("n", "<leader>se", ":SfdxExecuteFile<CR>")
keymap.set("n", "<leader>sp", ":SfdxPush<CR>")
keymap.set("n", "<leader>sd", ":DiffWithOrg<CR>")

-- markdown preview
keymap.set("n", "<leader>md", ":MarkdownPreview<CR>")
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>")

-- live server
keymap.set("n", "<leader>ls", ":LiveServerStart<CR>")
keymap.set("n", "<leader>lx", ":LiveServerStop<CR>")

-- switch case
local function switch_case()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local word = vim.fn.expand("<cword>")
	local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

	-- detect camelCase
	if word:find("[a-z][A-Z]") then
		-- convert camelCase to snake_case
		local snake_case_word = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
	-- detect snake_case
	elseif word:find("_[a-z]") then
		-- convert snake_case to camelCase
		local camel_case_word = word:gsub("(_)([a-z])", function(_, l)
			return l:upper()
		end)
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
	else
		print("Not a snake_case or camelCase word")
	end
end

vim.api.nvim_create_user_command("SwitchCase", switch_case, {})
keymap.set("n", "<leader>sc", ":SwitchCase<CR>")
