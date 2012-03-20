if has("gui_running")
  set guioptions-=T
  set guioptions-=T " disable toolbar
  set guioptions-=L " disable scrollbar
  set guioptions-=r " disable right-hand scrollbar
endif

if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  map <D-P> <Plug>PeepOpen
end
