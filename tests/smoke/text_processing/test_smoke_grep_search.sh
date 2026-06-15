#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
TmpDir=$(mktemp -d); cd $TmpDir
cat > fruits.txt << EOF
apple
banana
Apple pie
orange
EOF
rlRun 'grep apple fruits.txt' 0 "grep 基本搜索"
rlRun 'grep -i apple fruits.txt' 0 "grep -i 忽略大小写"
rlRun 'grep -c a fruits.txt' 0 "grep -c 计数"
rlRun 'grep -v banana fruits.txt' 0 "grep -v 反向匹配"
cd /; rm -rf $TmpDir
echo "smoke test passed!"
