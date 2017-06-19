#!/bin/bash
set -e

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     while [ -h "$SOURCE" ]; do
          # shellcheck disable=SC2091
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     cd -P "$( dirname "$SOURCE" )"
     pwd
}

select_role() {
  local role=$1
  case "$role" in
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
  if [ "$CIRCLECI" = true ]; then
    local ANSIBLE_PLAYBOOK="ansible-playbook"
  fi
  case "$install" in
      "Standard")
          # shellcheck disable=SC2086
          $ANSIBLE_PLAYBOOK -i envs/local/etc/ansible/ \
            -e play_dir="$(pwd)" \
            -e lib_roles_path="$(pwd)/roles" \
            $ANSIBLE_OPTS $SETUP_OPTS setup.yml
          ;;
      "Hipster")
          # shellcheck disable=SC2086
          $ANSIBLE_PLAYBOOK -i envs/local/etc/ansible/ \
            -e play_dir="$(pwd)" \
            -e lib_roles_path="$(pwd)/roles" \
            $ANSIBLE_OPTS hipster-setup.yml
          ;;
        *)
          echo invalid option
          exit 1
          ;;
  esac
}

cd "$(get_script_dir)"

./common/scripts/bootstrap.sh --skip-git-crypt

[ -d roles/docker/tasks ] || ./after-git-clone.sh

role=$1

if [ -z "$role" ]; then
  PS3='Select your role: '
  options=("Backend developer" "Frontend developer" "Algorithms developer" "System administrator" "All")
  select role in "${options[@]}";
  do
    select_role "$role"
    break
  done
else
  shift
  select_role "$role"
fi

install=$1
if [ -n "$1" ]; then
  shift
fi

SETUP_OPTS="--skip-tags=virtualbox"
if [ "$1" == "skip_docker" ]; then
  SETUP_OPTS="$SETUP_OPTS,docker"
  shift
fi
if [ "$1" == "skip_yed" ]; then
  SETUP_OPTS="$SETUP_OPTS,yed"
  shift
fi
remaining_opts="$*"
ANSIBLE_OPTS=${ANSIBLE_OPTS:-"$remaining_opts"}
ANSIBLE_OPTS="-e user=$USER -e user_home=$HOME $ANSIBLE_OPTS -e play_dir=$(pwd) $ANSIBLE_OPTS"
if [ -z "$install" ]; then
  PS3='Installation type: '
  install_options=("Standard" "Hipster")
  select install in "${install_options[@]}";
  do
    perform_install "$install"
    break
  done
else
  perform_install "$install"
fi
