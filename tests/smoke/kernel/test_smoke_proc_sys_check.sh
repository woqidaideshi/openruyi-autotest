#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -d /proc/sys' 0 "/proc/sys 目录存在"
rlRun 'cat /proc/sys/kernel/hostname' 0 "/proc/sys 可读"
echo "smoke test passed!"
