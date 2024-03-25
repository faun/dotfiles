local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("config.lazy")

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

vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

if vim.fn.exists("$TMUX") == 1 then
  vim.g["test#strategy"] = "vimux"
end

vim.g.VimuxHeight = "40"
vim.g.VimuxOrientation = "h"

vim.g["test#ruby#bundle_exec"] = 0

require("tabnine").setup({
  disable_auto_comment = true,
  accept_keymap = "<Right>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  suggestion_color = { gui = "#808080", cterm = 244 },
  codelens_color = { gui = "#808080", cterm = 244 },
  codelens_enabled = true,
  exclude_filetypes = { "TelescopePrompt", "NvimTree" },
  log_file_path = nil, -- absolute path to Tabnine log file
})
