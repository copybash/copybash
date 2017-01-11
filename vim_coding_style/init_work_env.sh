#!/bin/bash
GROUP=devops
USERNAME=$2
USERHOME=/data/$USERNAME
VIMPATH=/data/$USERNAME/.vim

CURRENT_PATH=$(dirname $0)
RUNTIME_PATH=$(cd $CURRENT_PATH; pwd)

function usagesss()
{
cat << eof
usage: sh $(basename $0) opt usr
    opt
        check   - check user's info whether it exists or not
        create  - create an new user who will belong to groups devops
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
    log noten "create file [$USERHOME/.vimrc.co]: "
    cp $RUNTIME_PATH/vimrc.co $USERHOME/.vimrc.co && echo "ok" || exit 1
    chown -R $USERNAME:$GROUP $USERHOME/{.vim*,.bashrc}
}

function installVimDocCN()
{
    log noten "install Vim Chinese Doc: "
    cd $RUNTIME_PATH
    tar -zxf vimcdoc-1.8.0.tar.gz
    cd $RUNTIME_PATH/vimcdoc-1.8.0
    sh vimcdoc.sh -i >/dev/null 2>&1 && echo "ok" || exit 1
    cd $RUNTIME_PATH && rm -rf $RUNTIME_PATH/vimcdoc-1.8.0
}

function createCodingCmd()
{
    log noten "create new command [coding]: "
    cp $RUNTIME_PATH/bashrc $USERHOME/.bashrc && echo "ok" || exit 1
    chown -R $USERNAME:$GROUP $USERHOME/{.vim*,.bashrc}

}

function createWorkingDirs()
{
    mkdir -pv $USERHOME/{download,coding/bash,coding/python,github.com,logs/nginx}
    chown -R $USERNAME:$GROUP $USERHOME
}

function create()
{
    if [ `whoami` != "root" ]; then
        log error "Error: you must run the script with 'root' privillege"
        exit 1
    fi
    createUser
    createDirForVim
    createCodingCmd
}

function delete()
{
    userdel -r $USERNAME
}

function installCodingCMD()
{
    createDirForVim
    installVimDocCN
    createCodingCmd
    source ~/.bashrc
}

# mian function

if [ $# -ne 2 ]; then usage; exit 1; fi
if [ "$USERNAME" == "root" ]; then log error "Error: the username can not be 'root'"; exit 1; fi
case $1 in
    check)      check;;
    create)     create;;
    delete)     delete;;
    install)    installCodingCMD;;
    *)          usage; exit 1;;
esac

