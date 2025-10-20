local utils = require("jonathan.core.utils")
return {
  -- note: you can lazy load plugins on certain keybinds too with the "keys" property (see :h lazy.nvim)
  {
    "nvim-lua/plenary.nvim",
    init = function()
      require("plenary.filetype").add_file("apex") -- add filetype to plenary so that telescope previewer can use it
      require("plenary.filetype").add_file("visualforce")
    end,
  }, -- Lua functions that many other plugins depend on
  -- {
  -- 	"LunarVim/bigfile.nvim", -- Could be useful for large files
  -- },
  {
    "zapling/mason-lock.nvim", -- Adds lockfile support to Mason until this is resolved: https://github.com/williamboman/mason.nvim/issues/1701
    config = true, -- Config written to vim.fn.stdpath("config") .. "/mason-lock.json"
  },
  { "echasnovski/mini.nvim", version = "*" },
  { "ixru/nvim-markdown" },
  {
    "tpope/vim-surround",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
    config = true,
  },
  {
    "tpope/vim-repeat",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  { "sindrets/diffview.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "christoomey/vim-tmux-navigator", lazy = false },
  "mbbill/undotree",
  "tpope/vim-fugitive",
  -- makes resolving merge conflicts easy ([x maps to next conflict)
  { "metakirby5/codi.vim", event = { "BufReadPre", "BufNewFile" } },
  {
    "rcarriga/cmp-dap",
    event = { "BufReadPre", "BufNewFile" },
  },
  -- java
  { "mfussenegger/nvim-jdtls", enabled = not utils.is_kotlin_monorepo() },
  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
