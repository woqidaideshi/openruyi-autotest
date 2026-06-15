#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'head -3 /etc/os-release' 0 "head 前3行"
rlRun 'tail -3 /etc/os-release' 0 "tail 后3行"
rlRun 'head -c 10 /etc/hostname' 0 "head 前10字节"
echo "smoke test passed!"
