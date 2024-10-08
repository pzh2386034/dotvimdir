"======================================================================
"
" init-basic.vim - 基础配置，该配置需要兼容 vim tiny 模式
"
" 所有人都能接受的配置，不掺渣任何 keymap, 和偏好设置
"
" Created by zeuspan on 2018/05/30
" Last Modified: 2018/05/30 16:53:18
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :

"----------------------------------------------------------------------
" 基础设置
"----------------------------------------------------------------------
"
" set leader key \
let mapleader = "\\"
" custom mapping
nnoremap #2 : w<CR>
nnoremap #3 : ggdG
nnoremap #4 :gg"+yG
" set cmdheight=2

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
nnoremap ,<space> i<space><esc>
nnoremap cw :w<CR>
nnoremap ce :q<CR>
" 设置 F10 打开/关闭 Quickfix 窗口
nnoremap co :call asyncrun#quickfix_toggle(6)<cr>
nnoremap ci :only<cr>
nnoremap cu :bd<cr>
" 设置quickfix 快捷键
nnoremap cn :cn<CR>
nnoremap cm :cp<CR>

let g:utl_cfg_hdl_scm_http = "silent !open -a Safari '%u'"
nnoremap <C-g> :echo expand('%:p')<CR>
set paste
vnoremap <C-c> "*y
nnoremap ,v    "*p
" <C-R>--Ctrl-R;
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

nnoremap * :keepjumps normal! mi*`i<CR>
nnoremap # :keepjumps normal! mi#`i<CR>
nmap <silent> <C-L> <C-L>:nohlsearch<CR>:match<CR>:diffupdate<CR>
" <left><left><left>-->把光标左移到//中间
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

nnoremap ,e :set hlsearch!<CR>
nnoremap ,h <C-W>h
nnoremap ,l <C-W>l
nnoremap ,j <C-W>j
nnoremap ,k <C-W>k

nnoremap mf <C-F>
nnoremap md <C-U>

nnoremap rl :vertical resize -10<CR>
nnoremap rh :vertical resize +10<CR>
nnoremap rk :resize +10<CR>
nnoremap rj :resize -10<CR>
" 另起一行粘贴
nnoremap ,p :pu<CR>
nnoremap ,P :pu!<CR>

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" 禁用 vi 兼容模式
set nocompatible

" 设置 Backspace 键模式
set bs=eol,start,indent

" 自动缩进
set autoindent

" 打开 C/C++ 语言缩进优化
set cindent

" Windows 禁用 ALT 操作菜单（使得 ALT 可以用到 Vim里）
set winaltkeys=no

" 关闭自动换行
set wrap

" 打开功能键超时检测（终端下功能键为一串 ESC 开头的字符串）
set ttimeout

" 功能键超时检测 50 毫秒
set ttimeoutlen=50

" 显示光标位置
set ruler


"----------------------------------------------------------------------
" 搜索设置
"----------------------------------------------------------------------

" 搜索时忽略大小写
" set ignorecase

" 智能搜索大小写判断，默认忽略大小写，除非搜索内容包含大写字母
set smartcase

" 高亮搜索内容
set hlsearch

" 查找输入时动态增量显示查找结果
set incsearch


"----------------------------------------------------------------------
" 编码设置
"----------------------------------------------------------------------
if has('multi_byte')
	" 内部工作编码
	set encoding=utf-8

	" 文件默认编码
	set fileencoding=utf-8

	" 打开文件时自动尝试下面顺序的编码
	set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif


"----------------------------------------------------------------------
" 允许 Vim 自带脚本根据文件类型自动设置缩进等
"----------------------------------------------------------------------
if has('autocmd')
	filetype plugin indent on
endif


"----------------------------------------------------------------------
" 语法高亮设置
"----------------------------------------------------------------------
if has('syntax')
	syntax enable
	syntax on
endif


"----------------------------------------------------------------------
" 其他设置
"----------------------------------------------------------------------

" 显示匹配的括号
set showmatch

" 显示括号匹配的时间
set matchtime=2

" 显示最后一行
set display=lastline

" 允许下方显示目录
set wildmenu

" 延迟绘制（提升性能）
set lazyredraw

" 错误格式
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m

" 设置分隔符可视
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<


" 设置 tags：当前文件所在目录往上向根目录搜索直到碰到 .tags 文件
" 或者 Vim 当前目录包含 .tags 文件
set tags=./.tags;,.tags

" 如遇Unicode值大于255的文本，不必等到格再折行
set formatoptions+=m

" 合并两行中文时，不在中间加空格
set formatoptions+=B

" 文件换行符，默认使用 unix 换行符
set ffs=unix,dos,mac


"----------------------------------------------------------------------
" 设置代码折叠
"----------------------------------------------------------------------
if has('folding')
	" 允许代码折叠
	set foldenable

	" 代码折叠默认使用缩进
	set fdm=indent

	" 默认打开所有缩进
	set foldlevel=2
	set foldmethod=syntax

endif


"----------------------------------------------------------------------
" 文件搜索和补全时忽略下面扩展名
"----------------------------------------------------------------------
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android
