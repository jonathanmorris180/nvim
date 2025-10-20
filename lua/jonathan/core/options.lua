local opt = vim.opt
vim.g.mapleader = " "

-- file types
vim.filetype.add({
  extension = {
    cls = "apex",
    apex = "apex",
    trigger = "apex",
    soql = "soql",
    sosl = "sosl",
    page = "html",
    cmp = "html",
    auradoc = "html",
    design = "html",
  },
})

-- see :h vim.diagnostic.Opts
-- Diagnostics can also be searched with :Telescope diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  float = {
    source = true,
    border = "rounded",
  },
})

-- opt.conceallevel = 1 -- for obsidian.nvim (only use if markdown.nvim is diabled)

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation (see https://stackoverflow.com/questions/51995128/setting-autoindentation-to-spaces-in-neovim)
opt.tabstop = 2
opt.shiftwidth = 2 -- replicate value doesn't work from above post
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- undo
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

opt.swapfile = false
opt.backup = false
opt.undodir = undo_dir
opt.undofile = true

-- line wrapping
opt.wrap = true

-- border for floating windows (disabling since this causes telescope bordering to be weird)
-- opt.winborder = "rounded"

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- time before vim waits to trigger an event (after typing, for example)
opt.updatetime = 50

-- appearance
opt.scrolloff = 8 -- no fewer than 8 lines from bottom or top when you scroll down/up
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes" -- ensures that the column for icons is always present so that line numbers don't move when icons appear/disappear

-- makes backspace work correctly
opt.backspace = "indent,eol,start"

-- allows neovim to use the system clipboard
-- opt.clipboard:append("unnamedplus")

-- allow splitting horizontally and vertically
opt.splitright = true
opt.splitbelow = true

-- nvim-ghost
vim.g.nvim_ghost_use_script = 1
vim.g.nvim_ghost_python_executable = "/Users/jonathanmorris/.pyenv/shims/python"

local group = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = { "*github.com" },
  command = "setfiletype markdown",
  group = group,
})

-- Add line numbers for scratch buffers (also used for leetcode.nvim)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "nofile" and vim.wo.number ~= true then -- only set if not already set
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
})
