#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'cat /proc/uptime' 0 "/proc/uptime 运行时间"
rlRun 'cat /proc/loadavg' 0 "/proc/loadavg 系统负载"
echo "smoke test passed!"
