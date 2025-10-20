return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim", -- allows only the fold icons to be shown in the column
      config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            { text = { "%s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          },
        })
      end,
    },
  },
  event = "BufReadPost",
  config = function()
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:󰐕]]

    -- Use "zo" and "zc" to open and close folds at the current level
    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    -- Use "zA" to open all folds at the current level recursively
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "(nvim-ufo) Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "(nvim-ufo) Close all folds" })
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "(nvim-ufo) Open folds except kinds" })
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "(nvim-ufo) Close folds with" }) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.lsp.buf.hover()
      end
    end, { desc = "(nvim-ufo) Peek folded lines under cursor" })

    require("ufo").setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        c = { "comment", "region" },
      },
      provider_selector = function(_, _, _)
        return {
          "lsp",
          "indent",
        }
      end,
    })
  end,
}
