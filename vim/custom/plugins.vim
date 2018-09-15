autocmd BufWritePost bundles.vim PlugInstall! --sync
autocmd BufWritePre bundles.vim :sort u
