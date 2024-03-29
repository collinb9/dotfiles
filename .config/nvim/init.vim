" Search for files anywhere lower in the file tree using fuzzy matching
set path+=**

" ignore files
set wildignore+=*.pyc
set wildignore+=*build/*
set wildignore+=**/coverage/*
set wildignore+=**/.git/*
set wildignore+=**/.history/*
set wildignore+=**/.aws-sam/*
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

" Make sure you use single quotes
" ervandew/supertab
" honza/vim-snippets
" ivanov/vim-ipython
" michaeljsmith/vim-indent-object
" psf/black
" skywind3000/asyncrun.vim
" talek/obvious-resize
" tommcdo/vim-exchange
" tpope/vim-speeddating
" tpope/vim-unimpaired
" tpope/vim-vinegar
" vim-test/vim-test
" Sirver/ultisnips
" honza/vim-snippets

"  Tpope stuff
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'

" general text editing improvements
" Plug 'jiangmiao/auto-pairs'
Plug 'wellle/targets.vim'

" navigation
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'phaazon/hop.nvim'

" treesitter
" For some reason TSUpdate isn't recognised as an editor command (same goes for all treesitter commands)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':lua require(\"nvim-treesitter.install\").commands.TSUpdate[\"run\"](\"all\")'}

" language servers and autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'onsails/lspkind-nvim'
Plug 'dense-analysis/ale'
Plug 'cespare/vim-toml'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'alaviss/nim.nvim'
Plug 'jose-elias-alvarez/typescript.nvim'

" make things look nice
Plug 'gruvbox-community/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" harpoon
Plug 'ThePrimeagen/harpoon'

" git worktree
Plug 'ThePrimeagen/git-worktree.nvim'

" test runner
Plug 'vim-test/vim-test'

" Preview markdown
Plug 'ellisonleao/glow.nvim', {'branch': 'main'}

" " Github copilot
" Plug 'github/copilot.vim'
" Plug 'hrsh7th/cmp-copilot'

" Database stuff
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

call plug#end()


" Colour scheme
set t_Co=256
colorscheme gruvbox
let g:gruvbox_transparent_bg=1
set background=dark

" Necessary to make background transparent
set termguicolors
hi! Normal ctermbg=NONE guibg=None
hi! NonText ctermbg=NONE guibg=None

" autocompletion
set completeopt=menu,menuone,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Use lua config
lua require("init")

" Stops things breaking
set nocompatible

"Allow switching from an unsaved buffer
set hidden
"
" dont wrap text
set nowrap

" Set runtime path and (vim)rc path
let $RTP=split(&runtimepath, ',')[0]
" let $RC="$HOME/.config/nvim/init.vim"

" No swap files
set noswapfile

" Backup
set backupdir=~/.cache/nvim/backups

" Line numbering
set number
set relativenumber

" Search highlighting
set hlsearch

" Remove whitespace
autocmd BufWritePre * :%s/\s\+$//e

" foratting
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=0

" Display all matching files when we tab complete
set wildmenu

" Typewriter mode
set scrolloff=999

" Easy switching between panes
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Some easier commands for saving and reloading vimrc
nnoremap <leader>w <cmd>w<CR>
nnoremap <leader>q <cmd>wq<CR>
nnoremap <leader>r :so ~/.config/nvim/init.vim<CR>
" Open Netrw
nnoremap <leader>x <cmd>Ex<CR>

" Bar marking column 80
set colorcolumn=80

" Plug remaps
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>pu :PlugUpdate<CR>

" Create a tags file (need to install ctags first)
command! MakeTags !ctags -R ./*

" Tweaks for file browsing
let g:netrw_banner=0
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_liststyle = 3
let g:netrw_localrmdir='rm -r'
" let g:netrw_keepdir= let g:AutoPairsShortcutToggle = <>

" Use system clipboard
set clipboard=unnamed

" Enable folding
set foldmethod=indent
set foldlevel=99
" nnoremap <space> za

" Bad whitespace highlighting
highlight badWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0
match BadWhitespace /\s\+$/ |

" utf-8 encoding
set encoding=utf-8

" Moving between buffers
nnoremap ]b <cmd>bnext<cr>
nnoremap [b <cmd>bprev<cr>
nnoremap <leader>bw <cmd>bw<cr>

" Working with nim
let g:nim_highlight_wait = v:true


" vim-airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#branch#enabled = 1
let g:airline_theme='murmur'

" ALE config
let g:ale_linters={
\   'python': ['pylint'],
\   'yaml.cloudformation': ['cfn-lint'],
\ }
let g:ale_fixers = {
\   'nim': ['nimpretty'],
\   'python': ['black'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier']
\}
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_fix_on_save = 1

" vim-test
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>tt :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

" Dadbod config
nnoremap <leader>db :DBUIToggle<CR>
nnoremap <leader>dp :% DB postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST/$POSTGRES_DATABASE<CR>
nnoremap <leader>dy :% DB mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE<CR>

" " syntastic config
" set statusline+=%#warningmsg#
" set statusline+=%*

""" Black config
" Run black automatically on save
" autocmd! BufWritePre *.py execute ':Black'
" let g:black_linelength=79

" Quickfix config
function! QuickFix_toggle()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor
    copen
endfunction
nnoremap <silent> coq :call QuickFix_toggle()<cr>

" Load all plugins now.
" " Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" " Load all of the helptags now, after plugins have been loaded.
" " All messages and errors will be ignored.
silent! helptags ALL
