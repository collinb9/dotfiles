""""""""""""" vim-plug

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
" airblade/vim-gitgutter
" dense-analysis/ale
" ervandew/supertab
" honza/vim-snippets
" ivanov/vim-ipython
" michaeljsmith/vim-indent-object
" psf/black
" skywind3000/asyncrun.vim
" talek/obvious-resize
" tommcdo/vim-exchange
" tpope/vim-fugitive
" tpope/vim-abolish
" tpope/vim-speeddating
" tpope/vim-unimpaired
" tpope/vim-vinegar
" vim-airline/vim-airline
" vim-airline/vim-airline-themes
" vim-test/vim-test
" Sirver/ultisnips
" honza/vim-snippets
" junegunn/fzf

" " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
"  Tpope stuff
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'

" general text editing improvements
Plug 'jiangmiao/auto-pairs'
Plug 'wellle/targets.vim'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" language servers and autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'nvim-telescope/telescope.nvim'
" Plug 'junegunn/vim-easy-align'
" 
" " Any valid git URL is allowed
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" 
" " Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" 
" " On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" 
" " Using a non-default branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
" 
" " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }
" 
" " Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
" 
" " Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" 
" " Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'
" 
" Initialize plugin system
call plug#end()

" Use lua config
" lua require("lua.config")

" Stops things breaking
set nocompatible

"Allow switching from an unsaved buffer
set hidden

" Set runtime path and (vim)rc path
let $RTP=split(&runtimepath, ',')[0]
" let $RC="$HOME/.config/nvim/init.vim"

" No swap files
 set noswapfile

" Line numbering
set number
set relativenumber

" Search highlighting
set hlsearch

" foratting
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=0

" Colour scheme
" let g:hybrid_custom_term_colors = 1
set t_Co=256
set background=dark
" colorscheme molokai

" Search for files anywhere lower in the file tree using fuzzy matching
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Easy switching between panes
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" " fzf mappings
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

" Create a tags file (need to install ctags first)
command! MakeTags !ctags -R ./*

" Tweaks for file browsing
let g:netrw_banner=0		" disable banner
let g:netrw_list_hide=netrw_gitignore#Hide()

" Use system clipboard
set clipboard=unnamed

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Bad whitespace highlighting
highlight badWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0
match BadWhitespace /\s\+$/ | 

" utf-8 encoding
set encoding=utf-8

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

""" obvious-resize config
noremap <silent> <ESC>k :ObviousResizeUp<CR>
noremap <silent> <ESC>j :ObviousResizeDown<CR>
noremap <silent> <ESC>h :ObviousResizeLeft<CR>
noremap <silent> <ESC>l :ObviousResizeRight<CR>

""" vim-airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='murmur'

""" ALE config
let g:ale_linters={'python': ['pylint']}
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

""" YCM config

" make YCM compatible with UltiSnips (using supertab)
" noremap <C-@> <C-Space>
" set rtp+="$HOME/.vim/pack/ycm-core/start/YouCompleteMe"
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:ycm_filetype_whitelist = {"python":1,}
" let g:ycm_auto_trigger = 1
" let g:ycm_min_num_of_chars_for_completion = 2
" let g:ycm_log_level = 'debug'
" let g:SuperTabDefaultCompletionType = '<C-n>'

""" asyncomplete config
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"
imap <C-space> <Plug>(asyncomplete_force_refresh)
let g:asyncomplete_auto_popup = 1

""" syntastic config
set statusline+=%#warningmsg#
set statusline+=%*

""" Black config
" Run black automatically on save
autocmd! BufWritePre *.py execute ':Black'
let g:black_linelength=79

""" asyncrun config
let g:asyncrun_open=8

" vim-test config
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let test#strategy="asyncrun"

" WSL yank support
" let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path
" if executable(s:clip)
"     augroup WSLYank
" 			autocmd!
" 			autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
" 		augroup END
" endif

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
