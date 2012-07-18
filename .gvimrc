if has("gui_running")
    set guioptions-=L
    set guioptions-=T

    if has('gui_macvim')
        set macmeta
    endif

    " Some meta mappings
    nnoremap <silent> <M-Right> :call WinMoveRight()<CR>
    nnoremap <silent> <M-l> :call WinMoveRight()<CR>
    nnoremap <silent> <M-Left> :call WinMoveLeft()<CR>
    nnoremap <silent> <M-h> :call WinMoveLeft()<CR>
    nnoremap <silent> <M-Up> :call WinMoveUp()<CR>
    nnoremap <silent> <M-k> :call WinMoveUp()<CR>
    nnoremap <silent> <M-Down> :call WinMoveDown()<CR>
    nnoremap <silent> <M-j> :call WinMoveDown()<CR>
    nnoremap <silent> <M-S-Right> :call WinSwapRight()<CR>
    nnoremap <silent> <M-S-l> :call WinSwapRight()<CR>
    nnoremap <silent> <M-S-Left> :call WinSwapLeft()<CR>
    nnoremap <silent> <M-S-h> :call WinSwapLeft()<CR>
    nnoremap <silent> <M-S-Up> :call WinSwapUp()<CR>
    nnoremap <silent> <M-S-k> :call WinSwapUp()<CR>
    nnoremap <silent> <M-S-Down> :call WinSwapDown()<CR>
    nnoremap <silent> <M-S-j> :call WinSwapDown()<CR>

    " Some window remapping
    nnoremap <C-S-Left> <C-w>5>
    nnoremap <C-S-Right> <C-w>5<
    nnoremap <C-S-Up> <C-w>-
    nnoremap <C-S-Down> <C-w>+

endif
