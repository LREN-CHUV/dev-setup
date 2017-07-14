#!/bin/sh

git submodule sync
git submodule update --init
pre-commit install || echo "Please install precomit using 'sudo -H pip install pre-commit'"
