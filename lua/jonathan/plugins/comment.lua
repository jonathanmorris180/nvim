return {
	"numToStr/Comment.nvim", -- commenting with "gc"
	config = function()
		require("Comment").setup()
		local ft = require("Comment.ft")
		ft.apex = { "//%s", "/**%s*/" }
	end,
}
