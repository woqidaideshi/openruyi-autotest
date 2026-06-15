#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "data" > f.txt
rlRun 'chmod 644 f.txt' 0 "chmod 设置权限"
rlRun 'test -r f.txt' 0 "文件可读"
rlRun 'test -w f.txt' 0 "文件可写"
chmod +x f.txt
rlRun 'test -x f.txt' 0 "文件可执行"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
