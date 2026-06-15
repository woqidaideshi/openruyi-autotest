#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'wc -l /etc/os-release' 0 "wc -l 统计行数"
rlRun 'wc -c /etc/hostname' 0 "wc -c 统计字节数"
rlRun 'wc -w /etc/os-release' 0 "wc -w 统计单词数"
echo "smoke test passed!"
