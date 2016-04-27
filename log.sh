#!/usr/bin/env bash
# Author: huichen
# Date  : 2016-04-30
# Usage : source /path/to/log.sh
#         log level "strings"

function log()
{
        local level=$1
        shift
        local msg=$*
	local ts=$(date +"%F %T")
        case $level in
                debug)  echo -e "$ts [DEBUG] $msg";;
                info)   echo -e "$ts [INFO] $msg";;
                note)   echo -e "$ts [NOTE] \033[92m$msg\033[0m";;
                warn)   echo -e "$ts [WARN] \033[93m$msg\033[0m";;
                error)  echo -e "$ts [ERROR] \033[91m$msg\033[0m";;
        esac
}
