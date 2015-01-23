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
set mouse=n

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

nnoremap <Leader>gd :GundoToggle<CR>
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nn :NERDTreeClose<CR>
nnoremap <Leader>df :VCSDiff<CR>

"File types
autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab
