return {
  "neovim/nvim-lspconfig",
  lazy = true,
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "folke/neoconf.nvim",
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
}, {
  "folke/neoconf.nvim",
  cmd = "Neoconf",
  config = function()
    require("neoconf").setup({})
  end,
  dependencies = { "nvim-lspconfig" },
}
