#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'nproc' 0 "nproc CPU 核心数"
rlRun 'nproc --all' 0 "nproc --all 所有处理器"
echo "smoke test passed!"
