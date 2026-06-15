#!/bin/sh -eu
rlRun() { eval "$1" 2>&1; return $?; }
sleep 1 &
rlRun 'jobs' 0 "jobs 列出后台任务"
wait
echo "smoke test passed!"
