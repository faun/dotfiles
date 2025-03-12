local anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
local openai_api_key = os.getenv("OPENAI_API_KEY")
local ollama_base_url = os.getenv("OLLAMA_API_BASE_URL")

local plugins = {}

local avante_lazy_config = {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*", -- Set to "*" to always pull the latest release or keep false for specific updates
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for Windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Optional dependencies
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      "folke/which-key.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true, -- Required for Windows users
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = function()
      -- Base configuration
      local opts = {
        behavior = {
          auto_focus_sidebar = true,
          auto_suggestions = true,
          auto_suggestions_respect_ignore = false,
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          jump_result_buffer_on_finish = false,
          support_paste_from_clipboard = false,
          minimize_diff = true,
          enable_token_counting = true,
          enable_cursor_planning_mode = false,
        },
        history = {
          max_tokens = 4096,
          storage_path = vim.fn.stdpath("state") .. "/avante",
          paste = {
            extension = "png",
            filename = "pasted-%Y-%m-%d-%H-%M-%S",
          },
        },
        highlights = {
          diff = {
            current = nil,
            incoming = nil,
          },
        },
        mappings = {
          diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
          },
          suggestion = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
          jump = {
            next = "]]",
            prev = "[[",
          },
          submit = {
            normal = "<CR>",
            insert = "<C-s>",
          },
          ask = "<leader>aa",
          edit = "<leader>ae",
          refresh = "<leader>ar",
          focus = "<leader>af",
          toggle = {
            default = "<leader>at",
            debug = "<leader>ad",
            hint = "<leader>ah",
            suggestion = "<leader>as",
            repomap = "<leader>aR",
          },
          sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            retry_user_request = "r",
            edit_user_request = "e",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
            remove_file = "d",
            add_file = "@",
            close = { "<Esc>", "q" },
          },
          files = {
            add_current = "<leader>ac",
          },
          select_model = "<leader>a?",
        },
        windows = {
          position = "right",
          wrap = true,
          width = 30,
          height = 30,
          sidebar_header = {
            enabled = true,
            align = "center",
            rounded = true,
          },
          input = {
            prefix = "> ",
            height = 8,
          },
          edit = {
            border = "rounded",
            start_insert = true,
          },
          ask = {
            floating = false,
            border = "rounded",
            start_insert = true,
            focus_on_apply = "ours",
          },
        },
        diff = {
          autojump = true,
          override_timeoutlen = 500,
        },
        run_command = {
          shell_cmd = "sh -c",
        },
        hints = {
          enabled = true,
        },
        repo_map = {
          ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules" },
          negate_patterns = {},
        },
        file_selector = {
          provider = "native",
          provider_opts = {},
        },
        suggestion = {
          debounce = 600,
          throttle = 600,
        },
      }

      if ollama_base_url then
        print("Using Avante with Ollama")
        local model = os.getenv("OLLAMA_MODEL") or "llama3.2"
        opts.provider = "ollama"
        opts.vendors = {
          ollama = {
            __inherited_from = "openai",
            api_key_name = "",
            endpoint = "http://127.0.0.1:11434/v1",
            model = model,
            timeout = 30000, -- Timeout in milliseconds
            temperature = 0,
            max_tokens = 4096,
          },
        }
      elseif openai_api_key then
        -- Check if OPENAI_API_KEY is defined
        print("Using Avante with OpenAI")
        local model = os.getenv("OPENAI_MODEL") or "gpt-4o"
        opts.provider = "openai"
        opts.openai = {
          endpoint = "https://api.openai.com/v1",
          model = model,
          timeout = 30000,
          temperature = 0,
          max_tokens = 4096,
        }
      -- Check if ANTHROPIC_API_KEY is defined
      elseif anthropic_api_key then
        print("Using Avante with Anthropic")
        local model = os.getenv("ANTHROPIC_MODEL") or "claude-3-7-sonnet-20250219"
        opts.provider = "claude"
        opts.claude = {
          endpoint = "https://api.anthropic.com",
          model = model,
          timeout = 30000,
          temperature = 0,
          max_tokens = 8000,
        }
      else
        print("Using Avante with GitHub Copilot")
        local model = os.getenv("COPILOT_MODEL") or "gpt-4o-2024-08-06"
        opts.provider = "copilot"
        opts.copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = model,
          timeout = 30000, -- timeout in milliseconds
          temperature = 0,
          max_tokens = 8192,
        }
      end

      return opts
    end,
  },
}

vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")

local codecompanion_lazy_config = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function()
    local strategy = function()
      if ollama_base_url then
        return "ollama"
      elseif openai_api_key then
        return "openai"
      elseif anthropic_api_key then
        return "anthropic"
      else
        return "copilot"
      end
    end
    require("codecompanion").setup({

      strategies = {
        chat = {
          adapter = strategy(),
          keymaps = {
            send = {
              modes = { n = "<C-s>", i = "<C-s>" },
            },
            close = {
              modes = { n = "<C-c>", i = "<C-c>" },
            },
          },
        },
        inline = {
          adapter = strategy(),
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = anthropic_api_key,
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = openai_api_key,
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              base_url = ollama_base_url,
            },
          })
        end,

        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {})
        end,
      },
    })
  end,
}

if os.getenv("CONFIG_USE_AVANTE") == "true" then
  -- Add avante config to the plugins list
  for _, plugin in ipairs(avante_lazy_config) do
    table.insert(plugins, plugin)
  end
elseif os.getenv("CONFIG_USE_CODECOMPANION") == "true" then
  -- Add codecompanion config to the plugins list
  table.insert(plugins, codecompanion_lazy_config)
end

return plugins
