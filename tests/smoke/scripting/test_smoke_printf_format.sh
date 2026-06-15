#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'printf "hello"' 0 "printf 基本输出"
rlRun 'printf "%d\n" 42' 0 "printf 格式化数字"
echo "smoke test passed!"
