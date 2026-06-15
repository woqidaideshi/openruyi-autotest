#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ps' 0 "ps 当前进程"
rlRun 'ps aux | head -5' 0 "ps aux 全部进程"
rlRun 'ps -p 1' 0 "ps 查看PID 1"
echo "smoke test passed!"
