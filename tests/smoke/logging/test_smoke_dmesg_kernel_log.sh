#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'dmesg | head -10' 0 "dmesg 内核日志"
rlRun 'dmesg | wc -l' 0 "dmesg 日志行数"
echo "smoke test passed!"
