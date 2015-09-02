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

[ -x /usr/local/bin/ansible ] || (

  # Install Ansible
  sudo apt-get install -y git python-setuptools python-yaml python-jinja2 python-paramiko python-keyczar
  sudo easy_install pip
  sudo pip install ansible
)

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
            break
            ;;
        *) echo invalid option;;
    esac
done

PS3='Installation type: '
options=("Standard", "Hipster")
select opt in "${options[@]}"
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
