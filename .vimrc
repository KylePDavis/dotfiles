" essentials
set ruler
set mouse=a
set nocompatible
set bs=2
set nowrap

" give me all of teh colors!!
set t_Co=256
set bg=dark
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

" map Alt+Right/Left arrow to movements
nmap <Esc>f <Esc>e
nmap <Esc>b <Esc>b
imap <Esc>f <Esc>lei
imap <Esc>b <Esc>bi

" simplify working with the system clipboard
vmap <C-c> "+y
nmap <C-c> V"+y
vmap <C-x> "+x
nmap <C-x> V"+x
imap <C-v> <Esc>"+Pi

" no more ex mode!
nmap Q <nop>

" force syntax on a few file types
filetype plugin indent on
"autocmd BufNewFile,BufReadPost *.ts set filetype=typescript syntax=typescript
"autocmd BufNewFile,BufReadPost *.tsx set filetype=typescript syntax=typescriptreact
"autocmd BufNewFile,BufReadPost *.json set filetype=json syntax=javascript
"autocmd BufNewFile,BufReadPost *.md set filetype=markdown
"autocmd BufNewFile,BufReadPost *.go set filetype=go

" force syntax for fenced code blocks in markdown
let g:markdown_fenced_languages = [
\ 'sh',
\ 'bash=sh',
\ 'zsh',
\ 'help',
\ 'log=apache',
\ 'json=javascript',
\ 'javascript=typescript',
\ 'js=typescript',
\ 'jsx=typescriptreact',
\ 'ts=typescript',
\ 'tsx=typescriptreact',
\ 'html',
\ 'css',
\ 'mermaid',
\ 'swift',
\ 'rust',
\ 'zig',
\ 'cpp',
\ 'c',
\ 'py=python',
\ 'go',
\ 'ruby',
\ 'clojure',
\ ]

" formatters
"TODO: failing on simple JSON files...
autocmd FileType * set formatprg=bunx\ -q\ prettier\ --stdin-filepath\ % | let $F=&formatprg | set equalprg=$F
autocmd FileType rust set formatprg=rustfmt | let $F=&formatprg | set equalprg=$F

" auto-format on save
"autocmd BufWritePre * normal gg=G''

" compilers/build tools
"autocmd FileType rust compiler cargo | cabbrev cargo make | command Cargo make

" prefer ripgrep if available
if executable('rg')
	set grepprg=rg\ --vimgrep\ $*
	set grepformat^=%f:%l:%c:%m
	" add a silent Grep and use that instead
	command! -nargs=+ -complete=file Grep execute 'silent grep! <args>' | redraw! | copen
endif

" VIM-PLUG PLUGINS (WITH FIRST-RUN AUTOINSTALL)
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !D="$HOME/.vim/autoload"; mkdir -p "$D"; U="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";  F="$D/plug.vim";  curl -fLo "$F" "$U" 2>/dev/null  ||  wget -qLO "$F" "$U"
	autocmd VimEnter * PlugInstall
endif
call plug#begin()

Plug 'tomasiser/vim-code-dark'  " VSCode Dark+ theme

Plug 'tpope/vim-commentary'  " comment stuff out

Plug 'vim-airline/vim-airline'  " more helpful tab line and status lines with colors
let g:airline#extensions#tabline#enabled = !has('gui_running')
let g:airline#extensions#tabline#show_buffers = 0
set laststatus=2
set ttimeoutlen=50

Plug 'editorconfig/editorconfig-vim'

Plug 'vim-syntastic/syntastic'  " multi-language syntax checker
let g:syntastic_check_on_open=1
let g:syntastic_aggregate_errors=1
let g:syntastic_javascript_checkers = ['eslint']

Plug 'ntpeters/vim-better-whitespace'  " whitespace!!
let g:strip_whitespace_on_save = 1

Plug 'nathanaelkane/vim-indent-guides'  " pretty indent guides with softtabs
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1

Plug 'lilydjwg/colorizer'  " colorize CSS inline

Plug 'ctrlpvim/ctrlp.vim'  " fuzzy file matcher / opener
let ctrlp_user_cmd_fallback = 'find %s -type f'
if executable('rg') | let ctrlp_user_cmd_fallback = 'rg --files %s' | endif
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', ctrlp_user_cmd_fallback]

Plug 'tpope/vim-fugitive'  " git commands and statusline

Plug 'airblade/vim-gitgutter'  " git changes in gutter

"# COC SETUP
if executable('node')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}  " amazing code completions
	let g:coc_global_extensions = [
		\ 'coc-git',
		\ 'coc-json',
		\ 'coc-tsserver',
		\ 'coc-eslint',
		\ 'coc-biome',
		\ 'coc-prettier',
		\ 'coc-java',
		\ ]
	if executable('zls') | call add(g:coc_global_extensions, 'coc-zig') | endif

	set encoding=utf-8
	set updatetime=300 " helps make some UI interactions more responsive
	set signcolumn=yes " always enable to avoid UI shifting on init

	" Use tab for trigger completion with characters ahead and navigate
	" NOTE: There's always complete item selected by default, you may want to enable
	" no select by `"suggest.noselect": true` in your configuration file
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config
	inoremap <silent><expr> <TAB>
		\ coc#pum#visible() ? coc#pum#next(1) :
		\ CheckBackspace() ? "\<Tab>" :
		\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
		\ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
		if CocAction('hasProvider', 'hover')
			call CocActionAsync('doHover')
		else
			call feedkeys('K', 'in')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	augroup mygroup
		autocmd!
		" Setup formatexpr specified filetype(s)
		autocmd FileType typescript,javascript,json setl formatexpr=CocAction('formatSelected')
	augroup end

	" Applying code actions to the selected code block
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying code actions at the cursor position
	nmap <leader>ac  <Plug>(coc-codeaction-cursor)
	" Remap keys for apply code actions affect whole buffer
	nmap <leader>as  <Plug>(coc-codeaction-source)
	" Apply the most preferred quickfix action to fix diagnostic on the current line
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Remap keys for applying refactor code actions
	nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
	xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
	nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

	" Run the Code Lens action on the current line
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> to scroll float windows/popups
	if has('nvim-0.4.0') || has('patch-8.2.0750')
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges
	" Requires 'textDocument/selectionRange' support of language server
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

	" statusline support
	let g:airline#extensions#coc#enabled = 1

	" Mappings for CoCList
	" Show all diagnostics
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

	"# COC SETUP END
endif

Plug 'rust-lang/rust.vim'

call plug#end()

colorscheme codedark
