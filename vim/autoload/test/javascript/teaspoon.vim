" https://gist.github.com/smarquez1/2e86c31294cc8e517c5f/
function! test#javascript#teaspoon#test_file(file) abort
 return a:file =~# '\v_spec\.(js|coffee|js.coffee)$'
endfunction

function! test#javascript#teaspoon#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--filter='.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#teaspoon#build_args(args) abort
  return a:args
endfunction

function! test#javascript#teaspoon#executable() abort
  if filereadable('./bin/teaspoon')
    return './bin/teaspoon'
  elseif filereadable('Gemfile')
    return 'bundle exec teaspoon'
  else
    return 'teaspoon'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction
