return {
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        css = { "stylelint" },
        fish = { "fish" },
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
        vue = { "eslint" },
        yaml = { "yamllint" },
      },
    },
  },
}
