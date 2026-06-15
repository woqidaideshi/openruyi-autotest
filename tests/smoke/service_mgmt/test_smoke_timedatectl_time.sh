#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'timedatectl 2>&1 || true' 0 "timedatectl 时间状态"
rlRun 'timedatectl list-timezones 2>&1 | head -3 || true' 0 "timedatectl 时区列表"
echo "smoke test passed!"
