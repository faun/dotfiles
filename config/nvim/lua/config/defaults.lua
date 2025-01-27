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

vim.opt.completeopt = { "menu", "menuone", "noselect" }

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

-- Don't fix newline end of file for existing files
vim.opt.fixendofline = false

-- Copy the previous indentation on autoindenting
vim.opt.copyindent = true

-- Use multiple of shiftwidth when indenting with '<' and '>'
vim.opt.shiftround = true

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  vert = "│",
  horiz = "─",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- No backup files
vim.opt.backup = false

-- Only in case you don't want a backup file while editing
vim.opt.writebackup = false

-- Specify backup directory locations
vim.opt.backupdir = { "~/.vim-tmp", "~/.tmp", "~/tmp", "/var/tmp", "/tmp" }

-- Specify directory locations for swap files
vim.opt.directory = { "~/.vim-tmp", "~/.tmp", "~/tmp", "/var/tmp", "/tmp" }

-- No swap files
vim.opt.swapfile = false

if vim.fn.exists("$TMUX") == 1 then
  vim.g["test#strategy"] = "vimux"
end

vim.g.VimuxHeight = "40"
vim.g.VimuxOrientation = "h"

vim.g["test#ruby#bundle_exec"] = 0

-- Quickly quit without saving with QQ
vim.api.nvim_set_keymap("n", "QQ", ":q!<CR>", { noremap = true, silent = true })

-- Conditional behavior when in diff mode
if vim.wo.diff then
  -- In diff mode, close all windows with Enter
  vim.api.nvim_set_keymap("n", "<CR>", ":qa!<CR>", { noremap = true, silent = true })
  -- And quit the diff with QQ
  vim.api.nvim_set_keymap("n", "QQ", ":cq!<CR>", { noremap = true, silent = true })
end

-- Disable the Perl provider
vim.g.loaded_perl_provider = 0
