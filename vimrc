" Vundle Setup
set nocompatible
filetype off
set rtp+=~/.vim/vundle.git
call vundle#rc()

" Bundles
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'greplace.vim'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-cucumber.git'
Bundle 'tpope/vim-bundler.git'
Bundle 'tpope/vim-git.git'
Bundle 'tpope/vim-endwise.git'
Bundle 'tpope/vim-rake.git'
Bundle 'tpope/vim-surround.git'
Bundle 'altercation/vim-colors-solarized.git'
Bundle 'othree/html5.vim.git'
Bundle 'kchmck/vim-coffee-script.git'
Bundle 'tComment'
Bundle 'scrooloose/nerdtree'
Bundle 'godlygeek/tabular.git'
Bundle 'Lokaltog/vim-powerline.git'
Bundle 'glsl.vim'
Bundle 'python.vim'
Bundle 'OmniCppComplete'
Bundle 'pangloss/vim-javascript.git'
Bundle 'stjernstrom/vim-ruby-run.git'
Bundle 'jayferd/ragel.vim'
Bundle 'derekwyatt/vim-scala.git'

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
set background=light
colorscheme solarized
call togglebg#map("<F6>")

" Search Options
set hlsearch
set incsearch

" Splits
set splitbelow
set splitright

" Grep
set grepprg=ack

" Trailing Whitespace
set listchars=tab:>\ ,trail:•,extends:>,precedes:<,nbsp:+
set list
nmap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Cursor
set cursorline

" Matching
runtime macros/matchit.vim
set showmatch
set mat=5
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

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
  set guifont=Inconsolata\ for\ Powerline:h14
endif
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis

" Line 80
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" powerline

" experimental tabbar


function MyTabLine()
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

function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(buflist[winnr - 1]), ":t")
endfunction

set tabline=%!MyTabLine()
set showtabline=2
