#!/bin/bash


sudo apt-get update && sudo apt-get install \
    python3-dev python3-venv python3-pip python-is-python3

python3 -m pip install --user debugpy

