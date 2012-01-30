filetype plugin on
syntax on
color zenburn
set t_Co=256
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

" Some options for plugins
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_CWInsert = 1
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|class)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|(^|[/\\])build($|[/\\])'

" Auto source .vimrc on save
" if has("autocmd")
"     autocmd BufWritePost .vimrc source $MYVIMRC
" endif

" Start NERDTree on startup
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

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
if has("gui_running")
    nnoremap <c-tab> :bn<CR>
else
    nnoremap <esc>[27;5;9~ :bn<CR>
endif
nnoremap <C-q> :Bclose<CR>

" Some window remapping
nnoremap <esc>[1;3C <C-w>l
nnoremap <esc>[1;3D <C-w>h
nnoremap <esc>[1;3A <C-w>k
nnoremap <esc>[1;3B <C-w>j
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
