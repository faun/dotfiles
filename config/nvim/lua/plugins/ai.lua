-- Layered AI features, gated per machine by lua/config/ai.lua:
--
--   Layer 1: inline ghost-text completion (copilot | fireworks | local llama.cpp)
--   Layer 2: next-edit suggestions via sidekick.nvim (Copilot LSP)
--   Layer 3: chat / inline edits via CodeCompanion
--
-- The deterministic completion menu (LSP/snippets/buffer) lives in
-- completion.lua and never contains AI sources.

local ai = require("config.ai")

local completion = ai.completion()
local nes = ai.nes()
local assist = ai.assist()

local anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")
local openai_api_key = os.getenv("OPENAI_API_KEY")
local ollama_base_url = os.getenv("OLLAMA_API_BASE_URL")

local plugins = {}

-- ---------------------------------------------------------------------------
-- Layer 1: inline ghost text
-- ---------------------------------------------------------------------------

-- Copilot ghost text only when it is the selected completion tier. The plugin
-- stays loaded on other tiers when NES is enabled, since sidekick.nvim rides
-- on its LSP server.
table.insert(plugins, {
  "zbirenbaum/copilot.lua",
  optional = true,
  enabled = completion == "copilot" or nes,
  opts = {
    suggestion = { enabled = completion == "copilot" },
  },
})

if completion == "local" or completion == "fireworks" then
  -- Qwen-Coder FIM prompt, used both by llama.cpp and Fireworks since neither
  -- completions endpoint supports the `suffix` request field.
  local function qwen_fim_prompt(context_before_cursor, context_after_cursor, _)
    return "<|fim_prefix|>" .. context_before_cursor .. "<|fim_suffix|>" .. context_after_cursor .. "<|fim_middle|>"
  end

  local fim_provider
  if completion == "local" then
    fim_provider = {
      -- llama.cpp needs no key, but minuet requires a non-empty env var name
      api_key = "TERM",
      name = "llama.cpp",
      end_point = ai.llama_endpoint(),
      model = "PLACEHOLDER", -- llama-server serves whatever model it was started with
      optional = { max_tokens = 128, top_p = 0.9 },
      template = { prompt = qwen_fim_prompt, suffix = false },
    }
  else
    fim_provider = {
      api_key = "FIREWORKS_API_KEY",
      name = "Fireworks",
      end_point = "https://api.fireworks.ai/inference/v1/completions",
      model = os.getenv("NVIM_AI_FIREWORKS_MODEL") or "accounts/fireworks/models/qwen2p5-coder-32b-instruct",
      optional = { max_tokens = 128, top_p = 0.9 },
      template = { prompt = qwen_fim_prompt, suffix = false },
    }
  end

  table.insert(plugins, {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = completion == "local" and 4096 or 12800,
      request_timeout = 3,
      throttle = completion == "local" and 400 or 1000,
      debounce = completion == "local" and 150 or 400,
      provider_options = {
        openai_fim_compatible = fim_provider,
      },
      virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
          accept = "<M-l>",
          accept_line = "<M-;>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    },
  })
end

-- ---------------------------------------------------------------------------
-- Layer 2: next-edit suggestions
-- ---------------------------------------------------------------------------

table.insert(plugins, {
  "folke/sidekick.nvim",
  enabled = nes,
  event = "VeryLazy",
  opts = {
    nes = { enabled = true },
  },
  keys = {
    {
      "<Tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
  },
})

-- ---------------------------------------------------------------------------
-- Layer 3: chat / inline edits
-- ---------------------------------------------------------------------------

local codecompanion_lazy_config = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-mini/mini.diff",
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
        ["Generate a Commit Message"] = {
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
            height = 1,
            width = 1,
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

    -- Create an autocommand group to organize related autocommands
    local commit_msg_group = vim.api.nvim_create_augroup("CommitMessageGroup", { clear = true })

    -- Define the autocommand to generate commit messages
    vim.api.nvim_create_autocmd("FileType", {
      group = commit_msg_group,
      pattern = "gitcommit",
      callback = function()
        require("codecompanion").prompt("commit")
      end,
      desc = "Automatically generate commit messages using CodeCompanion",
    })
  end,
}

if assist == "codecompanion" then
  vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")
  table.insert(plugins, codecompanion_lazy_config)
end

return plugins
