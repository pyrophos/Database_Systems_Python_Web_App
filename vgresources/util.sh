#!/bin/sh

cmd()
{
    require=no
    if [ "$1" = -x ]; then
        require=yes
        shift
    fi
    echo + "$@"
    "$@"
    ec="$?"
    if [ $require = yes -a "$ec" -ne 0 ]; then
        echo "command $1 failed with code $ec" >&2
        exit 2
    fi
}
