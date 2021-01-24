""" Python configuration
setlocal path=src/**,test/**
setlocal wildignore=*.pyc,*/__pycache__/*

" Basic formatting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set fileformat=unix

" Abbreviations
iabbrev <buffer> im import

""" custom commands
" augroup pycmd
"     autocmd!
"     autocmd nnoremap <buffer> <cr> :silent w<bar>only<bar>sp<bar>term ipython -i %<cr>
" augroup end


" virtual environment support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
	project_dir = os.environ['VIRTUAL_ENV']
	activate_this = os.path.join(project_dir, 'bin/activate_this.py')
	exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF

" Search for all imported modules
" set include=^\\s*\\(from\\\|import\\)\\s*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)
" function! PyInclude(fname)
"     let parts = split(a:fname, ' import ')
"     let l = parts[0]
"     if len(parts) > 1
"         let r = parts[1]
"         let joined = join([l, r], '.')
"         let fp = substitute(joined, '\.', '/', 'g') . '.py'
"         let found = glob(fp, 1)
"         if len(found)
"             return found
"         endif
"     endif
"     return substitute(joined, '\.', '/', 'g') . '.py'
" setlocal includeexpr=PyInclude(v:fname)
" endfunction


