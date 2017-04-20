#!/bin/bash
CURRENT_PATH=$(dirname $0)
RUNTIME_PATH=$(cd $CURRENT_PATH; pwd)

function usage()
{
cat << eof
usage: sh $(basename $0) check|install
        check   - Check current user's info.
        install - Just install vim coding style settings for current user.
                  Note: Install commad 'ctags' : yum install -y ctags
eof
}

function log()
{
        local level=$1
        shift
        local msg=$*
        case $level in
                info)   echo -e "\t$msg";;
                note)   echo -e "\033[92m$msg\033[0m";;
                noten)  echo -en "\033[92m$msg\033[0m";;
                warn)   echo -e "\033[93m$msg\033[0m";;
                error)  echo -e "\033[91m$msg\033[0m";;
                errorn) echo -en "\033[91m$msg\033[0m";;
        esac
}

function printResult()
{
    if [ $1 -eq 0 ]; then
            level=info
            msg="ok"
            rt=0
    else
            level=error
            msg="not found"
            rt=1
    fi
    log $level "$msg"
    return $rt
}

# check functions
function check()
{
    checkUserHome
    checkVim
    checkCtagsCmd
}

function checkUserHome()
{
    log noten "1. Dir [$HOME]:\t"
    test -d $HOME >/dev/null 2>&1
    printResult $?
}

function checkVim()
{
    log noten "2. Dir [$VIMPATH]:\t"
    test -d $VIMPATH >/dev/null 2>&1
    printResult $?
}

function checkCtagsCmd()
{
    log noten "3. Cmd [ctags]:\t"
    which ctags 1>/dev/null 2>&1
    printResult $?
}

# install functions
function install()
{
    createDirForVim
    installVimDocCN
}

function createDirForVim()
{
    log noten "create dir [$VIMPATH]: "
    mkdir -p $VIMPATH && echo ok || exit 1

    log noten "install vim plugin [taglist]: "
    unzip -qo $RUNTIME_PATH/taglist_46.zip -d $VIMPATH && echo "ok" || exit 1

    log noten "create file [$HOME/.vimrc]: "
    cp $RUNTIME_PATH/vimrc $HOME/.vimrc && echo "ok" || exit 1
}

function installVimDocCN()
{
    log noten "install Vim Chinese Docs: "
    cd $RUNTIME_PATH
    tar -zxf vimcdoc-1.8.0.tar.gz
    cd $RUNTIME_PATH/vimcdoc-1.8.0
    sh vimcdoc.sh -i >/dev/null 2>&1 && echo "ok" || exit 1
    cd $RUNTIME_PATH && rm -rf $RUNTIME_PATH/vimcdoc-1.8.0
}

# main function
opt=$1
if [ "$usr" == "root" ]; then
    log errorn "You're 'root'. Do you want to continue [y/n]? "
    read i
    if [ "$i" != "y" ]; then
        echo "exit"
        exit 1
    fi
fi
VIMPATH=$HOME/.vim
case $1 in
    check)      check;;
    install)    install;;
    *)          usage; exit 1;;
esac

