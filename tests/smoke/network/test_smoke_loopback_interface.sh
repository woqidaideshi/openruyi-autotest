#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ip addr show lo | grep -q LOOPBACK' 0 "lo 回环接口存在"
rlRun 'ping -c 1 127.0.0.1' 0 "127.0.0.1 可ping"
echo "smoke test passed!"
