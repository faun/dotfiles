return {
  {
    "williamboman/mason.nvim",
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.code_actions.gomodifytags.with({
          filetypes = { "go" },
          condition = function(utils)
            return utils.root_has_file({ "go.mod" })
          end,
        }),
        null_ls.builtins.code_actions.impl.with({
          filetypes = { "go" },
          condition = function(utils)
            return utils.root_has_file({ "go.mod" })
          end,
        }),
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.completion.spell,
        null_ls.builtins.completion.tags,
        null_ls.builtins.diagnostics.actionlint,
        null_ls.builtins.diagnostics.ansiblelint,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.diagnostics.editorconfig_checker,
        null_ls.builtins.diagnostics.fish,
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
        null_ls.builtins.diagnostics.semgrep.with({
          condition = function(utils)
            return utils.root_has_file(".semgrep.yml")
              or utils.root_has_file(".semgrep.yaml")
              or utils.root_has_file(".semgrep")
          end,
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          extra_args = function(utils)
            local config_files = {
              [".semgrep"] = true,
              [".semgrep.yml"] = true,
              [".semgrep.yaml"] = true,
            }

            local function get_config(file)
              return config_files[file] and { "--config", file } or nil
            end

            return get_config(".semgrep") or get_config(".semgrep.yml") or get_config(".semgrep.yaml") or {}
          end,
        }),
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_filetypes = { "mysql" },
          -- condition = function(utils)
          --   return utils.root_has_file({ ".sqlfluff" })
          -- end,
          extra_args = { "--dialect", "mysql" },
        }),
        null_ls.builtins.diagnostics.stylelint.with({
          condition = function(utils)
            return utils.root_has_file({
              ".stylelintrc",
              ".stylelintrc.json",
              ".stylelintrc.yml",
              ".stylelintrc.yaml",
              "stylelint.config.js",
              ".stylelintignore",
            })
          end,
        }),
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.diagnostics.textlint.with({
          condition = function(utils)
            return utils.root_has_file({ ".textlintrc", ".textlintrc.json", ".textlint.yml" })
          end,
        }),
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.diagnostics.tidy,
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
        null_ls.builtins.formatting.golines.with({
          condition = function(utils)
            return utils.root_has_file({ ".golines" })
          end,
          extra_args = { "--max-len=128", "--base-formatter=gofumpt" },
        }),
        null_ls.builtins.formatting.protolint,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.sqlfluff.with({
          extra_filetypes = { "mysql" },
          -- condition = function(utils)
          --   return utils.root_has_file({ ".sqlfluff" })
          -- end,
          extra_args = { "--dialect", "mysql" },
        }),
        null_ls.builtins.formatting.terraform_fmt,
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
        ensure_installed = nil,
        automatic_installation = true,
      })
    end,
  },
}
