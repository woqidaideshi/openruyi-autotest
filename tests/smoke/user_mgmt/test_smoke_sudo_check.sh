#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'which sudo' 0 "sudo 命令存在"
rlRun 'sudo -V 2>&1 | head -1' 0 "sudo 版本"
echo "smoke test passed!"
