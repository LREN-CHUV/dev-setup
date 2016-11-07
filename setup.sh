#!/bin/bash

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     $( cd -P "$( dirname "$SOURCE" )" )
     pwd
}

cd $(get_script_dir)

./common/scripts/bootstrap.sh --skip-git-crypt

[ -d roles/docker/tasks ] || ./after-git-clone.sh

ANSIBLE_OPTS="-e user=$USER -e user_home=$HOME $ANSIBLE_OPTS -e play_dir=$(pwd)"

role=$1
if [ -z "$role" ]; then
  PS3='Select your role: '
  options=("Backend developer" "Frontend developer" "Algorithms developer" "System administrator" "All")
  select role in "${options[@]}"
fi
do
    case $role in
        "Backend developer")
            ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=backend_dev"
            break
            ;;
        "Frontend developer")
            ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=frontend_dev"
            break
            ;;
        "Algorithms developer")
            ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=algorithms_dev"
            break
            ;;
        "System administrator")
            ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=sysadmin"
            break
            ;;
        "All")
            break
            ;;
        *) echo invalid option;;
    esac
done

install=$2
if [ -z "$install" ]; then
  PS3='Installation type: '
  install_options=("Standard" "Hipster")
  select install in "${install_options[@]}"
fi
do
    case $install in
        "Standard")
            ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ --skip-tags=virtualbox $@ \
  setup.yml
            break
            ;;
        "Hipster")
            ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ $ANSIBLE_OPTS $@ \
  hipster-setup.yml
            break
            ;;
        *) echo invalid option;;
    esac
done
