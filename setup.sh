#!/bin/bash

ansible-playbook --ask-become-pass -i envs/local/etc/ansible/ \
  setup.yml
