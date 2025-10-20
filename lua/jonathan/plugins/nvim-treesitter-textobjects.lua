return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["a="] = {
              query = "@assignment.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of an assignment",
            },
            ["i="] = {
              query = "@assignment.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of an assignment",
            },
            ["l="] = {
              query = "@assignment.lhs",
              desc = "(nvim-treesitter-textobjects) Select left-hand side of an assignment",
            },
            ["r="] = {
              query = "@assignment.rhs",
              desc = "(nvim-treesitter-textobjects) Select right-hand side of an assignment",
            },

            ["aa"] = {
              query = "@parameter.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of a parameter/argument",
            },
            ["ia"] = {
              query = "@parameter.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of a parameter/argument",
            },

            ["ai"] = {
              query = "@conditional.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of a conditional (if)",
            },
            ["ii"] = {
              query = "@conditional.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of a conditional (if)",
            },

            ["al"] = {
              query = "@loop.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of a loop",
            },
            ["il"] = {
              query = "@loop.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of a loop",
            },

            ["af"] = {
              query = "@call.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of a function call",
            },
            ["if"] = {
              query = "@call.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of a function call",
            },

            ["am"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of a method/function definition",
            },
            ["im"] = {
              query = "@function.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of a method/function definition",
            },

            ["ac"] = {
              query = "@class.outer",
              desc = "(nvim-treesitter-textobjects) Select outer part of a class",
            },
            ["ic"] = {
              query = "@class.inner",
              desc = "(nvim-treesitter-textobjects) Select inner part of a class",
            },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = {
              query = "@parameter.inner",
              desc = "(nvim-treesitter-textobjects) Swap parameters/argument with next",
            },
            ["<leader>n:"] = {
              query = "@property.outer",
              desc = "(nvim-treesitter-textobjects) Swap object property with next",
            },
            ["<leader>nm"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Swap function with next",
            },
          },
          swap_previous = {
            ["<leader>pa"] = {
              query = "@parameter.inner",
              desc = "(nvim-treesitter-textobjects) Swap parameters/argument with prev",
            },
            ["<leader>p:"] = {
              query = "@property.outer",
              desc = "(nvim-treesitter-textobjects) Swap object property with prev",
            },
            ["<leader>pm"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Swap function with previous",
            },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = {
              query = "@call.outer",
              desc = "(nvim-treesitter-textobjects) Next function call start",
            },
            ["]m"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Next method/function def start",
            },
            ["]c"] = { query = "@class.outer", desc = "(nvim-treesitter-textobjects) Next class start" },
            ["]i"] = {
              query = "@conditional.outer",
              desc = "(nvim-treesitter-textobjects) Next conditional start",
            },
            ["]l"] = { query = "@loop.outer", desc = "(nvim-treesitter-textobjects) Next loop start" },
          },
          goto_next_end = {
            ["]F"] = {
              query = "@call.outer",
              desc = "(nvim-treesitter-textobjects) Next function call end",
            },
            ["]M"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Next method/function def end",
            },
            ["]C"] = { query = "@class.outer", desc = "(nvim-treesitter-textobjects) Next class end" },
            ["]I"] = {
              query = "@conditional.outer",
              desc = "(nvim-treesitter-textobjects) Next conditional end",
            },
            ["]L"] = { query = "@loop.outer", desc = "(nvim-treesitter-textobjects) Next loop end" },
          },
          goto_previous_start = {
            ["[f"] = {
              query = "@call.outer",
              desc = "(nvim-treesitter-textobjects) Prev function call start",
            },
            ["[m"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Prev method/function def start",
            },
            ["[c"] = { query = "@class.outer", desc = "(nvim-treesitter-textobjects) Prev class start" },
            ["[i"] = {
              query = "@conditional.outer",
              desc = "(nvim-treesitter-textobjects) Prev conditional start",
            },
            ["[l"] = { query = "@loop.outer", desc = "(nvim-treesitter-textobjects) Prev loop start" },
          },
          goto_previous_end = {
            ["[F"] = {
              query = "@call.outer",
              desc = "(nvim-treesitter-textobjects) Prev function call end",
            },
            ["[M"] = {
              query = "@function.outer",
              desc = "(nvim-treesitter-textobjects) Prev method/function def end",
            },
            ["[C"] = { query = "@class.outer", desc = "(nvim-treesitter-textobjects) Prev class end" },
            ["[I"] = {
              query = "@conditional.outer",
              desc = "(nvim-treesitter-textobjects) Prev conditional end",
            },
            ["[L"] = { query = "@loop.outer", desc = "(nvim-treesitter-textobjects) Prev loop end" },
          },
        },
      },
    })
  end,
}
