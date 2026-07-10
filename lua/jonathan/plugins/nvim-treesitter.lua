return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "apex",
        "sosl",
        "soql",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "graphql",
        "bash",
        "xml",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "go",
      },
      -- auto install above language parsers
      auto_install = true,
      -- ignore_install = { "latex" }, -- uncomment if needed for imap completions (mostly needed for maths) - see :h vimtex-faq-treesitter
    })
  end,
  init = function()
    -- see https://www.qu8n.com/posts/treesitter-migration-guide-for-nvim-0-12
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- see https://www.qu8n.com/posts/treesitter-migration-guide-for-nvim-0-12
    local ensureInstalled = {
      "json",
      "javascript",
      "typescript",
      "apex",
      "sosl",
      "soql",
      "tsx",
      "yaml",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "graphql",
      "bash",
      "xml",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "go",
    }
    local alreadyInstalled = require("nvim-treesitter").get_installed()
    local parsersToInstall = vim
      .iter(ensureInstalled)
      :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
      end)
      :totable()
    require("nvim-treesitter").install(parsersToInstall)
  end,
}
