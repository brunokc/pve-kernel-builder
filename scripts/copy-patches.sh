#!/usr/bin/env bash

set -x

# (https://stackoverflow.com/questions/1215538/extract-parameters-before-last-parameter-in)
# TLDR, gnu.org/software/bash/manual/html_node/… .
# The last command is using $@ which is an array of all arguments.
# $# which is the number of arguments. And then the colon by itself
# in variable expansion means offset. Overall the command means.
# offset the array of args $@, by the number of args $# and convert the
# array to a string because of the variable expansion. It is the most
# portable because Environment variable expansion is specified in GNU Coreutils.

# last parameter
destination=${@:$#}
# all parameters except the last
sources=${*%${!#}}

for patch in $sources; do
    if [ -f $patch ]; then
        cp $patch $destination
    fi
done
