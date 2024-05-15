if vim.g.vscode then
  -- Disable which-key customization in VSCode
  return
end

-- Reload init.lua function
local function reload_config()
  local config_path = vim.fn.stdpath("config") .. "/init.lua"
  dofile(config_path)
  vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
end

-- Map <leader>* to live grep in Telescope with the current word under cursor as default text
local wk = require("which-key")
local mappings = {
  ["*"] = {
    "<cmd>lua require('telescope.builtin').live_grep({default_text = vim.fn.expand('<cword>')})<CR>",
    "Live Grep with Current Word",
  },
  ["r"] = {
    reload_config,
    "Reload init.lua",
  },
}
local opts = { prefix = "<leader>" }
wk.register(mappings, opts)