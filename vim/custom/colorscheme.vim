if exists("$VIM_DARK_BACKGROUND")
  set background=dark
endif

if exists("$VIM_LIGHT_BACKGROUND")
  set background=light
endif

if filereadable(expand("~/.vimrc_background"))
  " Use base16 colorscheme if set
  let base16colorspace=256
  source ~/.vimrc_background
else
  if exists("$VIM_USE_SEOUL_256_THEME")
    if(&background == "dark")
      colorscheme seoul256
    else
      colorscheme seoul256-light
    end
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255
  end

  if exists("$VIM_USE_GRUVBOX_THEME")
    colorscheme gruvbox
    let g:airline_theme='gruvbox'
  end
endif
