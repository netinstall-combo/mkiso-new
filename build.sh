#!/bin/bash
set -e
mkdir -p work/out
export DATA=$PWD/data
export DESTDIR=$PWD/work/out
export PATH=$PWD/work/out/toolchain/bin:$PATH

for mod in ./src/* ; do
    mkdir -p work/$(basename $mod)
    if [ ! -f work/$(basename $mod)/done."$1" ] ; then
        echo -e "\033[;32m$mod $1\033[;0m"
        bash -c "cd work/$(basename $mod) ; source ../../$mod ; $1"
        touch work/$(basename $mod)/done."$1"
    fi
done
