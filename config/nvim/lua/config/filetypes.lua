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
