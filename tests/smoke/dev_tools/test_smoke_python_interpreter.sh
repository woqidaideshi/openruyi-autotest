#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'which python3' 0 "python3 可用"
rlRun 'python3 --version' 0 "python3 版本"
rlRun 'python3 -c "print(1+1)"' 0 "python3 基本运算"
echo "smoke test passed!"
