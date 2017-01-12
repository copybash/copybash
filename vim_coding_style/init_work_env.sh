#!/bin/bash
CURRENT_PATH=$(dirname $0)
RUNTIME_PATH=$(cd $CURRENT_PATH; pwd)

function usage()
{
cat << eof
usage: sh $(basename $0) opt usr
    opt
        check   - check user's info.
        create  - create an new user who will belong to group devops, 
                    an install the vim coding style settings.
        install - just install vim coding style settings for current user.
    usr 
        the new username you want to create, the default group is 'devops'
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
            tr=1
    fi
    log $level "$msg"
    return $tr
}

# check functions
enum=0
function checkUser()
{
    log noten "1. Usr [$USERNAME]:\t"
    groups $USERNAME >/dev/null 2>&1
    printResult $?
}

function checkUserHome()
{
    log noten "2. Dir [$USERHOME]:\t"
    test -d $USERHOME >/dev/null 2>&1
    printResult $?
}

function checkVim()
{
    log noten "3. Dir [$VIMPATH]:\t"
    test -d $VIMPATH >/dev/null 2>&1
    printResult $?
}

function check()
{
    checkUser
    ((enum=enum+$?))
    checkUserHome
    ((enum=enum+$?))
    checkVim
    ((enum=enum+$?))
    if [ $enum -ne 0 ]; then 
            exit 1
    fi
}

# create functions

function createUser()
{
    log noten "create group [$GROUP]: "
    groupadd $GROUP && echo "ok"
    log noten "create user [$USERNAME]: "
    useradd $USERNAME -g $GROUP -md $USERHOME && echo ok || exit 1
}

function createDirForVim()
{
    log noten "create dir [$VIMPATH]: "
    mkdir -p $VIMPATH && echo ok || exit 1
    log noten "install vim plugin [taglist]: "
    unzip -qo $RUNTIME_PATH/taglist_46.zip -d $VIMPATH && echo "ok" || exit 1
    log noten "create file [$USERHOME/.vimrc]: "
    cp $RUNTIME_PATH/vimrc $USERHOME/.vimrc && echo "ok" || exit 1
    chown -R $USERNAME:$GROUP $USERHOME/.vimrc
}

function installVimDocCN()
{
    log noten "install Vim Chinese Docs: "
    cd $RUNTIME_PATH
    tar -zxf vimcdoc-1.8.0.tar.gz
    cd $RUNTIME_PATH/vimcdoc-1.8.0
    sh vimcdoc.sh -i >/dev/null 2>&1 && echo "ok" || exit 1
    cd $RUNTIME_PATH && rm -rf $RUNTIME_PATH/vimcdoc-1.8.0
    chown -R $USERNAME:$GROUP $USERHOME/.vim
}

function createWorkingDirs()
{
    dirs="$USERHOME/{download,coding/bash,coding/python,github.com,logs/nginx}"
    mkdir -pv $dirs
    chown -R $USERNAME:$GROUP $dirs
}

function create()
{
    if [ `whoami` != "root" ]; then
        log error "Error: the username can not be 'root'"
        exit 1
    fi
    createUser
    createDirForVim
    install
}

function install()
{
    createDirForVim
    installVimDocCN
}

function delete()
{
    userdel -r $USERNAME
}

# mian function

if [ $# -ne 2 ]; then usage; exit 1; fi
opt=$1
usr=$2
if [ "$usr" == "root" ]; then
    log errorn "You're 'root'. Do you want to continue [y/n]? "
    read i
    if [ "$i" != "y" ]; then
        echo "exit"
        exit 1
    fi
fi
USERNAME=$usr
case $2 in
    root)   GROUP=root
            USERHOME=/root
            VIMPATH=/$USERNAME/.vim 
            ;;
    *)      GROUP=devops
            USERHOME=/data/$USERNAME
            VIMPATH=/data/$USERNAME/.vim
            ;;
esac

case $1 in
    check)      check;;
    create)     create;;
    delete)     delete;;
    install)    install;;
    *)          usage; exit 1;;
esac

