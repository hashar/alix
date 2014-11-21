"
" http://www.slideshare.net/ZendCon/vim-for-php-programmers-presentation
"

" fix up backspace key with vim coming from homebrew
set backspace=2

set runtimepath^=$ALIX_DIR/vim
set rtp+=$ALIX_DIR/vim/powerline/powerline/bindings/vim
call pathogen#infect("$ALIX_DIR/vim")

" always show the powerline
set laststatus=2
" Hide mode text, handled by powerline
set noshowmode

" Avoid powerline x second timeout
" https://powerline.readthedocs.org/en/latest/tipstricks.html#vim
if ! has('gui_running')
	set ttimeoutlen=10
	augroup FastEscape
		autocmd!
		au InsertEnter * set timeoutlen=0
		au InsertLeave * set timeoutlen=1000
	augroup END
endif

let mapleader=","

" syntastic configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" Syntax check when buffer are first loaded and on saving
"let g:syntastic_check_on_open=1
let g:syntastic_warning_symbol='⚠'
let g:syntastic_error_symbol='✘'
let g:syntastic_style_warning_symbol='!'
let g:syntastic_style_error_symbol='!!'
" Open error window automatically
" Just use ':Errors' to show it up
"let g:syntastic_auto_loc_list=1
" Skip warnings? (default 0)
"let g:syntastic_quiet_warnings=1

let g:syntastic_phpmd_disable="1"
let g:syntastic_ruby_checkers=['mri', 'rubocop']

" Stop linting puppet, Wikimedia manifests are a mess
"let g:syntastic_puppet_lint_disable="1"

" Load phpcs MediaWiki standard
autocmd BufRead */projects/mediawiki/* let g:syntastic_php_phpcs_args = "--report=csv --standard=$HOME/projects/mediawiki/tools/codesniffer/MediaWiki"
autocmd BufRead */projects/integration/jenkins/mediawiki.d/* let g:syntastic_php_phpcs_args = "--report=csv --standard=$HOME/projects/mediawiki/tools/codesniffer/MediaWiki"
autocmd BufRead */projects/operations/mediawiki-config/* let g:syntastic_php_phpcs_args = "--report=csv --standard=$HOME/projects/mediawiki/tools/codesniffer/MediaWiki"

" Better status line, from the doc page
let g:syntastic_stl_format = '[%E{%e err, line %fe}%B{, }%W{%w warn, line %fw}]'

" git commit in a submodule did not have the correct filetype
autocmd BufNewFile,BufRead *.git/modules/**/COMMIT_EDITMSG setf gitcommit
autocmd BufNewFile,BufRead *.git/modules/**/config setf gitconfig

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


" Ultimately make php boolean keywords true/false to be green/red
autocmd Syntax * syn keyword phpBooleanTrue true contained
autocmd Syntax * syn keyword phpBooleanFalse false contained
autocmd Syntax * syn cluster phpClConst remove=phpBoolean
autocmd Syntax * syn cluster phpClConst add=phpBooleanTrue,phpBooleanFalse
autocmd Syntax * highlight phpBooleanTrue ctermfg=darkGreen guibg=darkGreen
autocmd Syntax * highlight phpBooleanFalse ctermfg=darkRed guibg=darkRed

" Override color for "String" types
autocmd ColorScheme * highlight String ctermfg=Magenta
colors hashar

" apache conf tweaks
autocmd Syntax apache set foldmethod=indent

" puppet tweak
autocmd Syntax puppet set foldmethod=indent

" Wikimedia style uses 4 spaces for indentation
autocmd BufRead */projects/operations/puppet/* set sw=4 ts=4 sts=4 et

" YAML tweak
autocmd Syntax yaml set foldmethod=indent

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

" Python scripts usually have 4 spaces for indentation
au FileType python setlocal tabstop=4 expandtab sw=4 softtabstop=4 foldmethod=indent

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

" from https://github.com/majutsushi/tagbar/wiki
let g:tagbar_type_puppet = {
    \ 'ctagstype': 'puppet',
    \ 'kinds': [
        \'c:class',
        \'s:site',
        \'n:node',
        \'d:definition'
      \]
    \}

" Tip 804: Single tags file for a source tree
" http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
" Find a tag file up to root, thanks to ;
set tags=tags;

" jedi-vim
" Mostly defaults, there for self doc
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "1"
