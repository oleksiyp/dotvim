if has("gui_running")
    set guioptions-=L
    set macmeta

    " Some meta mappings
    nnoremap <M-Right> <C-w>l
    nnoremap <M-Left> <C-w>h
    nnoremap <M-Up> <C-w>k
    nnoremap <M-Down> <C-w>j

    " Some window remapping
    nnoremap <C-S-Left> <C-w>5>
    nnoremap <C-S-Right> <C-w>5<
    nnoremap <C-S-Up> <C-w>-
    nnoremap <C-S-Down> <C-w>+

endif
