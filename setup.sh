#!/bin/bash

[ -x /usr/bin/ansible ] || (

  # Install Ansible
  sudo apt-get install -y python-setuptools python-yaml python-jinja2 python-paramiko python-keyczar
  sudo easy_install pip
  sudo pip install ansible

)

ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ $@ \
  setup.yml
