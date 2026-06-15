#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'ldd /bin/sh' 0 "ldd 查看链接"
rlRun 'ldd /bin/ls' 0 "ldd ls 依赖"
echo "smoke test passed!"
