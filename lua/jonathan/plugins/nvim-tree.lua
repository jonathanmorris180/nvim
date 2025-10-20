return {
  "nvim-tree/nvim-tree.lua", -- file explorer
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- icons in file explorer
  config = function()
    local nvimtree = require("nvim-tree")

    -- some settings that used to be set on vim.g have been moved to setup: https://github.com/nvim-tree/nvim-tree.lua/issues/674

    -- recommended settings
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- partially inspired by: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#modify-you-on_attach-function-to-have-ability-to-operate-multiple-files-at-once
    -- didn't implement all the methods since bulk actions are supported out of the box (bm = bulk move, bd = bulk delete, bt = bulk trash)
    nvimtree.setup({
      renderer = {
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- pulled from https://www.nerdfonts.com/cheat-sheet
              arrow_open = "",
            },
          },
        },
        group_empty = true,
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local opts = function(desc)
          return {
            desc = "(nvim-tree) " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        local mark_copy = function()
          local marks = api.marks.list()
          if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api.fs.copy.node(node)
          end
          api.marks.clear()
          api.tree.reload()
        end
        local mark_move_j = function()
          api.marks.toggle()
          vim.cmd("norm j")
        end
        local mark_move_k = function()
          api.marks.toggle()
          vim.cmd("norm k")
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        local function change_root_to_node(node)
          if node == nil then
            node = api.tree.get_node_under_cursor()
          end

          if node ~= nil and node.type == "directory" then
            vim.api.nvim_set_current_dir(node.absolute_path)
          end
          api.tree.change_root_to_node(node)
        end

        local function change_root_to_parent(node)
          local abs_path
          if node == nil then
            abs_path = api.tree.get_nodes().absolute_path
          else
            abs_path = node.absolute_path
          end

          local parent_path = vim.fs.dirname(abs_path)
          vim.api.nvim_set_current_dir(parent_path)
          api.tree.change_root(parent_path)
        end

        -- Could be useful for monorepo work (found here: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#change-nvims-working-directory-with-nvim-tree)
        vim.keymap.set("n", "<C-]>", change_root_to_node, opts("Change root to dir"))
        vim.keymap.set("n", "<C-[", change_root_to_parent, opts("Change root to parent"))

        -- collapse all: W
        -- help: g?
        vim.keymap.set("n", "B", api.node.navigate.sibling.last, opts("(nvim-tree) Go to last sibling"))
        vim.keymap.set("n", "T", api.node.navigate.sibling.first, opts("(nvim-tree) Go to first sibling"))
        vim.keymap.set("n", "J", mark_move_j, opts("(nvim-tree) Mark file and move down"))
        vim.keymap.set("n", "K", mark_move_k, opts("(nvim-tree) Mark file and move up"))
        vim.keymap.set("n", "by", mark_copy, opts("(nvim-tree) Copy marked file(s)"))
        vim.keymap.set("n", "bm", api.marks.bulk.move, opts("(nvim-tree) Move marked files"))
      end,
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          resize_window = false,
        },
      },
      sync_root_with_cwd = true, -- changes the root directory to the worktree directory when changing worktrees with git-worktree
      git = {
        enable = true,
        ignore = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
    })
  end,
}
