" ==========================================
" Wildmenu Settings

" Use wildmenu
set wildmenu

" Set completion style
set wildmode=longest,list,full

" Ignore images
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.ico

" Ignore PSDs
set wildignore+=*.psd

" Ignore PID files
set wildignore+=*.pid

" Ignore files in tmp
set wildignore+=*/tmp/*

" Ignore sqlite databases
set wildignore+=*.sqlite3

" Ignore xcode files
set wildignore+=*.ipa,*.xcodeproj/*,*.xib,*.cer,*.icns

" Ignore asset pipeline
set wildignore+=public/assets/*,public/stylesheets/compiled/*

" Ignore vcr cassettes
set wildignore+=spec/vcr/*

" Ignore bundler files
set wildignore+=bundler_stubs/*
