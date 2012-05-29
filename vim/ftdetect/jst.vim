autocmd Filetype jst setlocal noet ts=2 sts=2 sw=2
autocmd FileType jst set omnifunc=htmlcomplete#CompleteTags
autocmd FileType jst let b:surround_45 = "<%- \r %>"
autocmd FileType jst let b:surround_61 = "<%= \r %>"
autocmd FileType jst let b:surround_116 = "<%= t('\r') %>"
