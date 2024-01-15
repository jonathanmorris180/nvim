return {
	"jonathanmorris180/salesforce.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	dev = true,
	config = function()
		require("salesforce").setup({
			debug = true,
			file_manager = {
				ignore_conflicts = true,
			},
		})
		local keymap = vim.keymap

		keymap.set("n", "<leader>se", "<cmd>SalesforceExecuteFile<cr>")
		keymap.set("n", "<leader>sc", "<cmd>SalesforceClosePopup<cr>")
		keymap.set("n", "<leader>stt", "<cmd>SalesforceExecuteCurrentMethod<cr>")
		keymap.set("n", "<leader>stT", "<cmd>SalesforceExecuteCurrentClass<cr>")
		keymap.set("n", "<leader>sp", "<cmd>SalesforcePushToOrg<cr>")
		keymap.set("n", "<leader>sr", "<cmd>SalesforceRetrieveFromOrg<cr>")
		keymap.set("n", "<leader>sd", "<cmd>SalesforceDiffFile<cr>")
	end,
}
