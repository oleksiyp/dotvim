if has("gui_running")
    set guioptions-=L
    set macmeta

    " Some meta mappings
    nnoremap <M-Right> :call WinMoveRight()<CR>
    nnoremap <M-l> :call WinMoveRight()<CR>
    nnoremap <M-Left> :call WinMoveLeft()<CR>
    nnoremap <M-h> :call WinMoveLeft()<CR>
    nnoremap <M-Up> :call WinMoveUp()<CR>
    nnoremap <M-k> :call WinMoveUp()<CR>
    nnoremap <M-Down> :call WinMoveDown()<CR>
    nnoremap <M-j> :call WinMoveDown()<CR>
    nnoremap <M-S-Right> :call WinSwapRight()<CR>
    nnoremap <M-S-l> :call WinSwapRight()<CR>
    nnoremap <M-S-Left> :call WinSwapLeft()<CR>
    nnoremap <M-S-h> :call WinSwapLeft()<CR>
    nnoremap <M-S-Up> :call WinSwapUp()<CR>
    nnoremap <M-S-k> :call WinSwapUp()<CR>
    nnoremap <M-S-Down> :call WinSwapDown()<CR>
    nnoremap <M-S-j> :call WinSwapDown()<CR>

    " Some window remapping
    nnoremap <C-S-Left> <C-w>5>
    nnoremap <C-S-Right> <C-w>5<
    nnoremap <C-S-Up> <C-w>-
    nnoremap <C-S-Down> <C-w>+

endif
