" =========================================
" Fugitive Settings

" Map :Gcommit to Gcommit -v to get diffs with commit entry
cnoreabbrev <expr> Gcommit ((getcmdtype() is# ':' && getcmdline() is# 'Gcommit')?('Gcommit -v'):('Gcommit'))
cnoreabbrev <expr> Gap ((getcmdtype() is# ':' && getcmdline() is# 'Gap')?('Git add -p'):('Gap'))
cnoreabbrev <expr> Grh ((getcmdtype() is# ':' && getcmdline() is# 'Grh')?('Git reset head -p'):('Grh'))
cnoreabbrev <expr> Gco ((getcmdtype() is# ':' && getcmdline() is# 'Gco')?('Git checkout -p'):('Gco'))

" Toggle fugitive's git status window with F1
" From: https://gist.github.com/actionshrimp/6493611
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command! ToggleGStatus :call ToggleGStatus()
nmap <F1> :ToggleGStatus<CR>
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command! ToggleGStatus :call ToggleGStatus()
nmap <F1> :ToggleGStatus<CR>
