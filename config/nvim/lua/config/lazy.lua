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
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "black",
          "erb-formatter",
          "gofumpt",
          "goimports",
          "isort",
          "prettier",
          "rubyfmt",
          "rustfmt",
          "shfmt",
          "stylua",
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      keys = {
        {
          "<C-P>",
          function()
            require("telescope.builtin").find_files({ hidden = true })
          end,
          desc = "Find Files",
        },
        {
          "<C-F>",
          function()
            require("telescope.builtin").live_grep()
          end,
          desc = "Find Word",
        },
      },
    },
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
    {
      "nvim-neotest/neotest",
      lazy = true,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "vim-test/vim-test",
        "preservim/vimux",
        "nvim-neotest/neotest-vim-test",
        "nvim-neotest/neotest-go",
        "olimorris/neotest-rspec",
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-rspec")({
              -- Optionally your function can take a position_type which is one of:
              -- - "file"
              -- - "test"
              -- - "dir"
              rspec_cmd = function(position_type)
                if position_type == "test" then
                  return vim.tbl_flatten({
                    "bundle",
                    "exec",
                    "rspec",
                    "--format",
                    "documentation",
                    "--fail-fast",
                  })
                else
                  return vim.tbl_flatten({
                    "bundle",
                    "exec",
                    "rspec",
                  })
                end
              end,
            }),
            require("neotest-go"),
            require("neotest-vim-test")({
              ignore_filetypes = {},
            }),
          },
        })
      end,
    },
    {
      "vim-test/vim-test",
      dependencies = {
        "preservim/vimux",
      },
      keys = {
        { "<leader><CR>", "<cmd>TestNearest<cr>", desc = "Test nearest" },
        { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Test file" },
        { "<leader>\\", "<cmd>TestFile<cr>", desc = "Test file" },
        { "<leader>tf", "<cmd>TestFile<cr>", desc = "Test file" },
        { "<leader>ts", "<cmd>TestSuite<CR>", desc = "Test suite" },
        { "<leader>tl", "<cmd>TestLast<CR>", desc = "Test last" },
        { "<leader>tv", "<cmd>TestVisit<CR>", desc = "Test visit" },
      },
      init = function()
        if os.getenv("TMUX") ~= "" then
          vim.g["test#strategy"] = "vimux"
          vim.g["test#preserve_screen"] = 0
          vim.g.VimuxOrientation = "v"
          vim.g.VimuxHeight = "40"
        end
      end,
    },
    {
      "mfussenegger/nvim-dap",
      optional = true,
      dependencies = {
        {
          "williamboman/mason.nvim",
          opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "delve" })
          end,
        },
        {
          "leoluz/nvim-dap-go",
          config = true,
        },
      },
    },
    {
      "stevearc/conform.nvim",
      optional = true,
      opts = {
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2" },
          },
        },
        formatters_by_ft = {
          bash = { "shfmt" },
          c = { "clang_format" },
          cmake = { "cmake_format" },
          cpp = { "clang_format" },
          css = { "prettier" },
          eruby = { "erb-formatter" },
          fish = { "fish_indent" },
          go = { "gofumpt", "goimports" },
          html = { "prettier" },
          javascript = { { "prettierd", "prettier" } },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          less = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier" },
          python = { "isort", "black" },
          ruby = { "ruby_fmt" },
          rust = { "rustfmt" },
          scss = { "prettier" },
          sh = { "shfmt" },
          terraform = { "terraform_fmt" },
          tf = { "terraform_fmt" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          vue = { "prettier" },
          xhtml = { "prettier" },
          xml = { "prettier" },
          yaml = { "prettier" },
        },
      },
      keys = {
        {
          -- Customize or remove this keymap to your liking
          "<leader>==",
          function()
            require("conform").format({ async = true, lsp_fallback = true })
          end,
          mode = "",
          desc = "Format buffer",
        },
      },
    },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
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
