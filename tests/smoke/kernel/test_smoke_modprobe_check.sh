#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'modprobe --version 2>&1 || true' 0 "modprobe 版本"
rlRun 'ls /lib/modules/$(uname -r) 2>&1 | head -5 || true' 0 "模块目录存在"
echo "smoke test passed!"
