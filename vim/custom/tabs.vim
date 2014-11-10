" Set two spaces by default
set ts=2 sts=2 sw=2 expandtab

" Always set autoindenting on
set autoindent

" Copy the previous indentation on autoindenting
set copyindent

" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

" Insert tabs on the start of a line according to shiftwidth, not tabstop
set smarttab

" ==========================================
" Quickly switch tab settings
" http://vimcasts.org/episodes/tabs-and-spaces/

" :help tabstop
" :help softtabstop
" :help shiftwidth
" :help expandtab

" To invoke this command, go into normal mode (by pressing escape) then run:

" :Stab

" Then hit enter. You will see this:

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction
