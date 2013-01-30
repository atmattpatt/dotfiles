"Pathogen
call pathogen#infect()

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

"Formatting
set number

set smarttab
set shiftwidth=4
set tabstop=4
filetype plugin indent on

set showbreak=>>\ \    

"Automatically open NERDTree if opening empty editor
autocmd vimenter * if !argc() | NERDTree | endif

let g:Powerline_symbols = 'fancy'
set laststatus=2

