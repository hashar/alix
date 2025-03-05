"
" http://www.slideshare.net/ZendCon/vim-for-php-programmers-presentation
"

" fix up backspace key with vim coming from homebrew
set backspace=2

set runtimepath^=$ALIX_DIR/vim
set rtp+=$ALIX_DIR/vim/powerline/powerline/bindings/vim
execute pathogen#infect("$ALIX_DIR/vim/{}")

" always show the powerline
set laststatus=2
" Hide mode text, handled by powerline
set noshowmode

" Avoid powerline x second timeout
" https://powerline.readthedocs.io/en/master/tips-and-tricks.html
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

function! s:python_exec_settings()
	if getline(1) =~# '^#!.*python2'
		let g:syntastic_python_python_exec = 'python2'
	else
		let g:syntastic_python_python_exec = 'python3'
	endif
endfunction

let g:syntastic_puppet_puppetlint_exec = 'bundle exec puppet-lint'
let g:syntastic_puppet_puppet_exec = 'bundle exec puppet'
autocmd BufRead *.py call s:python_exec_settings()

let g:syntastic_sh_shellcheck_args = '-x'

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

autocmd BufNewFile,BufRead */Dockerfile set et ts=4 sw=4

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
autocmd BufRead $HOME/projects/operations/puppet/* set sw=4 ts=4 sts=4 et
autocmd BufRead $HOME/puppet/* set sw=4 ts=4 sts=4 et
autocmd BufRead $HOME/projects/mediawiki/selenium/* set sw=2 ts=2 sts=2 et
autocmd BufRead $HOME/projects/mediawiki/ruby/* set sw=2 ts=2 sts=2 et

" erb magic
autocmd BufRead *.conf.erb set ft=eruby.dosini
autocmd BufRead *.cnf.erb set ft=eruby.dosini
autocmd BufRead *.ini.erb set ft=eruby.dosini
autocmd BufRead *.ini.erb set ft=eruby.dosini
autocmd BufRead *.js.erb set ft=eruby.javascript
autocmd BufRead *.py.erb set ft=eruby.python
autocmd BufRead *.sh.erb set ft=eruby.sh

autocmd BufRead Dockerfile.template set ft=dockerfile

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
" MediaWiki does not care about javadoc auto brief
let g:doxygen_end_punctuation = '[.\n]'
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

" shell folding
"   1 functions
"   2 heredoc
"   4 ifdofor
let sh_fold_enabled = 7

" ruby
" https://github.com/vim-ruby/vim-ruby/blob/master/doc/ft-ruby-omni.txt
" https://github.com/vim-ruby/vim-ruby/blob/master/doc/ft-ruby-syntax.txt
let ruby_fold = 1
let ruby_operators = 1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_use_bundler = 1

let g:rubycomplete_include_object = 1
let g:rubycomplete_include_object_space = 1

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
