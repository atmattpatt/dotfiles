call plug#begin('~/.vim/plugged')

Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'RRethy/vim-illuminate'
Plug 'benmills/vimux'
Plug 'cakebaker/scss-syntax.vim'
Plug 'chase/vim-ansible-yaml'
Plug 'ekalinin/Dockerfile.vim'
Plug 'flazz/vim-colorschemes'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'hhvm/vim-hack'
Plug 'jlanzarotta/bufexplorer'
Plug 'joker1007/vim-ruby-heredoc-syntax'
Plug 'jparise/vim-graphql'
Plug 'jtratner/vim-flavored-markdown'
Plug 'junegunn/fzf', { 'tag': '0.21.0', 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user'
Plug 'kchmck/vim-coffee-script'
Plug 'majutsushi/tagbar'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'pangloss/vim-javascript'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'pgr0ss/vimux-ruby-test' | Plug 'atmattpatt/github-ruby-test'
Plug 'plasticboy/vim-markdown'
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'puppetlabs/puppet-syntax-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'uarun/vim-protobuf'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/matchit.zip'
Plug 'w0rp/ale'

call plug#end()

set nocompatible

"Enable syntax highlighting
syntax enable

"Color scheme
if &term != "xterm-color"
	if has("gui-running")
		let g:solarized_termcolors=256
		set t_Co=16
		colorscheme anotherdark
		set background=dark
	else
		set t_Co=16
		colorscheme anotherdark
		set background=dark
	endif
endif

"Mouse integration
set mouse=

"Formatting
set hlsearch
set number
set ruler

set smarttab
set shiftwidth=4
set tabstop=4
set expandtab
set nosmartindent
filetype plugin indent on

set showbreak=>>\ \    

"Automatically open NERDTree if opening empty editor
autocmd vimenter * if !argc() | NERDTree | endif

"Powerline
set laststatus=2
set showtabline=2

"Fuzzy find
let $FZF_DEFAULT_COMMAND = 'find * -type f 2>/dev/null | grep -v -E "deps/|_build/|node_modules/|vendor/|build_intellij/"' 
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_tags_command = 'ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

"Markdown
let g:vim_markdown_folding_disabled = 1

"Key bindings
let mapleader=","

nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nn :NERDTreeClose<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>
nnoremap <Leader>be :BufExplorer<CR>

map <silent> <leader>ff :Files<CR>
map <silent> <leader>t :Files<CR>
map <silent> <leader>fg :GFiles<CR>
map <silent> <leader>fb :Buffers<CR>
map <silent> <leader>ft :Tags<CR>

map <silent> <Leader>gt :VimuxRunCommand "clear && git status"<CR>
map <silent> <Leader>gd :VimuxRunCommand "clear && git diff"<CR>
map <silent> <Leader>gs :VimuxRunCommand "clear && git diff --cached"<CR>
map <silent> <Leader>gb :VimuxRunCommand "clear && git branch"<CR>

"File types
autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType yaml set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType vim set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType proto set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType puppet set tabstop=2|set shiftwidth=2|set expandtab

"Ruby mappings
map <silent> <Leader>rb :wa<CR> :RunAllRubyTests<CR>
map <silent> <Leader>rc :wa<CR> :RunRubyFocusedContext<CR>
map <silent> <Leader>rf :wa<CR> :RunRubyFocusedTest<CR>
map <silent> <Leader>rl :wa<CR> :VimuxRunLastCommand<CR>
map <silent> <Leader>vp :wa<CR> :VimuxPromptCommand<CR>
map <silent> <Leader>rs :!ruby -c %<CR>

"Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

"Test outline
function VimuxTestOutline()
  VimuxRunCommand('clear && grep -nE "^(\s*)(describe|context|specify|it|example|test|def test)" ' . expand('%'))
endfunction
nnoremap <silent> <leader>so :call VimuxTestOutline()<CR>
