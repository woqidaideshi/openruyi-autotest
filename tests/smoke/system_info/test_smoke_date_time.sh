#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'date' 0 "date 当前时间"
rlRun 'date +%Y-%m-%d' 0 "date 格式化日期"
rlRun 'date +%H:%M:%S' 0 "date 格式化时间"
echo "smoke test passed!"
