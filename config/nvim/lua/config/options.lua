-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set vim shortmess options
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Set terminal title bar
vim.opt.title = true

-- Use hidden buffers
vim.opt.hidden = true

-- Don't wrap lines
vim.opt.wrap = false

-- Let cursor keys wrap around lines
vim.opt.whichwrap:append("<,>,h,l,[")

-- Always show line numbers
vim.opt.number = true

-- Highlight right gutter at 80 characters
vim.opt.colorcolumn = "80"

-- Highlight the current cursor line
vim.opt.cursorline = true

-- Set show matching parenthesis
vim.opt.showmatch = true

-- Remove the noise in the vertical divider between splits
vim.opt.fillchars:append({ vert = "\\" })

-- Limit completion popup menu height
vim.opt.pumheight = 15

-- Set - as keyword so that ctags work correctly with dashed-method-names
vim.opt.iskeyword:append("-")

-- Set : as keyword so that ctags work correctly with ruby namespaced classes
-- vim.opt.iskeyword:append(":")

-- Don't show invisible characters by default
vim.opt.list = false

-- Set two spaces by default
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Copy the previous indentation on autoindenting
vim.opt.copyindent = true

-- Use multiple of shiftwidth when indenting with '<' and '>'
vim.opt.shiftround = true

-- Window
vim.api.nvim_set_keymap("n", "<left>", ":topleft vnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<right>", ":botright vnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<up>", ":topleft new<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<down>", ":botright new<CR>", { noremap = true })

-- Buffer
vim.api.nvim_set_keymap("n", "<leader><left>", ":leftabove vnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><right>", ":rightbelow vnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><up>", ":leftabove new<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><down>", ":rightbelow new<CR>", { noremap = true })

-- New window splits gain focus
vim.api.nvim_set_keymap("n", "<C-w>s", "<C-w>s<C-w>w", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-w>v", "<C-w>v<C-w>w", { noremap = true })

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  vert = "│",
  horiz = "-",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
