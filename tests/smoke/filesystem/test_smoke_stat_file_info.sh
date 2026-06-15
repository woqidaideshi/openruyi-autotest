#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'stat /etc/os-release' 0 "stat 查看文件"
rlRun 'stat -c "%s" /etc/os-release' 0 "stat 格式化输出大小"
rlRun 'stat /' 0 "stat 查看目录"
echo "smoke test passed!"
