" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Antoine Musso <hashar@free.fr>
" Last Change:	2017 12 01
"
" Based of pablo skin by Ron Aaron
" * force t_Co=256
" * remove the gui parts (I dont use gui)

hi clear
set background=dark
set t_Co=256

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "hashar"

highlight Comment	 ctermfg=45
highlight Constant	 ctermfg=13			   cterm=none
"highlight Function   ctermfg=3
highlight Identifier ctermfg=6
highlight Statement  ctermfg=227		   cterm=bold
highlight PreProc	 ctermfg=10
highlight Type		 ctermfg=2
highlight Special	 ctermfg=12
highlight Error					ctermbg=160
" TODO xxx
highlight Todo		 ctermfg=15	ctermbg=166
highlight Directory  ctermfg=2
highlight StatusLine ctermfg=11 ctermbg=12 cterm=none
highlight Normal     ctermbg=0
highlight Search				ctermbg=3

" http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
highlight DiffAdd     cterm=none               ctermbg=22
highlight DiffDelete  cterm=none  ctermfg=Red  ctermbg=52
highlight DiffChange  cterm=none               ctermbg=235
highlight DiffText    cterm=none               ctermbg=53

" Omni popup menu
highlight Pmenu ctermbg=244
