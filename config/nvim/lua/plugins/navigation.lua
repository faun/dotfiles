return {
  {
    "rgroli/other.nvim",
    config = function()
      -- default alternative targets
      local rails_alternative_targets = {
        { context = "model", target = "/app/models/%1.rb", transformer = "singularize" },
        { context = "controller", target = "/app/controllers/**/%1_controller.rb" },
        { context = "view", target = "/app/views/%1/*.html*" },
        { context = "view", target = "/app/views/%1/*.html*", transformer = "singularize" },
        { context = "channel", target = "/app/channels/**/%1_channel.rb" },
        { context = "mailer", target = "/app/mailers/%1_mailer.rb" },
        { context = "serializer", target = "/app/serializers/%1_serializer.rb" },
        { context = "mailer", target = "/app/mailers/%1_mailer.rb" },
        { context = "service", target = "/app/services/%1_service.rb" },
        { context = "worker", target = "/app/workers/**/%1_worker.rb" },
        { context = "factories", target = "/spec/factories/%1.rb", transformer = "pluralize" },
      }

      require("other-nvim").setup({
        mappings = {
          "golang",
          -- Rails mappings per filetype
          {
            pattern = "app/controllers/(.*)_controller.rb$",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/views/(.*)/.+.html*",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/models/(.*).rb",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/channels/(.*)_channel.rb",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/mailers/(.*)_mailer.rb",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/serializers/(.*)_serializer.rb",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/services/(.*)_service.rb",
            target = rails_alternative_targets,
          },
          {
            pattern = "/app/workers/(.*)/(.*)_worker.rb",
            target = rails_alternative_targets,
          },
          {
            -- generic test mapping for minitest and rspec
            pattern = "/app/(.*)/(.*).rb",
            target = {
              { context = "test", target = "/spec/%1/%2_spec.rb" },
              { context = "test", target = "/spec/%2_spec.rb" },
              { context = "test", target = "/spec/%1/%2_spec.rb" },
              { context = "test", target = "/spec/%2_spec.rb" },
            },
          },
          {
            pattern = "/db/(.*)/(.*).rb",
            target = {
              { context = "test", target = "/spec/%1/%2_spec.rb" },
            },
          },
          {
            pattern = "/lib/(.*)/(.*).rb",
            target = {
              { context = "test", target = "/spec/lib/%1/%2_spec.rb" },
            },
          },
          {
            pattern = "/spec/lib/(.*)/(.*)_spec.rb",
            target = {
              { context = "source", target = "/lib/%1/%2.rb" },
            },
          },
          {
            pattern = "/spec/(.*)/(.*)_spec.rb",
            target = {
              { context = "source", target = "/app/%1/%2.rb" },
            },
          },

          -- Switch between python test and implementation
          {
            pattern = "/tests/test_([^/]+).py$",
            target = {
              { context = "source", target = "/src/%1.py" },
            },
          },
          {
            pattern = "/tests/([^/]+)_test.py$",
            target = {
              { context = "source", target = "/src/%1.py" },
            },
          },
          {
            pattern = "/tests/test_([^/]+).py$",
            target = {
              { context = "source", target = "/src/%1.py" },
            },
          },
          {
            pattern = "/(.+)/test_([^/]+).py$",
            target = {
              { context = "source", target = "/%1/%2.py" },
            },
          },
          {
            pattern = "/src/([^/]+).py$",
            target = {
              { context = "test", target = "/tests/test_%1.py" },
              { context = "test", target = "/tests/%1_test.py" },
            },
          },
          {
            pattern = "/([^/]+).py$",
            target = {
              { context = "test", target = "/test_%1.py" },
              { context = "test", target = "/%1_test.py" },
            },
          },
        },
        hooks = {
          filePickerBeforeShow = function(files)
            -- This function is called before the filepicker is shown and allows
            -- you to filter the list of files that will be shown in the filepicker.
            --
            -- In this function, we filter out files that start with 'test_test_'
            -- or match the pattern 'test_.+_test'.
            --
            -- We do this to avoid showing test files from within test files
            -- The /([^/]+).py$ patten above will match test files, so we
            -- need to filter the corresponding incorrect names before presenting
            -- them in the filepicker.

            -- Create a new table to store the files that do not match the specified patterns
            local filteredFiles = {}

            -- Filter to keep files that do not have 'test_test_.+' or 'test_.+_test' in the filename
            for _, file in ipairs(files) do
              if file.filename:find("test_test_([^/]+)$") then
                goto continue
              elseif file.filename:find("test_([^/]+)_test([^/]+)$") then
                goto continue
              end

              -- If the file does not match the patterns, add it to the filteredFiles table
              table.insert(filteredFiles, file)

              ::continue::
            end

            -- Return the modified list or prevent opening the filepicker if empty
            if #filteredFiles == 0 then
              return false -- Prevents the filepicker from opening
            else
              return filteredFiles
            end
          end,
        },
        style = {
          border = "rounded",
          seperator = "|",
        },
      })

      -- Create aliases for vim-projectionist commonly used commands
      vim.api.nvim_create_user_command("AV", "OtherVSplit", {})
      vim.api.nvim_create_user_command("AH", "OtherSplit", {})
      vim.api.nvim_create_user_command("AT", "OtherTab", {})
      vim.api.nvim_create_user_command("A", "Other", {})
    end,
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<C-P>",
        function()
          require("telescope.builtin").find_files({ hidden = true })
        end,
        desc = "Find Files",
      },
    },
  },
  {
    "faun/jfind.nvim",
    enabled = function()
      return vim.fn.executable("jfind") == 1
    end,
    branch = "2.0",
    opts = {
      exclude = {
        ".git",
        ".idea",
        ".vscode",
        ".sass-cache",
        ".class",
        "__pycache__",
        "node_modules",
        "target",
        "build",
        "tmp",
        "assets",
        "dist",
        "public",
        "*.iml",
        "*.meta",
      },
    },
    keys = {
      {
        "<C-f>",
        function()
          local jfind = require("jfind")

          jfind.findFile({
            preview = false,
          })
        end,
      },
      {
        "<C-p>",
        function()
          local jfind = require("jfind")

          jfind.findFile({
            preview = true,
          })
        end,
      },
    },
  },
}
