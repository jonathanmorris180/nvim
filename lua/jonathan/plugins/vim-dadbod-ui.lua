return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0 -- disable execute on save, use <leader>S to execute instead
  end,
  keys = {
    { '<leader>S',  "<CMD>'<,'> DB<CR>",       desc = 'Runs highlighted SQL',                mode = 'v' }, -- workaround for this: https://github.com/kristijanhusak/vim-dadbod-ui/issues/326
    { '<leader>S',  "<CMD>DB < %<CR>",         desc = 'Runs SQL in current buffer',          mode = 'n' },
    { '<leader>df', "<CMD>DBUIFindBuffer<CR>", desc = "(vim-dadbod-ui) Find current buffer", mode = "n" },
  }
}
