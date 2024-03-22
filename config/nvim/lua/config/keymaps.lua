-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-f>", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader><leader>", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

vim.api.nvim_set_keymap("n", "<leader><CR>", ":TestNearest<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>\\", ":TestFile<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ts", ":TestSuite<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tl", ":TestLast<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tv", ":TestVisit<CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tb", ":GoToggleBreakpoint<CR>", { silent = true, noremap = true })
