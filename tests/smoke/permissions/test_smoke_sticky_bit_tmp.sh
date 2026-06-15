#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -d /tmp' 0 "/tmp 目录存在"
rlRun 'ls -ld /tmp' 0 "ls -ld /tmp 权限"
echo "smoke test passed!"
