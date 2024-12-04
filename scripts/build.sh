#!/bin/bash

export LC_ALL=C

err_handler() {
    ret=$?
    [ "$ret" -eq 0 ] && return

    echo "ERROR: Running ${FUNCNAME[1]} failed!"
    echo "ERROR: exit code $ret from line ${BASH_LINENO[0]}:"
    echo "    $BASH_COMMAND"
    exit $ret
}

trap 'err_handler' ERR
set -eE

function finish_build() {
    echo "Running ${FUNCNAME[1]} succeeded."
    cd $TOP_DIR
}


echo "build.sh"