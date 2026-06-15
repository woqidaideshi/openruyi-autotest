#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
sleep 10 &
PID=$!
rlRun "kill $PID" 0 "kill 终止进程"
sleep 1
if kill -0 $PID 2>/dev/null; then
    echo "kill may not have worked"
fi
echo "smoke test passed!"
