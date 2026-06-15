#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'lsmod | head -10' 0 "lsmod 列出模块"
rlRun 'lsmod | wc -l' 0 "lsmod 模块数量"
echo "smoke test passed!"
