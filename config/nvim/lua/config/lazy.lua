require("lazy").setup({
  spec = {
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
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.helm" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.ruby" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.vscode" },
    { "tpope/vim-eunuch" },
    { "tpope/vim-fugitive" },
    { "embear/vim-localvimrc" },
    { "jghauser/mkdir.nvim" },
    { "jake-stewart/jfind.nvim", branch = "2.0" },
    {
      "klen/nvim-config-local",
      config = function()
        require("config-local").setup({
          -- Config file patterns to load (lua supported)
          config_files = { ".nvim.lua", ".nvimrc", ".exrc", ".local.lua" },

          -- Where the plugin keeps files data
          hashfile = vim.fn.stdpath("data") .. "/config-local",

          autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
          commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
          silent = false, -- Disable plugin messages (Config loaded/ignored)
          lookup_parents = false, -- Lookup config files in parent directories
        })
      end,
    },
    {
      "mcauley-penney/tidy.nvim",
      opts = {
        enabled_on_save = true,
        filetype_exclude = { "markdown", "diff", "vim" },
      },
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
        {
          "<leader>*",
          function()
            require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
          end,
          desc = "Live Grep with Current Word",
        },
        {
          "<leader>r",
          function()
            local config_path = vim.fn.stdpath("config") .. "/init.lua"
            dofile(config_path)
            vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
          end,
          desc = "Reload vim config",
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
      "echasnovski/mini.surround",
      opts = {},
      version = "*",
    },
    {
      "sourcegraph/sg.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
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
      "hedyhli/outline.nvim",
      cmd = { "Outline", "OutlineOpen" },
      keys = {
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
      },
      opts = function()
        local Config = require("lazyvim.config")
        local defaults = require("outline.config").defaults
        local opts = {
          symbols = {},
          symbol_blacklist = {},
        }
        local filter = Config.kind_filter

        if type(filter) == "table" then
          local filter_opts = filter.default
          if type(filter_opts) == "table" then
            for kind, symbol in pairs(defaults.symbols) do
              opts.symbols[kind] = {
                icon = Config.icons.kinds[kind] or symbol.icon,
                hl = symbol.hl,
              }
              if not vim.tbl_contains(filter_opts, kind) then
                table.insert(opts.symbol_blacklist, kind)
              end
            end
          end
        end
        return opts
      end,
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
        "nvim-neotest/neotest-plenary",
        "olimorris/neotest-rspec",
        "nvim-neotest/neotest-python",
      },
      opts = {
        adapters = {
          ["neotest-go"] = {
            experimental = {
              test_table = true,
            },
            args = { "-v", "-count=1", "-timeout=60s" },
          },
          ["neotest-rspec"] = {},
          ["neotest-python"] = {
            dap = {
              justMyCode = false,
            },
            args = { "--log-level", "DEBUG" },
          },
          ["neotest-plenary"] = {},
          ["neotest-vim-test"] = {
            ignore_filetypes = { "python", "vim", "lua" },
          },
        },
      },
      keys = {
        {
          "<leader>tl",
          function()
            require("neotest").run.run_last()
          end,
          desc = "Run Last Test",
        },
        {
          "<leader>tL",
          function()
            require("neotest").run.run_last({ strategy = "dap" })
          end,
          desc = "Debug Last Test",
        },
      },
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
        -- Add -v to golang tests
        vim.g["test#go#gotest#options"] = "-v"
      end,
    },
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      },
      opts = {
        db_competion = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
            },
          })
        end,
      },
      config = function(_, opts)
        vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "sql",
            "mysql",
            "plsql",
          },
          command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "sql",
            "mysql",
            "plsql",
          },
          callback = function()
            vim.schedule(opts.db_completion)
          end,
        })
      end,
      keys = {
        { "<leader>Dt", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
        { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
        { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
        { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
      },
    },
    {
      "ray-x/go.nvim",
      dependencies = { -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("go").setup()
      end,
      event = { "CmdlineEnter" },
      ft = { "go", "gomod" },
      build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    },
    {
      "cuducos/yaml.nvim",
      ft = { "yaml" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
      },
    },
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
  checker = { enabled = false }, -- automatically check for plugin updates
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
