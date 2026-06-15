#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'echo $(uname)' 0 "\$() 命令替换"
X=$(date +%Y); test -n "$X"
echo "smoke test passed!"
