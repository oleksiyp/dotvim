filetype plugin on
syntax on
set t_Co=256
color zenburn
set nocompatible
set backspace=indent,eol,start
set nu
set hidden
set title
set ruler
set showmatch
set expandtab
set showcmd
set whichwrap+=<,>
set hlsearch
set smartindent
set cursorline
set softtabstop=4
set shiftwidth=4
set wildmenu

" Some options for plugins
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_CWInsert = 1
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|class)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|(^|[/\\])build($|[/\\])'
let g:viewdoc_open = "topleft new"
let g:no_viewdoc_abbrev = 1

" Auto source .vimrc on save
" if has("autocmd")
"     autocmd BufWritePost .vimrc source $MYVIMRC
" endif

" Start NERDTree on startup
" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p

" Save file on <C-s>
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>

" FuzzyFinder keybindings 
function! OpenFile()
    if stridx(bufname("%"),"NERD_tree") >= 0
        if winnr("$") == 1
           execute &columns/9 . 'vs'
        endif
        :wincmd w 
    endif
    :FufFile
endfunction
noremap <silent> <C-f> :call OpenFile()<CR>
function! OpenBuffer()
    if stridx(bufname("%"),"NERD_tree") >= 0
        if winnr("$") == 1
           execute &columns/9 . 'vs'
        endif
        :wincmd w 
    endif
    :FufBuffer
endfunction
noremap <silent> <C-b> :call OpenBuffer()<CR>

" C-Tab buffer switching
let g:switch_buf_time = reltime() 
function! SwitchTimeDiff(t,nt)
    let t2 = reltimestr(a:nt)
    let t1 = reltimestr(a:t)
    let t2f = str2float(strpart(t2,3,stridx(t2,'.')+2))
    let t1f = str2float(strpart(t1,3,stridx(t1,'.')+2))
    return t2f-t1f 
endfunction

function! SwitchBuf()
    let tdiff = SwitchTimeDiff(g:switch_buf_time,reltime())
    let g:switch_buf_time = reltime()
    if tdiff <= 0.5 && bufname('%') != '[BufExplorer]'
        :BufExplorer
    else
        :bn
    endif
endfunction

if has("gui_running")
    nnoremap <c-tab> :call SwitchBuf()<CR>
else
    nnoremap <esc>[27;5;9~ :call SwitchBuf()<CR>
endif
nnoremap <C-q> :Bclose<CR>

" Some window movement mappings
function! WinMoveUp()
    let w = winnr()
    :wincmd k
    if w == winnr()
        :wincmd j
    endif
endfunction

function! WinMoveDown()
    let w = winnr()
    :wincmd j
    if w == winnr()
        :wincmd k
    endif
endfunction

function! WinMoveRight()
    let w = winnr()
    :wincmd l
    if w == winnr()
        :wincmd h
    endif
endfunction

function! WinMoveLeft()
    let w = winnr()
    :wincmd h
    if w == winnr()
        :wincmd l
    endif
endfunction

nnoremap <esc>[1;3C :call WinMoveRight()<CR>
nnoremap <esc>l :call WinMoveRight()<CR>
nnoremap <esc>[1;3D :call WinMoveLeft()<CR>
nnoremap <esc>h :call WinMoveLeft()<CR>
nnoremap <esc>[1;3A :call WinMoveUp()<CR>
nnoremap <esc>k :call WinMoveUp()<CR>
nnoremap <esc>[1;3B :call WinMoveDown()<CR>
nnoremap <esc>j :call WinMoveDown()<CR>
nnoremap <esc>[1;6C <C-w>5<
nnoremap <esc>[1;6D <C-w>5>
nnoremap <esc>[1;6A <C-w>5-
nnoremap <esc>[1;6B <C-w>5+

" Some emacs inspired keymappings
nnoremap <C-x>x <C-w>q
nnoremap <C-x>c :qa<CR>
nnoremap <C-x>\| <C-w>v
nnoremap <C-x>- <C-w>s

" Term command for starting bash
command! Term ConqueTerm bash

" Invisible characters
set listchars=tab:▸\ ,eol:¬
