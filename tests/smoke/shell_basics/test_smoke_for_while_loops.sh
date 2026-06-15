#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
for i in 1 2 3; do echo $i; done | grep -q 2
rlRun 'echo ok' 0 "for 循环正常"
n=0; while [ $n -lt 3 ]; do n=$((n+1)); done; test $n -eq 3
echo "smoke test passed!"
