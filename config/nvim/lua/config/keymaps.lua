-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- vim-go mappings
vim.api.nvim_set_keymap("n", "<leader>tb", ":GoToggleBreakpoint<CR>", { silent = true, noremap = true })

-- Buffer
vim.api.nvim_set_keymap("n", "<leader><left>", ":leftabove vnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><right>", ":rightbelow vnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><up>", ":leftabove new<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><down>", ":rightbelow new<CR>", { noremap = true })

-- New window splits gain focus
vim.api.nvim_set_keymap("n", "<C-w>s", "<C-w>s<C-w>w", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-w>v", "<C-w>v<C-w>w", { noremap = true })
