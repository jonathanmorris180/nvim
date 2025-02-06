return {
	"theprimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup()
		local keymap = vim.keymap
		keymap.set("n", "<leader>ha", require("harpoon.mark").add_file, { desc = "(Harpoon) [H]arpoon [a]dd file" })
		keymap.set(
			"n",
			"<leader>ht",
			require("harpoon.ui").toggle_quick_menu,
			{ desc = "(Harpoon) [H]arpoon [t]oggle quick menu" }
		)
		keymap.set("n", "}", require("harpoon.ui").nav_next, { desc = "(Harpoon) Next harpooned file" })
		keymap.set("n", "{", require("harpoon.ui").nav_prev, { desc = "(Harpoon) Previous harpooned file" })
	end,
}
