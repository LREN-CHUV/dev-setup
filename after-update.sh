#!/bin/sh

git submodule sync
git submodule update --init

cd mmsi
git pull origin master
IN_SUBMODULE=true ./after-update.sh
