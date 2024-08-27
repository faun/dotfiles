return {
  {
    "williamboman/mason.nvim",
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
      formatters_by_ft = {
        c = { "clang_format" },
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        css = { "prettier" },
        eruby = { "erb_format" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        less = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        scss = { "prettier" },
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
    end,
  },
  {
    "zapling/mason-conform.nvim",
    config = function()
      require("mason-conform").setup()
    end,
  },
}
