#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'test -f /etc/fstab' 0 "/etc/fstab 存在"
rlRun 'cat /etc/fstab | head -5' 0 "/etc/fstab 可读"
echo "smoke test passed!"
