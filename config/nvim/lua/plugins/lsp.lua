return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
  { "folke/neoconf.nvim", cmd = "Neoconf", config = false },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    opts = {
      endwise = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "yaml", "ruby" },
      },
      autotag = {
        enable = true,
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
      ensure_installed = {
        "golangci_lint_ls",
        "gopls",
        "helm-ls",
        "lua_ls",
        "luarocks",
        "prettier",
        "sqlls",
        "stylua",
        "ts_ls",
      },
      automatic_installation = { exclude = {} },
    },
    config = function(opts)
      local ensure_installed = vim.tbl_keys(opts.ensure_installed or {})
      require("mason").setup()
      require("mason-registry").refresh()
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
  { "nanotee/sqls.nvim" },
  { "towolf/vim-helm" },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "nanotee/sqls.nvim",
      "towolf/vim-helm",
    },
    opts = function()
      -- Define custom LSP keymaps directly instead of relying on LazyVim
      local keys = {
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
        { "gr", vim.lsp.buf.references, desc = "References" },
        { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "gs", vim.lsp.buf.signature_help, desc = "Signature Help" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
      }

      return {
        -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = {}, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable lsp cursor word highlighting
        document_highlight = {
          enabled = true,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` can be overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },

        -- LSP Server Settings
        ---@type lspconfig.options.servers
        servers = {
          eslint = {
            settings = {
              -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
              workingDirectories = { mode = "auto" },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- ts_ls = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
        keys = keys,
      }
    end,
    config = function()
      local lspconfig = require("lspconfig")
      local blink_cmp = require("blink.cmp")

      -- Start with default LSP capabilities
      local default_capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Further extend with custom capabilities from blink.cmp
      local capabilities = blink_cmp.get_lsp_capabilities(default_capabilities)

      -- Apply the final capabilities to lspconfig defaults
      lspconfig.util.default_config.capabilities = capabilities

      --Enable (broadcasting) snippet capability for completion
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local diagnostics_active = true

      function ToggleDiagnostics()
        diagnostics_active = not diagnostics_active
        if diagnostics_active then
          vim.diagnostic.enable()
          print("Diagnostics enabled")
        else
          vim.diagnostic.enable(false)
          print("Diagnostics disabled")
        end
      end

      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
          vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- Enable completion
        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        local opts = { noremap = true, silent = true }

        -- See `:help vim.lsp.*` for documentation on any of the below
        buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        buf_set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)

        -- goto next and previous diagnostic with ]d and [d
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)

        -- toggle diagnostics with <space>dx
        buf_set_keymap("n", "<space>dx", "<cmd>lua ToggleDiagnostics()<CR>", opts)

        -- Set some keybinds conditional on server capabilities
        if client.server_capabilities.document_formatting then
          buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.server_capabilities.document_range_formatting then
          buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end

        -- Set autocommands conditional on server_capabilities
        if client.server_capabilities.document_highlight then
          vim.api.nvim_exec(
            [[
              hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
              hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
              hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
              augroup lsp_document_highlight
                autocmd!
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              augroup END
            ]],
            false
          )
        end
      end

      -- Configure bashls
      lspconfig.bashls.setup({
        filetypes = { "bash", "sh" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configure jsonls
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            format = {
              enable = true,
            },
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Configure helm_ls
      lspconfig.helm_ls.setup({
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "yaml-language-server",
            },
          },
        },
      })

      -- Configure yaml-ls
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas =
            vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
        capabilities = capabilities,
        settings = {
          yamlls = {
            enabled = true,
            enabledForFilesGlob = "*.{yaml,yml}",
            diagnosticsLimit = 50,
            showDiagnosticsDirectly = false,
            path = "yaml-language-server",
            config = {
              schemas = {
                kubernetes = "templates/**",
              },
              completion = true,
              hover = true,
            },
          },
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
            format = {
              enable = false,
            },
          },
        },
      })

      -- Configure html-ls
      lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configure css-ls
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configure astro-ls
      lspconfig.astro.setup({
        on_attach = on_attach,
        filetypes = {
          "astro",
        },
        capabilities = capabilities,
      })

      -- Configure eslint with autoformat
      lspconfig.eslint.setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        on_attach = function(client, bufnr)
          -- Disable ts_ls formatting if you prefer to use prettier
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          -- Attach the common keybindings and settings
          on_attach(client, bufnr)

          -- Add TypeScript specific keymaps here
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ti", ":TypescriptAddMissingImports<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>to", ":TypescriptOrganizeImports<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tR", ":TypescriptRenameFile<CR>", opts)
        end,
        capabilities = capabilities,

        -- TypeScript-specific settings
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            suggest = {
              includeCompletionsForModuleExports = true,
              includeCompletionsWithObjectLiteralMethodSnippets = true,
            },
            implementationsCodeLens = true,
            referencesCodeLens = true,
            preferences = {
              importModuleSpecifier = "relative",
              quoteStyle = "double",
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            suggest = {
              includeCompletionsForModuleExports = true,
              includeCompletionsWithObjectLiteralMethodSnippets = true,
            },
            implementationsCodeLens = true,
            referencesCodeLens = true,
          },
        },

        -- Additional commands that will be available
        commands = {
          TypescriptAddMissingImports = {
            function()
              vim.lsp.buf.execute_command({
                command = "_typescript.addMissingImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
            end,
            description = "Add missing imports",
          },
          TypescriptOrganizeImports = {
            function()
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
            end,
            description = "Organize imports",
          },
          TypescriptRenameFile = {
            function()
              vim.lsp.buf.execute_command({
                command = "_typescript.renameFile",
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
            end,
            description = "Rename file",
          },
        },

        -- Configure file types
        filetypes = {
          "typescript",
          "typescript.tsx",
          "typescriptreact",
          "javascript",
          "javascript.jsx",
          "javascriptreact",
        },

        -- Root directory patterns
        root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
      })

      -- Configure graphql-ls
      lspconfig.graphql.setup({
        on_attach = on_attach,
        filetypes = {
          "graphql",
          "gql",
        },
        capabilities = capabilities,
      })

      -- local function has_rubocop_config()
      --   -- Check for rubocop configuration file
      --   local has_rubocop_config_file = vim.fn.glob(".rubocop.*") ~= ""
      --
      --   -- Check for rubocop executable in bin directory
      --   local has_rubocop_binary = vim.fn.glob("bin/rubocop") ~= ""
      --
      --   return has_rubocop_config_file or has_rubocop_binary
      -- end
      --
      -- if has_rubocop_config() then
      --   -- Configure rubocop
      --   lspconfig.rubocop.setup({
      --     on_attach = on_attach,
      --     filetypes = {
      --       "ruby",
      --       "rake",
      --       "rbi",
      --       "rabl",
      --     },
      --     capabilities = capabilities,
      --     settings = {
      --       rubocop = {
      --         mason = false,
      --         cmd = function()
      --           local has_rubocop_binary = vim.fn.glob("bin/rubocop") ~= ""
      --           if has_rubocop_binary then
      --             return {
      --               "bin/rubocop",
      --               "--stop-server",
      --               "&&",
      --               "bin/rubopcop",
      --               "--lsp",
      --               ")",
      --             }
      --           else
      --             return { "mise", "x", "--", "rubocop", "--lsp" }
      --           end
      --         end,
      --       },
      --     },
      --     init_options = {
      --       formatter = "none", -- Use none to disable formatting
      --       enabledfeatures = {
      --         "codeactions",
      --         "diagnostics",
      --         "documenthighlights",
      --         "documentsymbols",
      --         "formatting",
      --         "inlayhint",
      --       },
      --     },
      --   })
      -- end
      --
      -- Configure ruby_lsp
      lspconfig.ruby_lsp.setup({
        flags = { debounce_text_changes = 500 },
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {
          "mise",
          "x",
          "--",
          "ruby-lsp",
        },
        single_file_support = true,
        settings = {
          ruby = {
            enabledFeatures = {
              "codeActions",
              "diagnostics",
              "documentFormatting",
              "hover",
              "completion",
              "rename",
              "signatureHelp",
              "workspaceSymbols",
            },
          },
          ruby_lsp = {
            mason = false,
          },
        },
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = true,
            },
          },
          formatter = "rubocop",
          enabled_features = {
            code_actions = true,
            code_lens = true,
            completion = true,
            definition = true,
            diagnostics = true,
            document_highlights = true,
            document_link = true,
            document_symbols = true,
            folding_ranges = true,
            formatting = true,
            hover = true,
            inlay_hint = true,
            on_type_formatting = true,
            selection_ranges = true,
            semantic_highlighting = true,
            signature_help = true,
            type_hierarchy = true,
            workspace_symbol = true,
          },
          features_configuration = {
            inlay_hint = {
              implicit_hash_value = true,
              implicit_rescue = true,
            },
          },
        },
      })

      local function is_sorbet_project()
        local root_dir = require("lspconfig.util").root_pattern("sorbet/config")

        -- Check for sorbet configuration file
        local has_sorbet_config = root_dir ~= ""

        -- Check for srb executable in bin directory
        local has_srb_binary = vim.fn.glob("bin/srb") ~= ""

        return has_sorbet_config or has_srb_binary
      end

      if is_sorbet_project() then
        -- Configure sorbet
        lspconfig.sorbet.setup({
          on_attach = on_attach,
          settings = {
            sorbet = {
              mason = false,
            },
          },
          filetypes = {
            "ruby",
            "rake",
            "rbi",
            "rabl",
          },
          capabilities = capabilities,
          cmd = {
            "mise",
            "x",
            "--",
            "srb",
            "tc",
            "--lsp",
            "--cache-dir",
            "tmp/sorbet-cache",
          },
          root_dir = require("lspconfig.util").root_pattern("sorbet/config"),
        })
      end

      local function has_sqlls_config()
        -- Check for sqlls configuration file
        return vim.fn.glob(".sqllsrc.json") ~= ""
      end

      if has_sqlls_config() then
        -- Configure sqlls if .sqllsrc.json exists
        lspconfig.sqlls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = { "sql", "mysql" },
          root_dir = function()
            return vim.loop.cwd()
          end,
        })
      end

      -- Configure golangci_lint_ls
      lspconfig.golangci_lint_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          golangci_lint_ls = {
            lintMode = "file",
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            init_options = {
              command = { "golangci-lint", "run", "--out-format", "json" },
            },
          },
        },
      })

      -- Setup lspconfig for gopls
      lspconfig.gopls.setup({
        on_attach = on_attach, -- Attach keybindings and other LSP features
        capabilities = capabilities, -- LSP capabilities for better feature support
        cmd = { "gopls" }, -- Command to start the gopls server
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),

        settings = {
          gopls = {
            -- Code analysis settings
            analyses = {
              unusedparams = true, -- Highlight unused function parameters
              unreachable = false, -- Don't analyze unreachable code
            },

            -- Code lens features
            codelenses = {
              generate = true, -- Show "go generate" commands
              gc_details = true, -- Show garbage collector details
              test = true, -- Show "run test" commands
              tidy = true, -- Show "go mod tidy" commands
            },

            -- Editor features
            usePlaceholders = true, -- Use placeholders in function completions
            completeUnimported = true, -- Show completions from unimported packages
            staticcheck = true, -- Enable staticcheck analyzer
            matcher = "Fuzzy", -- Use fuzzy matching for completions
            symbolMatcher = "fuzzy", -- Use fuzzy matching for symbols

            -- Performance settings
            diagnosticsDelay = "500ms", -- Delay before showing diagnostics
            experimentalWatchedFileDelay = "100ms", -- Delay for file watching

            -- Code style settings
            gofumpt = true, -- Use gofumpt for formatting
            goimports = true, -- Run goimports on save
            golines = true, -- Use golines for formatting
          },
        },
      })

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
      lspconfig.lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
          end
        end,

        ---@type lspconfig.options.settings
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = {
                "vim",
                "LazyVim",
              },
            },
            codeLens = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace",
            },
            doc = {
              privateName = { "^_" },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
              },
            },
          },
        },
        capabilities = capabilities,
      })
    end,
  },
}
