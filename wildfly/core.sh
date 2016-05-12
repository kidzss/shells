#!/bin/bash
# 提供处理的核心函数

# p1 脚本地址，如果不是/开头将以运行sh的目录取CLI
# 成对的property name & value
function execCLI(){
  if [[ ! ${WILDFLY_HOME} ]]; then
    # echo "${WILDFLY_HOME} do not exist."
    echo "echo 'export WILDFLY_HOME=' >> /etc/environment"
    echo "to set environment well."
    exit 1
  fi
  CLISH=${WILDFLY_HOME}/bin/jboss-cli.sh
  if [[ ! -x ${CLISH} ]]; then
    echo "${CLISH} is not execable file."
    exit 1
  fi
  CLI=$1

  if [[  ${CLI:0:1} != '/' ]]; then
    SCRIPTPATH=`dirname "$0"`
    SCRIPTPATH=`exec 2>/dev/null;(cd -- "$mypath") && cd -- "$mypath"|| cd "$mypath"; unset PWD; /usr/bin/pwd || /bin/pwd || pwd`
    CLI=$SCRIPTPATH"/"$CLI
  fi

  TMP="$(mktemp -q -t "$(basename "$0").XXXXXX" 2>/dev/null || mktemp -q)"
  
  while [[ $2 ]]; do
    # 读取 $2和$3
    echo "$2=$3" >> $TMP
    shift
    shift
  done
  if [[ ${WILDFLY_HOME_MANAGEMENT_USER} ]]; then
    $CLISH --properties=$TMP --file=$CLI -c -u=$WILDFLY_HOME_MANAGEMENT_USER -p=$WILDFLY_HOME_MANAGEMENT_PASSWORD
  else
    echo "setup WILDFLY_HOME_MANAGEMENT_USER WILDFLY_HOME_MANAGEMENT_PASSWORD vars in .bash_profile to work fast."
    $CLISH --properties=$TMP --file=$CLI -c
  fi

  rm $TMP
}
