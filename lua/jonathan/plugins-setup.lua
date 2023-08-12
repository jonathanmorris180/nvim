local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

local plugins = {
  {
    "dracula/vim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme dracula]])
    end,
  },
  "nvim-lua/plenary.nvim", -- Lua functions that many other plugins depend on
  "tpope/vim-surround",
  "folke/which-key.nvim",
  "numToStr/Comment.nvim",
  "nvim-tree/nvim-tree.lua",
  { "christoomey/vim-tmux-navigator", lazy = false },
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
}

require("lazy").setup(plugins, opts)
