" Plugins
set nocompatible
filetype off
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'skwp/greplace.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-git'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-surround'
Plug 'othree/html5.vim'
Plug 'tomtom/tcomment_vim'
Plug 'itchyny/lightline.vim'
Plug 'vim-scripts/OmniCppComplete'
Plug 'pangloss/vim-javascript'
Plug 'stjernstrom/vim-ruby-run'
Plug 'rking/ag.vim'
Plug 'nono/vim-handlebars'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kien/ctrlp.vim'
Plug 'flazz/vim-colorschemes'
Plug 'othree/yajs.vim'
Plug 'janko-m/vim-test'

if filereadable(expand("~/.vimrc.plugins.local"))
  source ~/.vimrc.plugins.local
endif

call plug#end()
filetype plugin indent on

" Syntax
syntax enable

" Completion
set completeopt=longest,menuone

" Tell vim to shut up
set visualbell
set vb t_vb=

" Status bar
set laststatus=2

" Tabs
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Line numbers
set number
set numberwidth=5

" Search Options
set incsearch

" Splits
set splitbelow
set splitright

" Trailing Whitespace
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set list
nmap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Leaders
let maplocalleader = " "
nmap <Leader>V :tabe ~/.vimrc<CR>
nmap <Leader>R :so ~/.vimrc<CR>

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

  set background=dark
  set mousehide
  set guifont=SourceCodePro:h12

  colorscheme triplejelly
else
  " Color Scheme
  set t_Co=256
  colorscheme triplejelly
  " Transparent background
  hi Normal guibg=NONE ctermbg=NONE
endif

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
map <Leader>n :call RenameFile()<cr>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>

" Indent
map <Leader>i mmgg=G`m<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab Completion
set complete=.,w,t

" Saving directories
function! s:MkNonExDir(file, buf)
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
autocmd BufNewFile,BufEnter,BufRead *:* nested call OpenToLineNumber()

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

" CTRLP
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
" let g:ctrlp_user_command = {
"       \ 'types': {
"       \ 1: ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'],
"       \ },
"       \ 'fallback': 'find %s -type f'
"       \ }

" Local vimrc - for when my decisions aren't good enough
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" set shell
set shell=$SHELL

" Project specific vimrc
set exrc
set secure

" Handle pasted text
nnoremap gp `[v`]

" Vim test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

let test#strategy = "vimterminal"
