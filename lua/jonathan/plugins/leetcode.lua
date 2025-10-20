local leet_arg = "leetcode.nvim"
return {
  "kawre/leetcode.nvim",
  lazy = leet_arg ~= vim.fn.argv(0, -1),
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("leetcode").setup({
      arg = leet_arg,
      editor = {
        reset_previous_code = false, ---@type boolean
        fold_imports = true, ---@type boolean
      },
      lang = "python3",
      image_support = false, -- disable since it prevents line wrapping because of this: https://github.com/3rd/image.nvim/issues/62#issuecomment-1778082534
      picker = "telescope",
      storage = {
        home = vim.env.HOME .. "/Documents/repos/leetcode.nvim-solutions",
      },
    })
    local keymap = vim.keymap
    keymap.set("n", "<leader>lr", "<CMD>:Leet run<CR>", { desc = "(leetcode.nvim) Run the test cases" })
    keymap.set(
      "n",
      "<leader>li",
      "<CMD>:Leet info<CR>",
      { desc = "(leetcode.nvim) Get information about the current challenge" }
    )
    keymap.set("n", "<leader>lm", "<CMD>:Leet menu<CR>", { desc = "(leetcode.nvim) Open the main dashboard (menu)" })
    keymap.set(
      "n",
      "<leader>lc",
      "<CMD>:Leet console<CR>",
      { desc = "(leetcode.nvim) Open the console (with test cases and stdout)" }
    )
    keymap.set("n", "<leader>lt", "<CMD>:Leet tabs<CR>", { desc = "(leetcode.nvim) Open the tab picker" })
    keymap.set("n", "<leader>ll", "<CMD>:Leet list<CR>", { desc = "(leetcode.nvim) Open the list of all challenges" })
    keymap.set("n", "<leader>ld", "<CMD>:Leet desc<CR>", { desc = "(leetcode.nvim) Toggle the description" })
    keymap.set("n", "<leader>ls", "<CMD>:Leet submit<CR>", { desc = "(leetcode.nvim) Submit the solution" })
    keymap.set("n", "<leader>lf", "<CMD>:Leet fold<CR>", { desc = "(leetcode.nvim) Fold the imports" })
  end,
}
