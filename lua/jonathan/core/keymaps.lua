vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<Esc>")
keymap.set("n", "<leader>j", ":nohl<CR>") -- clears search highlights

-- allow line movement when highlighted
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- format xml
keymap.set("n", "<leader>fx", ":%!xmllint '%' --format<CR>")

local function format_json()
	vim.cmd(":set filetype=json")
	vim.cmd(":%!jq '.'")
end

-- format json
keymap.set("n", "<leader>fj", format_json)

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
