return {
  {
    "williamboman/mason.nvim",
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang_format" },
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        css = { "prettier" },
        eruby = { "erb_format" },
        go = { "gofumpt", "goimports" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        less = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        ruby = { "rubyfmt" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        yaml = { "prettier" },
      },
    },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>==",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
  },
  {
    "zapling/mason-conform.nvim",
    config = function()
      require("mason-conform").setup()
    end,
  },
}
