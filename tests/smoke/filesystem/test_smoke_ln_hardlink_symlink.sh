#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "link test" > target.txt
rlRun 'ln target.txt hardlink.txt' 0 "ln 创建硬链接"
rlRun 'ln -s target.txt symlink.txt' 0 "ln -s 创建符号链接"
rlRun 'test -f hardlink.txt' 0 "硬链接存在"
rlRun 'test -L symlink.txt' 0 "符号链接存在"
rlRun 'cat hardlink.txt' 0 "硬链接可读"
rlRun 'cat symlink.txt' 0 "符号链接可读"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
