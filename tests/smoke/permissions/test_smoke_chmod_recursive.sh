#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
mkdir -p sub/nested; touch sub/nested/file.txt
rlRun 'chmod -R 755 sub' 0 "chmod -R 递归"
rlRun 'test -r sub/nested/file.txt' 0 "递归后文件可读"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
