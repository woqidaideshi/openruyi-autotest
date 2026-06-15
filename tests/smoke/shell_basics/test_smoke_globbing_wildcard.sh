#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
touch a.txt b.txt c.jpg
rlRun 'ls *.txt | wc -l' 0 "*.txt 通配符"
rlRun 'ls ?.jpg' 0 "?.jpg 单字通配符"
rlRun 'echo ~ | grep /' 0 "~ 家目录展开"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
