return {
  "williamboman/mason.nvim", -- LSP server, linter, and formatter manager
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- ties mason with nvim-lspconfig
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    -- import mason plugin safely
    local mason = require("mason")
    local path = require("mason-core.path")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_nvim_dap = require("mason-nvim-dap")

    -- enable mason
    mason.setup({
      install_root_dir = path.concat({ vim.fn.stdpath("data"), "mason" }),
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of language servers for mason to install (note that you can't add formatters here like isort)
      automatic_enable = false,
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "jdtls",
        "emmet_ls",
        -- "apex_ls", (removing for now since it's not yet supported by Neovim core and also isn't supported by nvim-lspconfig)
        "pyright", -- Provides go to definition (ruff doesn't support this yet)
        "bashls",
        "kotlin_language_server",
        "java_language_server",
        "eslint",
        "sqlls",
        "ruff", -- python all-in-one - needs to be used in conjunction with pyright for now due to incomplete features
        "gopls",
      },
      -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed. This is NOT the same as ensure_installed since that's just a static list.
      automatic_installation = true,
    })

    mason_nvim_dap.setup({
      -- list of dap adapters for mason to install
      ensure_installed = {
        "java-test",
        "java-debug-adapter",
      },
      automatic_installation = true,
    })
  end,
}
