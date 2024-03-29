return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "vim-test/vim-test",
      "preservim/vimux",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-go",
      "olimorris/neotest-rspec",
    },
    opts = {
      adapters = function()
        return {
          require("neotest-go"),
          require("neotest-rspec"),
          require("neotest-vim-test")({
            ignore_filetypes = {},
          }),
        }
      end,
    },
  },
  {
    "vim-test/vim-test",
    dependencies = {
      "preservim/vimux",
    },
    keys = {
      { "<leader><CR>", "<cmd>TestNearest<cr>", desc = "Test nearest" },
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Test file" },
      { "<leader>\\", "<cmd>TestFile<cr>", desc = "Test file" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "Test file" },
      { "<leader>ts", "<cmd>TestSuite<CR>", desc = "Test suite" },
      { "<leader>tl", "<cmd>TestLast<CR>", desc = "Test last" },
      { "<leader>tv", "<cmd>TestVisit<CR>", desc = "Test visit" },
    },
    init = function()
      if os.getenv("TMUX") ~= "" then
        vim.g["test#strategy"] = "vimux"
        vim.g["test#preserve_screen"] = 0
        vim.g.VimuxOrientation = "v"
        vim.g.VimuxHeight = "40"
      end
    end,
  },
}
