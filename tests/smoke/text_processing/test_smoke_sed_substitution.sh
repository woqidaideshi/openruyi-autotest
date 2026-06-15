#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
echo "hello world" | sed 's/world/universe/' | grep universe
rlRun 'echo "hello" | sed "s/h/H/"' 0 "sed 替换"
rlRun 'echo "a b c" | sed "s/ /,/g"' 0 "sed 全局替换"
echo "smoke test passed!"
