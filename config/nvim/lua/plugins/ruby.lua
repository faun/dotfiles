return {
  {
    "kana/vim-textobj-user",
    lazy = true,
    ft = "ruby",
  },
  {
    "nelstrom/vim-textobj-rubyblock",
    dependencies = { "kana/vim-textobj-user" },
    lazy = true,
    ft = "ruby",
  },
}
