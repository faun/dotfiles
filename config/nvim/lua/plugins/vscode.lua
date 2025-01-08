-- Check if running in VSCode
if not vim.g.vscode or not vim.g.cursor then
  return {}
end

local enabled = {
  "dial.nvim",
  "lazy.nvim",
  "mini.ai",
  "mini.comment",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "vim-repeat",
  "LazyVim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymaps",
  callback = function()
    vim.keymap.set("n", "H", function()
      require("vscode").call("workbench.action.previousEditor")
    end)
    vim.keymap.set("n", "L", function()
      require("vscode").call("workbench.action.nextEditor")
    end)
    vim.keymap.set({ "n", "x" }, "<leader>ca", function()
      require("vscode").call("editor.action.quickFix")
    end)
    vim.keymap.set({ "n", "x" }, "<leader>cr", function()
      require("vscode").call("editor.action.rename")
    end)
    vim.keymap.set("n", "<leader>cf", function()
      require("vscode").call("editor.action.formatDocument")
    end)
    vim.keymap.set("n", "<leader>co", function()
      require("vscode").call("editor.action.organizeImports")
    end)
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
  end,
})

return {
  {
    "LazyVim/LazyVim",
    config = function(_, opts)
      opts = opts or {}
      -- disable the colorscheme
      opts.colorscheme = function() end
      require("lazyvim").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },
  {
    "faun/jfind.nvim",
    enabled = false,
  },
}
