return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "antoinemadec/FixCursorHold.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/nvim-nio",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        }),
        require("neotest-rspec"),
        require("neotest-plenary"),
        require("neotest-vim-test")({
          ignore_file_types = { "vim", "lua" },
        }),
      },
    })
    require("neodev").setup({
      library = { plugins = { "neotest" }, types = true },
    })

    if vim.fn.exists("$TMUX") == 1 then
      vim.g["test#strategy"] = "vimux"
    end

    vim.g.VimuxHeight = "40"
    vim.g.VimuxOrientation = "h"

    vim.g["test#ruby#bundle_exec"] = 0
  end,
}
