#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'journalctl --version' 0 "journalctl 版本"
rlRun 'journalctl -n 10 --no-pager 2>&1 || true' 0 "journalctl 最近日志"
echo "smoke test passed!"
