"
" http://www.slideshare.net/ZendCon/vim-for-php-programmers-presentation
"

syntax on
set background=dark

" highlight trailing whitespaces with a red background
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
call matchadd('ExtraWhitespace', '\s\+$')

" highlight non breaking spaces (on Mac: alt+space)
highlight NoBreakSpace ctermbg=cyan guibg=cyan
autocmd ColorScheme * highlight NoBreakSpace ctermbg=cyan guibg=cyan
call matchadd('NoBreakSpace', ' ')


autocmd ColorScheme * highlight String ctermfg=Magenta
colors pablo


" puppet tweaks
autocmd BufRead,BufNewFile *.pp set filetype=puppet
autocmd FileType puppet source $VIMRUNTIME/syntax/ruby.vim
autocmd FileType puppet set foldmethod=indent
autocmd FileType puppet set sw=2
autocmd FileType puppet set ts=2


set tabstop=4
set shiftwidth=4

set hlsearch  " highlight searches
set smartcase

set ruler

" fancy tab completion from command line
set wildmenu
set wildmode=list:longest

" Make search case agnostic
set ignorecase
" Unless search string has an upper case character
set smartcase

set modeline
set modelines=5
filetype plugin indent on

set showcmd

" ###### SYNTAX #############################################################

" highlight doxygen syntax in comments
let g:load_doxygen_syntax = 1
" snippet grabbed from synload.vim to add PHP :-)
au Syntax php
    \ if (exists('b:load_doxygen_syntax') && b:load_doxygen_syntax)
    \   || (exists('g:load_doxygen_syntax') && g:load_doxygen_syntax)
    \   | runtime! syntax/doxygen.vim
    \ | endif
" overrides syntax/doxygen.vim defaults:
hi def link doxygenComment Comment


" ###### FOLDING ############################################################
set foldmethod=syntax
set foldlevelstart=99  " default to unfolded
" (un)fold with space bar
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf
let php_folding = 2
let javaScript_fold = 1
let g:xml_syntax_folding = 1
let perl_fold = 1
let perl_fold_blocks = 1


" Tip 804: Single tags file for a source tree
" http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
" Find a tag file up to root, thanks to ;
set tags=tags;
