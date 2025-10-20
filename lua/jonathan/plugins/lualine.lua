return {
  "nvim-lualine/lualine.nvim", -- adds a nice status line
  config = function()
    if vim.g.started_by_firenvim == true then
      return
    end
    local lualine = require("lualine")
    local dracula_theme = require("lualine.themes.dracula")

    -- new colors for theme
    local new_colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      black = "#000000",
    }

    -- change theme colors for different modes
    dracula_theme.normal.a.bg = new_colors.blue
    dracula_theme.insert.a.bg = new_colors.yellow
    dracula_theme.visual.a.bg = new_colors.violet
    dracula_theme.command = {
      a = {
        gui = "bold",
        bg = new_colors.yellow,
        fg = new_colors.black, -- black
      },
    }

    lualine.setup({
      options = {
        theme = "catppuccin",
        disabled_filetypes = { "NvimTree" },
      },
      -- can add custom sections to lualine with "sections" property here
      sections = {
        lualine_c = {
          "filename",
          {
            "require'salesforce.org_manager':get_default_alias()",
            icon = "󰢎",
          },
        },
      },
    })
  end,
}
