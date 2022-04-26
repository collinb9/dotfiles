augroup filetypedetect
    au! BufRead,BufNewFile *.yaml  if getline(1)=~ '^AWSTemplateFormatVersion.*' | set filetype=yaml.cloudformation | else | set filetype=yaml | endif
    au! BufRead,BufNewFile *.yml  if getline(1)=~ '^AWSTemplateFormatVersion.*' | set filetype=yaml.cloudformation | else | set filetype=yaml | endif
augroup END

augroup markdown
    autocmd!
    :autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END
