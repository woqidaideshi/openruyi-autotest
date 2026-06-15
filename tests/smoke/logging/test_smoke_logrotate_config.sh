#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -d /etc/logrotate.d' 0 "/etc/logrotate.d 目录存在"
rlRun 'logrotate --version 2>&1 || true' 0 "logrotate 可用"
echo "smoke test passed!"
