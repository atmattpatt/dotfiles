"Pathogen
call pathogen#infect()

set nocompatible

"Enable syntax highlighting
syntax enable

"Solarized color scheme
if &term != "xterm-color"
	if has("gui-running")
		let g:solarized_termcolors=256
		set t_Co=16
		colorscheme solarized
		set background=dark
	else
		set t_Co=16
		colorscheme solarized
		set background=dark
	endif
endif

"Mouse integration
set mouse=a

"Formatting
set number

set smarttab
set shiftwidth=4
set tabstop=4
set expandtab
filetype plugin indent on

set showbreak=>>\ \    

"Automatically open NERDTree if opening empty editor
autocmd vimenter * if !argc() | NERDTree | endif

let g:Powerline_symbols = 'fancy'
set laststatus=2

"Command T overrides
let g:CommandTMaxFiles=1000000

"Key bindings
let mapleader=","

nnoremap <F1> :NERDTree<CR>
nnoremap <Leader>d :VCSDiff<CR>

"File types
autocmd BufEnter *.sls setlocal ft=yaml | setlocal smarttab | setlocal shiftwidth=2 | setlocal tabstop=2 | setlocal expandtab
