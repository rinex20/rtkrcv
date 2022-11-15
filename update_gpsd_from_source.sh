#!/bin/bash

# update gpsd from source
VER=3.24

sudo apt update
sudo apt install -y scons libncurses-dev python-dev pps-tools git-core asciidoctor python3-matplotlib build-essential manpages-dev pkg-config python3-distutils

sudo wget http://download.savannah.gnu.org/releases/gpsd/gpsd-${VER}.tar.gz 
tar -xzf gpsd-${VER}.tar.gz
cd gpsd-${VER}

sudo scons

sudo scons install
