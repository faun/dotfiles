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
    "hrsh7th/nvim-cmp",
    "echasnovski/mini.diff",
    "nvim-telescope/telescope.nvim",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    { "stevearc/dressing.nvim", opts = {} },
    {
      "ravitemer/mcphub.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
      },
      cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
      build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
      config = function()
        require("mcphub").setup({
          -- Required options
          port = 3003, -- Port for MCP Hub server
          config = vim.fn.expand("~/.config/mcp/servers.json"), -- Absolute path to config file
          extensions = {
            codecompanion = {
              -- Show the mcp tool result in the chat buffer
              -- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
              show_result_in_chat = true,
              make_vars = true, -- make chat #variables from MCP server resources
            },
          },

          -- -- Optional options
          -- on_ready = function(hub)
          --   -- Called when hub is ready
          -- end,
          -- on_error = function(err)
          --   -- Called on errors
          -- end,
          log = {
            level = vim.log.levels.WARN,
            to_file = false,
            file_path = nil,
            prefix = "MCPHub",
          },
        })
      end,
    },
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionChat<CR>", mode = { "n", "v" }, desc = "[A]I [A]sk" },
    { "<leader><esc>", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "[A]I [A]sk" },
    {
      "<leader>acm",
      "<cmd>CodeCompanion Commit Message<CR>",
      mode = { "n", "v" },
      desc = "[A]I [C]ommit [M]essage",
    },
    { "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "[A]I [T]oggle" },
    { "<leader>ae", "<cmd>CodeCompanionChat<CR>", mode = { "n", "v" }, desc = "[A]I [E]dit" },
    { "<leader>am", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "[A]I [M]enu" },
    { "<leader>ap", "<cmd>CodeCompanionChat Add<CR>", mode = { "v" }, desc = "[A]I [P]aste" },
  },
  config = function()
    local spinner = require("plugins.codecompanion.spinner")
    spinner:init({})
    do
      local ok, lualine = pcall(require, "lualine")
      if not ok then
        return
      end

      local lualine_cfg = lualine.get_config()
      table.insert(lualine_cfg.sections.lualine_x, 1, spinner)
      lualine.setup(lualine_cfg)
    end

    local chat_strategy = function()
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

    local inline_strategy = function()
      if openai_api_key then
        return "openai"
      elseif anthropic_api_key then
        return "anthropic"
      else
        return "copilot"
      end
    end
    require("codecompanion").setup({
      prompt_library = {
        ["Commit Message"] = {
          strategy = "inline",
          description = "Generate a commit message",
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return string.format(
                  [[Generate a commit message with the following conventions:

## Message Structure

"Summary\n\nBody"

### Subject Line

- Use imperative mood ("Add" not "Added")
- Keep it under 50 characters
- Don't end with period
- Start with capital letter
- Use present tense

### Body

- Use present tense
- Keep it under 3 paragraphs
- Use bullet points if needed
- Use github-flavored markdown for formatting

Given the git diff listed below, please generate a commit message for me:

```diff
%s
```

]],
                  vim.fn.system("git diff --no-ext-diff --staged")
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
      strategies = {
        chat = {
          adapter = chat_strategy(),
          keymaps = {
            send = {
              modes = { n = "<C-s>", i = "<C-s>" },
            },
            close = {
              modes = { n = "<C-c>", i = "<C-c>" },
            },
          },
          slash_commands = {
            ["file"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using Telescope",
              opts = {
                provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
                contains_code = true,
              },
            },
          },
          tools = {
            ["mcp"] = {
              -- calling it in a function would prevent mcphub from being loaded before it's needed
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                requires_approval = false,
                auto_approve = true,
              },
            },
          },
        },
        inline = {
          adapter = inline_strategy(),
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject the suggested change",
            },
          },
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
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "default", -- default|telescope|mini_pick
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
        chat = {
          intro_message = "",
          show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
          separator = "─", -- The separator between the different messages in the chat buffer
          show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
          show_settings = false, -- Show LLM settings at the top of the chat buffer?
          show_token_count = true, -- Show the token count for each response?
          start_in_insert_mode = true, -- Open the chat buffer in insert mode?
          -- Options to customize the UI of the chat buffer
          window = {
            layout = "float", -- float|vertical|horizontal|buffer
            position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
            border = "single",
            height = 0.8,
            width = 0.45,
            relative = "editor",
            full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          slash_commands = {
            ["file"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using Telescope",
              opts = {
                provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
                contains_code = true,
              },
            },
          },
        },
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
