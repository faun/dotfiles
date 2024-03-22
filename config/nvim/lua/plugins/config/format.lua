-- https://github.com/stevearc/conform.nvim
M = {}

M.setup_conform = function()
  local conform = require("conform")
  conform.setup({
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
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
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- `Format` user command bound to `<leader><leader>f` during lsp `on_attach()`
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        conform.format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
  })
end

return M
