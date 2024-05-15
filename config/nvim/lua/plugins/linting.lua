return {
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
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.golangci_lint,
      })
    end,
  },
}
