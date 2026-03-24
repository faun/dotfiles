-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local tofu_fmt = vim.api.nvim_create_augroup("tofu_fmt", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = tofu_fmt,
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.cmd("silent !tofu fmt %")
    vim.cmd("edit")
  end,
})
