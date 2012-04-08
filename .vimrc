set nocompatible
filetype plugin indent on
syntax on
set t_Co=256
color zenburn

set backspace=indent,eol,start
set nu
set hidden
set title
set ruler
set showmatch
set expandtab
set showcmd
set whichwrap+=<,>,h,l
set hlsearch
set ignorecase
set smartcase
set incsearch
set smartindent
set cursorline
set softtabstop=4
set shiftwidth=4
set wildmenu
set statusline=\ %f\ %#Keyword#%m%r%h%w%*\ (%l/%L,\ %c)\ %P%=\ %y\ [%{&encoding}:%{&fileformat}]\ \ 
set laststatus=2

" Some options for plugins
let g:smartusline_hi_replace = 'guibg=#d6aefe guifg=black ctermbg=183 ctermfg=black'
let g:smartusline_hi_insert = 'guibg=#afd7ff guifg=black ctermbg=153 ctermfg=black'
let g:smartusline_hi_virtual_replace = 'guibg=#d6aefe guifg=black ctermbg=183 ctermfg=black'
let g:smartusline_hi_normal = 'guibg=#f0dfaf guifg=black ctermbg=223 ctermfg=black'
let g:smartusline_string_to_highlight = ' %f '
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_CWInsert = 1
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|class)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|(^|[/\\])build($|[/\\])'
let g:viewdoc_open = "topleft new"
let g:no_viewdoc_abbrev = 1

" Java Related settings
au FileType java syntax keyword Keyword package import public protected private abstract class interface extends implements static final volatile synchronized | syntax keyword Type Integer Short Byte Float Double Char Boolean Long String | match Type /^import\s\+.*\.\zs.*\ze;/

" Erlang Related settings
let erlang_folding = 1
au FileType erlang setlocal foldenable foldopen=all foldclose=all

" XML Related settings
au FileType xml setlocal sw=2 sts=2

" Auto source .vimrc on save
" if has("autocmd")
"     autocmd BufWritePost .vimrc source $MYVIMRC
" endif

" Start NERDTree on startup
" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p

" Shell
function! s:ExecuteInShell(command)
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    if winnr < 0
        execute &lines/3 . 'sp ' . fnameescape(command)
    else
        execute winnr . 'wincmd w'
    endif
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    if line('$') < &lines/3 && (line('$')-(&lines/3)+1) < 0
        silent! execute 'resize '. (line('$')-(&lines/3)+1)
    endif
    normal G
    silent! redraw
    echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

" Ant
command! -nargs=+ Ant Shell ant <args>

" Maven
command! -complete=customlist,ListMavenCompletions -nargs=+ Maven call ShellMvn(<q-args>)
command! -complete=customlist,ListMavenCompletions -nargs=+ Mvn call ShellMvn(<q-args>)
fun! ShellMvn(command)
    if a:command =~ '^archetype:generate'
        execute '!mvn '.a:command  
    else
        call s:ExecuteInShell('mvn '.a:command) 
    endif
endfun
fun! ListMavenCompletions(A,L,P)
    let mavengoals = ['compile','package','validate','test','deploy','site','clean','install','archetype:generate'] 
    return filter(mavengoals,"v:val =~ \'^".a:A."\'") 
endfun

" Save file on <C-s>
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>

" Next search occurence in search mode
cmap <c-n> <CR>n/<c-p>

" pbpaste and pbcopy
command! Pbpaste :execute 'let @r = system("ssh mini pbpaste")'
command! Pbcopy :execute 'call system("ssh mini pbcopy",@r)'

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
    if tdiff <= 0.25 && bufname('%') != '[BufExplorer]'
        :BufExplorer
    else
        let n = bufnr('%')
        :bn
        while n != bufnr('%') && getbufvar('%','&buftype') == 'nofile'
            :bn
        endwhile
    endif
endfunction

if has("gui_running")
    nnoremap <silent> <c-tab> :call SwitchBuf()<CR>
else
    nnoremap <silent> <esc>[27;5;9~ :call SwitchBuf()<CR>
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

function! WinSwapUp()
    let b = bufname('%') 
    let w = winnr()
    :wincmd k
    if w == winnr()
        :wincmd j
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

function! WinMoveDown()
    let w = winnr()
    :wincmd j
    if w == winnr()
        :wincmd k
    endif
endfunction

function! WinSwapDown()
    let b = bufname('%') 
    let w = winnr()
    :wincmd j
    if w == winnr()
        :wincmd k
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

function! WinMoveRight()
    let w = winnr()
    :wincmd l
    if w == winnr()
        :wincmd h
    endif
endfunction

function! WinSwapRight()
    let b = bufname('%') 
    let w = winnr()
    :wincmd l
    if w == winnr()
        :wincmd h
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

function! WinMoveLeft()
    let w = winnr()
    :wincmd h
    if w == winnr()
        :wincmd l
    endif
endfunction

function! WinSwapLeft()
    let b = bufname('%') 
    let w = winnr()
    :wincmd h
    if w == winnr()
        :wincmd l
    endif
    let w2 = winnr()
    if w != w2
        let b2 = bufname('%')
        execute w . "wincmd w"
        execute "b " . b2
        execute w2 . "wincmd w"
        execute "b " . b
    endif
endfunction

nnoremap <silent> <esc>[1;3C :call WinMoveRight()<CR>
nnoremap <silent> <esc>l :call WinMoveRight()<CR>
nnoremap <silent> <esc>[1;3D :call WinMoveLeft()<CR>
nnoremap <silent> <esc>h :call WinMoveLeft()<CR>
nnoremap <silent> <esc>[1;3A :call WinMoveUp()<CR>
nnoremap <silent> <esc>k :call WinMoveUp()<CR>
nnoremap <silent> <esc>[1;3B :call WinMoveDown()<CR>
nnoremap <silent> <esc>j :call WinMoveDown()<CR>
nnoremap <silent> <esc>[1;10C :call WinSwapRight()<CR>
nnoremap <silent> <esc>L :call WinSwapRight()<CR>
nnoremap <silent> <esc>[1;10D :call WinSwapLeft()<CR>
nnoremap <silent> <esc>H :call WinSwapLeft()<CR>
nnoremap <silent> <esc>[1;10A :call WinSwapUp()<CR>
nnoremap <silent> <esc>K :call WinSwapUp()<CR>
nnoremap <silent> <esc>[1;10B :call WinSwapDown()<CR>
nnoremap <silent> <esc>J :call WinSwapDown()<CR>
nnoremap <silent> <esc>[1;6C <C-w>5<
nnoremap <silent> <esc>[1;6D <C-w>5>
nnoremap <silent> <esc>[1;6A <C-w>5-
nnoremap <silent> <esc>[1;6B <C-w>5+

" Some emacs inspired keymappings
nnoremap <C-x>x <C-w>q
nnoremap <C-x>c :qa<CR>
nnoremap <C-x>\| <C-w>v
nnoremap <C-x>- <C-w>s

" Term command for starting bash
command! Term ConqueTerm bash

" Invisible characters
set listchars=tab:▸\ ,eol:¬
