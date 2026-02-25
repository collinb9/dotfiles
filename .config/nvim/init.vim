" Use lua config
lua require("init")

set clipboard=unnamed

" Bad whitespace highlighting
highlight badWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0
match BadWhitespace /\s\+$/ |

" Dadbod config
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

