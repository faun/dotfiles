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
        rubocop = {
          ---@param ctx conform.Context
          condition = function(_, ctx)
            if
              vim.fs.find({
                "bin/rubocop",
              }, {
                upward = true,
                path = ctx.dirname,
                stop = vim.fs.find({ ".git" }, { upward = true, path = ctx.dirname })[1],
              })[1] ~= nil
            then
              return true
            end

            -- Otherwise, only use rubocop when config file is present
            return vim.fs.find({
              ".rubocop.yml",
              ".rubocop.yaml",
              ".rubocop_todo.yml",
              ".rubocop_todo.yaml",
            }, {
              upward = true,
              path = ctx.dirname,
              stop = vim.fs.find({ ".git" }, { upward = true, path = ctx.dirname })[1],
            })[1] ~= nil
          end,
          --@param ctx conform.Context
          command = function(_, ctx)
            if
              vim.fs.find({
                "bin/rubocop",
              }, {
                upward = true,
                path = ctx.dirname,
                stop = vim.fs.find({ ".git" }, { upward = true, path = ctx.dirname })[1],
              })[1] ~= nil
            then
              return "bin/rubocop"
            end

            return "rubocop"
          end,
          --@param ctx conform.Context
          args = function(_, ctx)
            if
              vim.fs.find({
                "bin/rubocop",
              }, {
                upward = true,
                path = ctx.dirname,
                stop = vim.fs.find({ ".git" }, { upward = true, path = ctx.dirname })[1],
              })[1] ~= nil
            then
              -- Use the binstub if it exists
              return { "--server", "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" }
            end
            -- Otherwise, use the default rubocop command
            return { "bundle", "exec", "rubocop", "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" }
          end,
          format_on_save = false, -- rubocop can be slow, so we don't want to run it on save
          format_after_save = false,
          lsp_format = "first",
        },
        injected = { options = { ignore_errors = true } },
        prettier = {
          -- Only use prettier when config file is present
          ---@param ctx conform.Context
          condition = function(ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              "prettier.config.js",
              ".prettierrc.cjs",
              "prettier.config.cjs",
              ".prettierrc.toml",
              "package.json",
            }, {
              upward = true,
              path = ctx.dirname,
              stop = vim.fs.find({ ".git" }, { upward = true, path = ctx.dirname })[1],
            })[1] ~= nil
          end,
        },
      },
      default_format_opts = {
        timeout_ms = 500,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        ["*"] = { "trim_whitespace", "trim_newlines" },
        css = { "prettier", "stylelint" },
        fish = { "fish_indent" },
        graphql = { "prettier", "eslint" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        js = { "prettier", "eslint" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        scss = { "prettier", "stylelint" },
        sh = { "shfmt" },
        ts = { "prettier", "eslint" },
        tsx = { "prettier", "eslint" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
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
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        format_after_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 5000, lsp_format = "first" }
        end,
      })

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
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
