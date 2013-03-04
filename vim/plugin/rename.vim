" Rename file function.
" Call using :Rename new_file_name.txt
function RenameFile()
  let oldpath = expand('%')
  let newpath = input('New file name: ', expand('%'), 'file')
  let file_modified = getbufvar(oldpath, '&modified')
  echohl ErrorMsg
  if file_modified == 1
    echomsg oldpath . " has been modified, please save before renaming!"
  else
    let renamed = rename(oldpath, newpath)
    if renamed != 0
      echomsg "Failed to rename file to " . newpath . "!"
    else
      bd
      call delete(oldpath)
      exec "e " . newpath
    endif
  endif
  echohl None
endfunction
map <leader>n :call RenameFile()<cr>
