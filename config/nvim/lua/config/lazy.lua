require("lazy").setup({
  spec = {
    {
      "nvimdev/dashboard-nvim",
      enabled = false,
    },
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "catppuccin-latte",
      },
    },
    { "folke/neodev.nvim", opts = {} },
    -- add onenord colorscheme
    { "rmehri01/onenord.nvim" },
    { "tpope/vim-eunuch" },
    { "embear/vim-localvimrc" },
    {
      "nvim-neotest/neotest",
      lazy = true,
      dependencies = {
        "antoinemadec/FixCursorHold.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/neotest-go",
        "nvim-neotest/neotest-plenary",
        "nvim-neotest/nvim-nio",
        "nvim-treesitter/nvim-treesitter",
        "olimorris/neotest-rspec",
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-go")({
              experimental = {
                test_table = true,
              },
              args = { "-count=1", "-timeout=60s" },
            }),
            require("neotest-rspec"),
            require("neotest-plenary"),
            require("neotest-vim-test")({
              ignore_file_types = { "vim", "lua" },
            }),
          },
        })
        require("neodev").setup({
          library = { plugins = { "neotest" }, types = true },
        })
      end,
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      config = function()
        require("telescope").load_extension("frecency")
      end,
    },
    { "folke/neodev.nvim", opts = {} },
    { "vim-test/vim-test" },
    { "preservim/vimux" },
    { "codota/tabnine-nvim", build = "./dl_binaries.sh" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.json" },
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

require("onenord").setup({
  theme = "dark",
})

require("lualine").setup({
  options = {
    theme = "onenord",
  },
})
