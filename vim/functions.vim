""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>R :call RunTestFile()<cr>
map <leader>r :call RunNearestTest()<cr>
map <leader>bt <ESC>:w<CR>\|:Dispatch bundle exec rspec --color --no-drb %<cr>
map <leader>z <ESC>:w<CR>\|:Dispatch rspec --color --no-drb %<cr>
map <leader>tu <ESC>:w<CR>\|:Dispatch rspec --color --no-drb spec/lib<cr>
map <leader>bu <ESC>:w<CR>\|:Dispatch bundle exec rspec --color --no-drb spec/lib<cr>

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\|_test.js\|_spec.js\)')

  if in_test_file >= 0
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    :echo "Vim: I don't know what file to test :("
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)

  " JAVASCRIPT
  if match(expand("%"), '\(._test.js\|_spec.js\)') >= 0

    let filename_for_spec = substitute(expand("%"), "spec/javascripts/", "", "")
    "Konacha
    if filereadable("Gemfile") && match(readfile("Gemfile"), "konacha") >= 0

      " Konacha with Zeus
      if filereadable("zeus.json")
        :silent !echo "Konacha with zeus"
        exec ":Dispatch zeus rake konacha:run SPEC=" . filename_for_spec

      " Konacha with bundle exec
      else
        :silent !echo "Konacha with bundle exec"
        exec ":Dispatch bundle exec rake konacha:run SPEC=" . filename_for_spec
      endif

    " Everything else (QUnit)
    else
      "Rake
      exec ":Dispatch rake"
    endif

  " RUBY
  elseif match(a:filename, '\(._test.rb\|_spec.rb\)') >= 0

    let filename_without_line_number = substitute(a:filename, ':\d\+$', '', '')
    " Minitest
    if match(a:filename, '\(_test\)') != -1
      exec ":Dispatch ruby -Ilib/ " . a:filename

    " Bundler
    elseif match(readfile(filename_without_line_number), '\("spec_helper\|''spec_helper\|capybara_helper\|acceptance_spec_helper\|acceptance_helper\)') >= 0

      " Zeus
      if filereadable("zeus.json") && filereadable("Gemfile")
        :silent !echo "Using zeus"
        exec ":Dispatch zeus rspec -O ~/.rspec --color --format progress --no-drb --order random " . a:filename

      " bundle exec
      elseif filereadable("Gemfile")
        :silent !echo "Using bundle exec"
        exec ":Dispatch bundle exec rspec --color --order random " . a:filename

      " pure rspec
      else
        :silent !echo "Using vanilla rspec"
        exec ":Dispatch rspec -O ~/.rspec --color --format progress --no-drb --order random " . a:filename
      end

    " Everything else
    else
      :silent !echo "Using vanilla rspec outside Rails"
      exec ":Dispatch rspec -O ~/.rspec --color --format progress --no-drb --order random " . a:filename
    end
  end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==========================================
" Smart Tab completion
" http://vim.wikia.com/wiki/VimTip102

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>

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

" ==========================================
" Diff with buffer with original (from: http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file)

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()
