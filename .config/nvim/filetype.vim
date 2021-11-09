augroup filetypedetect
    au! BufRead,BufNewFile *.yaml  if getline(1)=~ '^AWSTemplateFormatVersion.*' | set filetype=yaml.cloudformation | else | set filetype=yaml | endif
    au! BufRead,BufNewFile *.yml  if getline(1)=~ '^AWSTemplateFormatVersion.*' | set filetype=yaml.cloudformation | else | set filetype=yaml | endif
augroup END
