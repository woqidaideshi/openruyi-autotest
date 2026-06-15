#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'bash --version' 0 "bash 版本"
rlRun 'bash -c "echo shell works"' 0 "bash -c 执行命令"
echo "smoke test passed!"
