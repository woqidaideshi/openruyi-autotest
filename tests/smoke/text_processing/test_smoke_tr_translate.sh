#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'echo "HELLO" | tr "A-Z" "a-z"' 0 "tr 大小写转换"
rlRun 'echo "a b c" | tr -d " "' 0 "tr -d 删除空格"
rlRun 'echo "a  b   c" | tr -s " "' 0 "tr -s 压缩重复空格"
echo "smoke test passed!"
