#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -f /etc/os-release' 0 "test -f 文件存在"
rlRun '[ -d /tmp ]' 0 "[ -d ] 目录存在"
rlRun 'test "a" = "a"' 0 "test 字符串相等"
rlRun 'test 1 -lt 2' 0 "test 数值比较"
echo "smoke test passed!"
