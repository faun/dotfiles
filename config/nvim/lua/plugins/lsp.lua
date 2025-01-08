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
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
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
        "solargraph",
        "sqlls",
        "stylua",
        "tsserver",
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
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
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
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = false,
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
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
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
          -- tsserver = function(_, opts)
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
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      --Enable (broadcasting) snippet capability for completion
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local diagnostics_active = true

      function ToggleDiagnostics()
        diagnostics_active = not diagnostics_active
        if diagnostics_active then
          vim.diagnostic.enable()
          print("Diagnostics enabled")
        else
          vim.diagnostic.disable()
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
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Configure golangci_lint_ls
      lspconfig.golangci_lint_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          golangci_lint = {},
        },
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

      lspconfig.tsserver.setup({
        on_attach = function(client, bufnr)
          -- Disable tsserver formatting if you prefer to use prettier
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

      -- Helper function to find executable with fallback
      local function get_binstub_with_fallback(local_bin, fallback_path, args)
        -- Ensure args is a table, default to empty if not provided
        args = args or {}

        -- Check if local binary exists in the current directory
        local local_path = vim.fn.getcwd() .. "/bin/" .. local_bin
        local bin_exists = vim.fn.filereadable(local_path) == 1

        -- Base command depending on which binary exists
        local base_cmd
        if bin_exists then
          base_cmd = "bin/" .. local_bin
        else
          base_cmd = fallback_path
        end

        -- Construct final command array
        local cmd = { vim.fn.expand(base_cmd) }
        -- Add any additional arguments
        for _, arg in ipairs(args) do
          table.insert(cmd, arg)
        end

        return cmd
      end

      local function has_rubocop_config()
        -- Check for rubocop configuration file
        local has_rubocop_config_file = vim.fn.glob(".rubocop.*") ~= ""

        -- Check for rubocop executable in bin directory
        local has_rubocop_binary = vim.fn.glob("bin/rubocop") ~= ""

        return has_rubocop_config_file or has_rubocop_binary
      end

      if has_rubocop_config() then
        -- Configure rubocop
        lspconfig.rubocop.setup({
          on_attach = on_attach,
          filetypes = {
            "ruby",
            "rake",
            "rbi",
            "rabl",
          },
          capabilities = capabilities,
          settings = {
            rubocop = {
              mason = false,
              cmd = get_binstub_with_fallback(
                "rubocop", -- use ./bin/rubocop if it exists
                "$HOME/.local/share/mise/shims/rubocop", -- fallback to mise rubocop shim
                { "--lsp" } -- additional arguments
              ),
            },
          },
        })
      end

      -- Configure ruby_lsp
      lspconfig.ruby_lsp.setup({
        on_attach = on_attach,
        filetypes = {
          "ruby",
          "rake",
          "rbi",
          "rabl",
        },
        capabilities = capabilities,
        settings = {
          ruby_lsp = {
            mason = false,
            cmd = get_binstub_with_fallback(
              "ruby-lsp", -- use ./bin/ruby-lsp if it exists
              "$HOME/.local/share/mise/shims/ruby-lsp" -- fallback to mise ruby-lsp shim
            ),
          },
        },
      })

      local function is_sorbet_project()
        -- Check for sorbet configuration file
        local has_sorbet_config = vim.fn.glob("sorbet/config") ~= ""

        -- Check for srb executable in bin directory
        local has_srb_binary = vim.fn.glob("bin/srb") ~= ""

        return has_sorbet_config or has_srb_binary
      end

      if is_sorbet_project() then
        -- Configure sorbet
        lspconfig.sorbet.setup({
          on_attach = on_attach,
          filetypes = {
            "ruby",
            "rake",
            "rbi",
            "rabl",
          },
          capabilities = capabilities,
          cmd = get_binstub_with_fallback(
            "srb", -- use ./bin/srb if it exists
            "$HOME/.local/share/mise/shims/srb", -- fallback to mise srb shim
            { "tc", "--lsp", "--cache-dir", "tmp/sorbet-cache" } -- additional arguments
          ),
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

      -- Setup lspconfig for gopls
      lspconfig.gopls.setup({
        on_attach = on_attach, -- Attach keybindings and other LSP features
        capabilities = capabilities, -- LSP capabilities for better feature support
        cmd = { "gopls" }, -- Command to start the gopls server

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
            ["local"] = "", -- Package path for local imports
            gofumpt = true, -- Use gofumpt for formatting
            goimports = true, -- Run goimports on save

            -- Build settings
            buildFlags = { "-tags", "integration" }, -- Add integration build tag
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
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
      "ray-x/cmp-treesitter",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      {
        "saadparwaiz1/cmp_luasnip",
        dependencies = "L3MON4D3/LuaSnip",
      },
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "copilot.lua",
        opts = {},
        init = function(_, opts)
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })

          local copilot_cmp = require("copilot_cmp")
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          LazyVim.lsp.on_attach(function(client)
            if client.name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end)
        end,
      },
    },
    init = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "s" }),
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",

              buffer = "[Buffer]",
              copilot = "[Copilot]",
              luasnip = "[Snippet]",
              tags = "[Tag]",
              path = "[Path]",
              ["vim-dadbod-completion"] = "[DB]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "copilot" },
          { name = "luasnip" },
          { name = "treesitter", max_item_count = 5 },
          { name = "buffer", max_item_count = 5 },
          { name = "emoji" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "vim-dadbod-completion" },
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          -- documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.exact,
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparator list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })

      local lspkind = require("lspkind")
      lspkind.init({
        mode = "symbol_text",
        symbol_map = {
          Copilot = "",
        },
      })
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
}
