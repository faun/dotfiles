return {
  "tpope/vim-projectionist",
  config = function()
    vim.cmd([[
          let g:projectionist_heuristics ={
          \  "spec/*.rb": {
          \     "app/*.rb": { "alternate": "spec/{}_spec.rb", "type": "source"},
          \     "lib/*.rb": { "alternate": "spec/{}_spec.rb", "type": "source"},
          \     "spec/*_spec.rb": { "alternate": ["app/{}.rb","lib/{}.rb"],"type": "test"},
          \  },
          \ "*_test.go": {
          \    "*.go":       { "alternate": "{}_test.go", "type": "test" },
          \    "*_test.go":  { "alternate": "{}.go", "type": "source" },
          \  },
          \}
        ]])
  end,
  event = { "BufReadPost", "BufNewFile" },
}
