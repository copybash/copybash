## 这是一个单独的项目，安装文件已经全部放在此目录，除了系统命令，没有其他外部依赖

# 安装

> git clone git@github.com:copybash/copybash.git

# 获取脚本使用帮助


> cd copybash/vim_coding_style

> sh init_work_env.sh

# 脚本使用例子 

## 1. 创建新用户，并安装 vim 设置 

> sh init_work_env.sh create username

## 2. 为已存在用户安装 vim 设置 

**请先备份该用户的文件：~/.vimrc**

> sh init_work_env.sh install username

# 使用编程模式

> vim test.sh

F5  - 进入/关闭编程模式，默认是普通 vim 操作模式
```
   " Press <F1> to display hel|  1 #!/bin/bash
                              |  2 GROUP=devops
-  init_work_env.sh (/data/dev|  3 USERNAME=$2
|-   function                 |  4 USERHOME=/data/$USERNAME
||     usage                  |  5 VIMPATH=/data/$USERNAME/.vim
||     log                    |  6 
||     printResult            |  7 CURRENT_PATH=$(dirname $0)
||     checkUser              |  8 RUNTIME_PATH=$(cd $CURRENT_PATH; pwd)
||     checkUserHome          |  9 
||     checkVim               | 10 function usage() {}
```

# 编程模式说明

```
编程模式支持鼠标操作
    复制操作：Shift + 左键
    窗口切换：左键
    函数跳转：双击左边标签窗口中的函数名即可，或者用键盘上下键移动光标到该函数名 + p
    标签折叠：左键单击左边标签窗口中的 - 收起列表，点击 + 展开列表，也可用键盘 +/*

视图模式下的组合键：把一个单词用指定的符号括起来(非编程模式也支持)
    \{} : hello -> {hello} 
    \{" : hello -> {"hello"} 
    \[] : hello -> [hello]
    \<> : hello -> <hello>
    \"" : hello -> "hello"
    \'' : hello -> 'hello'
```

具体 vim 设置查看 **~/.vimrc**

# 参考文档

官方收录的插件

http://www.vim.org/scripts/index.php

vim 中文文档下载

https://sourceforge.net/projects/vimcdoc/files/vimcdoc/

vimScript 编程书籍

https://github.com/sjl/learnvimscriptthehardway.git

入门手册

> vimtutor
