return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" }, -- respects stylua.toml
        python = { "isort", "black" },
        javascript = { "prettier" },
        go = { "gofmt" },
        sql = { "sql_formatter" },
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
        timeout_ms = 3000,
      },
    })
  end,
}
