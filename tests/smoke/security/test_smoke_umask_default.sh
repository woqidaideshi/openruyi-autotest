#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'umask' 0 "umask 当前掩码"
TmpDir=$(mktemp -d); cd $TmpDir
umask 022; touch umask_test
rlRun 'ls -l umask_test' 0 "umask 影响新文件权限"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
