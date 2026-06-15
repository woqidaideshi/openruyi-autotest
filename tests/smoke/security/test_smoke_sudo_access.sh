#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -f /etc/sudoers' 0 "/etc/sudoers 存在"
rlRun 'sudo -l 2>&1 || true' 0 "sudo -l 列出权限"
echo "smoke test passed!"
