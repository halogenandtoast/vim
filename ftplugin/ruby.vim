" Trailing white space
augroup RubyWhitespace
  autocmd!
  autocmd FileType ruby autocmd BufWritePre * %s/\s\+$//e
  autocmd FileType ruby autocmd BufWritePre * %s/\n\n\+$//e
augroup end

" Leaders
nmap <buffer> <localleader>r :!ruby %<CR>
nmap <buffer> <localleader>c :%s/^\s*#.*\n//g<CR>:%s/\(\n\n\)\n\+/\1/g<CR>:nohl<CR>gg
nmap <buffer> <localleader>h :%s/:\(\w\+\) =>/\1:/gc<CR>

" vim-rspec mappings
map <buffer> <localleader>t :call RunCurrentSpecFile()<CR>
map <buffer> <localleader>S :call RunNearestSpec()<CR>
map <buffer> <localleader>l :call RunLastSpec()<CR>
map <buffer> <localleader>a :call RunAllSpecs()<CR>
let g:rspec_command = "Dispatch rspec {spec}"
