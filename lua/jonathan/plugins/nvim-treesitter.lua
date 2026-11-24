return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- main doesn't auto-install parsers
    require("nvim-treesitter").install({ "lua" })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- only enable TS indent if a parser actually started for this buffer
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
