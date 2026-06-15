#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ls -l /usr/bin/passwd' 0 "passwd 权限检查"
rlRun 'ls -l /usr/bin/sudo' 0 "sudo 权限检查"
echo "smoke test passed!"
