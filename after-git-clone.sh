#!/bin/sh

git submodule update --init --recursive
pre-commit install || echo "Please install precomit using 'sudo -H pip install pre-commit'"
