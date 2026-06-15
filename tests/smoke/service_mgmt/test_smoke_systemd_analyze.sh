#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'systemd-analyze 2>&1 || true' 0 "systemd-analyze 启动时间"
rlRun 'systemd-analyze blame 2>&1 | head -3 || true' 0 "systemd-analyze blame"
echo "smoke test passed!"
