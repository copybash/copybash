# app home 目录
APP_HOME=$HOME/app
# 只需要修改 BIN_APP 和 SBIN_APP
BIN_APP="   jdk1.8.0_112
            kafka_2.10-0.10.1.1
            zookeeper-3.4.9"
SBIN_APP=""
# 以下代码一般不用修改
for app in $BIN_APP; do
    APP_BIN_PATH=$APP_HOME/$app/bin
    PATH=$APP_BIN_PATH:$PATH
done
for app in $SBIN_APP; do
    APP_SBIN_PATH=$APP_HOME/$app/sbin
    PATH=$APP_SBIN_PATH:$PATH
done
# 声明 PATH
export PATH
