-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable lazy loading of the `lazygit` plugin
vim.g.lazygit_config = false

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd([[ set foldenable]])

-- Load blink.nvim from main branch when set to true.
-- You need to have a working rust toolchain to build the plugin in this case.
vim.g.lazyvim_blink_main = true
