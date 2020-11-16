let b:ale_fixers = ['prettier', 'eslint', 'prettier-eslint']

" JS Prettier options
nnoremap gp ma:silent %!prettier --config .prettierrc.js<CR>`a
