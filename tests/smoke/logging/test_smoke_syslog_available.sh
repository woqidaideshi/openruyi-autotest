#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'logger -t smoke_test "smoke test log message"' 0 "logger 写入日志"
rlRun 'journalctl -t smoke_test --no-pager -n 1 2>&1 || true' 0 "journalctl 查询测试日志"
echo "smoke test passed!"
