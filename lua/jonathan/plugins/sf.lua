return {
	"xixiaofinland/sf.nvim",
	config = function()
		local nmap = function(keys, func, desc)
			if desc then
				desc = "[Sf] " .. desc
			end
			vim.keymap.set("n", keys, func, { desc = desc })
		end

		nmap("<leader><leader>t", require("sf.term").toggle, "[T]erminal toggle")

		-- other keys defined in after/ftplugins/apex.lua

		vim.api.nvim_create_autocmd({ "VimEnter" }, {
			callback = function()
				require("sf.org").fetch()
			end,
		})
	end,
}
