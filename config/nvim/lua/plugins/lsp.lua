return {
  { "folke/neodev.nvim", opts = {} },
  { "folke/neoconf.nvim", cmd = "Neoconf", config = false },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solargraph",
        "black",
        "delve",
        "erb-formatter",
        "gofumpt",
        "gopls",
        "goimports",
        "golangci-lint",
        "gopls",
        "golangci-lint-langserver",
        "isort",
        "prettier",
        "rubyfmt",
        "shfmt",
        "stylua",
      })
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
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")

      --Enable (broadcasting) snippet capability for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Configure bashls
      lspconfig.bashls.setup({})

      -- Configure golangci_lint_ls
      lspconfig.golangci_lint_ls.setup({})

      -- Configure jsonls
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })

      -- Configure html-ls
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- Configure css-ls
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- Configure rubocop
      lspconfig.rubocop.setup({})

      -- Configure ruby_lsp
      lspconfig.ruby_lsp.setup({})

      -- Configure lua_ls
      local lua_settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            globals = {
              "vim",
              "LazyVim",
            },
          },
          telemetry = { enable = false },
          hint = { enable = true },
        },
      }

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = lua_settings,
      })
    end,
    opts = {
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
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info,
          },
        },
      },
    },
  },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "neovim/nvim-lspconfig",
      "ray-x/cmp-treesitter",
      "onsails/lspkind.nvim",
      {
        "saadparwaiz1/cmp_luasnip",
        dependencies = "L3MON4D3/LuaSnip",
      },
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
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
        sources = cmp.config.sources({
          { name = "luasnip", group_index = 1 },
          { name = "treesitter", group_index = 1 },
          { name = "emoji", group_index = 1 },
          { name = "nvim_lua", group_index = 1 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "copilot", group_index = 2 },
          { name = "codeium", group_index = 2 },
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

            -- Below is the default comparitor list and order for nvim-cmp
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

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local nvim_lsp = require("lspconfig")

      -- Setup lspconfig fo gopls
      nvim_lsp["gopls"].setup({
        cmd = { "gopls" },
        capabilities = capabilities,
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
        init_options = {
          usePlaceholders = true,
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
