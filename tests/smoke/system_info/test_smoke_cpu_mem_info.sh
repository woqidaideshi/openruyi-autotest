#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'cat /proc/cpuinfo | head -5' 0 "/proc/cpuinfo CPU 信息"
rlRun 'cat /proc/meminfo | head -5' 0 "/proc/meminfo 内存信息"
echo "smoke test passed!"
