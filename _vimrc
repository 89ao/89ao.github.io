set nobackup " 不保留备份文件 
set nocompatible " 关闭 vi 兼容模式 
syntax on " 自动语法高亮 
set number " 显示行号 
set cursorline " 突出显示当前行 
filetype plugin indent on " 开启插件 
set ruler " 打开状态栏标尺 
set tabstop=4 " 设定 tab 长度为 4 
set softtabstop=4 " 使得按退格键时可以一次删掉 4 个空格 
set shiftwidth=4 " 设定 << 和 >> 命令移动时的宽度为 4 
set autochdir " 自动切换当前目录为当前文件所在的目录 
set ignorecase smartcase " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感 
set nowrapscan " 禁止在搜索到文件两端时重新搜索 
set incsearch " 输入搜索内容时就显示搜索结果 
set hlsearch " 搜索时高亮显示被找到的文本 
set noerrorbells " 关闭错误信息响铃 
set novisualbell " 关闭使用可视响铃代替呼叫 
set t_vb= " 置空错误铃声的终端代码 
set guioptions-=T " 隐藏工具栏 " 
set guioptions-=m " 隐藏菜单栏 
set history=400 " vim记住的历史操作的数量，默认的是20 
set autoread " 当文件在外部被修改时，自动重新读取 
"vmap "+y " 选中状态下 Ctrl+c 复制

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

language messages zh_CN.utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

