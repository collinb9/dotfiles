augroup filetypedetect
    " Enhanced CloudFormation detection for YAML files
    " Check first 10 lines for AWSTemplateFormatVersion or AWS::Serverless transform
    au! BufRead,BufNewFile *.yaml  call s:DetectCloudFormation('yaml')
    au! BufRead,BufNewFile *.yml   call s:DetectCloudFormation('yaml')

    " JSON CloudFormation detection
    " Check first 5 lines for CloudFormation indicators in JSON
    au! BufRead,BufNewFile *.json  call s:DetectCloudFormation('json')

    " Direct CloudFormation file extensions
    au! BufRead,BufNewFile *.template set filetype=yaml.cloudformation
    au! BufRead,BufNewFile *.cfn      set filetype=yaml.cloudformation
    au! BufRead,BufNewFile *.cf       set filetype=yaml.cloudformation
augroup END

" Function to detect CloudFormation templates
function! s:DetectCloudFormation(base_type)
    let lines = getline(1, 10)
    let content = join(lines, ' ')

    " Check for CloudFormation indicators
    if content =~? 'AWSTemplateFormatVersion\|AWS::Serverless\|Transform.*AWS::Serverless'
        execute 'set filetype=' . a:base_type . '.cloudformation'
    else
        execute 'set filetype=' . a:base_type
    endif
endfunction

augroup markdown
    autocmd!
    :autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END
