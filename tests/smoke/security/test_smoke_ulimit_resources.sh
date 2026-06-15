#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ulimit -n' 0 "ulimit -n 文件描述符上限"
rlRun 'ulimit -u' 0 "ulimit -u 用户进程数上限"
echo "smoke test passed!"
