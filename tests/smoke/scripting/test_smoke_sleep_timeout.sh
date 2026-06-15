#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'sleep 1' 0 "sleep 1秒"
rlRun 'timeout 1 sleep 0.5' 0 "timeout 命令"
echo "smoke test passed!"
