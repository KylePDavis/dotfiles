" essentials
set ruler
set mouse=a
set nocompatible
set bs=2
set nowrap

" give me all of teh colors!!
set t_Co=256
set bg=dark
colorscheme elflord
syntax on

" misc
set path+=** " make :find tab-completion search subdirectories
set wildmenu " show tab-complete menu for : commands

" search
set ignorecase " case insensitive search
set smartcase  " auto switch to case-sensitive if uppercase *is* used
set incsearch  " live incremental searching
set showmatch  " show matches live while typing
set hlsearch   " highlight matches

" tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4

" tab based indention behaviors
vmap <Tab> >
nmap <Tab> >>
vmap <S-Tab> <
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i

" folds
set foldmethod=syntax
set foldlevelstart=99

" simplify working with the system clipboard
vmap <C-c> "+y
nmap <C-c> V"+y
vmap <C-x> "+x
nmap <C-x> V"+x
imap <C-v> <Esc>"+Pi

" no more ex mode!
nmap Q <nop>

" force syntax on a few file types
autocmd BufNewFile,BufReadPost *.json set filetype=json syntax=javascript
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.go set filetype=go

" prefer ripgrep if available
if executable('rg')
	set grepprg=rg\ --vimgrep\ $*
	set grepformat^=%f:%l:%c:%m
endif

" VIM-PLUG PLUGINS (WITH FIRST-RUN AUTOINSTALL)
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !mkdir -p "$HOME/.vim/autoload"; U="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";  F="$HOME/.vim/autoload/plug.vim";  curl -fLo "$F" "$U" 2>/dev/null  ||  wget -qLO "$F" "$U"
	autocmd VimEnter * PlugInstall
endif
call plug#begin()

Plug 'tpope/vim-commentary'  " comment stuff out

Plug 'vim-airline/vim-airline'  " more helpful tab line and status lines with colors
let g:airline#extensions#tabline#enabled = !has('gui_running')
let g:airline#extensions#tabline#show_buffers = 0
set laststatus=2
set ttimeoutlen=50

Plug 'mg979/vim-visual-multi'  " multiple cursor support

Plug 'editorconfig/editorconfig-vim'

Plug 'vim-syntastic/syntastic'  " multi-language syntax checker
let g:syntastic_check_on_open=1
let g:syntastic_aggregate_errors=1
let g:syntastic_javascript_checkers = ['eslint']

Plug 'ntpeters/vim-better-whitespace'  " whitespace!!
let g:strip_whitespace_on_save = 1

Plug 'nathanaelkane/vim-indent-guides'  " pretty indent guides with softtabs
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter * :highlight IndentGuidesOdd ctermbg=233
autocmd VimEnter * :highlight IndentGuidesEven ctermbg=234
autocmd VimEnter * :IndentGuidesEnable

Plug 'lilydjwg/colorizer'  " colorize CSS inline

Plug 'ctrlpvim/ctrlp.vim'  " fuzzy file matcher / opener
let ctrlp_user_cmd_fallback = 'find %s -type f'
if executable('rg') | let ctrlp_user_cmd_fallback = 'rg --files %s' | endif
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', ctrlp_user_cmd_fallback]

Plug 'tpope/vim-fugitive'  " git commands and statusline

Plug 'mhinz/vim-signify'  " label VCS changes in gutter

Plug 'pangloss/vim-javascript'  " better JavaScript support

Plug 'moll/vim-node'  " nodejs extras

Plug 'leafgarland/typescript-vim'  " TypeScript support
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

Plug 'rust-lang/rust.vim'

call plug#end()
