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

[ -x /usr/bin/ansible ] || (

  # Install Ansible
  sudo apt-get install -y python-setuptools python-yaml python-jinja2 python-paramiko python-keyczar
  sudo easy_install pip
  sudo pip install ansible

)

ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ $@ \
  setup.yml
