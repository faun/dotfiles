return {
  {
    "williamboman/mason.nvim",
  },
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        html = { "htmlhint" },
        json = { "jsonlint" },
        python = { "flake8" },
        ruby = { "ruby" },
      },
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    config = function()
      require("mason-nvim-lint").setup({
        automatic_installation = false,
        ensure_installed = {
          "flake8",
          "htmlhint",
          "jsonlint",
          "rubocop",
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.completion.spell,
        null_ls.builtins.completion.tags,
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.ansiblelint,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.golangci_lint.with({
          extra_args = {
            "--disable=maligned",
          },
        }),
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.proselint,
        null_ls.builtins.diagnostics.protolint,
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.revive.with({
          condition = function(utils)
            return utils.root_has_file({ "revive.toml" })
          end,
          args = { "-config", "revive.toml", "-formatter", "json", "./..." },
        }),
        null_ls.builtins.diagnostics.rubocop.with({
          condition = function(utils)
            return utils.root_has_file({ ".rubocop.yml", ".rubocop.yaml" })
          end,
        }),
        null_ls.builtins.diagnostics.semgrep,
        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_filetypes = { "mysql" },
          -- condition = function(utils)
          --   return utils.root_has_file({ ".sqlfluff" })
          -- end,
          extra_args = { "--dialect", "mysql" },
        }),
        null_ls.builtins.diagnostics.staticcheck,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.diagnostics.textlint.with({
          condition = function(utils)
            return utils.root_has_file({ ".textlintrc", ".textlintrc.json", ".textlint.yml" })
          end,
        }),
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.diagnostics.tidy,
        null_ls.builtins.diagnostics.todo_comments,
        null_ls.builtins.diagnostics.trivy,
        null_ls.builtins.diagnostics.vacuum,
        null_ls.builtins.diagnostics.vale.with({
          condition = function(utils)
            return utils.root_has_file({ "vale.ini", ".vale.ini" })
          end,
        }),
        null_ls.builtins.diagnostics.vint,
        null_ls.builtins.diagnostics.write_good,
        null_ls.builtins.diagnostics.yamllint.with({
          condition = function(utils)
            return utils.root_has_file({ ".yamllint", ".yamllint.yaml", ".yamllint.yml" })
          end,
        }),
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.formatting.protolint,
        null_ls.builtins.formatting.rubocop.with({
          condition = function(utils)
            return utils.root_has_file({ ".rubocop.yml", ".rubocop.yaml" })
          end,
        }),
        null_ls.builtins.formatting.sqlfluff.with({
          extra_filetypes = { "mysql" },
          -- condition = function(utils)
          --   return utils.root_has_file({ ".sqlfluff" })
          -- end,
          extra_args = { "--dialect", "mysql" },
        }),
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup()

      require("mason-null-ls").setup({
        automatic_installation = true,
      })
    end,
  },
}
