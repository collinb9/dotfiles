" Use lua config
lua require("init")

"" Easy switching between panes
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-h> <C-w>h
"nnoremap <C-l> <C-w>l
"

set clipboard=unnamed



"" let g:clipboard = {
"   \   'name': 'myClipboard',
"   \   'copy': {
"   \      '+': ['tmux', 'load-buffer', '-'],
"   \      '*': ['tmux', 'load-buffer', '-'],
"   \    },
"   \   'paste': {
"   \      '+': ['tmux', 'save-buffer', '-'],
"   \      '*': ['tmux', 'save-buffer', '-'],
"   \   },
"   \   'cache_enabled': 1,
"   \ }

"" Bad whitespace highlighting
highlight badWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0
match BadWhitespace /\s\+$/ |

"" ALE config
"let g:ale_linters={
"\   'python': ['pylint'],
"\   'yaml.cloudformation': ['cfn-lint'],
"\ }
"let g:ale_fixers = {
"\   'nim': ['nimpretty'],
"\   'python': ['black'],
"\   'typescript': ['prettier'],
"\   'typescriptreact': ['prettier']
"\}
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
"let g:ale_fix_on_save = 1

"" Dadbod config
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

