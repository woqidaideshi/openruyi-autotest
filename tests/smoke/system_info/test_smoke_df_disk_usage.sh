#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'df' 0 "df 磁盘使用"
rlRun 'df -h' 0 "df -h 人类可读"
rlRun 'df /' 0 "df 根分区"
echo "smoke test passed!"
