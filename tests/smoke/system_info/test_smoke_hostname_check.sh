#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'hostname' 0 "hostname 显示主机名"
rlRun 'cat /etc/hostname' 0 "hostname 文件可读"
echo "smoke test passed!"
