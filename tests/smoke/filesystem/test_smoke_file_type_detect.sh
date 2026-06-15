#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
echo "text" > t.txt
rlRun 'file t.txt | grep -i text' 0 "file 识别文本文件"
rlRun 'file /bin/sh | grep -i elf' 0 "file 识别 ELF 二进制"
rlRun 'file /' 0 "file 识别目录"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
