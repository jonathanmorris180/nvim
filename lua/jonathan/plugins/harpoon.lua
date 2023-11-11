return {
	"theprimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup()
		local keymap = vim.keymap
		keymap.set("n", "<leader>ha", require("harpoon.mark").add_file, { desc = "[H]arpoon [A]dd file" })
		keymap.set(
			"n",
			"<leader>ht",
			require("harpoon.ui").toggle_quick_menu,
			{ desc = "[H]arpoon [T]oggle quick menu" }
		)
		keymap.set("n", "}", require("harpoon.ui").nav_next)
		keymap.set("n", "{", require("harpoon.ui").nav_prev)
	end,
}
