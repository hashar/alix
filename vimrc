syntax on
set background=dark
colors pablo
highlight String ctermfg=Magenta

set tabstop=4
set shiftwidth=4

set hlsearch  " highlight searches
set smartcase

set ruler

set modeline
set modelines=5
filetype plugin indent on

" ###### FOLDING ############################################################
set foldmethod=syntax
set foldlevelstart=99  " default to unfolded
" (un)fold with space bar
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf
let php_folding = 2

