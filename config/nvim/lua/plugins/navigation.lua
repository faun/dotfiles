return {
  "rgroli/other.nvim",
  config = function()
    require("other-nvim").setup({
      mappings = {
        "rails",
        "golang",
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
