" essentials
syntax on
set ruler
set bg=dark
set mouse=a
set nocompatible
set bs=2
set hlsearch
set nowrap

" tabs and indents
set shiftwidth=4 tabstop=4 softtabstop=4
set list lcs=tab:\⦚\  " pretty indent guides when using tabs
highlight SpecialKey ctermfg=darkgray guifg=#424242

" tab based indention behaviors
vmap <Tab> >
nmap <Tab> >>
vmap <S-Tab> <
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i

" coping to Mac OS X clipboard (kinda)
vmap <C-c> :w !pbcopy<CR><CR>

" force syntax on a few file types
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.md set ft=markdown

" run js-beautify with the = key
autocmd FileType javascript setlocal equalprg=js-beautify\ -f\ -\ -q\ -t\ -j\ -w\ 140\ --good-stuff

" VIM-PLUG PLUGINS (WITH FIRST-RUN AUTOINSTALL)
let PLUG_VIM_FILE = expand('~/.vim/autoload/plug.vim')
let HAS_PLUG = filereadable(PLUG_VIM_FILE)
if !HAS_PLUG
	silent !mkdir -p ~/.vim/autoload
	silent !curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin()

Plug 'bling/vim-airline'  " more helpful tab line and status lines with colors
let g:airline#extensions#tabline#enabled = !has('gui_running')
let g:airline#extensions#tabline#show_buffers = 0
set laststatus=2
set ttimeoutlen=50
"TODO: decide if I care enough for:  https://github.com/Lokaltog/powerline-fonts

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }  " tree file browser
map <C-n> :NERDTreeToggle<CR>
map <C-\> :NERDTreeToggle<CR>
"TODO: detect SHIFT?: map <Shift><C-\> :NERDTreeFind<CR>

Plug 'scrooloose/syntastic'  " multi-language syntax checker

Plug 'ntpeters/vim-better-whitespace'  " whitespace!!
let g:strip_whitespace_on_save = 1
let g:better_whitespace_filetypes_blacklist=['conque_term']

Plug 'nathanaelkane/vim-indent-guides'  " pretty indent guides with softtabs
let g:indent_guides_guide_size = 1

Plug 'lilydjwg/colorizer'  " colorize CSS inline

Plug 'kien/ctrlp.vim'  " fuzzy file matcher / opener

Plug 'fisadev/vim-ctrlp-cmdpalette'  " fuzzy command matcher / runner
"TODO: detect SHIFT?: map <Shift><C-p> :CtrlPCmdPalette<CR>

Plug 'tpope/vim-fugitive'  " git commands and statusline

Plug 'mhinz/vim-signify'  " label VCS changes in gutter

Plug 'oplatek/Conque-Shell'  " a shell in a buffer
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CloseOnEnd = 1

Plug 'moll/vim-node'  " nodejs extras

Plug 'sidorares/node-vim-debugger'  " nodejs debugger
command NodeDebug call conque_term#open('node ' . expand('~/.vim/plugged/node-vim-debugger/bin/vim-inspector') . ' "' . expand('%') . '"', ['belowright split'])

call plug#end()
if !HAS_PLUG
	:PlugInstall
	silent !cd ~/.vim/plugged/node-vim-debugger/ && npm install
	:source ~/.vimrc
endif
