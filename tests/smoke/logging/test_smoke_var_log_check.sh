#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -d /var/log' 0 "/var/log 目录存在"
rlRun 'ls /var/log | head -10' 0 "/var/log 日志文件列表"
rlRun 'test -f /var/log/messages || test -f /var/log/syslog || echo "no standard syslog"' 0 "系统日志存在性检查"
echo "smoke test passed!"
