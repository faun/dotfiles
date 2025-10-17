return {
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Function to apply the theme
      local function set_theme()
        -- Read theme from temporary file that shell script maintains
        local handle = io.open(vim.fn.expand("~/.cache/theme_mode"), "r")
        if handle then
          local content = handle:read("*a")
          handle:close()
          local theme = content:match("^%s*(.-)%s*$") -- trim whitespace
          if theme == "dark" or theme == "light" then
            vim.o.background = theme
            require("onenord").setup({
              theme = theme,
            })
            if theme == "light" then
              -- Set the Normal highlight group background color to (Nord 4 AKA Frost 1) light color #E5E9F0
              vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE", bg = "#E5E9F0" })
              -- Set the color column highlight to the same color as the background,
              -- so it creates a subtle knotch in the line highlight
              vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "lightgray", bg = "#E5E9F0" })
              -- Set cursor line highlight to (Nord 6 AKA Snow Storm 3) light color #ECEFF4
              vim.api.nvim_set_hl(0, "CursorLine", {
                ctermbg = "lightgray",
                bg = "#ECEFF4",
              })
            elseif theme == "dark" then
              -- Set the Normal highlight group background color to (Nord 0 AKA Polar Night 1) dark color #2E3440
              vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE", bg = "#2E3440" })
              -- Set the color column highlight to the same color as the background,
              -- so it creates a subtle knotch in the line highlight
              vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "NONE", bg = "#2E3440" })
              -- Set cursor line highlight to (Nord 1 AKA Polar Night 2) dark color #3B4252
              vim.api.nvim_set_hl(0, "CursorLine", {
                ctermbg = "darkgray",
                bg = "#3B4252",
              })
            end
          end
        end
      end

      -- Set up autocommand for theme changes
      vim.api.nvim_create_autocmd("Signal", {
        pattern = "SIGUSR1",
        callback = function()
          set_theme()
        end,
      })

      -- Initial theme setup
      set_theme()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "onenord",
    },
  },
  { "tpope/vim-eunuch" },
  { "tpope/vim-fugitive" },
  { "embear/vim-localvimrc" },
  { "jghauser/mkdir.nvim" },
  { "ruanyl/vim-gh-line" },
  {
    "sindrets/diffview.nvim",
    opts = {
      default_args = {
        DiffviewOpen = { "--imply-local" },
      },
    },
  },
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
      {
        "<leader>ut", -- 'u' for ui, 't' for toggle
        function()
          -- Toggle between light and dark
          vim.o.background = vim.o.background == "dark" and "light" or "dark"
        end,
        desc = "Toggle theme light/dark",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
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
    opts = {
      -- Use default symbols and configuration
      outline_window = {
        position = "right",
        width = 25,
        relative_width = true,
      },
      outline_items = {
        highlight_hovered_item = true,
        show_symbol_details = true,
      },
      symbols = {
        icons = {
          File = { icon = "󰈔", hl = "Identifier" },
          Module = { icon = "󰆧", hl = "Include" },
          Namespace = { icon = "󰅪", hl = "Include" },
          Package = { icon = "󰏗", hl = "Include" },
          Class = { icon = "𝓒", hl = "Type" },
          Method = { icon = "ƒ", hl = "Function" },
          Property = { icon = "", hl = "Identifier" },
          Field = { icon = "󰆨", hl = "Identifier" },
          Constructor = { icon = "", hl = "Special" },
          Enum = { icon = "ℰ", hl = "Type" },
          Interface = { icon = "󰜰", hl = "Type" },
          Function = { icon = "", hl = "Function" },
          Variable = { icon = "", hl = "Constant" },
          Constant = { icon = "", hl = "Constant" },
          String = { icon = "𝓐", hl = "String" },
          Number = { icon = "#", hl = "Number" },
          Boolean = { icon = "⊨", hl = "Boolean" },
          Array = { icon = "󰅪", hl = "Constant" },
          Object = { icon = "⦿", hl = "Type" },
          Key = { icon = "🔐", hl = "Type" },
          Null = { icon = "NULL", hl = "Type" },
          EnumMember = { icon = "", hl = "Identifier" },
          Struct = { icon = "𝓢", hl = "Type" },
          Event = { icon = "🗲", hl = "Type" },
          Operator = { icon = "+", hl = "Identifier" },
          TypeParameter = { icon = "𝙏", hl = "Identifier" },
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
    opts = {},
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
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "/" },
      -- log_level = 'debug',
    },
  },
  -- Plugin overrides for renamed plugins
  { "nvim-mini/mini.diff" },
  { "nvim-mini/mini.pairs" },
  { "mason-org/mason.nvim" },
  { "mason-org/mason-lspconfig.nvim" },
}
