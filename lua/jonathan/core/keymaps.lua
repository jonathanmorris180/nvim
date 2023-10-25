vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<Esc>")
keymap.set("n", "<leader>j", ":nohl<CR>") -- clears search highlights

-- allow line movement when highlighted
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

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

-- open blame
keymap.set("n", "<leader>gb", ":Git<Space>blame<CR>")

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

-- SFDX
vim.api.nvim_create_user_command("SfdxDiffFile", function()
	local path = vim.fn.expand("%:p")
	local command = "SFDX_DIFF_JSON=$(sfdx force:source:diff -p "
		.. path
		.. " --json) && git diff $(echo ${SFDX_DIFF_JSON} | jq '.result.remote' -r) $(echo ${SFDX_DIFF_JSON} | jq '.result.local' -r)"
	local tmux = require("harpoon.tmux")
	tmux.sendCommand("{next}", command)
	tmux.gotoTerminal("{next}")
end, {})
keymap.set("n", "<leader>df", ":SfdxDiffFile<CR>")

-- markdown preview
keymap.set("n", "<leader>md", ":MarkdownPreview<CR>")
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>")

-- live server
keymap.set("n", "<leader>ls", ":LiveServerStart<CR>")
keymap.set("n", "<leader>lx", ":LiveServerStop<CR>")
