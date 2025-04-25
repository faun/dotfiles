return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
    config = function()
      require("cmp").ConfirmBehavior = {
        Insert = "insert",
        Replace = "replace",
      }
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "giuxtaposition/blink-cmp-copilot" },
      { "rafamadriz/friendly-snippets" },
      { "dmitmel/cmp-digraphs" },
      { "saghen/blink.compat", opts = { enable_events = true } },
      { "mini.icons" },
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    lazy = true,

    opts = function(_, opts)
      opts.appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds),
      }

      opts.completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        ghost_text = {
          enabled = true,
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            components = {
              item_idx = {
                text = function(ctx)
                  return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
                end,
                highlight = "BlinkCmpItemIdx",
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 800,
          treesitter_highlighting = true,
        },
      }
      opts.signature = { enabled = false }
      opts.keymap = {
        preset = "enter",
      }
      opts.sources = {
        compat = {},
        default = {
          "lazydev",
          "lsp",
          "path",
          "snippets",
          "omni",
          "buffer",
          "copilot",
        },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 90,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 80,
            async = true,
          },
        },
      }
      return opts
    end,
    opts_extend = { "sources.default" },
  },
}
