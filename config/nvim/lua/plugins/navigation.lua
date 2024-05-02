return {
  "rgroli/other.nvim",
  config = function()
    require("other-nvim").setup({
      mappings = {
        "rails",
        "golang",
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
}
