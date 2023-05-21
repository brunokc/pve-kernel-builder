#!/usr/bin/env bash

set -x

echoerr() {
    printf "%s\n" "$*" >&2
}

re='config/([^/]+)/version'
for commit in `yq '.commits[] as $c | $c.id' -`; do
    #echoerr "Commit: ${commit}"
    affected_files=$(git log --format= --name-status -n 1 $commit | cut -f 2)
    for file in $affected_files; do
        #echoerr "analyzing $file"
        if [[ $file =~ $re ]]; then
            echo "${BASH_REMATCH[1]}"
        fi
    done
done
