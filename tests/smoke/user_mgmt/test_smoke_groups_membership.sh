#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'groups' 0 "groups 当前用户组"
rlRun 'groups root' 0 "groups root用户组"
echo "smoke test passed!"
