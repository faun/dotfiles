return {
  {
    "williamboman/mason.nvim",
  },
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        css = { "stylelint" },
        go = { "golangcilint" },
        html = { "htmlhint" },
        json = { "jsonlint" },
        less = { "stylelint" },
        markdown = { "markdownlint" },
        python = { "flake8" },
        ruby = { "ruby", "rubocop" },
        sass = { "stylelint" },
        scss = { "stylelint" },
        sh = { "shellcheck" },
        vim = { "vint" },
        yaml = { "yamllint" },
      },
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    config = function()
      require("mason-nvim-lint").setup({
        automatic_installation = false,
        ensure_installed = {
          "flake8",
          "golangci-lint",
          "htmlhint",
          "jsonlint",
          "markdownlint",
          "rubocop",
          "shellcheck",
          "stylelint",
          "vint",
          "yamllint",
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.golangci_lint,
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup()

      require("mason-null-ls").setup({
        automatic_installation = true,
      })
    end,
  },
}
