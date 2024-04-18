return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    opts = function(_, opts)
      opts.autotag = {
        enable = true,
      }
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      require("lspconfig").gopls.setup({
        servers = {
          gopls = {
            cmd_env = {
              GOFLAGS = "-tags=integration",
            },
          },
        },
      }),
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.gofumpt,
        nls.builtins.diagnostics.golangci_lint,
      })
    end,
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = { "delve", "gofumpt", "gopls", "golangci-lint" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = function(_, opts)
      opts.adapters = vim.list_extend(opts.adapters or {}, {
        require("neotest-go")({
          args = { "-tags=integration" },
        }),
      })
    end,
  },
}
