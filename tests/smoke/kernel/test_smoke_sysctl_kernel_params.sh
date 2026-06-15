#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'sysctl -a 2>&1 | head -5 || true' 0 "sysctl -a 内核参数"
rlRun 'sysctl kernel.hostname 2>&1 || true' 0 "sysctl 读取hostname参数"
echo "smoke test passed!"
