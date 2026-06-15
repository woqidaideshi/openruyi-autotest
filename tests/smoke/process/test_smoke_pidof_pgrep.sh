#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'pidof systemd' 0 "pidof 查找systemd"
rlRun 'pgrep -x systemd' 0 "pgrep 查找进程"
echo "smoke test passed!"
