local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.parent_pattern_exists(root_patterns)
	return vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
end

function M.is_worktree()
	return M.parent_pattern_exists({ "packed-refs" }) ~= nil
end

function M.is_submodule()
	return M.parent_pattern_exists({ ".gitmodules" }) ~= nil
end

function M.is_obsidian_vault()
	return M.parent_pattern_exists({ ".obsidian" }) ~= nil
end

-- Find nodes by type
local function find_parent_by_type(expr, type_name)
	while expr do
		if expr:type() == type_name then
			break
		end
		expr = expr:parent()
	end
	return expr
end

-- Find child nodes by type
local function find_child_by_type(expr, type_name)
	local id = 0
	local expr_child = expr:child(id)
	while expr_child do
		if expr_child:type() == type_name then
			break
		end
		id = id + 1
		expr_child = expr:child(id)
	end

	return expr_child
end

-- Get Current Method Name
function M.get_current_method_name()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then
		return nil
	end

	local expr = find_parent_by_type(current_node, "method_declaration")
	if not expr then
		return nil
	end

	local child = find_child_by_type(expr, "identifier")
	if not child then
		return nil
	end
	return vim.treesitter.get_node_text(child, 0)
end

-- Get Current Class Name
function M.get_current_class_name()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then
		return nil
	end

	local class_declaration = find_parent_by_type(current_node, "class_declaration")
	if not class_declaration then
		return nil
	end

	local child = find_child_by_type(class_declaration, "identifier")
	if not child then
		return nil
	end
	return vim.treesitter.get_node_text(child, 0)
end

-- Get Current Package Name
function M.get_current_package_name()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then
		return nil
	end

	local program_expr = find_parent_by_type(current_node, "program")
	if not program_expr then
		return nil
	end
	local package_expr = find_child_by_type(program_expr, "package_declaration")
	if not package_expr then
		return nil
	end

	local child = find_child_by_type(package_expr, "scoped_identifier")
	if not child then
		return nil
	end
	return vim.treesitter.get_node_text(child, 0)
end

-- Get Current Full Class Name
function M.get_current_full_class_name()
	local package = M.get_current_package_name()
	local class = M.get_current_class_name()
	return package .. "." .. class
end

-- Get Current Full Method Name with delimiter or default '.'
function M.get_current_full_method_name(delimiter)
	delimiter = delimiter or "."
	local full_class_name = M.get_current_full_class_name()
	local method_name = M.get_current_method_name()
	return full_class_name .. delimiter .. method_name
end

local function escape_pattern(text)
	return text:gsub("([^%w])", "%%%1")
end

function M.get_maven_module()
	local utils = require("jonathan.core.utils")
	local current_file = vim.fn.expand("%:p")
	local is_java_file = vim.bo.filetype == "java" -- just in case this isn't used in ftplugin/java.lua
	local root_dir = utils.parent_pattern_exists({ "pom.xml" })
	if not root_dir or not is_java_file then
		return nil
	end
	local relative_path_to_current_file = current_file:gsub(escape_pattern(root_dir .. "/"), "")
	local first_element = vim.split(relative_path_to_current_file, "/")[1]
	local root_contents = vim.split(vim.fn.glob(root_dir .. "/*"), "\n", { trimempty = true })
	local module_paths = vim.split(vim.fn.glob(root_dir .. "/*/pom.xml"), "\n")
	local modules_exist = #module_paths > 0
	if modules_exist then
		-- check if the current file is in a maven module
		for _, path in ipairs(root_contents) do
			local file_or_dir = vim.fn.fnamemodify(path, ":t")
			if vim.fn.isdirectory(path) == 1 and first_element == file_or_dir then
				-- the first element of the relative path to the current file is a directory
				-- and we know we are in a multi-module maven project
				return first_element
			end
		end
	end
	return nil
end

-- Check if the root .gitignore contains .fdb_latexmk (which should be ignored in a LaTeX project)
function M.is_tex_project()
	local root = require("jonathan.core.utils").parent_pattern_exists(".gitignore")

	if not root then
		return false
	end

	local lines = vim.fn.readfile(root .. "/.gitignore")

	if #lines == 0 then
		return false
	end

	for _, line in ipairs(lines) do
		if line:match("%.fdb_latexmk") then
			return true
		end
	end
	return false
end

--- Return the visually selected text as an array with an entry for each line
--- Pulled from https://www.reddit.com/r/neovim/comments/1b1sv3a/function_to_get_visually_selected_text/
--- @return string[]|nil lines The selected text as an array of lines.
function M.get_visual_selection_text()
	local _, srow, scol = unpack(vim.fn.getpos("v"))
	local _, erow, ecol = unpack(vim.fn.getpos("."))

	-- visual line mode
	if vim.fn.mode() == "V" then
		if srow > erow then
			return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
		else
			return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
		end
	end

	-- regular visual mode
	if vim.fn.mode() == "v" then
		if srow < erow or (srow == erow and scol <= ecol) then
			return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
		else
			return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
		end
	end

	-- visual block mode
	if vim.fn.mode() == "\22" then
		local lines = {}
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		for i = srow, erow do
			table.insert(
				lines,
				vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
			)
		end
		return lines
	end
end

function M.switch_case()
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

function M.edit_visual_selection(formatted_string)
	local _, srow, scol = unpack(vim.fn.getpos("v"))
	local _, erow, ecol = unpack(vim.fn.getpos("."))
	-- in case we start selecting from the end of the selection
	if srow > erow then
		srow, erow = erow, srow
	end
	if scol > ecol then
		scol, ecol = ecol, scol
	end
	local text = M.get_visual_selection_text()
	local result = string.format(formatted_string, vim.fn.join(text, ""))
	vim.api.nvim_buf_set_text(vim.api.nvim_get_current_buf(), srow - 1, scol - 1, erow - 1, ecol, { result })
end

----------------
--- Markdown ---
----------------

-- unused because the nvim-markdown plugin has a better implementation but keeping for reference as replacing a highlighted selection in the future might be useful
function M.add_markdown_link()
	M.edit_visual_selection("[%s](%s)")
	-- Exit visual mode
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
	vim.api.nvim_feedkeys("f(", "i", true) -- move cursor to the first bracket
end

function M.markdown_bold()
	M.edit_visual_selection("**%s**")
	-- Exit visual mode because selection is now different - TODO: Select the surrounded word instead
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
end

function M.markdown_italic()
	M.edit_visual_selection("*%s*")
	-- Exit visual mode
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
end

function M.markdown_strikethrough()
	M.edit_visual_selection("~~%s~~")
	-- Exit visual mode
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)
end

function M.toggle_markdown_bullet()
	local line = vim.api.nvim_get_current_line()

	-- Matches a line that starts with 0 or more spaces (^%s*), followed by a bullet (%-), followed by a space
	local pattern = "^%s*%- "
	if line:match(pattern) then
		-- Remove bullet
		line = line:gsub(pattern, "", 1)
	else
		-- Add bullet
		line = "- " .. line
	end

	vim.api.nvim_set_current_line(line)
end

function M.set_markdown_header(delta)
	local current_line = vim.api.nvim_get_current_line()
	local fist_char = string.sub(current_line, 1, 1)
	local hashes, rest = current_line:match("^(#*)(.*)$")
	if #hashes == 1 and delta < 0 then
		vim.notify("Header at minimum", vim.log.levels.INFO)
		return
	elseif #hashes == 6 and delta > 0 then
		vim.notify("Header at maximum", vim.log.levels.INFO)
		return
	end
	if fist_char == "#" then
		local new_count = math.max(1, math.min(6, #hashes + delta))
		local line_with_new_header = string.rep("#", new_count) .. rest
		vim.api.nvim_set_current_line(line_with_new_header)
	else
		vim.notify("No markdown header found", vim.log.levels.INFO)
	end
end

-- formats bullets so that there are only two spaces instead of four since this is the default formatting used in Obsidian (this setting can't be changed as far as I know)
function M.format_bullet_list()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- Uses the same regex pattern as in obsidian-plugin-prettier: https://github.com/hipstersmoothie/obsidian-plugin-prettier/blob/main/src/main.ts
	local pattern = "^([ ]*)[-*][ ]+"
	local replacement = "%1- "

	for i, line in ipairs(lines) do
		lines[i] = line:gsub(pattern, replacement)
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

return M
