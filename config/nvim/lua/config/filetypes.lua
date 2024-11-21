if not vim.filetype then
  return
end

vim.filetype.add({
  filename = {
    PULLREQ_EDITMSG = "markdown.ghpull",
    ISSUE_EDITMSG = "markdown.ghissue",
    RELEASE_EDITMSG = "markdown.ghrelease",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.bo.commentstring = "-- %s"
  end,
})
