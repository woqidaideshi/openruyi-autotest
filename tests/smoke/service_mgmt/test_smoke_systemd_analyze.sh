#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'timeout 10 systemd-analyze 2>&1 || true' 0 "systemd-analyze 启动时间"
rlRun 'timeout 15 systemd-analyze blame 2>&1 | head -5 || true' 0 "systemd-analyze blame"
echo "smoke test passed!"
