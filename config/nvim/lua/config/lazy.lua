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
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        theme = "onenord",
      },
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
    { "tpope/vim-eunuch" },
    { "tpope/vim-fugitive" },
    { "embear/vim-localvimrc" },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup()
      end,
    },
    {
      "folke/neodev.nvim",
      dependencies = {
        "nvim-neotest/neotest",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
      },
      lazy = true,
      config = function()
        require("neodev").setup({
          library = {
            plugins = {
              "neotest",
              "nvim-treesitter",
              "plenary.nvim",
              "telescope.nvim",
            },
            types = true,
          },
        })
      end,
    },
    {
      "sourcegraph/sg.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      build = "nvim -l build/init.lua",
      keys = {
        {
          "<leader>sf",
          "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>",
          desc = "Sourcegraph fuzzy search results",
        },
      },
      opts = {
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
      },
    },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.vscode" },
    { import = "plugins" },
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
