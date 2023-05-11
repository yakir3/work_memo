"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => 通用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader 键设置
let mapleader = ","
nmap <leader>w :w!<cr>
noremap <leader>d dd
noremap <leader>y yy
" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" 命令行补全以增强模式运行
set wildmenu
" 命令模式下，使用 tab 补全命令
set wildmode=longest:list,full

" 命令的历史和最近搜索模式的历史
set history=256

" 载入文件类型插件 & 为特定文件类型载入相关缩进文件
filetype on
filetype plugin on
filetype indent on

" 当文件在外部被修改时，自动更新该文件
set autoread
" set autowrite

" 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" 在状态栏显示正在输入的命令
set showcmd
" 左下角显示当前vim模式
set showmode
" 显示状态栏标尺
set ruler

" 突出显示当前列与行
set cursorcolumn
set cursorline

" 快速到行首行尾快捷键
noremap H ^
noremap L $

""" 搜索配置
" 搜索模式里忽略大小写
set ignorecase
" 搜索模式里包含大写字符，不使用ignorecase选项
set smartcase
" 搜索时高亮显示被找到的文本
set hlsearch
" 输入搜索命令时，显示目前输入的模式的匹配位置。匹配的字符串被高亮
set incsearch 

" 避免不必要的重绘，提升性能
set lazyredraw 


" 设定命令行的行数为1
set cmdheight=1

" 放弃时隐藏缓冲区
set hid

" 配置退格键
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" 插入括号时，短暂地跳转到匹配的对应括号 
set showmatch 
" 短暂跳转到匹配括号的时间
set mat=2

" ,ss 切换和取消切换拼写检查
map <leader>ss :setlocal spell!<cr>

" 总是显示状态栏
set laststatus=2
" 状态栏格式
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" 删除Windows ^M
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" 快速打开 ~/buffer 以进行临时写入
map <leader>q :e ~/buffer<cr>

" 快速打开 ~/buffer.md 以进行临时写入
map <leader>x :e ~/buffer.md<cr>

" 打开和关闭粘贴模式
map <leader>pp :setlocal paste!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FileType Settings  文件类型设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()


"新建文件自动插入头部注释
autocmd BufNewFile *.sh,*.py, exec ":call SetNewFileTitle()"
let $author_name = "Yakir"
"let $author_email = "xxxx@xxx.xx"
func SetNewFileTitle()
    if expand("%:e") == 'py'
        call setline(1,"\#=============================================================")
        call append(line("."), "\# Author: ".$author_name)
        call append(line(".")+1, "\# Created Time: ".strftime("%c"))
        call append(line(".")+2, "\#=============================================================")
        call append(line(".")+3, "\#!/usr/bin/env python")
        call append(line(".")+4, "\#")
    else
        call setline(1,"\#=============================================================")
        call append(line("."), "\# Author: ".$author_name)
        call append(line(".")+1, "\# Created Time: ".strftime("%c"))
        call append(line(".")+2, "\#=============================================================")
        call append(line(".")+3, "\#!/bin/bash")
        call append(line(".")+4, "\#")
    normal G
    normal o
    normal o
    endif
endfun

" 关闭备份
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => HotKey Settings  自定义快捷键设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F1 - F6设置
" F1 废弃这个键,防止调出系统帮助
noremap <F1> <Esc>"

""F2 设置为开关NERDTree的快捷键
map <F2> :NERDTreeToggle<CR>

" F3 文件内部注释快捷键
func SetComment()
    call append(line(".")  , '//**************** comment start ********************')
    call append(line(".")+1, '//**************** comment end   ********************')
endfunc
"映射F3快捷键，生成后跳转至下行，然后使用O进入vim的插入模式
map <F3> :call SetComment()<CR>j<CR>O

" F4 换行开关
nnoremap <F4> :set wrap! wrap?<CR>

" F5 粘贴模式paste_mode开关,用于有格式的代码粘贴
" Automatically set paste mode in Vim when pasting in insert mode
set pastetoggle=<F5>
" disbale paste mode when leaving insert mode
au InsertLeave * set nopaste
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" F6 语法开关，关闭语法可以加快大文件的展示
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
" fonts install --> https://github.com/powerline/fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
set background=dark
colorscheme solarized
"colorscheme molokai

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 使用空格代替 tab
set expandtab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" 插入模式下输入<cr>或使用"o"或"O"命令开新行，从当前行复制缩进距离
set ai "Auto indent
" 开启新行时使用智能自动缩进
set si "Smart indent
" 设置文本达到 textwidth 宽度时自动换行，但实际文件还是一行
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
"vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
"vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" 保存时删除尾部空白
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" 自动切换当前目录为当前文件所在的目录
set autochdir 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""
" => Plugins
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'exvim/ex-colorschemes'
    "Plugin 'VundleVim/Vundle.vim'       "vundle插件
    "Plugin 'vim-syntastic/syntastic'    "语法检查
call vundle#end()


"""" settings for YouCompleteMe
"" 自动补全配置
" set completeopt=longest,menu
"" "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
" autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"" 离开插入模式后自动关闭预览窗口
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"" 回车即选中当前项
"" 上下左右键的行为 会显示其他信息
" inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
" inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
" inoremap <expr> <PageDown> pumvisible() ? \<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
" inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" :"\<PageUp>"
" 代码折叠
set foldenable
set foldmethod=indent
set foldlevel=99
