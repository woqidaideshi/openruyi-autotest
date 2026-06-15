#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -d /etc/skel' 0 "/etc/skel 骨架目录存在"
rlRun 'ls -la /home' 0 "ls /home 用户家目录"
echo "smoke test passed!"
