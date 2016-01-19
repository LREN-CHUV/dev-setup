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

ANSIBLE_OPTS=""

PS3='Select your role: '
options=("Backend developer" "Frontend developer" "Algorithms developer" "System administrator" "All")
select opt in "${options[@]}"
do
    case $opt in
        "Backend developer")
            ANSIBLE_OPTS="--tags=backend_dev"
            break
            ;;
        "Frontend developer")
            ANSIBLE_OPTS="--tags=frontend_dev"
            break
            ;;
        "Algorithms developer")
            ANSIBLE_OPTS="--tags=algorithms_dev"
            break
            ;;
        "System administrator")
            ANSIBLE_OPTS="--tags=sysadmin"
            break
            ;;
        "All")
            ANSIBLE_OPTS="--tags=backend_dev,frontend_dev,algorithms_dev,sysadmin"
            break
            ;;
        *) echo invalid option;;
    esac
done

PS3='Installation type: '
install_options=("Standard" "Hipster")
select opt in "${install_options[@]}"
do
    case $opt in
        "Standard")
            ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ -e play_dir=$(pwd) $ANSIBLE_OPTS --skip-tags=virtualbox $@ \
  setup.yml
            break
            ;;
        "Hipster")
            ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ -e play_dir=$(pwd) $ANSIBLE_OPTS $@ \
  hipster-setup.yml
            break
            ;;
        *) echo invalid option;;
    esac
done
