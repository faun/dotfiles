return {
  {
    "williamboman/mason.nvim",
  },
  {
    "stevearc/conform.nvim",
    ---@type conform.setupOpts
    opts = {
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        injected = { options = { ignore_errors = true } },
      },
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        fish = { "fish_indent" },
        css = { "prettier", "stylelint" },
        scss = { "prettier", "stylelint" },
        lua = { "stylua" },
        sh = { "shfmt" },
        tsx = { "prettier", "eslint" },
        js = { "prettier", "eslint" },
        ts = { "prettier", "eslint" },
        graphql = { "prettier", "eslint" },
        ruby = { "ruby" },
        yaml = {},
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
      {
        -- FormatDisable will disable formatting just for this buffer
        "<leader>=D",
        function()
          -- Call the command with a bang to disable formatting just for this buffer
          vim.cmd("FormatDisable!")
        end,
        mode = "",
        desc = "Disable autoformat-on-save for this buffer",
      },
      {
        -- FormatDisable will disable formatting globally
        "<leader>=d",
        function()
          vim.cmd("FormatDisable")
        end,
        mode = "",
        desc = "Disable autoformat-on-save globally",
      },

      {
        "<leader>=e",
        function()
          vim.cmd("FormatEnable")
        end,
        mode = "",
        desc = "Enable autoformat-on-save",
      },
    },
    init = function()
      require("conform").setup({
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 5000, lsp_format = "fallback" }
        end,
      })
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
      end, { range = true })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
          print("Autoformat-on-save disabled for this buffer")
        else
          vim.g.disable_autoformat = true
          print("Autoformat-on-save disabled globally")
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function(args)
        if args.bang then
          -- FormatEnable! will disable formatting just for this buffer
          vim.b.disable_autoformat = false
          print("Autoformat-on-save enabled for this buffer")
        else
          vim.g.disable_autoformat = false
          print("Autoformat-on-save enabled globally")
        end
      end, {
        desc = "Re-enable autoformat-on-save",
        bang = true,
      })
    end,
  },
  {
    "zapling/mason-conform.nvim",
    enabled = false,
    config = function()
      require("mason-conform").setup()
    end,
  },
}
