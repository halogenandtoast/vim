" Vundle Setup
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Bundles
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'greplace.vim'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-bundler.git'
Plugin 'tpope/vim-git.git'
Plugin 'tpope/vim-endwise.git'
Plugin 'tpope/vim-dispatch.git'
Plugin 'tpope/vim-rake.git'
Plugin 'tpope/vim-surround.git'
Plugin 'othree/html5.vim.git'
Plugin 'kchmck/vim-coffee-script.git'
Plugin 'tComment'
Plugin 'godlygeek/tabular.git'
Plugin 'itchyny/lightline.vim'
Plugin 'OmniCppComplete'
Plugin 'pangloss/vim-javascript.git'
Plugin 'stjernstrom/vim-ruby-run.git'
Plugin 'rking/ag.vim'
Plugin 'nono/vim-handlebars.git'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kien/ctrlp.vim.git'
Plugin 'flazz/vim-colorschemes'
Plugin 'othree/yajs.vim'

call vundle#end()
filetype plugin indent on

" Syntax
syntax enable

" Completion
set completeopt=longest,menuone

" Tell vim to shut up
set visualbell

" Status bar
set laststatus=2

" Tabs
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Line numbers
set number
set numberwidth=5

" Color Scheme
set t_Co=256
colorscheme molokai

" Search Options
set incsearch

" Splits
set splitbelow
set splitright

" Trailing Whitespace
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set list
nmap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
autocmd FileType ruby autocmd BufWritePre * %s/\s\+$//e
autocmd FileType ruby autocmd BufWritePre * %s/\n\n\+$//e

" Leaders
nmap <leader>r :!ruby %<CR>
nmap <leader>c :%s/^\s*#.*$//g<CR>:%s/\(\n\)\n\+/\1/g<CR>:nohl<CR>gg
nmap <leader>V :tabe ~/.vimrc<CR>
nmap <leader>h :%s/:\(\w\+\) =>/\1:/gc<CR>
nmap <leader>R :so ~/.vimrc<CR>

" Cursor
set cursorline

" Matching
runtime macros/matchit.vim
set showmatch
set mat=5

" File messages and options
set shortmess=atI
set wildmode=list:longest
set wildignore=*.o,*.obj,*~,*.swp

" Swap files
set noswapfile
set nobackup
set nowb

" Persisted undo
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" Gvim options
if has("gui_running")
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
  set guioptions-=L
  set guioptions-=t

  set mousehide
  set guifont=Inconsolata\ for\ Powerline:h12
endif
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis

" Faster escape
set noesckeys

" Incomplete Commands
set showcmd

" experimental tabbar

function! MyTabLine()
  hi TabLineFill term=bold cterm=bold ctermbg=236
  hi TabLine term=bold cterm=bold ctermbg=240 ctermfg=231
  hi TabLineSel term=bold cterm=bold ctermbg=148 ctermfg=22
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(buflist[winnr - 1]), ":t")
endfunction

set tabline=%!MyTabLine()
set showtabline=2

" Crazy Land

" Merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  split
  execute "buffer " . bufferName
endfunction

nmap <C-W>u :call MergeTabs()<CR>

" More useful k and j
nmap k gk
nmap j gj

" Don't add the comment prefix when I hit enter or o/O on a comment line.
au FileType * set fo-=c fo-=r fo-=o

" Rename file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
map <leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>

" Indent
map <leader>i mmgg=G`m<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab Completion
inoremap <TAB> <C-n>

set complete=.,w,t
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Saving directories
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
let g:rspec_command = "Dispatch rspec {spec}"

" use OS clipboard
set clipboard=unnamed

" I see you trolling
set bs=

" Powerlined
set noshowmode

" Open to linenumber
function! OpenToLineNumber()
  let filename=expand("%")
  let parts=split(filename, ":")
  exec ":e " . parts[0]
  exec ":" . parts[1]
  redraw!
endfunction
autocmd BufEnter,BufRead *:* nested call OpenToLineNumber()

" Resize splits when the window is resized
autocmd VimResized * exe "normal! \<c-w>="

" Help System Speedups
autocmd filetype help nnoremap <buffer><cr> <c-]>
autocmd filetype help nnoremap <buffer><bs> <c-T>
autocmd filetype help nnoremap <buffer>q :q<CR>
autocmd filetype help set nonumber

" NetRW
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_keepdir = 1

" Local vimrc - for when my decisions aren't good enough
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" set shell
set shell=$SHELL

" Project specific vimrc
set exrc
set secure
