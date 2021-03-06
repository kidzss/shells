#!/bin/bash
# 安装wildfly到当前目录

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

wget http://resali.huobanplus.com/wildfly-10.0.0.Final.tar.gz
# 获取当前目录
tar -xzf wildfly-10.0.0.Final.tar.gz
rm wildfly-10.0.0.Final.tar.gz

PWD=`pwd`
HOME=${PWD}/wildfly-10.0.0.Final

# 添加用户
useradd -c "Wildfly Daemon User" -r -d "${HOME}" wildfly

chown -R wildfly:wildfly $HOME

echo "export WILDFLY_USER=wildfly" >> /etc/environment
echo "export WILDFLY_HOME=$HOME" >> /etc/environment

echo "it's very importment to true resolve-parameter-values in ${HOME}/bin/jboss-cli.xml"

# TODO 要制作一个启动的脚本呀，笨
# TODO 再制作 2个 用户专用 启动脚本 和cli脚本
# TODO 开启acl之后 千万记得 加入权限 <user realm="ManagementRealm" name="CJ"/>
# TODO 如果需要开启远程web管理  那么hosts 还需要加入使用public interface作为远程管理的接口
