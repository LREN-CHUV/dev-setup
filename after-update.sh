#!/bin/sh

git submodule sync
git submodule update --init
pre-commit install
