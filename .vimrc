set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" Bundles

" original repos on github
Bundle 'mileszs/ack.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/snipmate-snippets'
Bundle 'rson/vim-conque'
Bundle 'molok/vim-smartusline'
Bundle 'ervandew/supertab'
Bundle 'tomtom/tcomment_vim'
Bundle 'majutsushi/tagbar'
Bundle 'vim-scripts/mru.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'oscarh/vimerl'
Bundle 'sjl/vitality.vim'
Bundle 'luizribeiro/javacomplete'
Bundle 'benmills/vimux'
Bundle 'troydm/pb.vim'
Bundle 'tmhedberg/matchit'

" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'bufexplorer.zip'
Bundle 'ZoomWin'
Bundle 'netrw.vim'
Bundle 'Gundo'

filetype plugin indent on
syntax on
set t_Co=256
color zenburn

set encoding=utf-8
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
set timeoutlen=500

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
let g:snippets_dir = '~/.vim/bundle/snipmate-snippets/snippets'
let g:vitality_fix_focus = 0

" Java complete maven addition
let g:mvn_project = ''
let g:mvn_project_pom_ftime = 0
let g:mvn_project_source_path_set = 0
function! MvnInitializeProject()
    if (g:mvn_project != getcwd() || g:mvn_project_pom_ftime != getftime('pom.xml')) && filereadable('pom.xml')
        let g:mvn_project = getcwd()
        let g:mvn_project_pom_ftime = getftime('pom.xml')
        let mvn_classpath = ''
        let mvn_classpath_output = split(system('mvn dependency:build-classpath'),"\n")
        let class_path_next = 0
        for line in mvn_classpath_output
            if class_path_next == 1
                let mvn_classpath = line
                break
            endif
            if match(line,'Dependencies classpath:') >= 0
                let class_path_next = 1
            endif
        endfor
        if mvn_classpath != ''
            call javacomplete#SetClassPath(mvn_classpath)
        endif
        if g:mvn_project_source_path_set == 0
            call javacomplete#AddSourcePath('src/main/java')
            call javacomplete#AddSourcePath('src/test/java')
            let g:mvn_project_source_path_set = 1
        endif
    endif     
endfunction

function! MvnJavaComplete(findstart, base)
    call MvnInitializeProject()
    return javacomplete#Complete(a:findstart, a:base)
endfunction

function! MvnJavaCompleteParamsInfo(findstart, base)
    call MvnInitializeProject()
    return javacomplete#CompleteParamsInfo(a:findstart, a:base)
endfunction

" Java maven compile on save
let g:mvn_compile_on_save_enabled = 0
function! MvnCompileProject()
    if filereadable('pom.xml')
        Maven compile
    endif
endfunction

au BufWritePost *.java if g:mvn_compile_on_save_enabled | silent call MvnCompileProject() | endif
command! MavenCompileOnSaveToggle let g:mvn_compile_on_save_enabled = !g:mvn_compile_on_save_enabled | if g:mvn_compile_on_save_enabled | echo "Maven compile on save enabled" | else | echo "Maven compile on save disabled" | endif

" Java generate property setters and getters
" Operates on ranges and can take two arguments specify what level of visiblity
" we need for methods e.g. (private, protected or public)
" first optional argument is get methods visibility level (public by default)
" second optional argument is set methods visibility level (public by default)
" generated code is saved into current register (v:register)
command! -range -nargs=* JavaGenerateBeanProperties :call JavaGenBeanProps(<line1>,<line2>,<f-args>)
function! JavaGenBeanProps(l1,l2,...)
    let generatedCode = ''
    let getType = 'public'
    let setType = 'public'
    if a:0 > 0
        if strpart(a:1,0,2) == 'pu'
            let getType = 'public'
        endif
        if strpart(a:1,0,2) == 'pr'
            let getType = 'private'
        endif
        if strpart(a:1,0,3) == 'pro'
            let getType = 'protected'
        endif
    endif
    if a:0 > 1
        if strpart(a:2,0,2) == 'pu'
            let setType = 'public'
        endif
        if strpart(a:2,0,2) == 'pr'
            let setType = 'private'
        endif
        if strpart(a:2,0,3) == 'pro'
            let setType = 'protected'
        endif
    endif
    let l = a:l1
    let indlvl = ''
    let indlvlset = 0
    while l <= a:l2
        if indlvlset == 0
            let [__, indlvl; _] = matchlist(getline(l),'\(\s*\)')
            let indlvlset = 1
        endif
        let [__, type, name; _] = matchlist(getline(l),'\([a-zA-Z_]\+\)\s\+\([a-zA-Z_]\+\)\s*\;')
        let cName = toupper(strpart(name,0,1)) . strpart(name,1) 
        let getName = 'get' . cName
        let setName = 'set' . cName
        if type == 'boolean'
            let getName = 'is' . cName
        endif
        " generating getter
        let generatedCode .= indlvl . getType . ' ' . type . ' ' . getName . "(){\n"
        let generatedCode .= indlvl . '    return this.' . name .";\n" .indlvl. "}\n\n"
        " generating setter
        let generatedCode .= indlvl . setType . ' void ' . setName . '(' . type . ' ' . name . "){\n"
        let generatedCode .= indlvl . '    this.' . name .' = ' . name . ";\n" .indlvl. "}\n\n"
        let l += 1
    endwhile
    :call setreg(v:register,generatedCode)
endfunction

" Java package name command
let g:java_package_name_search_dir_limit = 5
let g:java_package_name_read_limit = 100
command! JavaPackageName :exe 'normal ggOpackage '.GetJavaPackageName().';<esc>B'
function! GetJavaPackageName()
    let curdir = expand('%:h:p')
    let suffix_p = ''
    let p = g:java_package_name_search_dir_limit 
    while p > 0
       let pn = GetJavaPackageNameDir(curdir) 
       if pn != '' 
           return pn . suffix_p 
       else
           let suffix_p = '.' . fnamemodify(curdir,':t') . suffix_p
           let curdir = fnamemodify(curdir,':h')
       endif
       let p -= 1
    endwhile
endfunction
function! GetJavaPackageNameDir(dir)
    for j in split(globpath(a:dir,'*.java'),"\n")
        for line in readfile(j, '', g:java_package_name_read_limit)
            let p = matchlist(line,'package\s\+\([a-zA-Z.]*\)\s*;')
            if !empty(p) | return p[1] | endif
        endfor
    endfor
    return ''
endfunction

" Java Related settings
au FileType java syntax keyword Keyword package import public protected private abstract class interface extends implements static final volatile synchronized try catch finally throws | syntax keyword Type Integer Short Byte Float Double Char Boolean Long String | match Type /^import\s\+.*\.\zs.*\ze;/
au BufRead,BufNewFile *.jar,*.war,*.ear,*.sar,*.rar set filetype=zip
au FileType java setlocal foldmethod=syntax foldclose=all foldlevel=1 foldcolumn=1 foldenable foldopen=all omnifunc=MvnJavaComplete completefunc=MvnJavaCompleteParamsInfo
au FileType java nnoremap <buffer> [[ ?{\s*$<CR>^:nohlsearch<CR>:echo 'prev {'<CR>
au FileType java nnoremap <buffer> ][ ?}\s*$<CR>^:nohlsearch<CR>:echo 'prev }'<CR>
au FileType java nnoremap <buffer> ]] $/{\s*$<CR>^:nohlsearch<CR>:echo 'next {'<CR>
au FileType java nnoremap <buffer> [] $/}\s*$<CR>^:nohlsearch<CR>:echo 'next }'<CR>

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
command! -complete=customlist,ListAntCompletions -nargs=* Ant Shell ant <args>
fun! ListAntCompletions(A,L,P)
    let antgoals = [] 
    let anttargets = split(system('ant -p'),'\n')
    let i = -1
    for l in anttargets
        if i >= 0 && strlen(l) > 0
            if strpart(l,0,1) == ' ' && strpart(l,0,2) != ' -'
                let antgoals = add(antgoals,strpart(l,1,stridx(l,' ',1)))
            endif
            let i += 1
            if strpart(l,0,1) != ' '
                let i = -1
            endif
        endif
        if l == 'Main targets:'
            let i = 0
        endif 
    endfor
    return filter(antgoals,"v:val =~ \'^".a:A."\'") 
endfun

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

" PbYank and PbPaste
let g:pb_command_prefix = 'ssh mini '

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

" Visual tab mapping
vmap <Tab> >gv
vmap <S-Tab> <gv

" Some emacs inspired keymappings
nnoremap <C-x>x <C-w>q
nnoremap <C-x>c :qa<CR>
nnoremap <C-x>\| <C-w>v
nnoremap <C-x>- <C-w>s

" Term command for starting bash
command! Term if GetTermBufnr() != -1 | exe ':b'.GetTermBufnr().' | :startinsert' | else | exe ':ConqueTerm bash' | endif
command! TermNew ConqueTerm bash
function! GetTermBufnr()
    for i in range(1, bufnr('$'))
        if match(bufname(i),'bash - [0-9]*') == 0 | return i | endif
    endfor
    return -1
endfunction

" Invisible characters
if !(has("win16") || has("win32") || has("win64"))
    set listchars=tab:▸\ ,eol:¬
endif
