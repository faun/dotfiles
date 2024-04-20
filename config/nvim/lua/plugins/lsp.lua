return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "delve",
        "erb-formatter",
        "gofumpt",
        "gopls",
        "goimports",
        "golangci-lint",
        "gopls",
        "isort",
        "prettier",
        "rubyfmt",
        "rustfmt",
        "shfmt",
        "stylua",
      },
    },
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
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lua_settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            globals = {
              "vim",
            },
          },
          telemetry = { enable = false },
          hint = { enable = true },
        },
      }

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
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
  { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
  { "folke/neodev.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "neovim/nvim-lspconfig",
      "ray-x/cmp-treesitter",
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
        config = function(_, opts)
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
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "treesitter" },
          { name = "emoji" },
          { name = "nvim_lua" },
          {
            name = "copilot",
            option = {
              group_index = 1,
              priority = 100,
            },
          },
          {
            name = "codeium",
            option = {
              group_index = 1,
              priority = 100,
            },
          },
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
    end,
  },
}
