" =========================================
" Turbux + Vimux FTW

let g:turbux_runner  = 'vimux'
" Run the current file with rspec
map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>

" =========================================
" Fugitive Settings

" Map :Gcommit to Gcommit -v to get diffs with commit entry
cnoreabbrev <expr> Gcommit ((getcmdtype() is# ':' && getcmdline() is# 'Gcommit')?('Gcommit -v'):('Gcommit'))
cnoreabbrev <expr> Gap ((getcmdtype() is# ':' && getcmdline() is# 'Gap')?('Git add -p'):('Gap'))
cnoreabbrev <expr> Grh ((getcmdtype() is# ':' && getcmdline() is# 'Grh')?('Git reset head -p'):('Grh'))
cnoreabbrev <expr> Gco ((getcmdtype() is# ':' && getcmdline() is# 'Gco')?('Git checkout -p'):('Gco'))


