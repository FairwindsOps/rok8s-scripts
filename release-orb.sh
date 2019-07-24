#!/bin/bash

command -v circleci >/dev/null 2>&1 || { echo >&2 "I require circleci but it's not installed.  Aborting."; exit 1; }

commit=$(git log -n1 --pretty='%h')
tag=$(git describe --exact-match --tags "$commit")

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "You need to checkout a valid tag for this to work."
fi
exit $retVal

echo "Releasing orb for ${tag:1}"

make orb-validate || { echo 'Orb failed to validate.' ; exit 1; }

circleci orb publish orb.yml "fairwinds/rok8s-scripts@${tag:1}"
