" =========================================
" Turbux + Vimux FTW

let g:turbux_runner  = 'vimux'
let g:turbux_command_rspec  = 'rspec'
let g:turbux_command_teaspoon = 'rake spec:javascript'
let g:turbux_command_prefix = 'bundle exec'

let g:no_turbux_mappings = 1
nmap <leader>\ <Plug>SendTestToTmux
nmap <leader><CR> <Plug>SendFocusedTestToTmux

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
