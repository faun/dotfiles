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
        "lua_ls",
        "solargraph",
        "sqlls",
        "typescript",
        "typescript-language-server",
        "ts_ls",
      },
      automatic_installation = { exclude = {} },
      config = function(opts)
        local ensure_installed = vim.tbl_keys(opts.ensure_installed or {})

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
    },
    opts = function()
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
          gopls = {
            cmd_env = {
              GOFLAGS = "-tags=integration",
            },
          },
          jsonls = {
            -- lazy-load schemastore when needed
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
              json = {
                format = {
                  enable = true,
                },
                validate = { enable = true },
              },
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
      }
    end,
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      --Enable (broadcasting) snippet capability for completion
      capabilities.textDocument.completion.completionItem.snippetSupport = true

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
        buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        -- Set some keybinds conditional on server capabilities
        if client.server_capabilities.document_formatting then
          buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.server_capabilities.document_range_formatting then
          buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end

        -- Enable autoformat on save
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("lsp", { clear = true }),
          callback = function(args)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ async = false, id = args.data.client_id })
              end,
            })
          end,
        })

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
      })

      -- Configure jsonls
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
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

      -- Configure rubocop
      lspconfig.rubocop.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          rubocop = {
            mason = false,
            cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
          },
        },
      })

      -- Configure ruby_lsp
      lspconfig.ruby_lsp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ruby_lsp = {
            mason = false,
            cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
          },
        },
      })

      -- Configure sorbet
      lspconfig.sorbet.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "bin/srb", "tc", "--lsp", "--cache-dir", "tmp/sorbet-cache" },
        root_dir = require("lspconfig.util").root_pattern("sorbet/config"),
      })

      -- Configure sqlls
      lspconfig.sqlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "sql", "mysql" },
        root_dir = function()
          return vim.loop.cwd()
        end,
      })

      -- Setup lspconfig for gopls
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "gopls" },
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = false,
          },
        },
        init_options = {
          usePlaceholders = true,
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
        capabilities = lsp_capabilities,
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
