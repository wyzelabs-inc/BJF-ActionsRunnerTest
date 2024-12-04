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


function usage()
{
	echo "Usage: docker_build.sh [OPTIONS]"
	echo "Available options:"
	echo "build              -build project"
	echo ""
	echo "Default option is 'build'."
}


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TOP_DIR=$(realpath $SCRIPT_DIR/..)

DOCKER=firmware/mesh-router:v01

echo "============start docker build======"
echo "TOP_DIR: $TOP_DIR"
echo "===================================="

# ID=$(id -u)
# GROUP=$(id -g)

[ ! -z "$DOCKER_IMAGES" ] && DOCKER=${DOCKER_IMAGES}/${DOCKER}
[ ! -z "$CI_BUILD_NUMBER" ] && ENV="-e CI_BUILD_NUMBER=$CI_BUILD_NUMBER"

#=========================
# build targets
#=========================
if echo $@|grep -wqE "help|-h"; then
	if [ -n "$2" -a "$(type -t usage$2)" == function ]; then
		echo "###Current Default [ $2 ] Build Command###"
		eval usage$2
	else
		usage
	fi
	exit 0
fi

OPTIONS="${@:-build}"

docker run --rm --privileged=true -u root ${ENV} -v $TOP_DIR:/project -w /project $DOCKER bash scripts/build.sh $OPTIONS