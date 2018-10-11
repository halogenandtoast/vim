let g:haskellmode_completion_ghc = 1
augroup HaskellOmni
  autocmd!
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup end

setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

map <Leader>T :SyntasticToggleMode<CR>

noremap t :GhcModType<CR>
noremap T :GhcModTypeClear<CR>

setlocal statusline+=%#warningmsg#

setlocal statusline+=%{SyntasticStatuslineFlag()}
setlocal statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif
