require("lazy").setup({
  spec = {
    {
      "nvimdev/dashboard-nvim",
      enabled = false,
    },
    {
      "catppuccin/nvim",
      enabled = false,
    },
    {
      "rmehri01/onenord.nvim",
      lazy = false,
      priority = 1000,
    },
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = function()
          require("onenord").setup({
            theme = "dark",
          })
        end,
      },
    },
    { "folke/neodev.nvim", opts = {} },
    { "tpope/vim-eunuch" },
    { "tpope/vim-fugitive" },
    { "embear/vim-localvimrc" },
    {
      "nvim-telescope/telescope-frecency.nvim",
      config = function()
        require("telescope").load_extension("frecency")
      end,
    },
    { "folke/neodev.nvim", opts = {} },
    { "vim-test/vim-test" },
    { "preservim/vimux" },
    {
      "sourcegraph/sg.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      build = "nvim -l build/init.lua",
    },
    {
      "tpope/vim-projectionist",
      config = function()
        vim.cmd([[
          let g:projectionist_heuristics ={
          \  "spec/*.rb": {
          \     "app/*.rb": { "alternate": "spec/{}_spec.rb", "type": "source"},
          \     "lib/*.rb": { "alternate": "spec/{}_spec.rb", "type": "source"},
          \     "spec/*_spec.rb": { "alternate": ["app/{}.rb","lib/{}.rb"],"type": "test"},
          \  },
          \ "*_test.go": {
          \    "*.go":       { "alternate": "{}_test.go", "type": "test" },
          \    "*_test.go":  { "alternate": "{}.go", "type": "source" },
          \  },
          \}
        ]])
      end,
      event = { "BufReadPost", "BufNewFile" },
    },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("lualine").setup({
  options = {
    theme = "onenord",
  },
})

require("sg").setup({
  enable_cody = true,
  accept_tos = true,
  diagnostics = {
    enable = true,
    severity = {
      error = "Error",
      warning = "Warning",
      hint = "Hint",
      information = "Information",
    },
  },
})

require("copilot").setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = "node", -- Node.js version must be > 18.x
  server_opts_overrides = {},
})
