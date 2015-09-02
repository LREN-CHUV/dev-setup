#!/bin/sh

git submodule sync
git submodule update --init

cd roles
git pull origin master
./after-update.sh
