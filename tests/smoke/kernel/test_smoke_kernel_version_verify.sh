#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'uname -r' 0 "内核版本"
rlRun 'cat /proc/cmdline' 0 "/proc/cmdline 启动参数"
rlRun 'cat /proc/version' 0 "/proc/version 内核编译信息"
echo "smoke test passed!"
