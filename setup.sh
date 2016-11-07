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

select_role() {
  local role=$1
  case $role in
      "Backend developer")
          ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=backend_dev"
          ;;
      "Frontend developer")
          ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=frontend_dev"
          ;;
      "Algorithms developer")
          ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=algorithms_dev"
          ;;
      "System administrator")
          ANSIBLE_OPTS="$ANSIBLE_OPTS --tags=sysadmin"
          ;;
      "All")
          ;;
      *)
          echo invalid option
          exit 1
          ;;
  esac

}

perform_install() {
  local install=$1
  local ANSIBLE_PLAYBOOK="ansible-playbook --ask-become-pass"
  # Do not ask password on CircleCI
  if [ -z "$CIRCLE_USERNAME" ]; then
    local ANSIBLE_PLAYBOOK="ansible-playbook"
  fi
  case $install in
      "Standard")
          $ANSIBLE_PLAYBOOK -i envs/local/etc/ansible/ --skip-tags=virtualbox $@ setup.yml
          ;;
      "Hipster")
          $ANSIBLE_PLAYBOOK -i envs/local/etc/ansible/ $ANSIBLE_OPTS $@ hipster-setup.yml
          ;;
        *)
          echo invalid option
          exit 1
          ;;
  esac
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
  do
    select_role $role
  done
else
  select_role $role
fi

install=$2
if [ -z "$install" ]; then
  PS3='Installation type: '
  install_options=("Standard" "Hipster")
  select install in "${install_options[@]}"
  do
    perform_install $install
  done
else
  perform_install $install
fi
