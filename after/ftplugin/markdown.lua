-- placing this file in /ftplugin doesn't seem to work for some reason (possibly related?: https://github.com/neovim/neovim/issues/5088)
local opt = vim.opt

-- override Neovim's default indent for Markdown files
opt.tabstop = 2
opt.shiftwidth = 2 -- replicate value doesn't work from above post
opt.softtabstop = 2
