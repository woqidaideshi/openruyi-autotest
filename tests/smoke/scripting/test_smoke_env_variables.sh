#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'env | head -5' 0 "env 列出环境变量"
rlRun 'echo $PATH | grep /bin' 0 "\$PATH 含/bin"
rlRun 'echo $SHELL' 0 "\$SHELL 默认shell"
echo "smoke test passed!"
