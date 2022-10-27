" Include # as a comment marker for mysql comments
autocmd FileType sql setlocal comments=s1:/*,mb:*,ex:*/,:--,://,:#
autocmd FileType sql syn match sqlComment "#.*$" contains=@Spell
