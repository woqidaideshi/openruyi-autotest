#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
echo "a:b:c:d" | cut -d: -f1,3 | grep "a:c"
rlRun 'echo "user:x:1000" | cut -d: -f1' 0 "cut 提取第一字段"
rlRun 'echo "hello" | cut -c1-3' 0 "cut 按字符位置"
echo "smoke test passed!"
