#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'uname' 0 "uname 内核名称"
rlRun 'uname -a' 0 "uname -a 全部信息"
rlRun 'uname -r' 0 "uname -r 内核版本"
rlRun 'uname -m' 0 "uname -m 机器架构"
echo "smoke test passed!"
