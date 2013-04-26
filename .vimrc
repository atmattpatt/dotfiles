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

"Mouse integration
set mouse=a

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

command! -nargs=1 JiraSummary exe "normal a" . system('jiraSummary ' . '<args>')

"Command T overrides
let g:CommandTMaxFiles=1000000

"Key bindings
let mapleader=","

nnoremap <F1> :NERDTree<CR>
nnoremap <Leader>d :VCSDiff<CR>

"File sync with sandbox
nnoremap <Leader>s :!syncwc %<CR>
nnoremap <F12> :call ToggleAutoSyncFiles()<CR>

let b:autosync=0
function! DoAutoSyncFiles()
	if exists("b:autosync")
		if b:autosync == 1
			echo ""
			:silent !syncwc %
			:redraw!
		endif
	endif
endfunction

function! ToggleAutoSyncFiles()
	if exists("b:autosync")
		if b:autosync == 1
			let b:autosync=0
			echo "Auto sync disabled"
		else
			let b:autosync=1
			echo "Auto sync enabled"
		endif
	else
		let b:autosync=1
		echo "Auto sync enabled"
	endif
endfunction

autocmd BufWritePost */wc/* :call DoAutoSyncFiles()

"Run SQL on bookit-dev server
function! RunSQLonBookItDev()
	if expand("%:e") == "sql"
		!mysql -h "DEVSERVER" -u "USERNAME" --password="PASSWORD" --verbose < %
	endif
endfunction

command! -nargs=0 Runsql call RunSQLonBookItDev()

