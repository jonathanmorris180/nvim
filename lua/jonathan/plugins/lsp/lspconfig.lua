return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- autocompletion
  },
  config = function()
    -- disable lsp logs ("off") unless needed so it doesn't create a huge file (switch to "debug" if needed)
    vim.lsp.set_log_level("off")

    local lspconfig_util = require("lspconfig.util")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local utils = require("jonathan.core.utils")

    local keymap = vim.keymap -- for conciseness

    -- First param is the client - it has all the properties from :h lsp-client
    ---@diagnostic disable-next-line: unused-local
    local on_attach = function(client, bufnr)
      -- keybind options
      local opts = function(desc)
        return { desc = desc, buffer = bufnr, noremap = true, silent = true }
      end

      -- set keybinds
      keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts("(Lspsaga) Show definition/references"))
      keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts("Go to declaration"))
      keymap.set(
        "n",
        "gd",
        "<cmd>Lspsaga peek_definition<CR>",
        opts("(Lspsaga) See definition and make edits in window")
      )
      keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts("Go to implementation"))
      keymap.set("n", "<leader>ga", "<cmd>Lspsaga code_action<CR>", opts("(Lspsaga) Show available code actions"))
      keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts("(Lspsaga) Smart rename"))
      keymap.set(
        "n",
        "<leader>D",
        "<cmd>Lspsaga show_line_diagnostics<CR>",
        opts("(Lspsaga) Show diagnostics for line")
      )
      keymap.set(
        "n",
        "<leader>d",
        "<cmd>Lspsaga show_cursor_diagnostics<CR>",
        opts("(Lspsaga) Show diagnostics for cursor")
      )
      keymap.set(
        "n",
        "[d",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        opts("(Lspsaga) Jump to previous diagnostic in buffer")
      )
      keymap.set(
        "n",
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        opts("(Lspsaga) Jump to next diagnostic in buffer")
      )
      keymap.set("n", "<leader>[d", vim.diagnostic.goto_prev, opts("Go to previous diagnostic (builtin)"))
      keymap.set("n", "<leader>]d", vim.diagnostic.goto_next, opts("Go to next diagnostic (builtin)"))
      keymap.set(
        "n",
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        opts("(Lspsaga) Jump to next diagnostic in buffer")
      )
      keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts("(Lspsaga) Show documentation for what is under cursor"))
    end

    -- used to enable autocompletion (assign to every lsp server config)
    -- See https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#capabilities
    local capabilities = cmp_nvim_lsp.default_capabilities()
    vim.lsp.config("*", {
      capablities = capabilities, -- defines nvim-cmp capabilities for all natively managed LSPs
    })

    --------------------------------
    --- Natively managed configs ---
    --------------------------------

    local config_dir = utils.parent_dir_exists(".nvim")
    if config_dir then
      vim.opt.runtimepath:append(config_dir) -- per-project config with .nvim dir
    end

    vim.lsp.enable("gopls")

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        -- Set up keymaps
        on_attach(client, vim.api.nvim_get_current_buf())
      end,
    })

    ------------------------------
    --- nvim-lspconfig configs ---
    ------------------------------

    -- configure html server
    vim.lsp.enable("html")

    vim.lsp.config("java_language_server", {
      cmd = { vim.fn.stdpath("data") .. "/mason/packages/java-language-server/java-language-server" },
      filetypes = { "java" },
      root_dir = lspconfig_util.root_pattern("BUILD.bazel"),
    })
    vim.lsp.enable("java_language_server")

    -- configure python server
    if not vim.g.started_by_firenvim == true then
      vim.lsp.config("pyright", {
        filetypes = { "python" },
        settings = { -- see settings here: https://github.com/microsoft/pyright/blob/main/docs/settings.md
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })
      vim.lsp.enable("pyright")
      -- Pyright can't be replaced with this yet since it doesn't have all LSP features (like go to definition)
      -- This is still useful for linting issues though
      vim.lsp.config("ruff", {
        filetypes = { "python" },
        cmd = { "ruff", "server" },
      })
      vim.lsp.enable("ruff")
    end

    -- configure typescript server with plugin
    vim.lsp.config("ts_ls", {
      init_options = {
        -- relative imports
        preferences = {
          importModuleSpecifierPreference = "relative",
          importModuleSpecifierEnding = "minimal",
        },
        plugins = {},
      },
      filetypes = {
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "vue",
      },
    })
    vim.lsp.enable("ts_ls")

    -- configure css server
    vim.lsp.enable("cssls")

    -- configure bash server
    vim.lsp.enable("bashls")

    -- configure tailwindcss server
    vim.lsp.enable("tailwindcss")

    -- configure emmet language server
    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })
    vim.lsp.enable("emmet_ls")

    vim.lsp.enable("eslint")

    -- configure lua server
    vim.lsp.config("lua_ls", {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most
            -- likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
              "lua/?.lua",
              "lua/?/init.lua",
            },
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
              -- '${3rd}/busted/library'
            },
            -- Or pull in all of 'runtimepath'.
            -- NOTE: this is a lot slower and will cause issues when working on
            -- your own configuration.
            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
            -- library = {
            --   vim.api.nvim_get_runtime_file('', true),
            -- }
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })
    vim.lsp.enable("lua_ls")

    vim.lsp.config("apex_ls", {
      cmd = function(dispatchers, _)
        local apex_jar_path = vim.fn.stdpath("data")
          .. "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar"
        local apex_enable_semantic_errors = false -- Whether to allow Apex Language Server to surface semantic errors
        local apex_enable_completion_statistics = false -- Whether to allow Apex Language Server to collect telemetry on code completion usage
        local local_cmd = {
          vim.env.JAVA_HOME and (vim.env.JAVA_HOME .. "/bin/java") or "java",
          "-cp",
          apex_jar_path,
          "-Ddebug.internal.errors=true",
          "-Ddebug.semantic.errors=" .. tostring(apex_enable_semantic_errors or false),
          "-Ddebug.completion.statistics=" .. tostring(apex_enable_completion_statistics or false),
          "-Dlwc.typegeneration.disabled=true",
        }
        -- if config.apex_jvm_max_heap then
        -- 	table.insert(local_cmd, "-Xmx" .. config.apex_jvm_max_heap)
        -- end
        table.insert(local_cmd, "apex.jorje.lsp.ApexLanguageServerLauncher")

        return vim.lsp.rpc.start(local_cmd, dispatchers)
      end,
      filetypes = { "apex" },
      root_markers = {
        "sfdx-project.json",
      },
    })
    vim.lsp.enable("apex_ls")
  end,
}
