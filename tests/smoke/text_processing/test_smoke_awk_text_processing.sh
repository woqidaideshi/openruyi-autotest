#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
echo "a 1
b 2
c 3" > data.txt
rlRun 'awk "{print \$1}" data.txt' 0 "awk 打印第一列"
rlRun 'awk "{print \$2}" data.txt' 0 "awk 打印第二列"
rlRun 'awk "{sum+=\$2} END{print sum}" data.txt' 0 "awk 求和"
rm -f data.txt
echo "smoke test passed!"
