#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ss -tln' 0 "ss -tln 监听TCP端口"
rlRun 'ss -s' 0 "ss -s 连接统计"
echo "smoke test passed!"
