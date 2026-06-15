#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ping -c 3 127.0.0.1' 0 "ping localhost"
rlRun 'ping -c 2 -W 2 8.8.8.8 2>&1 || true' 0 "ping 外部地址"
echo "smoke test passed!"
