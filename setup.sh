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

./common/scripts/bootstrap.sh

ANSIBLE_OPTS=""

PS3='Select your role: '
options=("Backend developer" "Frontend developer" "Algorithms developer" "All")
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
        "All")
            ANSIBLE_OPTS="--tags=backend_dev,frontend_dev,algorithms_dev"
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
            ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ $ANSIBLE_OPTS $@ \
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
