#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'free' 0 "free 内存使用"
rlRun 'free -h' 0 "free -h 人类可读"
rlRun 'free -t' 0 "free -t 含合计行"
echo "smoke test passed!"
