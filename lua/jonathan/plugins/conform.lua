return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local utils = require("jonathan.core.utils")

    local augroup = vim.api.nvim_create_augroup("formatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      callback = function(args)
        if utils.is_obsidian_vault() then
          utils.format_bullet_list() -- format bullet list for Obsidian
        end
      end,
    })

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" }, -- respects stylua.toml
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        go = { "gofmt" },
        sql = { "pg_format" }, -- Needs pgformatter to be installed: https://github.com/darold/pgFormatter (`brew install pgformatter`)
        apex = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
      },
      format_on_save = {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 5000, -- Apex prettier formatter is slow and so is Black
      },
    })
  end,
}
