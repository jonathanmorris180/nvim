return {
  "lervag/vimtex",
  init = function()
    -- see default insert mode mappings with :VimtexImapsList
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_context_pdf_viewer = "skim" -- external PDF viewer run from vimtex menu command
    vim.g.vimtex_log_ignore = {} -- Error suppression
    vim.g.vimtex_syntax_enabled = 0 -- use treesitter instead (see :h vimtex-faq-treesitter)
    vim.g.vimtex_syntax_conceal_disable = 1 -- use treesitter instead
    -- compile with <space>ll (<space> is the localleader for tex files)
    -- You can command + shift + left-click in Skim to jump to the corresponding line in the source file
    -- This is done by adding the following command to Skim preferences (under Sync):
    -- nvim --headless -c "VimtexInverseSearch %line '%file'"
    -- see :h vimtex-synctex-inverse-search
  end,
}
