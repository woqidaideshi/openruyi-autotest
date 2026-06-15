#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'last -n 5 2>&1 || true' 0 "last 最近登录"
rlRun 'test -f /var/log/wtmp' 0 "/var/log/wtmp 登录记录"
echo "smoke test passed!"
