#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -f /etc/passwd' 0 "/etc/passwd 文件存在"
rlRun 'test -f /etc/shadow' 0 "/etc/shadow 文件存在"
rlRun 'cat /etc/passwd | head -3' 0 "/etc/passwd 可读"
echo "smoke test passed!"
