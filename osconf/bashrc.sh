#### 标准输出字符集 ###########################################################
export LANG="zh_CN.UTF8"

#### 给 bash shell 的前缀添加颜色 ###########################################
export PS1='[\[\e[31;01m\]\u\[\e[00m\]@\[\e[32;01m\]\h\[\e[00m\]:\[\e[34;01m\]\w\[\e[00m\]]\$ '

#### 历史命令相关设置 #########################################################
# 忽略重复命令
#export HISTCONTROL=ignoredups
# 设置保存历史命令文件的大小
export HISTFILESIZE=50000000
# 设置保存历史命令条数为
export HISTSIZE=50000000
# 把历史命令实时写入文件，而非退出 shell 的时候才写入1
export PROMPT_COMMAND="history -a;"
# 以追加形式写入文件，而非覆盖式写入
shopt -s histappend
# 显示历史命令时添加时间戳
export HISTTIMEFORMAT="%F %T "

#### 命令别名 #################################################################
alias ..='cd ..'
alias ...='cd ../..'
#### 危险操作必须使用绝对路径 ####
alias init='echo use absolute path to execute init'
alias halt='echo use absolute path to execute halt'
alias reboot='echo use absolute path to execute reboot'
alias poweroff='echo use absolute path to execute poweroff'
alias shutdown='echo use absolute path to execute shutdown'
