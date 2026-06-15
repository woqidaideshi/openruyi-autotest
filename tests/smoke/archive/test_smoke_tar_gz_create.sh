#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
mkdir pkg; echo "test" > pkg/README
rlRun 'tar -czf pkg.tar.gz pkg' 0 "tar -czf 创建tar.gz"
rlRun 'test -f pkg.tar.gz' 0 "tar.gz 文件存在"
mkdir out; cd out
rlRun 'tar -xzf ../pkg.tar.gz' 0 "tar -xzf 解压tar.gz"
rlRun 'test -f pkg/README' 0 "解压内容存在"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
